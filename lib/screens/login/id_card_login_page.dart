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
import 'package:flutter_devices_sdk/devices/thai_id_card/thai_card.dart';

class IdCardLoginPage extends StatefulWidget {
  const IdCardLoginPage({Key? key}) : super(key: key);

  @override
  State<IdCardLoginPage> createState() => IdCardLoginPageState();
}

class IdCardLoginPageState extends State<IdCardLoginPage> {
  // 屏幕宽度
  double width = 0;
  // 屏幕高度
  double height = 0;
  ThaiCard thaiCard = ThaiCard();
  String _name = "";
  String _age = "";
  String _genderStr = "";
  int _gender = 1;
  String languageCode = "";

  String getVideoFileName() {
    languageCode = BlocProvider.of<LocaleCubit>(context).locale.languageCode;
    return '${AppConfig().videosDir}/$languageCode/id_card_read_${languageCode.toUpperCase()}.mp4';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 10), () async {
      await thaiCard.getThaiIdCard();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 分割线
  Widget buildDivider() {
    return Divider(
      height: 2.0, // 分隔线高度
      thickness: 1.0, // 分隔线厚度
      color: Colors.grey, // 分隔线颜色
    );
  }

  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        width: width * 0.7,
        child: Column(
          children: [
            SizedBox(height: height * 0.01),
            Row(
              children: [
                Icon(
                  Icons.person,
                  size: height * 0.018,
                ),
                Text(
                  AppLocalizations.of(context)!.name,
                  style: TextStyle(
                      color: Color.fromRGBO(103, 155, 206, 1),
                      fontSize: height * 0.02),
                ),
                SizedBox(width: width * 0.01),
                Expanded(
                    child: Text(
                  _name,
                  style: TextStyle(fontSize: height * 0.016),
                )),
              ],
            ),
            SizedBox(height: height * 0.02),
            buildDivider(),
            SizedBox(height: height * 0.02),
            Row(
              children: [
                Icon(
                  Icons.wc,
                  size: height * 0.018,
                ),
                Text(
                  AppLocalizations.of(context)!.gender,
                  style: TextStyle(
                      color: Color.fromRGBO(103, 155, 206, 1),
                      fontSize: height * 0.02),
                ),
                SizedBox(width: width * 0.01),
                Expanded(
                    child: Text(
                  _genderStr,
                  style: TextStyle(fontSize: height * 0.016),
                )),
              ],
            ),
            SizedBox(height: height * 0.02),
            buildDivider(),
            SizedBox(height: height * 0.02),
            Row(
              children: [
                Icon(
                  Icons.escalator_warning,
                  size: height * 0.018,
                ),
                Text(
                  AppLocalizations.of(context)!.print_age,
                  style: TextStyle(
                      color: Color.fromRGBO(103, 155, 206, 1),
                      fontSize: height * 0.02),
                ),
                SizedBox(width: width * 0.01),
                Expanded(
                    child: Text(
                  _age,
                  style: TextStyle(fontSize: height * 0.016),
                )),
              ],
            ),
            SizedBox(height: height * 0.02),
            buildDivider(),
            SizedBox(height: height * 0.04),
          ],
        ),
      ),
    );
  }

  int calculateAge(int year, int month, int day) {
    var now = DateTime.now();
    var years = now.year - year;
    // var birthdayThisYear = DateTime(now.year, month, day);
    // if (now.isAfter(birthdayThisYear)) {
    //   years++; // 如果今年已经过了生日，年龄要加1
    // }
    return years;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    _name = _age = _genderStr = AppLocalizations.of(context)!.loading;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            const Header(),
            VideoWidget(
                videoName: getVideoFileName(),
                setLooping: false,
                fromFile: true),
            SizedBox(height: height * 0.01),
            ValueListenableBuilder(
                valueListenable: thaiIdCard,
                builder: (context, idcard, child) {
                  if (idcard != null) {
                    var dataMap = idcard.toMap();
                    // 姓名
                    if (languageCode == 'th') {
                      _name =
                          '${dataMap['firstnameTH']} ${dataMap['lastnameTH']}';
                    } else {
                      _name =
                          '${dataMap['firstnameEN']} ${dataMap['lastnameEN']}';
                    }

                    // 年龄
                    List<String> dateList = dataMap['birthdate'].split('-');
                    int age = 0;
                    if (dateList.length == 3) {
                      age = calculateAge(int.parse(dateList[0]),
                          int.parse(dateList[1]), int.parse(dateList[2]));
                    }
                    _age = age.toString();
                    // 性别
                    int? gender = dataMap['gender'];
                    if (gender == 1) {
                      _gender = 1;
                      _genderStr = AppLocalizations.of(context)!.male;
                    } else {
                      _gender = 0;
                      _genderStr = AppLocalizations.of(context)!.female;
                    }
                  }

                  return buildBody();
                }),
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
                      Navigator.pushNamedAndRemoveUntil(context,
                          '/SelectLoginMethodPage', ((route) => false));
                    },
                    child: Text(AppLocalizations.of(context)!.back,
                        style: TextStyle(
                            color: Colors.white, fontSize: height * 0.016))),
                SizedBox(width: width * 0.26),
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
                      String text = AppLocalizations.of(context)!.loading;
                      if (_name != text) {
                        UserInfo().name = _name;
                        UserInfo().gender = _gender;
                        UserInfo().age = _age;
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
                            content: Text(AppLocalizations.of(context)!
                                .please_reinsert_id_card),
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
