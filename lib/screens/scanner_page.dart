import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_devices_sdk/utils/app_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_devices_sdk/view/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simple_kiosk_software/blocs/locale/locale_bloc.dart';
import 'package:simple_kiosk_software/common/footer.dart';
import 'package:simple_kiosk_software/common/header.dart';
import 'package:simple_kiosk_software/common/video_widget.dart';
import 'package:simple_kiosk_software/utils/scanner_utils.dart';
import 'package:simple_kiosk_software/utils/user_info.dart';

class ScannerPage extends StatefulWidget {
  @override
  ScannerPageState createState() => ScannerPageState();
}

class ScannerPageState extends State<ScannerPage> {
  // 数据默认值
  String dataDefaultValue = "- - -";
  // 当前播放的视频文件
  String curPlayFile = "";
  // 屏幕宽度
  double width = 0;
  // 屏幕高度
  double height = 0;
  // StatelessWidget需要保存上下文才能进行页面跳转，翻译
  late BuildContext mainContext;
  // 扫码数据
  late Map<String, dynamic> scannerData;

  @override
  void initState() {
    super.initState();
    ScannerUtils().listenData = listenScannerData;
  }

  // 监听扫码器数据
  void listenScannerData(String data) {
    // 判断时候是json数据
    int startPos = data.lastIndexOf('{');
    int endPos = data.lastIndexOf('}');
    if (startPos != -1 && endPos != -1) {
      data = data.substring(startPos, endPos + 1);
    } else {
      Fluttertoast.showToast(msg: "The QR code data format is incorrect!");
      return;
    }

    // 解析json数据
    LogPrinter.log("qr code normal data:$data");
    try {
      scannerData = jsonDecode(data);

      UserInfo().name = scannerData["name"].toString();
      UserInfo().age = scannerData["age"].toString();
      UserInfo().gender = scannerData["gender"] as int;
      UserInfo().clearResult();
    } catch (e) {
      Fluttertoast.showToast(msg: "The QR code data format is incorrect!");
      return;
    }

    // 判断用户信息是否为空
    if (UserInfo().name.isEmpty || UserInfo().age.isEmpty) {
      Fluttertoast.showToast(msg: "User information is incorrect!");
      return;
    }

    ScannerUtils().listenData = null;
    Navigator.pushNamedAndRemoveUntil(
        mainContext, "/HeightWeightMeasure", (route) => false);
  }

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
        GestureDetector(
          onDoubleTap: () {
            UserInfo().name = "User";
            UserInfo().age = "25";
            UserInfo().gender = 1;
            UserInfo().clearResult();
            Navigator.pushNamedAndRemoveUntil(
                context, '/HeightWeightMeasure', ((route) => false));
          },
          child: Image.asset(
            "assets/images/qr-code.png",
            height: width * 0.3,
            width: width * 0.3,
          ),
        ),
        Image.asset(
          "assets/images/red_down_arrow.png",
          height: width * 0.06,
        ),
      ],
    );
  }

  Widget buildTipInfoArea() {
    String localeCode =
        BlocProvider.of<LocaleCubit>(mainContext).locale.languageCode;

    return Row(
      children: [
        SizedBox(width: width * 0.08),
        SizedBox(
          width: width * 0.45,
          child: Column(
            children: [
              Text(
                AppLocalizations.of(mainContext)!.scanner_title,
                textAlign: TextAlign.left,
                softWrap: true,
                style: TextStyle(
                  fontSize: localeCode == "ta" ? height * 0.02 : height * 0.028,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Text(
                AppLocalizations.of(mainContext)!.scanner_tip,
                textAlign: TextAlign.left,
                softWrap: true,
                style: TextStyle(
                  fontSize:
                      localeCode == "ta" ? height * 0.018 : height * 0.022,
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
