import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_kiosk_software/blocs/locale/locale_bloc.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:simple_kiosk_software/blocs/device/device_bloc.dart';
import 'package:simple_kiosk_software/blocs/device/device_state.dart';
import 'package:simple_kiosk_software/common/client_details.dart';
import 'package:simple_kiosk_software/common/footer.dart';
import 'package:simple_kiosk_software/common/header.dart';
import 'package:simple_kiosk_software/common/video_widget.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_kiosk_software/utils/control_measure_page_utils.dart';

class BaseMeasureLayoutWidget extends StatelessWidget {
  String dataDefaultValue = "- - -";
  // 步骤原形图标数量
  final stepCircleCount = 4;
  String startVideoFile = '';
  String endVideoFile = '';
  String title = "";
  double width = 0;
  double height = 0;
  ValueNotifier<bool> startButtonPressed = ValueNotifier<bool>(false);
  late BuildContext mainContext;

  // 子类需要实现的数据显示函数
  Widget buildCardDataShowArea() {
    throw UnimplementedError();
  }

  void init() {}

  @override
  Widget build(BuildContext context) {
    mainContext = context;
    init();
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          const Header(),
          _buildVideoArea(),
          _buildStepArea(),
          _buildCardArea(),
          _buildBackNextControlBtn(),
          const Footer()
        ],
      ),
    );
  }

  // 播放视频区域
  Widget _buildVideoArea() {
    String file = startVideoFile;
    return BlocListener<DeviceBloc, DeviceState>(
      listener: (context, state) {
        if (state is DeviceDataUpdated || ControlMeasurePageUtils().measured) {
          file = endVideoFile;
        } else {
          file = startVideoFile;
        }
      },
      child: BlocBuilder<DeviceBloc, DeviceState>(builder: (context, state) {
        return VideoWidget(key: GlobalKey(), videoName: file, setLooping: true);
      }),
    );

    return BlocBuilder<DeviceBloc, DeviceState>(builder: (context, state) {
      String file = state is DeviceDataUpdated ? endVideoFile : startVideoFile;
      return VideoWidget(key: GlobalKey(), videoName: file, setLooping: true);
    });
  }

  // 显示步骤区域
  Widget _buildStepArea() {
    double radius = height * 0.04;
    double interval = width * 0.06;
    return Container(
      height: height * 0.05,
      margin: EdgeInsets.only(
          left: width * 0.2,
          right: width * 0.2,
          top: height * 0.006,
          bottom: height * 0.006),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: buildStepArea(),
      ),
    );
  }

  // 卡片信息区域
  Widget _buildCardArea() {
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: ColorPalette.greyWidgetBorder, width: 2.5),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: width * 0.05),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          _buildCardTopArea(),
          Expanded(child: buildCardDataShowArea()),
          Container(
            margin: EdgeInsets.only(
                left: width * 0.015,
                right: width * 0.015,
                top: height * 0.003,
                bottom: height * 0.003),
            color: ColorPalette.greyWidgetBorder,
            height: 1.5,
          ),
          const ClientDetails(
            userDetails: {},
          ),
        ],
      ),
    ));
  }

  // 返回下一步控制按钮
  Widget _buildBackNextControlBtn() {
    return Padding(
      padding: EdgeInsets.only(
          top: height * 0.01, bottom: height * 0.01, right: width * 0.05),
      child: Row(
        children: [
          const Spacer(),
          InkWell(
            onTap: () {
              ControlMeasurePageUtils().onBackStep(mainContext);
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
                    AppLocalizations.of(mainContext)!.back,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: height * 0.015,
                        fontWeight: FontWeight.w600),
                  ),
                )),
          ),
          SizedBox(
            width: width * 0.03,
          ),
          _buildResultOrNextBtn()
        ],
      ),
    );
  }

  // 卡片顶部区域
  Widget _buildCardTopArea() {
    double imageSize = height * 0.05;
    double titleFontSize = height * 0.02;
    return Row(
      children: [
        Image.asset(
          ControlMeasurePageUtils().iconFile,
          width: imageSize,
          height: imageSize,
        ),
        const SizedBox(width: 5),
        Padding(
          padding: EdgeInsets.symmetric(vertical: height * 0.01),
          child: IntrinsicWidth(
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: titleFontSize),
                ),
                Container(
                  color: ControlMeasurePageUtils().color,
                  height: 1.5,
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        startButton(),
      ],
    );
  }

  String getVideoFileName(DeviceType type, bool completed) {
    String localeCode =
        BlocProvider.of<LocaleCubit>(mainContext).locale.languageCode;

    Map<DeviceType, String> directoryNames = {
      DeviceType.HEIGHT_DEVICE: "heightweight",
      DeviceType.BC_DEVICE: "bodycomposition",
      DeviceType.BP_DEVICE: "bloodpressure",
      DeviceType.BF_DEVICE: "bloodfat",
      DeviceType.BO_DEVICE: "spo2_measure",
      DeviceType.BG_DEVICE: "bloodglucose",
      DeviceType.TEMP_DEVICE: "temperature",
      DeviceType.ECG_DEVICE: "ecg"
    };

    String strCompleted = completed ? "completed_" : "";
    String videoFileName =
        '${directoryNames[type]}_$strCompleted${localeCode.toUpperCase()}.mp4';

    return 'assets/videos/$localeCode/$videoFileName';
  }

  Widget startButton() {
    double btnFontSize = height * 0.025;
    return BlocBuilder<DeviceBloc, DeviceState>(builder: (context, state) {
      if (state is DeviceConnected ||
          state is DeviceDataLoading ||
          state is DeviceDataUpdated) {
        return InkWell(
          onTap: () async {
            await onStop();
          },
          child: Container(
            height: height * 0.03,
            width: width * 0.15,
            decoration: BoxDecoration(
              color: ColorPalette.materialGreen,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(AppLocalizations.of(mainContext)!.stop,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: btnFontSize,
                      color: Colors.white)),
            ),
          ),
        );
      } else {
        return InkWell(
          onTap: () async {
            ControlMeasurePageUtils().measured = false;
            await onStart();
          },
          child: Container(
            height: height * 0.03,
            width: width * 0.15,
            decoration: BoxDecoration(
              color: ColorPalette.materialGreen,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(AppLocalizations.of(mainContext)!.start,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: btnFontSize,
                      color: Colors.white)),
            ),
          ),
        );
      }
    });

    return ValueListenableBuilder<bool>(
        valueListenable: startButtonPressed,
        builder: (context, value, child) {
          if (!value) {
            return InkWell(
              onTap: () async {
                await onStart();
                startButtonPressed.value = true;
              },
              child: Container(
                height: height * 0.03,
                width: width * 0.15,
                decoration: BoxDecoration(
                  color: ColorPalette.materialGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text("Start",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: btnFontSize,
                          color: Colors.white)),
                ),
              ),
            );
          } else {
            return InkWell(
              onTap: () async {
                await onStop();
                startButtonPressed.value = false;
              },
              child: Container(
                height: height * 0.03,
                width: width * 0.15,
                decoration: BoxDecoration(
                  color: ColorPalette.materialGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text("Stop",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: btnFontSize,
                          color: Colors.white)),
                ),
              ),
            );
          }
        });
  }

  // 结果或者下一步按钮
  Widget _buildResultOrNextBtn() {
    if (ControlMeasurePageUtils().pageIndex !=
        ControlMeasurePageUtils().measurelist.length - 1) {
      return InkWell(
        onTap: () {
          ControlMeasurePageUtils().onNextStep(mainContext);
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
                AppLocalizations.of(mainContext)!.next,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: height * 0.015,
                    fontWeight: FontWeight.w600),
              ),
            )),
      );
    } else {
      return InkWell(
        onTap: () {
          Navigator.pushNamedAndRemoveUntil(
              mainContext, "/FrailtySummaryPage", (route) => false);
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
                AppLocalizations.of(mainContext)!.results,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: height * 0.015,
                    fontWeight: FontWeight.w600),
              ),
            )),
      );
    }
  }

  // 开始
  onStart() async {}

  // 停止
  onStop() async {}

  Widget _buildCircleArea(int index, Color color) {
    double radius = height * 0.04;
    return Container(
        height: radius,
        width: radius,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        child: Center(
          child: Text(
            "${index + 1}",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: height * 0.03),
          ),
        ));
  }

  List<Widget> buildStepArea() {
    double radius = height * 0.04;
    double interval = width * 0.06;
    List<Widget> list = [];
    int index = 0;
    for (int i = 0;
        i < stepCircleCount && i < ControlMeasurePageUtils().measurelist.length;
        ++i) {
      if (ControlMeasurePageUtils().pageIndex < stepCircleCount - 1) {
        index = i;
      } else {
        //
        index = i + ControlMeasurePageUtils().pageIndex - (stepCircleCount - 2);
        if (ControlMeasurePageUtils().pageIndex ==
            ControlMeasurePageUtils().measurelist.length - 1) {
          index--;
        }
      }

      if (index < ControlMeasurePageUtils().measurelist.length) {
        if (index == ControlMeasurePageUtils().pageIndex) {
          list.add(Image.asset(
            ControlMeasurePageUtils().measurelist[index]['icon_file'],
            height: radius,
          ));
        } else if (index < ControlMeasurePageUtils().pageIndex) {
          if (ControlMeasurePageUtils().measurelist[index]['measured']) {
            list.add(_buildCircleArea(index,
                Color(ControlMeasurePageUtils().measurelist[index]['color'])));
          }
        } else {
          list.add(_buildCircleArea(index, ColorPalette.greyWidgetBorder));
        }
      }

      if (i < stepCircleCount - 1) {
        list.add(
          SizedBox(
            width: interval,
          ),
        );
      }
    }

    return list;
  }
}
