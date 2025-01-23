import 'package:flutter_devices_sdk/view/colors.dart';
import 'package:simple_kiosk_software/blocs/locale/locale_bloc.dart';
import 'package:flutter/material.dart';
import 'package:simple_kiosk_software/common/footer.dart';
import 'package:simple_kiosk_software/common/header.dart';
import 'package:simple_kiosk_software/common/video_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_kiosk_software/utils/app_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_kiosk_software/utils/body_range.dart';
import 'package:simple_kiosk_software/utils/control_measure_page_utils.dart';
import 'package:simple_kiosk_software/utils/user_info.dart';

class UserLoginPage extends StatefulWidget {
  const UserLoginPage({Key? key}) : super(key: key);

  @override
  State<UserLoginPage> createState() => UserLoginPageState();
}

class UserLoginPageState extends State<UserLoginPage> {
  final double spaceBetweenButtons = 15.0;
  final TextEditingController _staffIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String selectedGender = '';
  // 屏幕宽度
  double width = 0;
  // 屏幕高度
  double height = 0;
  String languageCode = "";
  String getVideoFileName() {
    languageCode = BlocProvider.of<LocaleCubit>(context).locale.languageCode;
    return '${AppConfig().videosDir}/$languageCode/login_manual_entry_${languageCode.toUpperCase()}.mp4';
  }

  @override
  void dispose() {
    super.dispose();
    _staffIdController.dispose();
    _nameController.dispose();
    _ageController.dispose();
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
            //const DateTimeSection(),
            const Header(),
            VideoWidget(
                videoName: getVideoFileName(),
                setLooping: false,
                fromFile: true),
            // const Footer(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: width * 0.7,
                child: Column(
                  children: [
                    // Text Field for StaffId
                    TextField(
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                      controller: _staffIdController,
                      textCapitalization: TextCapitalization.none,
                      cursorColor: const Color.fromRGBO(103, 155, 206, 1),
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!
                              .identity_card_number,
                          labelStyle: TextStyle(
                              color: Color.fromRGBO(103, 155, 206, 1),
                              fontSize: height * 0.016),
                          prefixIcon: Icon(
                            Icons.perm_identity,
                            size: height * 0.018,
                          ),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: Color.fromRGBO(103, 155, 206, 1),
                            width: 2.0,
                          ))),
                      style: TextStyle(fontSize: height * 0.02),
                    ),
                    SizedBox(height: height * 0.01),
                    // Text Field for Name
                    TextField(
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      cursorColor: const Color.fromRGBO(103, 155, 206, 1),
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.name,
                          labelStyle: TextStyle(
                              color: Color.fromRGBO(103, 155, 206, 1),
                              fontSize: height * 0.016),
                          prefixIcon: Icon(
                            Icons.person,
                            size: height * 0.018,
                          ),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: Color.fromRGBO(103, 155, 206, 1),
                            width: 2.0,
                          ))),
                      style: TextStyle(fontSize: height * 0.02),
                    ),
                    SizedBox(height: height * 0.02),

                    // Dropdown for Gender
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.gender,
                          labelStyle: TextStyle(
                              color: Color.fromRGBO(103, 155, 206, 1),
                              fontSize: height * 0.02),
                          hintText: 'Select Gender',
                          prefixIcon: Icon(
                            Icons.wc,
                            size: height * 0.018,
                          ),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: Color.fromRGBO(103, 155, 206, 1),
                            width: 2.0,
                          ))),
                      value: selectedGender,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value!;
                        });
                      },
                      items: [
                        "",
                        AppLocalizations.of(context)!.male,
                        AppLocalizations.of(context)!.female
                      ].map((gender) {
                        return DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender,
                              style: TextStyle(fontSize: height * 0.01)),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: height * 0.02),

                    // Text Field for Age
                    TextField(
                      autocorrect: false,
                      controller: _ageController,
                      cursorColor: const Color.fromRGBO(103, 155, 206, 1),
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.print_age,
                          labelStyle: TextStyle(
                            color: Color.fromRGBO(103, 155, 206, 1),
                            fontSize: height * 0.02,
                          ),
                          prefixIcon: Icon(Icons.escalator_warning,
                              size: height * 0.018),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: Color.fromRGBO(103, 155, 206, 1),
                            width: 2.0,
                          ))),
                      style: TextStyle(fontSize: height * 0.016),
                      keyboardType: TextInputType.number,
                    ),

                    SizedBox(height: height * 0.04),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all<Size>(
                        Size(width * 0.22, height * 0.04),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        ColorPalette.materialGreen,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/SelectLoginMethodPage", (route) => false);
                    },
                    child: Text(AppLocalizations.of(context)!.back,
                        style: TextStyle(
                            color: Colors.white, fontSize: height * 0.016))),
                SizedBox(width: width * 0.06),
                ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all<Size>(
                        Size(width * 0.22, height * 0.04),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        ColorPalette.materialGreen,
                      ),
                    ),
                    child: Text(AppLocalizations.of(context)!.next,
                        style: TextStyle(
                            color: Colors.white, fontSize: height * 0.016)),
                    onPressed: () {
                      String staffId = _staffIdController.text.trim();
                      String name = _nameController.text.trim();
                      String gender = selectedGender ?? '';
                      String age = _ageController.text.trim();
                      if (staffId.isNotEmpty &&
                          name.isNotEmpty &&
                          gender.isNotEmpty &&
                          age.isNotEmpty) {
                        UserInfo().patientId = staffId;
                        UserInfo().name = name;
                        UserInfo().gender = gender.contains('男性') ||
                                gender.contains('Male') ||
                                gender.contains('Lelaki') ||
                                gender.contains('ஆண்') ||
                                gender.contains('ชาย')
                            ? 1
                            : 0;
                        UserInfo().age = age;
                        UserInfo().clearResult();
                        BodyRange().init();

                        ControlMeasurePageUtils().pageIndex = 0;
                        ControlMeasurePageUtils().clearMeasure();
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/HeightWeightMeasure', (route) => false);
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(AppLocalizations.of(context)!.error),
                            content: const Text(
                                'Please fill in all required fields.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    }),
              ],
            ),
            const Spacer(),
            Footer(),
          ],
        ),
      ),
    );
  }
}
