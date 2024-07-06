import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_devices_sdk/view/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_kiosk_software/utils/user_info.dart';

class SummaryBodyComposition extends StatelessWidget {
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
            buildBodyCompositionArea(),
          ],
        ));
  }

  Widget buildBodyCompositionArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildCardTopArea(
              "assets/images/bodycomposition_logo.png",
              AppLocalizations.of(mainContext)!.bcm,
              ColorPalette.colorbodyComposition),
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
                  AppLocalizations.of(mainContext)!.bcm_fat,
                  style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  UserInfo().bodyFatPercentage,
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
                  AppLocalizations.of(mainContext)!.bcm_skeletal,
                  style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  UserInfo().skeletalMusclePercentage,
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
                  AppLocalizations.of(mainContext)!.bcm_metabolism,
                  style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  UserInfo().basalMetabolism,
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
                  AppLocalizations.of(mainContext)!.bcm_visceralfat,
                  style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  UserInfo().visceralFatLevel,
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
                  AppLocalizations.of(mainContext)!.bcm_water,
                  style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  UserInfo().bodyWaterPercentage,
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
                  AppLocalizations.of(mainContext)!.bcm_protein,
                  style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  UserInfo().protein,
                  style: TextStyle(
                      fontSize: dataFontSize,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.materialGreen),
                )
              ],
            ),
          ),
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
