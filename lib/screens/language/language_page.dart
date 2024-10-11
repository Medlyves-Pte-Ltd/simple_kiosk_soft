import 'package:provider/provider.dart';
import 'package:simple_kiosk_software/blocs/locale/locale_bloc.dart';
import 'package:flutter/material.dart';
import 'package:simple_kiosk_software/common/buttons.dart';
import 'package:simple_kiosk_software/common/header_text.dart';
import 'package:simple_kiosk_software/common/layouts/layout1.dart';
import 'package:simple_kiosk_software/common/layouts/layout2.dart';
import 'package:simple_kiosk_software/common/video_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({Key? key}) : super(key: key);

  @override
  State<LanguagePage> createState() => LanguagePageState();
}

class LanguagePageState extends State<LanguagePage> {
  final double spaceBetweenButtons = 25.0;
  late Locale locale;
  final List<Map<String, String>> languages = [
    {"name": "English", "code": "en"},
    {"name": "中文", "code": "zh"},
    // {"name": "Bahasa Melayu", "code": "ms"},
    // {"name": "தமிழ்", "code": "ta"},
    {"name": "ภาษาไทย", "code": "th"},
  ];

  void _changeLanguage(String code) {
    BlocProvider.of<LocaleCubit>(context).loadLocale(Locale(code));
    Navigator.pushNamedAndRemoveUntil(
        context, '/ScannerPage', ((route) => false));
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
      videoSpace: VideoWidget(
        videoName: 'assets/videos/language_selection.mp4',
        setLooping: true,
      ),
      content2Builder: (context) {
        return Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.05),
          child: Column(
            children: languages
                .map((language) => Padding(
                      padding: EdgeInsets.only(bottom: spaceBetweenButtons),
                      child: _buildLanguageButton(
                          language["name"]!, language["code"]!),
                    ))
                .toList(),
          ),
        );
      },
    )));
  }

  Widget _buildLanguageButton(String languageName, String languageCode) {
    return ElevatedButton(
      onPressed: () {
        BlocProvider.of<LocaleCubit>(context).loadLocale(Locale(languageCode));
        Navigator.pushNamedAndRemoveUntil(
            context, '/ScannerPage', ((route) => false));
      },
      style: _getButtonStyle(),
      child: Text(languageName, style: _getFontStyle()),
    );
  }

  ButtonStyle _getButtonStyle() {
    return ButtonStyle(
      surfaceTintColor: MaterialStateProperty.all<Color>(
          const Color.fromARGB(255, 214, 209, 209)),
      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
      padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
      elevation: MaterialStateProperty.all<double>(5),
      shadowColor: MaterialStateProperty.all<Color>(Colors.grey),
      minimumSize: MaterialStateProperty.all(const Size(320.0, 40.0)),
    );
  }

  TextStyle _getFontStyle() {
    return const TextStyle(fontSize: 17, fontWeight: FontWeight.bold);
  }
}
