import 'dart:convert';
import 'dart:io';
import 'package:flutter_devices_sdk/kiosk_type.dart';
import 'package:flutter_devices_sdk/log/log_printer.dart';
import 'package:flutter_devices_sdk/device_sdk_param_setting.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:simple_kiosk_software/common/common.dart';
import 'package:simple_kiosk_software/utils/body_range.dart';
import 'package:simple_kiosk_software/remote/config/settings.dart';

class AppConfig {
  String appVersion = '1.0.0';
  //String mainDir = "/storage/emulated/0/kiosk";
  String mainDir = "/sdcard/kiosk";
  String configDir = "";
  String imagesDir = "";
  String videosDir = "";
  String audiosDir = "";
  String logsDir = "";
  Map<String, dynamic> configMap = {};

  Future<void> init() async {
    // 获取版本
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;

    configDir = "$mainDir/configs";
    imagesDir = "$mainDir/images";
    videosDir = "$mainDir/videos";
    audiosDir = "$mainDir/audios";
    logsDir = "$mainDir/logs";

    // 创建目录
    await createDirectory(configDir);
    await createDirectory(imagesDir);
    await createDirectory(videosDir);
    await createDirectory(audiosDir);
    await createDirectory(logsDir);

    // 加载配置文件
    await loadFile();
    // 环境设置
    envSetting();
    // 范围
    await BodyRange().loadFile();

    // 参数设置
    DeviceSdkParamSetting().kioskType = KioskType.values.byName(kioskType);
    DeviceSdkParamSetting().replayIoCount = relayIoCount;
    DeviceSdkParamSetting().configDir = configDir;
    DeviceSdkParamSetting().totalHeight = totalHeight;
    DeviceSdkParamSetting().heightOffset = heightOffset;
  }

  // 环境设置
  void envSetting() {
    String envType = configMap["env_type"];
    host = configMap[envType]["host"];
    firebaseRdbUrl = configMap[envType]["firebaseRdbUrl"];
    firebaseApiKey = configMap[envType]["firebaseApiKey"];
    firebaseAppId = configMap[envType]["firebaseAppId"];
    firebaseMessagingSenderId = configMap[envType]["firebaseMessagingSenderId"];
    firebaseProjectId = configMap[envType]["firebaseProjectId"];
    firebaseStorageBucket = configMap[envType]["firebaseStorageBucket"];
  }

  // 读文件
  Future<String> loadFile() async {
    var file = File('$configDir/app_config.json');
    try {
      String json = await file.readAsString();
      configMap = jsonDecode(json);
    } catch (e) {
      LogPrinter.log('Error: $e');
      return 'Error: $e';
    }
    return "";
  }

  // 写文件
  Future<String> saveFile() async {
    String text = jsonEncode(configMap);
    var file = File('$configDir/app_config.json');
    try {
      await file.writeAsString(text);
    } catch (e) {
      LogPrinter.log('Error: $e');
      return "Error: $e";
    }

    return "";
  }

  String get kioskId {
    return configMap["kiosk_id"] as String;
  }

  set kioskId(String value) {
    configMap["kiosk_id"] = value;
    saveFile();
  }

  String get deviceModel {
    return configMap["device_model"] as String;
  }

  set deviceModel(String value) {
    configMap["device_model"] = value;
    saveFile();
  }

  String get deviceAddress {
    return configMap["device_address"] as String;
  }

  set deviceAddress(String value) {
    configMap["device_address"] = value;
    saveFile();
  }

  String get clientName {
    return configMap["client_name"] as String;
  }

  set clientName(String value) {
    configMap["client_name"] = value;
    saveFile();
  }

  // 是否远程医疗
  bool get enableTC {
    return configMap["enable_tc"] as bool;
  }

  set enableTC(bool value) {
    configMap["enable_tc"] = value;
    saveFile();
  }

  double get totalHeight {
    return configMap["total_height"] as double;
  }

  set totalHeight(double value) {
    configMap["total_height"] = value;
    saveFile();
  }

  double get heightOffset {
    return configMap["height_offset"] as double;
  }

  set heightOffset(double value) {
    configMap["height_offset"] = value;
    saveFile();
  }

  String get kioskType {
    return configMap["kiosk_type"] as String;
  }

  set kioskType(String value) {
    configMap["kiosk_type"] = value;
    saveFile();
  }

  String get envType {
    return configMap["env_type"] as String;
  }

  set envType(String value) {
    configMap["env_type"] = value;
    envSetting();
    saveFile();
  }

  int get relayIoCount {
    return configMap["relay_io_count"] as int;
  }

  set relayIoCount(int value) {
    configMap["relay_io_count"] = value;
    saveFile();
  }

  String get relayCommType {
    return configMap["relay_comm_type"] as String;
  }

  set relayCommType(String value) {
    configMap["relay_comm_type"] = value;
    saveFile();
  }

  // 是否使用usb继电器
  bool get enableUsbRelay {
    return false;
    return configMap["enable_usb_relay"] as bool;
  }

  set enableUsbRelay(bool value) {
    configMap["enable_usb_relay"] = value;
    saveFile();
  }

  // 私有构造函数
  AppConfig._internal();
  // 保存单例
  static final AppConfig _instance = AppConfig._internal();
  // 工厂构造函数
  factory AppConfig() => _instance;
}
