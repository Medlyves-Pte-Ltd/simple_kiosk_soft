import 'dart:convert';
import 'dart:io';
import 'package:flutter_devices_sdk/log/log_printer.dart';
import 'package:flutter_devices_sdk/device_sdk_param_setting.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:simple_kiosk_software/common/common.dart';
import 'package:simple_kiosk_software/utils/body_range.dart';

class AppConfig {
  // 是否使用扫码器
  bool useScanner = false;
  String appVersion = '1.0.0';
  String mainDir = "/sdcard/kiosk";
  String configDir = "";
  String imagesDir = "";
  String videosDir = "";
  String audiosDir = "";
  String logsDir = "";
  String recordDir = "";
  Map<String, dynamic> configMap = {};

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
    return configMap["enable_usb_relay"] as bool;
  }

  set enableUsbRelay(bool value) {
    configMap["enable_usb_relay"] = value;
    saveFile();
  }

  int get usbSequenceCheckTime {
    return configMap["usb_sequence_check_time_s"] as int;
  }

  set usbSequenceCheckTime(int value) {
    configMap["usb_sequence_check_time_s"] = value;
    saveFile();
  }

  // 升降io停止时间
  int get upDownIoStopTime {
    return configMap["up_down_io_stop_time_ms"] as int;
  }

  set upDownIoStopTime(int value) {
    configMap["up_down_io_stop_time_ms"] = value;
    saveFile();
  }

  // 退出时输出测试结果
  bool get testResultOutCsv {
    try {
      return configMap["test_result_out_csv"] as bool;
    } catch (e) {
      return false;
    }
  }

  set testResultOutCsv(bool value) {
    configMap["test_result_out_csv"] = value;
    saveFile();
  }

  Future<void> init() async {
    // 获取版本
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;

    configDir = "$mainDir/configs";
    imagesDir = "$mainDir/images";
    videosDir = "$mainDir/videos";
    audiosDir = "$mainDir/audios";
    logsDir = "$mainDir/logs";
    recordDir = "$mainDir/records";

    // 加载配置文件
    await loadFile();

    // 创建目录
    await createDirectory(logsDir);
    if (testResultOutCsv) {
      await createDirectory(recordDir);
    }
    // 范围
    await BodyRange().loadFile();

    DeviceSdkParamSetting().useSimulateUsbDevice = false;
    DeviceSdkParamSetting().replayIoCount = relayIoCount;
    DeviceSdkParamSetting().configDir = configDir;
    DeviceSdkParamSetting().totalHeight = totalHeight;
    DeviceSdkParamSetting().heightOffset = heightOffset;
    DeviceSdkParamSetting().upDownIoStopTimeInterval = upDownIoStopTime;
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

  // 私有构造函数
  AppConfig._internal();
  // 保存单例
  static final AppConfig _instance = AppConfig._internal();
  // 工厂构造函数
  factory AppConfig() => _instance;
}
