import 'package:flutter_devices_sdk/run_param_setting.dart';
import 'package:simple_kiosk_software/utils/shared_preferences.dart';

class AppConfig {
  String appVersion = '1.0.0';

  String get kioskId {
    return SharedPreferencesUtil.getString("kioskId",
        defaultValue: "CN-ICD-DEV-1");
  }

  set kioskId(String value) {
    SharedPreferencesUtil.setString("kioskId", value);
  }

  String get deviceModel {
    return SharedPreferencesUtil.getString("deviceModel", defaultValue: "");
  }

  set deviceModel(String value) {
    SharedPreferencesUtil.setString("deviceModel", value);
  }

  String get deviceAddress {
    return SharedPreferencesUtil.getString("deviceAddress", defaultValue: "");
  }

  set deviceAddress(String value) {
    SharedPreferencesUtil.setString("deviceAddress", value);
  }

  String get clientName {
    return SharedPreferencesUtil.getString("clientName", defaultValue: "");
  }

  set clientName(String value) {
    SharedPreferencesUtil.setString("clientName", value);
  }

  // 是否远程医疗
  bool get enableTC {
    return SharedPreferencesUtil.getBool("tc", defaultValue: false);
  }

  set enableTC(bool value) {
    SharedPreferencesUtil.setBool("tc", value);
  }

  double get totalHeight {
    return SharedPreferencesUtil.getDouble("totalHeight", defaultValue: 2.14);
  }

  set totalHeight(double value) {
    SharedPreferencesUtil.setDouble("totalHeight", value);
  }

  // 私有构造函数
  AppConfig._internal();
  // 保存单例
  static final AppConfig _instance = AppConfig._internal();
  // 工厂构造函数
  factory AppConfig() => _instance;
}
