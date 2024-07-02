import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_devices_sdk/view/colors.dart';

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
      "icon_file": "assets/images/spo2_icon.png",
      "measured": false,
      "page_route": "/BloodOxygenMeasure",
      "color": ColorPalette.colorbloodoxygen.value,
    },
    {
      "icon_file": "assets/images/heightweight_logo.png",
      "measured": false,
      "page_route": "/HeightWeightMeasure",
      "color": ColorPalette.colorheightWeight.value,
    },
    {
      "icon_file": "assets/images/heightweight_logo.png",
      "measured": false,
      "page_route": "/HeightWeightMeasure",
      "color": ColorPalette.colorheightWeight.value,
    },
    {
      "icon_file": "assets/images/spo2_icon.png",
      "measured": false,
      "page_route": "/BloodOxygenMeasure",
      "color": ColorPalette.colorbloodoxygen.value,
    },
    {
      "icon_file": "assets/images/heightweight_logo.png",
      "measured": false,
      "page_route": "/HeightWeightMeasure",
      "color": ColorPalette.colorheightWeight.value,
    },
    {
      "icon_file": "assets/images/heightweight_logo.png",
      "measured": false,
      "page_route": "/HeightWeightMeasure",
      "color": ColorPalette.colorheightWeight.value,
    }
  ];

  void onBackStep(BuildContext context) {
    if (pageIndex > 0) {
      pageIndex--;
      String route = measurelist[pageIndex]["page_route"];
      Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
    } else if (pageIndex == 0) {
      Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
    }
  }

  void onNextStep(BuildContext context) {
    if (pageIndex < measurelist.length) {
      measurelist[pageIndex]["measured"] = true;
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
