import 'package:base_kiosk_software/blocs/locale/locale_bloc.dart';
import 'package:flutter/material.dart';
import 'package:base_kiosk_software/common/buttons.dart';
import 'package:base_kiosk_software/common/header_text.dart';
import 'package:base_kiosk_software/common/layouts/layout1.dart';
import 'package:base_kiosk_software/common/layouts/layout2.dart';
import 'package:base_kiosk_software/common/video_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({Key? key}) : super(key: key);

  @override
  State<LanguagePage> createState() => LanguagePageState();
}

class LanguagePageState extends State<LanguagePage> {
  late Locale locale;
  final List<Map<String, String>> languages = [
    {"name": "English", "code": "en"},
    {"name": "中文", "code": "zh"},
    {"name": "Bahasa Melayu", "code": "ms"},
    {"name": "தமிழ்", "code": "ta"},
  ];

  void _changeLanguage(String code) {
    BlocProvider.of<LocaleCubit>(context).loadLocale(Locale(code));
    Navigator.pushNamedAndRemoveUntil(context, '/login', ((route) => false));
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double boxHeight = screenHeight * 0.045;
    double topPadding = screenHeight * 0.045;

    return Scaffold(
        body: Layout1(
            content1: Content1Body(
      stage: StageType.measurement,
      videoSpace: Container(
          child: const VideoWidget(
        videoName: 'assets/videos/language_selection.mp4',
        setLooping: true,
      )),
      content2Builder: (context) {
        return Container(
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.only(top: topPadding),
                  child: const HeaderText(
                    text: "Please select your preferred language",
                  )),
              SizedBox(height: topPadding),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                GreenButton(
                    buttonText: "English",
                    onTap: () {
                      _changeLanguage("en");
                    },
                    disabled: false,
                    buttontype: ButtonType.language),
                GreenButton(
                    buttonText: "Bahasa Melayu",
                    onTap: () {
                      _changeLanguage("ms");
                    },
                    disabled: false,
                    buttontype: ButtonType.language),
              ]),
              SizedBox(height: boxHeight),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                GreenButton(
                    buttonText: "中文",
                    onTap: () {
                      _changeLanguage("zh");
                    },
                    disabled: false,
                    buttontype: ButtonType.language),
                GreenButton(
                    buttonText: "தமிழ்",
                    onTap: () {
                      _changeLanguage("ta");
                    },
                    disabled: false,
                    buttontype: ButtonType.language),
              ])
            ],
          ),
        );
      },
    )));
  }
}
