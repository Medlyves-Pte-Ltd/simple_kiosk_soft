import 'package:country_flags/country_flags.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_devices_sdk/device_data/code_scanner_data.dart';
import 'package:simple_kiosk_software/blocs/device/debug_device_bloc.dart';
import 'package:simple_kiosk_software/blocs/device/device_state.dart';
import 'package:simple_kiosk_software/blocs/locale/locale_bloc.dart';
import 'package:flutter/material.dart';
import 'package:simple_kiosk_software/common/common.dart';
import 'package:simple_kiosk_software/common/footer.dart';
import 'package:simple_kiosk_software/common/video_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_kiosk_software/screens/language/date_time_section.dart';
import 'package:simple_kiosk_software/utils/app_config.dart';
import 'package:simple_kiosk_software/utils/kiosk_config.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({Key? key}) : super(key: key);

  @override
  State<LanguagePage> createState() => LanguagePageState();
}

class LanguagePageState extends State<LanguagePage> {
  // 屏幕宽度
  double width = 0;
  // 屏幕高度
  double height = 0;
  final double spaceBetweenButtons = 15.0;
  late Locale locale;
  final List<Map<String, String>> languages = [
    {"name": "ภาษาไทย", "code": "th", "flag": "THA"},
    {"name": "English", "code": "en", "flag": "GBR"},
    // {"name": "中文", "code": "zh", "flag": "CHN"},
    // {"name": "Bahasa Melayu", "code": "ms", "flag": ""},
    // {"name": "தமிழ்", "code": "ta", "flag": ""},
  ];

  @override
  void initState() {
    super.initState();
    // if (!AppConfig().useScanner) {
    //   // 打开扫码器
    //   Future.delayed(Duration(milliseconds: 50), () {
    //     AppConfig().useScanner = startScanner(context);
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            // const Footer(),
            const DateTimeSection(),
            VideoWidget(
              videoName: "${AppConfig().videosDir}/th/welcome_TH.mp4",
              setLooping: false,
              fromFile: true,
            ),
            SizedBox(height: height * 0.01),
            Expanded(
                child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: languages
                    .map((language) => Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: width * 0.03),
                          height: height * 0.06,
                          width: width * 0.18,
                          child: _buildLanguageButton(
                            language["name"]!,
                            language["code"]!,
                            language["flag"]!,
                          ),
                        ))
                    .toList(),
              ),
            )),
            // BlocListener<DeviceBloc, DeviceState>(
            //     listener: (context, state) {
            //       if (state is DeviceDataUpdated &&
            //           state.deviceData is CodeScannerData) {
            //         String data = (state.deviceData as CodeScannerData).scanner;
            //         print("language page qr code: $data");
            //       }
            //     },
            //     child: downloadInfo()),
            downloadInfo(),
            SizedBox(
              height: height * 0.01,
            ),
            downloadQrCode(),
            SizedBox(
              height: height * 0.03,
            ),
            Footer(),
          ],
        ),
      ),
    );
  }

  // 下载信息提示
  Widget downloadInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "กรุณาสแกน QR Code เพื่อลงทะเบียนในแอปพลิเคชันมือถือ",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: height * 0.015),
        ),
        SizedBox(
          height: height * 0.003,
        ),
        Text("Please scan QR code to register in Medlyves mobile application.",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: height * 0.015)),
        SizedBox(
          height: height * 0.003,
        ),
        Text("请扫码二维码下载MedLyves App以注册账户",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: height * 0.015)),
      ],
    );
  }

  // 下载二维码
  Widget downloadQrCode() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/images/apple_market.png",
              height: height * 0.03,
              width: height * 0.10,
            ),
            Image.asset(
              "assets/images/apple_code.png",
              height: height * 0.10,
              width: height * 0.10,
            )
          ],
        ),
        SizedBox(
          width: width * 0.2,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/images/google_market.png",
              height: height * 0.03,
              width: height * 0.10,
            ),
            Image.asset(
              "assets/images/google_qrcode.png",
              height: height * 0.10,
              width: height * 0.10,
            )
          ],
        )
      ],
    );
  }

  Widget _buildLanguageButton(
      String languageName, String languageCode, String flagCode) {
    Widget flag = CountryFlag.fromCountryCode(
      flagCode,
      height: height * 0.05,
      width: width * 0.16,
    );

    return ElevatedButton(
      onPressed: () {
        BlocProvider.of<LocaleCubit>(context).loadLocale(Locale(languageCode));
        if (KioskConfig().healthScreeningMode == HealthScreeningMode.online) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/ScannerPage', ((route) => false));
        } else {
          if (AppConfig().onlyInputLogin) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/UserLoginPage', ((route) => false));
          } else {
            Navigator.pushNamedAndRemoveUntil(
                context, '/IdCardLoginPage', ((route) => false));
          }
        }
      },
      style: _getButtonStyle(),
      child: flag,
    );
  }

  ButtonStyle _getButtonStyle() {
    return ButtonStyle(
      surfaceTintColor: MaterialStateProperty.all<Color>(
          const Color.fromARGB(255, 214, 209, 209)),
      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
      padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 5, vertical: 5)),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
      elevation: MaterialStateProperty.all<double>(5),
      shadowColor: MaterialStateProperty.all<Color>(Colors.grey),
      minimumSize: MaterialStateProperty.all(const Size(320.0, 40.0)),
    );
  }
}
