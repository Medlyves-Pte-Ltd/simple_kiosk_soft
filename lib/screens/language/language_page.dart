import 'package:simple_kiosk_software/blocs/locale/locale_bloc.dart';
import 'package:flutter/material.dart';
import 'package:simple_kiosk_software/common/footer.dart';
import 'package:simple_kiosk_software/common/video_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_kiosk_software/screens/language/date_time_section.dart';
import 'package:simple_kiosk_software/utils/app_config.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({Key? key}) : super(key: key);

  @override
  State<LanguagePage> createState() => LanguagePageState();
}

class LanguagePageState extends State<LanguagePage> {
  final double spaceBetweenButtons = 15.0;
  late Locale locale;
  final List<Map<String, String>> languages = [
    {"name": "English", "code": "en"},
    {"name": "中文", "code": "zh"},
    {"name": "ภาษาไทย", "code": "th"},
    // {"name": "Bahasa Melayu", "code": "ms"},
    // {"name": "தமிழ்", "code": "ta"},
  ];

  void _changeLanguage(String code) {
    BlocProvider.of<LocaleCubit>(context).loadLocale(Locale(code));
    Navigator.pushNamedAndRemoveUntil(
        context, '/ScannerPage', ((route) => false));
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
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
              videoName: 'assets/videos/th/welcome_TH.mp4',
              setLooping: true,
            ),
            // const Footer(),
            SizedBox(height: screenHeight * 0.03),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: languages
                    .map((language) => Padding(
                          padding: EdgeInsets.only(bottom: spaceBetweenButtons),
                          child: _buildLanguageButton(
                              language["name"]!, language["code"]!),
                        ))
                    .toList(),
              ),
            )),
            IconButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/KioskManager', ((route) => false));
                },
                icon: Icon(Icons.settings)),
            const Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageButton(String languageName, String languageCode) {
    return ElevatedButton(
      onPressed: () {
        BlocProvider.of<LocaleCubit>(context).loadLocale(Locale(languageCode));
        if (AppConfig().enableTC) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/ScannerPage', ((route) => false));
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, '/login', ((route) => false));
        }
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
