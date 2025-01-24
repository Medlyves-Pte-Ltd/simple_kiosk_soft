import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:flutter_devices_sdk/devices/device_config.dart';
import 'package:flutter_devices_sdk/log/log_printer.dart';
import 'package:medlyves_mobile_components/blocs/hms_room_overview/room_overview_bloc.dart';
import 'package:medlyves_mobile_components/blocs/hms_room_overview/room_overview_event.dart';
import 'package:medlyves_mobile_components/blocs/hms_room_overview/room_overview_state.dart';
import 'package:simple_kiosk_software/remote/blocs/appointment/appointment_bloc.dart';
import 'package:simple_kiosk_software/blocs/locale/locale_bloc.dart';
import 'package:simple_kiosk_software/remote/utils/enum_appointment_mode.dart';
import 'package:simple_kiosk_software/utils/app_config.dart';
import 'package:simple_kiosk_software/utils/kiosk_config.dart';
import 'package:simple_kiosk_software/utils/print_utils.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:simple_kiosk_software/common/footer.dart';
import 'package:simple_kiosk_software/common/header.dart';
import 'package:simple_kiosk_software/common/video_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_kiosk_software/screens/summary_pages/summary_basic_vitals.dart';
import 'package:simple_kiosk_software/screens/summary_pages/summary_body_composition.dart';
import 'package:simple_kiosk_software/screens/summary_pages/summary_ecg.dart';
import 'package:simple_kiosk_software/screens/summary_pages/summary_otoscope.dart';
import 'package:simple_kiosk_software/screens/summary_pages/summary_stethoscope.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:simple_kiosk_software/utils/control_measure_page_utils.dart';
import 'package:simple_kiosk_software/utils/test_result_csv_utils.dart';
import 'package:simple_kiosk_software/utils/user_info.dart';
import 'package:simple_kiosk_software/remote/config/settings.dart';

class SummaryLayoutWidget extends StatelessWidget {
  // 文本和Widget顺序需要相同
  List<Widget> _tabBarList = [];
  final List<Widget> _tabViewList = [
    SummaryBasicVitals(),
    SummaryBodyComposition(),
    SummaryEcg(),
    // SummaryStethoscope(),
    // SummaryOtoscope(),
  ];
  // 当前播放的视频文件
  String _curPlayFile = "";
  // 步骤原形图标数量
  final stepCircleCount = 4;
  // 屏幕宽度
  double width = 0;
  // 屏幕高度
  double height = 0;
  // StatelessWidget需要保存上下文才能进行页面跳转，翻译
  late BuildContext mainContext;
  // 能后控制打印
  ValueNotifier<bool> enableClickPrint = ValueNotifier<bool>(true);

  // 子类需要实现的数据显示函数
  Widget buildCardDataShowArea() {
    return const SizedBox.shrink();
  }

  void init() {
    if (_curPlayFile.isEmpty) {
      _curPlayFile = getVideoFileName();
    }

    if (_tabBarList.isEmpty) {
      _tabBarList = [
        Tab(text: AppLocalizations.of(mainContext)!.basic_vitals),
        Tab(text: AppLocalizations.of(mainContext)!.summary_body_composition),
        Tab(text: AppLocalizations.of(mainContext)!.summary_ecg),
        // Tab(text: AppLocalizations.of(mainContext)!.summary_stethoscope),
        // Tab(text: AppLocalizations.of(mainContext)!.summary_otoscope),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    mainContext = context;
    init();
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return BlocListener<AppointmentBloc, AppointmentState>(
      listener: (context, state) {
        String? displayName;
        String? appointmentId;

        if (state is AppointmentStartSent) {
          displayName = state.appointment!.patientName;
          appointmentId = state.appointment!.id;
        } else if (state is AppointmentFailure) {
          displayName = null;
        } else if (state is AppointmentTCReady) {
          displayName = state.appointment!.patientName;
          appointmentId = state.appointment!.id;
          Navigator.of(context).pushNamed('/TCMeetingScreen', arguments: {
            'displayName': displayName,
            'appointmentId': appointmentId
          });
          if (kDebugMode) {
            print("go to doctor appointment");
          }
        } else if (state is AppointmentEnd) {
          LogPrinter.log('Appointment ended');
          displayName = null;
          appointmentId = null;
          Navigator.pushNamedAndRemoveUntil(
              mainContext, "/LanguagePage", (route) => false);
        }
      },
      child: BlocBuilder<AppointmentBloc, AppointmentState>(
        builder: (context, state) {
          String? displayName;
          // ignore: unused_local_variable
          Mode? mode;
          if (state is AppointmentStartSent) {
            displayName = state.appointment!.patientName;
            mode = Mode.values.firstWhere(
              (e) => e.toString() == 'Mode.${state.appointment!.mode}',
              orElse: () => Mode.HS,
            );
          } else if (state is AppointmentFailure) {
            displayName = null;
            mode = Mode.HS;
          }

          return Scaffold(
            body: Column(
              children: [
                const Header(),
                buildVideoArea(),
                buildCardArea(),
                buildBottomBtn(),
                Footer()
              ],
            ),
          );
        },
      ),
    );
  }

  // 播放视频区域
  Widget buildVideoArea() {
    return VideoWidget(
      videoName: _curPlayFile,
      setLooping: false,
      fromFile: true,
    );
  }

  // 卡片信息区域
  Widget buildCardArea() {
    double fontSize = height * 0.016;
    return Expanded(
        child: Padding(
            padding: EdgeInsets.only(
                left: width * 0.03,
                right: width * 0.03,
                top: height * 0.01,
                bottom: height * 0.01),
            child: DefaultTabController(
                length: _tabBarList.length,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ButtonsTabBar(
                      contentCenter: true,
                      radius: 10,
                      height: height * 0.07,
                      width: width * 0.3,
                      backgroundColor: ColorPalette.materialGreen,
                      borderWidth: 0,
                      // borderColor: ColorPalette.colorAppBackground,
                      // unselectedBackgroundColor:
                      //     ColorPalette.colorAppBackground,
                      labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize,
                      ),
                      unselectedLabelStyle: TextStyle(
                        color: ColorPalette.darkGrey,
                        fontSize: fontSize,
                      ),
                      // Add your tabs here
                      tabs: _tabBarList,
                    ),
                    Expanded(
                      child: TabBarView(
                        children: _tabViewList
                            .map((widget) => _buildAddBorder(widget))
                            .toList(),
                      ),
                    ),
                  ],
                ))));
  }

  // 打印
  void btnPrint() async {
    enableClickPrint.value = false;
    // 由于关闭打印机会抛异常，暂时没法解决，先全局使用
    await PrintUtils().connect();
    await PrintUtils().startPrint(mainContext, () {
      enableClickPrint.value = true;
    });
  }

  Widget buildBottomBtn() {
    return Padding(
      padding: EdgeInsets.only(
          top: height * 0.01, bottom: height * 0.01, right: width * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            UserInfo().name ?? 'Default Name',
            style: TextStyle(
                fontSize: width * 0.015,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          buildPrintExitControlBtn(),
          // AppConfig().enableTC && UserInfo().teleconsultation
          //     ? startTCButton()
          //     : buildPrintExitControlBtn(),
        ],
      ),
    );
  }

  // 远程医疗按钮
  Widget startTCButton() {
    return InkWell(
      onTap: () {
        LogPrinter.log('Call doctor pressed');
        BlocProvider.of<AppointmentBloc>(mainContext)
            .add(SendReadyEvent(kioskId: KioskConfig().kioskId));
        BlocProvider.of<AppointmentBloc>(mainContext)
            .add(GetTeleconsultToken(kioskId: KioskConfig().kioskId));
      },
      child: Container(
          height: height * 0.03,
          width: width * 0.15,
          decoration: BoxDecoration(
            color: ColorPalette.materialGreen,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              AppLocalizations.of(mainContext)!.call_doc,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: height * 0.015,
                  fontWeight: FontWeight.w600),
            ),
          )),
    );
  }

  // 打印退出控制按钮
  Widget buildPrintExitControlBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        KioskConfig().healthScreeningMode == HealthScreeningMode.online &&
                KioskConfig().teleConsultationMode == TeleConsultationMode.on &&
                UserInfo().teleconsultation
            ? startTCButton()
            : const SizedBox.shrink(),
        SizedBox(
          width: width * 0.03,
        ),
        Visibility(
          visible: DeviceConfig().deviceEnable(DeviceType.PRINTER_DEVICE),
          child: ValueListenableBuilder(
              valueListenable: enableClickPrint,
              builder: (context, enable, child) {
                return InkWell(
                  onTap: enable ? btnPrint : null,
                  child: Container(
                      height: height * 0.03,
                      width: width * 0.15,
                      decoration: BoxDecoration(
                        color: enable
                            ? ColorPalette.materialGreen
                            : ColorPalette.darkGrey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(mainContext)!.print,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: height * 0.015,
                              fontWeight: FontWeight.w600),
                        ),
                      )),
                );
              }),
        ),
        SizedBox(
          width: width * 0.03,
        ),
        buildExitBtn(),
        SizedBox(
          width: width * 0.03,
        ),
      ],
    );
  }

  // 退出按钮
  Widget buildExitBtn() {
    return InkWell(
      onTap: () async {
        if (AppConfig().testResultOutCsv) {
          TestResultCsv testResultCsv = TestResultCsv();
          await testResultCsv.writeTestDataToCsv();
        }

        mainContext
            .read<AppointmentBloc>()
            .add(SendStopEvent(kioskId: KioskConfig().kioskId));
        UserInfo().clearUserInfo();
        UserInfo().clearResult();
        ControlMeasurePageUtils().pageIndex = 0;
        ControlMeasurePageUtils().clearMeasure();
        Navigator.pushNamedAndRemoveUntil(
            mainContext, "/LanguagePage", (route) => false);
      },
      child: Container(
          height: height * 0.03,
          width: width * 0.15,
          decoration: BoxDecoration(
            color: ColorPalette.materialGreen,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              AppLocalizations.of(mainContext)!.exit,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: height * 0.015,
                  fontWeight: FontWeight.w600),
            ),
          )),
    );
  }

  String getVideoFileName() {
    String localeCode =
        BlocProvider.of<LocaleCubit>(mainContext).locale.languageCode;
    return '${AppConfig().videosDir}/$localeCode/end_session_${localeCode.toUpperCase()}.mp4';
  }

  // 加边框
  Widget _buildAddBorder(Widget item) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.all(height * 0.01),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(mainContext).canvasColor,
          border: Border.all(
            width: 1,
            color: Colors.grey[300] ?? Colors.grey,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300] ?? Colors.grey,
              offset: const Offset(1, 1),
              blurRadius: 5,
            ),
            BoxShadow(
                color: Colors.grey[300] ?? Colors.grey,
                offset: const Offset(-1, -1),
                blurRadius: 5),
            BoxShadow(
                color: Colors.grey[300] ?? Colors.grey,
                offset: const Offset(1, -1),
                blurRadius: 5),
            BoxShadow(
                color: Colors.grey[300] ?? Colors.grey,
                offset: const Offset(-1, 1),
                blurRadius: 5)
          ]),
      child: item,
    );
  }
}
