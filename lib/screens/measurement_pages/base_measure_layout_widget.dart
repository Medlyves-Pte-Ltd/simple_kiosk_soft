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
import 'package:simple_kiosk_software/utils/app_config.dart';
import 'package:simple_kiosk_software/utils/control_measure_page_utils.dart';

class BaseMeasureLayoutWidget extends StatelessWidget {
  // 是否测过
  bool measured = false;
  // 数据默认值
  String dataDefaultValue = "- - -";
  // 当前播放的视频文件
  String curPlayFile = "";
  // 步骤原形图标数量
  final stepCircleCount = 4;
  // 测试开始视频
  String startVideoFile = '';
  // 测试结束视频
  String endVideoFile = '';
  // 标题
  String title = "";
  // 屏幕宽度
  double width = 0;
  // 屏幕高度
  double height = 0;
  // StatelessWidget需要保存上下文才能进行页面跳转，翻译
  late BuildContext mainContext;

  // 子类需要实现的数据显示函数
  Widget buildCardDataShowArea() {
    throw UnimplementedError();
  }

  void init() {}

  // 开始
  Future<void> onStart() async {}

  // 停止
  Future<void> onStop() async {}

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
          buildVideoArea(),
          _buildStepArea(),
          buildCardArea(),
          buildBackNextControlBtn(),
          Footer()
        ],
      ),
    );
  }

  // 播放视频区域
  Widget buildVideoArea() {
    String file = ControlMeasurePageUtils().measured == false
        ? startVideoFile
        : endVideoFile;
    return BlocBuilder<DeviceBloc, DeviceState>(buildWhen: (previous, state) {
      if (state is DeviceDataUpdated) {
        file = endVideoFile;
      } else if (state is DeviceConnected) {
        file = startVideoFile;
      }
      return file != curPlayFile;
    }, builder: (context, state) {
      curPlayFile = file;
      return VideoWidget(
          key: GlobalKey(), videoName: file, setLooping: true, fromFile: true);
    });
  }

  // 显示步骤区域
  Widget _buildStepArea() {
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
  Widget buildCardArea() {
    return Expanded(
        child: Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: width * 0.05),
      padding: EdgeInsets.all(height * 0.01),
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
      child: Column(
        children: [
          buildCardTopArea(),
          Expanded(child: buildCardDataShowArea()),
          Container(
            margin: EdgeInsets.only(
                left: width * 0.015,
                right: width * 0.015,
                top: height * 0.003,
                bottom: height * 0.003),
            color: Colors.grey[300] ?? ColorPalette.greyWidgetBorder,
            height: 2,
          ),
          const ClientDetails(),
        ],
      ),
    ));
  }

  // 返回下一步控制按钮
  Widget buildBackNextControlBtn() {
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
          buildResultOrNextBtn()
        ],
      ),
    );
  }

  // 卡片顶部区域
  Widget buildCardTopArea() {
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
      DeviceType.BF_DEVICE: "bloodfit",
      DeviceType.BO_DEVICE: "spo2",
      DeviceType.BG_DEVICE: "bloodglucose",
      DeviceType.TEMP_DEVICE: "temperature",
      DeviceType.ECG_DEVICE: "ecg"
    };
    String videoFileName = "";
    if (completed) {
      if (type == DeviceType.ECG_DEVICE) {
        videoFileName = 'completed_results_${localeCode.toUpperCase()}.mp4';
      } else {
        videoFileName = 'completed_next_${localeCode.toUpperCase()}.mp4';
      }
    } else {
      videoFileName = '${directoryNames[type]}_${localeCode.toUpperCase()}.mp4';
    }

    return '${AppConfig().videosDir}/$localeCode/$videoFileName';
  }

  Widget startButton() {
    double btnFontSize = height * 0.025;
    String btnText = AppLocalizations.of(mainContext)!.start;
    return BlocBuilder<DeviceBloc, DeviceState>(buildWhen: (previous, state) {
      bool update = false;

      if (state is DeviceConnected) {
        btnText = AppLocalizations.of(mainContext)!.stop;
        update = true;
      } else if (state is DeviceDisconnected) {
        btnText = AppLocalizations.of(mainContext)!.start;
        update = true;
      }

      return update;
    }, builder: (context, state) {
      return InkWell(
        onTap: () async {
          if (btnText == AppLocalizations.of(mainContext)!.stop) {
            await onStop();
          } else {
            await onStart();
          }
        },
        child: Container(
          height: height * 0.04,
          width: width * 0.2,
          decoration: BoxDecoration(
            color: ColorPalette.materialGreen,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(btnText,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: btnFontSize,
                    color: Colors.white)),
          ),
        ),
      );
    });
  }

  // 结果或者下一步按钮
  Widget buildResultOrNextBtn() {
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
              mainContext, "/Summary", (route) => false);
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

  Widget buildCircleArea(int index, Color color) {
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
            list.add(buildCircleArea(index,
                Color(ControlMeasurePageUtils().measurelist[index]['color'])));
          } else {
            list.add(buildCircleArea(index, ColorPalette.greyWidgetBorder));
          }
        } else {
          list.add(buildCircleArea(index, ColorPalette.greyWidgetBorder));
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
