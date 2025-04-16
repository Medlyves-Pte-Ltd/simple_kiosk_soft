import 'dart:async';
import 'package:flutter_devices_sdk/log/log_printer.dart';
import 'package:flutter_devices_sdk/view/colors.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:flutter/material.dart';
import 'package:simple_kiosk_software/common/footer.dart';
import 'package:simple_kiosk_software/common/video_widget.dart';
import 'package:simple_kiosk_software/screens/language/date_time_section.dart';
import 'package:simple_kiosk_software/utils/app_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_kiosk_software/utils/kiosk_config.dart';

class SelectLoginMethodPage extends StatefulWidget {
  const SelectLoginMethodPage({Key? key}) : super(key: key);

  @override
  State<SelectLoginMethodPage> createState() => SelectLoginMethodPageState();
}

class SelectLoginMethodPageState extends State<SelectLoginMethodPage> {
  // 屏幕宽度
  double width = 0;
  // 屏幕高度
  double height = 0;
  final double spaceBetweenButtons = 15.0;
  late Locale locale;
  Timer? time;
  int count = 0;

  @override
  void initState() {
    super.initState();
    if (AppConfig().ecoMode) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    if (AppConfig().ecoMode) {
      time?.cancel();
    }
    super.dispose();
  }

  Future<void> setSystemScreenBrightness(double brightness) async {
    try {
      await ScreenBrightness.instance.setSystemScreenBrightness(brightness);
    } catch (e) {
      LogPrinter.log("set system brightness failed : " + e.toString());
    }
  }

  void _startTimer() {
    time = Timer.periodic(const Duration(minutes: 1), (Timer timer) {
      setState(() {
        count++;
        if (count == AppConfig().ecoModeTimeMinute) {
          setSystemScreenBrightness(0.01);
          timer.cancel();
          LogPrinter.log(
              "user does not operate for a long time, the screen darkens and the timer stops");
        }
      });
    });
  }

  void _resetTimer() {
    time?.cancel();
    setState(() {
      count = 0;
    });
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () async {
        if (AppConfig().ecoMode) {
          _resetTimer();
          await setSystemScreenBrightness(1.0);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              // const Footer(),
              const DateTimeSection(),
              VideoWidget(
                videoName: KioskConfig().kioskType != "simple_sg" ? "${AppConfig().videosDir}/th/welcome_TH.mp4" : "${AppConfig().videosDir}/en/welcome_EN.mp4",
                setLooping: false,
                fromFile: true,
              ),
              SizedBox(height: height * 0.08),
              selectLoginMethod(),
              Spacer(),
              Footer(),
            ],
          ),
        ),
      ),
    );
  }

  // 选择登录方式
  Widget selectLoginMethod() {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _buildLoginMethod(
            context,
            'assets/images/Medlyves_logo_only.png',
            "Medlyves app",
                () {
              KioskConfig().healthScreeningMode = HealthScreeningMode.online;
              KioskConfig().teleConsultationMode = TeleConsultationMode.on;
              Navigator.pushNamed(context, "/ScannerPage");
            },
          ),
          SizedBox(
            width: width * 0.14,
          ),
          _buildLoginMethod(
            context,
            'assets/images/thailand_id.png',
            AppLocalizations.of(context)!.id_card,
                () {
              KioskConfig().healthScreeningMode = HealthScreeningMode.standalone;
              KioskConfig().teleConsultationMode = TeleConsultationMode.off;
              Navigator.pushNamed(context, "/IdCardLoginPage");
            },
          ),
          SizedBox(
            width: width * 0.14,
          ),
          _buildLoginMethod(
            context,
            'assets/images/manual_entry.png',
            AppLocalizations.of(context)!.manual_entry,
                () {
              KioskConfig().healthScreeningMode = HealthScreeningMode.standalone;
              KioskConfig().teleConsultationMode = TeleConsultationMode.off;
              Navigator.pushNamed(context, "/UserLoginPage");
            },
          ),
        ]),
        SizedBox(height: height * 0.1),
        buildBackBtn(),
      ],
    );
  }

  Widget _buildLoginMethod(
      BuildContext context, String imagePath, String text, VoidCallback onTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: height * 0.08,
            width: height * 0.08,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                width: 1,
                color: ColorPalette.materialGreen,
              ),
            ),
            child: Transform.scale(
              scale: 0.7,
              child: Image.asset(imagePath),
            ),
          ),
        ),
        SizedBox(height: height * 0.02),
        Text(
          text,
          style: TextStyle(
            fontSize: height * 0.018,
            color: ColorPalette.materialGreen,
          ),
        ),
      ],
    );
  }

  // 返回按钮
  Widget buildBackBtn() {
    return Container(
      height: height * 0.08,
      padding: EdgeInsets.only(
        top: height * 0.01,
        bottom: height * 0.01,
        right: width * 0.05,
      ),
      child: Row(
        children: [
          const Spacer(),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, "/LanguagePage");
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
                  AppLocalizations.of(context)!.back,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: height * 0.015,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}