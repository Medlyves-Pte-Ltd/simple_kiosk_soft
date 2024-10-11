import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:simple_kiosk_software/utils/user_info.dart';
import 'package:flutter_devices_sdk/comm/usb_interface.dart';

class ControlMeasurePageUtils {
  int pageIndex = 0;

  List<Map<String, dynamic>> measurelist = [
    {
      "icon_file": "assets/images/heightweight_logo.png",
      "measured": false,
      "page_route": "/HeightWeightMeasure",
      "color": ColorPalette.colorheightWeight.value,
    },
    {
      "icon_file": "assets/images/temperature_icon.png",
      "measured": false,
      "page_route": "/BodyTemperatureMeasure",
      "color": ColorPalette.colorbodytemperature.value,
    },
    {
      "icon_file": "assets/images/bodycomposition_logo.png",
      "measured": false,
      "page_route": "/BodyCompositionMeasure",
      "color": ColorPalette.colorbodyComposition.value,
    },
    {
      "icon_file": "assets/images/bloodpressure_logo.png",
      "measured": false,
      "page_route": "/BloodPressureMeasure",
      "color": ColorPalette.colorbloodPressure.value,
    },
    {
      "icon_file": "assets/images/spo2_icon.png",
      "measured": false,
      "page_route": "/BloodOxygenMeasure",
      "color": ColorPalette.colorbloodoxygen.value,
    },
    // {
    //   "icon_file": "assets/images/blood_glucose.png",
    //   "measured": false,
    //   "page_route": "/BloodGlucoseMeasure",
    //   "color": ColorPalette.colorbloodGlucose.value,
    // },
    // {
    //   "icon_file": "assets/images/blood_fit.png",
    //   "measured": false,
    //   "page_route": "/BloodFitMeasure",
    //   "color": ColorPalette.colorbloodFat.value,
    // },
    {
      "icon_file": "assets/images/ecg.png",
      "measured": false,
      "page_route": "/ECGMeasure",
      "color": ColorPalette.colorEcg.value,
    },
  ];

  Color get color => Color(ControlMeasurePageUtils()
      .measurelist[ControlMeasurePageUtils().pageIndex]["color"]);

  String get iconFile =>
      ControlMeasurePageUtils().measurelist[ControlMeasurePageUtils().pageIndex]
          ["icon_file"];

  bool get measured =>
      ControlMeasurePageUtils().measurelist[ControlMeasurePageUtils().pageIndex]
          ["measured"] as bool;

  set measured(bool measured) {
    ControlMeasurePageUtils().measurelist[ControlMeasurePageUtils().pageIndex]
        ["measured"] = measured;
  }

  void clearMeasure() {
    for (var it in measurelist) {
      it["measured"] = false;
    }
  }

  void onBackStep(BuildContext context) {
    if (pageIndex > 0) {
      pageIndex--;
      String route = measurelist[pageIndex]["page_route"];
      Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
    } else if (pageIndex == 0) {
      UserInfo().clearUserInfo();
      UserInfo().clearResult();
      pageIndex = 0;
      clearMeasure();
      Navigator.pushNamedAndRemoveUntil(
          context, "/LanguagePage", (route) => false);
    }
  }

  void onNextStep(BuildContext context) {
    if (pageIndex < measurelist.length) {
      pageIndex++;
      String route = measurelist[pageIndex]["page_route"];
      Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
    } else {}
  }

  // 私有构造函数
  ControlMeasurePageUtils._internal();
  // 保存单例
  static final ControlMeasurePageUtils _instance =
      ControlMeasurePageUtils._internal();
  // 工厂构造函数
  factory ControlMeasurePageUtils() => _instance;
}
