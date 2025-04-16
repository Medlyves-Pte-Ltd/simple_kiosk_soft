import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_devices_sdk/log/log_printer.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:simple_kiosk_software/utils/app_config.dart';
import 'package:simple_kiosk_software/utils/user_info.dart';

class ControlMeasurePageUtils {
  int pageIndex = 0;
  List<Map<String, dynamic>> measurelist = [];

  List<dynamic> configList = [
    {"name": "Height Weight", "enable": true},
    {"name": "Body Composition", "enable": true},
    {"name": "Temperature", "enable": true},
    {"name": "Blood Pressure", "enable": true},
    {"name": "Blood Oxygen", "enable": true},
    {"name": "ECG", "enable": true},
    {"name": "Blood Glucose", "enable": false},
    {"name": "Blood Fit", "enable": false},
  ];

  List<Map<String, dynamic>> defaultList = [
    {
      "name": "Height Weight",
      "icon_file": "assets/images/heightweight_logo.png",
      "measured": false,
      "page_route": "/HeightWeightMeasure",
      "color": ColorPalette.colorheightWeight.value,
    },
    {
      "name": "Body Composition",
      "icon_file": "assets/images/bodycomposition_logo.png",
      "measured": false,
      "page_route": "/BodyCompositionMeasure",
      "color": ColorPalette.colorbodyComposition.value,
    },
    {
      "name": "Temperature",
      "icon_file": "assets/images/temperature_icon.png",
      "measured": false,
      "page_route": "/BodyTemperatureMeasure",
      "color": ColorPalette.colorbodytemperature.value,
    },
    {
      "name": "Blood Pressure",
      "icon_file": "assets/images/bloodpressure_logo.png",
      "measured": false,
      "page_route": "/BloodPressureMeasure",
      "color": ColorPalette.colorbloodPressure.value,
    },
    {
      "name": "Blood Oxygen",
      "icon_file": "assets/images/spo2_icon.png",
      "measured": false,
      "page_route": "/BloodOxygenMeasure",
      "color": ColorPalette.colorbloodoxygen.value,
    },
    {
      "name": "ECG",
      "icon_file": "assets/images/ecg.png",
      "measured": false,
      "page_route": "/ECGMeasure",
      "color": ColorPalette.colorEcg.value,
    },
    {
      "name": "Blood Glucose",
      "icon_file": "assets/images/blood_glucose.png",
      "measured": false,
      "page_route": "/BloodGlucoseMeasure",
      "color": ColorPalette.colorbloodGlucose.value,
    },
    {
      "name": "Blood Fit",
      "icon_file": "assets/images/blood_fit.png",
      "measured": false,
      "page_route": "/BloodFitMeasure",
      "color": ColorPalette.colorbloodFat.value,
    },
  ];

  Future<String> load() async {
    String errorInfo = "";
    var file = File('${AppConfig().configDir}/measure_config.json');
    bool exist = await file.exists();
    if (!exist) {
      errorInfo = "${file.path} not exist";
      LogPrinter.log('Error: $errorInfo');
      addMeasureList();
      return errorInfo;
    }

    try {
      String json = await file.readAsString();
      configList = jsonDecode(json);
    } catch (e) {
      addMeasureList();
      LogPrinter.log('Error: $e');
      return 'Error: $e';
    }

    addMeasureList();

    return errorInfo;
  }

  void addMeasureList() {
    measurelist = [];
    for (var item in configList) {
      bool enable = item['enable'] as bool;
      if (!enable) {
        continue;
      }

      String name = item['name'] as String;
      for (var it in defaultList) {
        if (it["name"] == name) {
          measurelist.add(it);
          break;
        }
      }
    }
  }

  String firstMeasurePage() {
    if (measurelist.isNotEmpty) {
      return measurelist.first["page_route"] as String;
    }

    return "/HeightWeightMeasure";
  }

  // 写文件
  Future<String> saveFile() async {
    String text = jsonEncode(configList);

    var file = File('${AppConfig().configDir}/measure_config.json');
    try {
      await file.writeAsString(text);
    } catch (e) {
      LogPrinter.log('Error: $e text:$text');
      return "Error: $e";
    }

    return "";
  }

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
