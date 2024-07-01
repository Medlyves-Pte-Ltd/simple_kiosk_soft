import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_kiosk_software/common/buttons.dart';
import 'package:simple_kiosk_software/common/dropdown_field.dart';
import 'package:simple_kiosk_software/common/header_text.dart';
import 'package:simple_kiosk_software/common/layouts/layout1.dart';
import 'package:simple_kiosk_software/common/layouts/layout2.dart';
import 'package:simple_kiosk_software/common/login_textfield.dart';
import 'package:simple_kiosk_software/common/video_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:simple_kiosk_software/providers/locale_provider.dart';
import 'package:simple_kiosk_software/utils/storage_utils.dart';
import 'package:provider/provider.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({Key? key}) : super(key: key);

  @override
  State<UserLogin> createState() => UserLoginState();
}

class UserLoginState extends State<UserLogin> {
  final StorageUtils userDetailsrepo = StorageUtils();
  Map<String, String> userDetails = {
    'patientId': '',
    'gender': '', // Assuming gender is selected from the drop-down
    'age': '', // Assuming age is entered in the text field
  };
  String getVideoFileName() {
    // final videoName = Provider.of<LocaleProvider>(context, listen: false);
    // String localeCode = videoName.locale.languageCode;
    // String basePath = 'assets/videos';
    // String upperLocaleCode = localeCode.toUpperCase();
    //
    // String videoFileName = 'welcome_$upperLocaleCode.mp4';
    // String fullPath = '$basePath/$localeCode/$videoFileName';

    return "assets/videos/zh/welcome_ZH.mp4";
  }

  bool _buttonEnabled = false;
  void backButtonEnabled(bool isInitialised) {
    setState(() {
      _buttonEnabled = isInitialised;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    double boxHeight = screenHeight * 0.0365;
    double topPadding = screenHeight * 0.033;
    double boxHeight1 = screenHeight * 0.0465;
    Locale currentLocale = Localizations.localeOf(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Layout1(
            content1: Content1Body(
          stage: StageType.measurement,
          videoSpace: VideoWidget(
            key: ValueKey(getVideoFileName()),
            videoName: getVideoFileName(),
            setLooping: true,
            onVideoInitialised: backButtonEnabled,
          ),
          content2Builder: (context) {
            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: SizedBox(
                width: screenWidth * 0.95,
                height: screenHeight,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: topPadding),
                          child: HeaderText(
                              text: AppLocalizations.of(context)!.welc),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          right: currentLocale.languageCode == 'ta'
                              ? screenWidth * 0.12
                              : screenWidth * 0.14),
                      child: Column(
                        children: [
                          SizedBox(height: topPadding),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                LoginTextField(
                                    textfieldType: TextFieldLabel.patientId,
                                    onChanged: (value) {
                                      userDetails['patientId'] = value;
                                    })
                              ]),
                          SizedBox(height: boxHeight),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                LoginTextField(
                                    textfieldType: TextFieldLabel.age,
                                    onChanged: (value) {
                                      userDetails['age'] = value;
                                    })
                              ]),
                          SizedBox(height: topPadding),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                DropDownField(
                                  label: GenderLabel.gender,
                                  onChanged: (value) {
                                    setState(() {
                                      userDetails['gender'] = value!;
                                      SystemChrome.setEnabledSystemUIMode(
                                          SystemUiMode.manual,
                                          overlays: []);
                                    });
                                  },
                                )
                              ]),
                        ],
                      ),
                    ),
                    SizedBox(height: boxHeight1),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GreenButton(
                              buttonText:
                                  AppLocalizations.of(context)!.getstarted,
                              onTap: () async {
                                await StorageUtils.saveData(userDetails);
                                if (context.mounted) {
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      '/measurement', (route) => false);
                                }
                              },
                              disabled:
                                  handleDisableGetStartedButton(userDetails),
                              buttontype: ButtonType.getstarted),
                        ])
                  ],
                ),
              ),
            );
          },
        )));
  }

  bool handleDisableGetStartedButton(Map<String, String> userDetails) {
    bool anyFieldEmpty =
        userDetails.values.any((value) => value.toString().isEmpty);
    return anyFieldEmpty;
  }
}
