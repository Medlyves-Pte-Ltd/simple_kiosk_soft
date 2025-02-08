import 'dart:convert';
import 'dart:io';
import 'package:flutter_devices_sdk/kiosk_type.dart';
import 'package:flutter_devices_sdk/log/log_printer.dart';
import 'package:flutter_devices_sdk/device_sdk_param_setting.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:simple_kiosk_software/common/common.dart';
import 'package:simple_kiosk_software/utils/app_config.dart';
import 'package:simple_kiosk_software/utils/body_range.dart';
import 'package:simple_kiosk_software/remote/config/settings.dart';

enum HealthScreeningMode {
  // 在线
  online,
  // 脱机
  standalone
}

enum TeleConsultationMode { on, off }

class KioskConfig {
  Map<String, dynamic> configMap = {};

  String get kioskId {
    return configMap["kiosk_id"] as String;
  }

  set kioskId(String value) {
    configMap["kiosk_id"] = value;
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

  HealthScreeningMode healthScreeningMode = HealthScreeningMode.standalone;
  TeleConsultationMode teleConsultationMode = TeleConsultationMode.off;

  Future<void> init() async {
    // 加载配置文件
    await loadFile();
    // 环境设置
    envSetting();

    // 参数设置
    DeviceSdkParamSetting().kioskType = KioskType.values.byName(kioskType);
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
    var file = File('${AppConfig().configDir}/kiosk_config.json');
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

    var file = File('${AppConfig().configDir}/kiosk_config.json');
    try {
      await file.writeAsString(text);
    } catch (e) {
      LogPrinter.log('Error: $e');
      return "Error: $e";
    }

    return "";
  }

  // 私有构造函数
  KioskConfig._internal();
  // 保存单例
  static final KioskConfig _instance = KioskConfig._internal();
  // 工厂构造函数
  factory KioskConfig() => _instance;
}
