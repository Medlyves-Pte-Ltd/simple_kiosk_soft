import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_devices_sdk/view/colors.dart';
import 'package:simple_kiosk_software/common/range_widget.dart';
import 'package:simple_kiosk_software/utils/body_range.dart';
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
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    mainContext = context;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    titleFontSize = height * 0.02;
    dataFontSize = height * 0.02;
    return RawScrollbar(
        controller: _scrollController,
        thumbColor: ColorPalette.darkGrey,
        // 一直显示滑动条
        thumbVisibility: true,
        // 滑动条的宽度
        thickness: 6,
        radius: const Radius.circular(10),
        // 滑动条为true 可拖动
        interactive: true,
        child: ListView(
          controller: _scrollController,
          children: [
            buildBodyCompositionArea(),
          ],
        ));
  }

  Widget buildItem(
      String title, String? data, String min, String max, bool compare) {
    double titleFontSize = height * 0.02;
    double dataFontSize = height * 0.02;
    return Offstage(
      offstage: data!.isEmpty,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: titleFontSize, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              rangeSummaryWidget(min, max, dataFontSize),
              summaryValueChangeColor(data, min, max, dataFontSize, compare),
            ],
          ),
          SizedBox(height: height * 0.008),
        ],
      ),
    );
  }

  Widget buildBodyCompositionArea() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          UserInfo().bodyFatPercentage.isEmpty
              ? SizedBox.shrink()
              : buildItem(
                  AppLocalizations.of(mainContext)!.bcm_fat,
                  UserInfo().bodyFatPercentage,
                  BodyRange().fatRateMin.toString(),
                  BodyRange().fatRateMax.toString(),
                  true),
          UserInfo().basalMetabolism.isEmpty
              ? SizedBox.shrink()
              : buildItem(
                  AppLocalizations.of(mainContext)!.bcm_metabolism,
                  UserInfo().basalMetabolism,
                  BodyRange().basalMetabolismMin.toString(),
                  BodyRange().basalMetabolismMax.toString(),
                  true),
          UserInfo().visceralFatLevel.isEmpty
              ? SizedBox.shrink()
              : buildItem(
                  AppLocalizations.of(mainContext)!.bcm_visceralfat,
                  UserInfo().visceralFatLevel,
                  BodyRange().visceralFatLevelMin.toString(),
                  BodyRange().visceralFatLevelMax.toString(),
                  true),
          UserInfo().boneMass.isEmpty
              ? SizedBox.shrink()
              : buildItem(
                  AppLocalizations.of(mainContext)!.bcm_bone_mass,
                  UserInfo().boneMass,
                  BodyRange().boneMassMin.toStringAsFixed(1),
                  BodyRange().boneMassMax.toStringAsFixed(1),
                  true),
          UserInfo().bodyWaterPercentage.isEmpty
              ? SizedBox.shrink()
              : buildItem(
                  AppLocalizations.of(mainContext)!.bcm_water,
                  UserInfo().bodyWaterPercentage,
                  BodyRange().waterRateMin.toStringAsFixed(1),
                  BodyRange().waterRateMax.toStringAsFixed(1),
                  true),
          UserInfo().bodyAge.isEmpty
              ? SizedBox.shrink()
              : buildItem(AppLocalizations.of(mainContext)!.body_age,
                  UserInfo().bodyAge, "", "", false),
          UserInfo().extracellularFluid.isEmpty
              ? SizedBox.shrink()
              : buildItem(
                  AppLocalizations.of(mainContext)!.bcm_extrac_fluid,
                  UserInfo().extracellularFluid,
                  BodyRange().extracellularWaterRateMin.toStringAsFixed(1),
                  BodyRange().extracellularWaterRateMax.toStringAsFixed(1),
                  true),
          UserInfo().intracellularWaterPercentage.isEmpty
              ? SizedBox.shrink()
              : buildItem(
                  AppLocalizations.of(mainContext)!.bcm_intrac_fluid,
                  UserInfo().intracellularWaterPercentage,
                  BodyRange().intracellularWaterRateMin.toStringAsFixed(1),
                  BodyRange().intracellularWaterRateMax.toStringAsFixed(1),
                  true),
          UserInfo().totalMoisture.isEmpty
              ? SizedBox.shrink()
              : buildItem(
                  AppLocalizations.of(mainContext)!.bcm_moisture,
                  UserInfo().totalMoisture,
                  BodyRange().totalMoistureMin.toStringAsFixed(1),
                  BodyRange().totalMoistureMax.toStringAsFixed(1),
                  true),
          UserInfo().protein.isEmpty
              ? SizedBox.shrink()
              : buildItem(
                  AppLocalizations.of(mainContext)!.bcm_protein,
                  UserInfo().protein,
                  BodyRange().proteinMin.toStringAsFixed(1),
                  BodyRange().proteinMax.toStringAsFixed(1),
                  true),
          UserInfo().bodyFatMass.isEmpty
              ? SizedBox.shrink()
              : buildItem(
                  AppLocalizations.of(mainContext)!.bcm_fatmass,
                  UserInfo().bodyFatMass,
                  BodyRange().bodyFatMassMin.toStringAsFixed(1),
                  BodyRange().bodyFatMassMax.toStringAsFixed(1),
                  true),
          UserInfo().skeletalMusclePercentage.isEmpty
              ? SizedBox.shrink()
              : buildItem(
                  AppLocalizations.of(mainContext)!.bcm_skeletal,
                  UserInfo().skeletalMusclePercentage,
                  BodyRange().skeletalRateMin.toStringAsFixed(1),
                  BodyRange().skeletalRageMax.toStringAsFixed(1),
                  true),
          UserInfo().proteinPercentage.isEmpty
              ? SizedBox.shrink()
              : buildItem(
                  AppLocalizations.of(mainContext)!.bcm_protein_percentage,
                  UserInfo().proteinPercentage,
                  BodyRange().proteinRateMin.toStringAsFixed(1),
                  BodyRange().proteinRateMax.toStringAsFixed(1),
                  true),
          UserInfo().muscleMass.isEmpty
              ? SizedBox.shrink()
              : buildItem(
                  AppLocalizations.of(mainContext)!.bcm_muscle_mass,
                  UserInfo().muscleMass,
                  BodyRange().muscleMassMin.toStringAsFixed(1),
                  BodyRange().muscleMassMax.toStringAsFixed(1),
                  true),
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
