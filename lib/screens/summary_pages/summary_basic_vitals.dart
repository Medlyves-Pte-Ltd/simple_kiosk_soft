import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_devices_sdk/view/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_kiosk_software/utils/user_info.dart';

class SummaryBasicVitals extends StatelessWidget {
  // 屏幕宽度
  double width = 0;
  // 屏幕高度
  double height = 0;
  double titleFontSize = 0;
  double dataFontSize = 0;
  // StatelessWidget需要保存上下文才能进行页面跳转，翻译
  late BuildContext mainContext;

  @override
  Widget build(BuildContext context) {
    mainContext = context;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    titleFontSize = height * 0.02;
    dataFontSize = height * 0.02;
    return RawScrollbar(
        thumbColor: ColorPalette.darkGrey,
        // 一直显示滑动条
        thumbVisibility: true,
        // 滑动条的宽度
        thickness: 6,
        radius: const Radius.circular(10),
        // 滑动条为true 可拖动
        interactive: true,
        child: ListView(
          children: [
            buildHeightWeightArea(),
            buildTemperatureArea(),
            buildBloodPressureArea(),
            buildBloodOxygenArea(),
            buildBloodGlucoseArea(),
            buildBloodFitArea(),
          ],
        ));
  }

  Widget buildTemperatureArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
      height: height * 0.13,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildCardTopArea(
              "assets/images/temperature_icon.png",
              AppLocalizations.of(mainContext)!.temperature,
              ColorPalette.colorbodytemperature),
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.1,
              right: width * 0.1,
              top: height * 0.01,
              bottom: height * 0.01,
            ),
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(mainContext)!.temp_temperature,
                  style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  UserInfo().temperature,
                  style: TextStyle(
                      fontSize: dataFontSize,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.materialGreen),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildBloodOxygenArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
      height: height * 0.17,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildCardTopArea(
              "assets/images/spo2_icon.png",
              AppLocalizations.of(mainContext)!.bo,
              ColorPalette.colorbloodoxygen),
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.1,
              right: width * 0.1,
              top: height * 0.01,
              bottom: height * 0.01,
            ),
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(mainContext)!.bo_oxygen_staturation,
                  style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  UserInfo().bloodOxygen,
                  style: TextStyle(
                      fontSize: dataFontSize,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.materialGreen),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.1,
              right: width * 0.1,
              top: height * 0.01,
              bottom: height * 0.01,
            ),
            child: Text(
              AppLocalizations.of(mainContext)!.bo_heartrate,
              style: TextStyle(
                  fontSize: titleFontSize, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Widget buildBloodGlucoseArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
      height: height * 0.17,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildCardTopArea(
              "assets/images/blood_glucose.png",
              AppLocalizations.of(mainContext)!.bg,
              ColorPalette.colorbloodGlucose),
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.1,
              right: width * 0.1,
              top: height * 0.01,
              bottom: height * 0.01,
            ),
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(mainContext)!.bg_ifcc,
                  style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  UserInfo().IFCC,
                  style: TextStyle(
                      fontSize: dataFontSize,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.materialGreen),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.1,
              right: width * 0.1,
              top: height * 0.01,
              bottom: height * 0.01,
            ),
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(mainContext)!.bg_bloodglucose,
                  style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  UserInfo().eAG,
                  style: TextStyle(
                      fontSize: dataFontSize,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.materialGreen),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildBloodFitArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
      height: height * 0.3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildCardTopArea("assets/images/blood_fit.png",
              AppLocalizations.of(mainContext)!.bf, ColorPalette.colorbloodFat),
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.1,
              right: width * 0.1,
              top: height * 0.01,
              bottom: height * 0.01,
            ),
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(mainContext)!.bf_totalCholesterol,
                  style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  UserInfo().chol,
                  style: TextStyle(
                      fontSize: dataFontSize,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.materialGreen),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.1,
              right: width * 0.1,
              top: height * 0.01,
              bottom: height * 0.01,
            ),
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(mainContext)!.bf_triglyceride,
                  style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  UserInfo().trig,
                  style: TextStyle(
                      fontSize: dataFontSize,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.materialGreen),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.1,
              right: width * 0.1,
              top: height * 0.01,
              bottom: height * 0.01,
            ),
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(mainContext)!.bf_hgl,
                  style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  UserInfo().hdl,
                  style: TextStyle(
                      fontSize: dataFontSize,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.materialGreen),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.1,
              right: width * 0.1,
              top: height * 0.01,
              bottom: height * 0.01,
            ),
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(mainContext)!.bf_ldl,
                  style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  UserInfo().ldl,
                  style: TextStyle(
                      fontSize: dataFontSize,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.materialGreen),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildBloodPressureArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
      height: height * 0.17,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildCardTopArea(
              "assets/images/bloodpressure_logo.png",
              AppLocalizations.of(mainContext)!.blood_pressure,
              ColorPalette.colorbloodPressure),
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.1,
              right: width * 0.1,
              top: height * 0.01,
              bottom: height * 0.01,
            ),
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(mainContext)!.bp_bloodpressure,
                  style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  "${UserInfo().systolic}/${UserInfo().diastolic}",
                  style: TextStyle(
                      fontSize: dataFontSize,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.materialGreen),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.1,
              right: width * 0.1,
              top: height * 0.01,
              bottom: height * 0.01,
            ),
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(mainContext)!.bp_pulse,
                  style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  UserInfo().heartRate,
                  style: TextStyle(
                      fontSize: dataFontSize,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.materialGreen),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildHeightWeightArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
      height: height * 0.17,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildCardTopArea(
              "assets/images/heightweight_logo.png",
              AppLocalizations.of(mainContext)!.hw,
              ColorPalette.colorheightWeight),
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.1,
              right: width * 0.1,
              top: height * 0.01,
              bottom: height * 0.01,
            ),
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(mainContext)!.hw_height,
                  style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  UserInfo().height,
                  style: TextStyle(
                      fontSize: dataFontSize,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.materialGreen),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.1,
              right: width * 0.1,
              top: height * 0.01,
              bottom: height * 0.01,
            ),
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(mainContext)!.hw_weight,
                  style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  UserInfo().weight,
                  style: TextStyle(
                      fontSize: dataFontSize,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.materialGreen),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // 卡片顶部区域
  Widget buildCardTopArea(String iconFile, String title, Color color) {
    double imageSize = height * 0.05;
    double titleFontSize = height * 0.02;
    return Row(
      children: [
        Image.asset(
          iconFile,
          width: imageSize,
          height: imageSize,
        ),
        SizedBox(width: width * 0.005),
        Padding(
          padding: EdgeInsets.symmetric(vertical: height * 0.01),
          child: IntrinsicWidth(
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: titleFontSize),
                ),
                Container(
                  color: color,
                  height: 1.5,
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
