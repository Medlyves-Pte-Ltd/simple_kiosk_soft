import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class ColorPalette {
  static const Color colorAppBackground = Colors.white;
  static const Color colorAppCardReadingData = Colors.limeAccent;
  static const Color colorAppCardDefaultData = Colors.white;
  static const Color colorDefaultPfp = Color(0xFF936025);
  static const Color colorClientCard = Colors.lightBlue;
  static const Color colorAppButtons = Color(0xFFC69F22);
  static const Color colorAppTheme = Color(0xFF679BCE); //
  static const Color colorClientWithData = Color.fromARGB(255, 122, 122, 121);
  static const primaryButtonColor = Color(0xFF2B71AC);
  static const darkGreyColor = Color(0xFF5a5a5a);
  static const lightBlueColor = Color(0xFFc1dae6);
}

class Margin {
  static double marginComponent = 5.w;
}

class App {
  static const double appVersion = 2.0;
  static const List<String> languages = ["English", "ภาษาไทย", "中文"];
  final List<String> languageCodes = ["en", "th", "zh"];
}

class FontSize {
  static double fontSizeExtraSmall = 5.dp;
  static double fontSizeSmall = 7.dp;
  static double fontSizeStandard = 10.dp;
  static double fontSizeLarge = 20.dp;
  static double fontSizeExtraLarge = 30.dp;
}

class HttpStatus {
  static const String success = "Success";
  static const String noData = "No Data";
  static const String error = "Error";
  static const String defaultErrorMessage = "Internal Server Error";
}

class ErrorCode {
  static const int success = 200;
  static const int badRequest = 400;
  static const int unprocessable = 422;
  static const int conflict = 409;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int internalServerError = 500;
  static const int notFound = 404;
}

class ConfigDirectory {
  static const String kioskConfigDirectory = "assets/configs/kiosks/";
  static const String heightWeightDeviceConfigDirectory =
      "assets/configs/devices/hw_devices/";
  static const String bodyTemperatureDeviceConfigDirectory =
      "assets/configs/devices/temp_devices/";
  static const String bodyCompositionDeviceConfigDirectory =
      "assets/configs/devices/bc_devices/";
  static const String bloodOxygenDeviceConfigDirectory =
      "assets/configs/devices/spo2_devices/";
  static const String bloodPressureDeviceConfigDirectory =
      "assets/configs/devices/bp_devices/";
  static const String ecgDeviceConfigDirectory =
      "assets/configs/devices/ecg_devices/";
  static const String scannerDeviceConfigDirectory =
      "assets/configs/devices/qr_devices/";
  static const String printerDeviceConfigDirectory =
      "assets/configs/devices/printer_devices/";
}
