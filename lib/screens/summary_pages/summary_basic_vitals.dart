import 'package:flutter/material.dart';
import 'package:flutter_devices_sdk/view/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_kiosk_software/common/range_widget.dart';
import 'package:simple_kiosk_software/utils/app_config.dart';
import 'package:simple_kiosk_software/utils/body_range.dart';
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          child: ListView(
            children: [
              Offstage(
                offstage: UserInfo().height.isEmpty,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(mainContext)!.hw_height,
                      style: TextStyle(
                          fontSize: titleFontSize, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Offstage(
                offstage: UserInfo().height.isEmpty,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      UserInfo().height,
                      style: TextStyle(
                          fontSize: dataFontSize,
                          fontWeight: FontWeight.bold,
                          color: ColorPalette.materialGreen),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.008),
              Offstage(
                offstage: UserInfo().weight.isEmpty,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(mainContext)!.hw_weight,
                      style: TextStyle(
                          fontSize: titleFontSize, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Offstage(
                offstage: UserInfo().weight.isEmpty,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    rangeSummaryWidget(
                      BodyRange().weightMin.toStringAsFixed(1),
                      BodyRange().weightMax.toStringAsFixed(1),
                      dataFontSize,
                    ),
                    summaryValueChangeColor(
                        UserInfo().weight,
                        BodyRange().weightMin.toStringAsFixed(1),
                        BodyRange().weightMax.toStringAsFixed(1),
                        dataFontSize,
                        true),
                  ],
                ),
              ),
              SizedBox(height: height * 0.008),
              Offstage(
                offstage: UserInfo().bmi.isEmpty,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(mainContext)!.hw_bmi,
                      style: TextStyle(
                          fontSize: titleFontSize, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Offstage(
                offstage: UserInfo().bmi.isEmpty,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    rangeSummaryWidget(
                      BodyRange().bmiMin.toStringAsFixed(1),
                      BodyRange().bmiMax.toStringAsFixed(1),
                      dataFontSize,
                    ),
                    summaryValueChangeColor(
                        UserInfo().bmi,
                        BodyRange().bmiMin.toStringAsFixed(1),
                        BodyRange().bmiMax.toStringAsFixed(1),
                        dataFontSize,
                        true),
                  ],
                ),
              ),
              SizedBox(height: height * 0.008),
              Offstage(
                offstage: UserInfo().temperature.isEmpty,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(mainContext)!.temp_temperature,
                      style: TextStyle(
                          fontSize: titleFontSize, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Offstage(
                offstage: UserInfo().temperature.isEmpty,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    rangeSummaryWidget(
                        BodyRange().temperatureMin.toStringAsFixed(1),
                        BodyRange().temperatureMax.toStringAsFixed(1),
                        dataFontSize),
                    summaryValueChangeColor(
                        UserInfo().temperature,
                        BodyRange().temperatureMin.toStringAsFixed(1),
                        BodyRange().temperatureMax.toStringAsFixed(1),
                        dataFontSize,
                        true),
                  ],
                ),
              ),
              SizedBox(height: height * 0.008),
              Offstage(
                offstage: UserInfo().systolic.isEmpty,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(mainContext)!.bp_bloodpressure,
                      style: TextStyle(
                          fontSize: titleFontSize, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Offstage(
                offstage: UserInfo().systolic.isEmpty,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppConfig().healthReferenceRange
                        ? Text(
                            "( < ${BodyRange().systolicMax}) / ( < ${BodyRange().diastolicMax})",
                            style: TextStyle(
                                fontSize: dataFontSize,
                                color: ColorPalette.materialGreen),
                          )
                        : SizedBox.shrink(),
                    Text(
                      "${UserInfo().systolic}/${UserInfo().diastolic}",
                      style: TextStyle(
                          fontSize: dataFontSize,
                          fontWeight: FontWeight.bold,
                          color: AppConfig().rangeChangeColor &&
                                  UserInfo().systolic.isNotEmpty &&
                                  UserInfo().diastolic.isNotEmpty &&
                                  ((double.parse(UserInfo().systolic) >
                                          BodyRange().systolicMax ||
                                      double.parse(UserInfo().diastolic) >
                                          BodyRange().diastolicMax))
                              ? Colors.red
                              : ColorPalette.materialGreen),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.008),
              Offstage(
                offstage: getPulse().isEmpty,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(mainContext)!.bp_pulse,
                      style: TextStyle(
                          fontSize: titleFontSize, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Offstage(
                offstage: getPulse().isEmpty,
                child: buildPulse(getPulse()),
              ),
              SizedBox(height: height * 0.008),
              Offstage(
                offstage: UserInfo().bloodOxygen.isEmpty,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(mainContext)!.bo_oxygen_staturation,
                      style: TextStyle(
                          fontSize: titleFontSize, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Offstage(
                offstage: UserInfo().bloodOxygen.isEmpty,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    rangeSummaryWidget(BodyRange().spo2Min.toString(),
                        BodyRange().spo2Max.toString(), dataFontSize),
                    summaryValueChangeColor(
                        UserInfo().bloodOxygen,
                        BodyRange().spo2Min.toString(),
                        BodyRange().spo2Max.toString(),
                        dataFontSize,
                        true),
                  ],
                ),
              ),
              // buildBloodGlucoseArea(),
              // buildBloodFitArea(),
            ],
          ),
        ));
  }

  String getPulse() {
    String pulse = "";
    if (UserInfo().HR.isNotEmpty) {
      pulse = UserInfo().HR;
    } else if (UserInfo().bpHeartRate.isNotEmpty) {
      pulse = UserInfo().bpHeartRate;
    } else if (UserInfo().spo2HeartRate.isNotEmpty) {
      pulse = UserInfo().spo2HeartRate;
    }

    return pulse;
  }

  Widget buildPulse(String pulse) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            rangeSummaryWidget(BodyRange().heartRateMin.toString(),
                BodyRange().heartRateMax.toString(), dataFontSize)
          ],
        ),
        summaryValueChangeColor(pulse, BodyRange().heartRateMin.toString(),
            BodyRange().heartRateMax.toString(), dataFontSize, true),
      ],
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
              top: height * 0.01,
              bottom: height * 0.01,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              top: height * 0.01,
              bottom: height * 0.01,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              top: height * 0.01,
              bottom: height * 0.01,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              top: height * 0.01,
              bottom: height * 0.01,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              top: height * 0.01,
              bottom: height * 0.01,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              top: height * 0.01,
              bottom: height * 0.01,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
