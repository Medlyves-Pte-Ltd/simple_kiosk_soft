import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_devices_sdk/device_data/code_scanner_data.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_devices_sdk/view/colors.dart';
import 'package:simple_kiosk_software/blocs/device/debug_device_bloc.dart';
import 'package:simple_kiosk_software/blocs/device/device_event.dart';
import 'package:simple_kiosk_software/blocs/device/device_state.dart';
import 'package:simple_kiosk_software/blocs/locale/locale_bloc.dart';
import 'package:simple_kiosk_software/common/footer.dart';
import 'package:simple_kiosk_software/common/header.dart';
import 'package:simple_kiosk_software/common/video_widget.dart';

class ScannerPage extends StatelessWidget {
  // 数据默认值
  String dataDefaultValue = "- - -";
  String scannerData = "";
  // 当前播放的视频文件
  String curPlayFile = "";
  // 屏幕宽度
  double width = 0;
  // 屏幕高度
  double height = 0;

  // StatelessWidget需要保存上下文才能进行页面跳转，翻译
  late BuildContext mainContext;

  @override
  Widget build(BuildContext context) {
    mainContext = context;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    init();
    return Scaffold(
      backgroundColor: ColorPalette.colorAppBackground,
      body: Column(
        children: [
          const Header(),
          buildVideoArea(),
          SizedBox(
            height: height * 0.02,
          ),
          SizedBox(
            height: height * 0.3,
            child: buildTipInfoArea(),
          ),
          const Spacer(),
          buildQrCode(),
          SizedBox(
            height: height * 0.02,
          ),
          const Footer()
        ],
      ),
    );
  }

  Widget buildQrCode() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/qr-code.png",
          height: width * 0.3,
          width: width * 0.3,
        ),
        Image.asset(
          "assets/images/red_down_arrow.png",
          height: width * 0.06,
        ),
      ],
    );
  }

  Widget buildTipInfoArea() {
    return Row(
      children: [
        SizedBox(width: width * 0.08),
        SizedBox(
          width: width * 0.45,
          child: Column(
            children: [
              Text(
                "Please scan your QR Code from the Medlyves application.",
                textAlign: TextAlign.left,
                softWrap: true,
                style: TextStyle(
                  fontSize: height * 0.028,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Text(
                r"Under Appointments, click 'Start' to get the QR Code.",
                textAlign: TextAlign.left,
                softWrap: true,
                style: TextStyle(
                  fontSize: height * 0.022,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        SizedBox(
            width: width * 0.35,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(height * 0.01),
                    width: width * 0.25,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.grey, // 阴影颜色
                              offset: Offset(-10, 10), //阴影xy轴偏移量
                              blurRadius: 25.0, //阴影模糊程度
                              spreadRadius: 5 //阴影扩散程度
                              )
                        ]),
                    child: Image.asset("assets/images/Medlyves_logo_only.png"),
                  ),
                  SizedBox(height: height * 0.008),
                  Text(
                    "Medlyves",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: height * 0.018,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            )),
        SizedBox(width: width * 0.05),
      ],
    );
  }

  // 播放视频区域
  Widget buildVideoArea() {
    return VideoWidget(
        key: GlobalKey(), videoName: curPlayFile, setLooping: true);
  }

  void startScanner() async {
    DeviceConnectEvent connectEvent =
        DeviceConnectEvent(deviceType: DeviceType.SCANNER_DEVICE);
    BlocProvider.of<DeviceBloc>(mainContext).add(connectEvent);
  }

  Widget scannerShow() {
    double titleFontSize = height * 0.02;
    double dataFontSize = height * 0.02;

    return BlocBuilder<DeviceBloc, DeviceState>(builder: (context, state) {
      // if (state is DeviceDataUpdated &&
      //     state.deviceData is CodeScannerData) {
      //   scannerData = (state.deviceData as CodeScannerData).scanner;
      // }
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "二维码信息:",
              style: TextStyle(
                  fontSize: titleFontSize, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: height * 0.02),
            Text(
              scannerData,
              style: TextStyle(
                  fontSize: dataFontSize,
                  fontWeight: FontWeight.bold,
                  color: ColorPalette.materialGreen),
            )
          ],
        ),
      );
    });
  }

  Widget buildBtn() {
    return Padding(
      padding: EdgeInsets.only(
          top: height * 0.01, bottom: height * 0.01, right: width * 0.05),
      child: Row(
        children: [
          const Spacer(),
          InkWell(
            onTap: startScanner,
            child: Container(
                height: height * 0.03,
                width: width * 0.15,
                decoration: BoxDecoration(
                  color: ColorPalette.materialGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "扫码",
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
          InkWell(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  mainContext, "/", (route) => false);
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
          )
        ],
      ),
    );
  }

  void init() {
    if (curPlayFile.isEmpty) {
      curPlayFile = getVideoFileName();
    }
  }

  String getVideoFileName() {
    String localeCode =
        BlocProvider.of<LocaleCubit>(mainContext).locale.languageCode;
    String videoFileName = 'qr_code_${localeCode.toUpperCase()}.mp4';
    return 'assets/videos/$localeCode/$videoFileName';
  }
}
