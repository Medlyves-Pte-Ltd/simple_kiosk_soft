import 'dart:convert';
import 'dart:io';
import 'package:flutter_devices_sdk/devices/device_config.dart';
import 'package:flutter_devices_sdk/log/log_printer.dart';
import 'package:flutter_devices_sdk/device_sdk_param_setting.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:simple_kiosk_software/common/common.dart';
import 'package:simple_kiosk_software/utils/body_range.dart';
import 'package:simple_kiosk_software/utils/control_measure_page_utils.dart';

class AppConfig {
  // 是否使用扫码器
  bool useScanner = false;
  String appVersion = '1.0.0';
  String externalStorageDir = "/sdcard";
  String mainDir = "";
  String configDir = "";
  String imagesDir = "";
  String videosDir = "";
  String audiosDir = "";
  String logsDir = "";
  String recordDir = "";
  Map<String, dynamic> configMap = {};

  double get totalHeight {
    try {
      return configMap["total_height"] as double;
    } catch (e) {
      return DeviceSdkParamSetting().totalHeight1;
    }
  }

  set totalHeight(double value) {
    configMap["total_height"] = value;
    DeviceSdkParamSetting().totalHeight1 = value;
    saveFile();
  }

  double get playVolume {
    try {
      return configMap["play_volume"] as double;
    } catch (e) {
      return 1.0;
    }
  }

  set playVolume(double value) {
    configMap["play_volume"] = value;
    saveFile();
  }

  int get relayIoCount {
    return configMap["relay_io_count"] as int;
  }

  set relayIoCount(int value) {
    configMap["relay_io_count"] = value;
    DeviceSdkParamSetting().replayIoCount = value;
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
    DeviceSdkParamSetting().upDownIoStopTimeInterval = value;
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

  // 节能模式
  bool get ecoMode {
    try {
      return configMap["eco_mode"] as bool;
    } catch (e) {
      return false;
    }
  }

  set ecoMode(bool value) {
    configMap["eco_mode"] = value;
    saveFile();
  }

  // 健康参考范围
  bool get healthReferenceRange {
    try {
      return configMap["Health_reference_range"] as bool;
    } catch (e) {
      return false;
    }
  }

  set healthReferenceRange(bool value) {
    configMap["Health_reference_range"] = value;
    saveFile();
  }

  // 测量值超过范围是否改变颜色
  bool get rangeChangeColor {
    try {
      return configMap["range_change_color"] as bool;
    } catch (e) {
      return false;
    }
  }

  set rangeChangeColor(bool value) {
    configMap["range_change_color"] = value;
    saveFile();
  }

  bool get onlyInputLogin {
    try {
      return configMap["only_input_login"] as bool;
    } catch (e) {
      return false;
    }
  }

  set onlyInputLogin(bool value) {
    configMap["only_input_login"] = value;
    saveFile();
  }

  // usb转换器使用的vid-pid
  int get relayUsbConverterVid {
    try {
      return configMap["relay_usb_converter_vid"] as int;
    } catch (e) {
      return 1027;
    }
  }

  set relayUsbConverterVid(int value) {
    configMap["relay_usb_converter_vid"] = value;
    DeviceSdkParamSetting().relayUsbConverterPid = value;
    saveFile();
  }

  int get relayUsbConverterPid {
    try {
      return configMap["relay_usb_converter_pid"] as int;
    } catch (e) {
      return 24577;
    }
  }

  set relayUsbConverterPid(int value) {
    configMap["relay_usb_converter_pid"] = value;
    DeviceSdkParamSetting().relayUsbConverterVid = value;
    saveFile();
  }

  String get relayUsbPath {
    try {
      return configMap["relay_usb_path"] as String;
    } catch (e) {
      return "/dev/bus/usb/002/";
    }
  }

  set relayUsbPath(String value) {
    configMap["relay_usb_path"] = value;
    DeviceSdkParamSetting().relayUsbPath = value;
    saveFile();
  }

  String get relaySerialPath {
    try {
      return configMap["relay_serial_path"] as String;
    } catch (e) {
      return "/dev/ttyS4";
    }
  }

  set relaySerialPath(String value) {
    configMap["relay_serial_path"] = value;
    DeviceSdkParamSetting().relaySerialPath = value;
    saveFile();
  }

  int get ecoModeTimeMinute {
    try {
      return configMap["eco_mode_time_minute"] as int;
    } catch (e) {
      return 5;
    }
  }

  set ecoModeTimeMinute(int value) {
    configMap["eco_mode_time_minute"] = value;
    saveFile();
  }

  int get measureAutomaticStopTimeSecond {
    try {
      return configMap["measure_automatic_stop_time_s"] as int;
    } catch (e) {
      return 90;
    }
  }

  set measureAutomaticStopTimeSecond(int value) {
    configMap["measure_automatic_stop_time_s"] = value;
    saveFile();
  }

  Future<void> init() async {
    // 获取版本
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
    mainDir = "$externalStorageDir/kiosk";
    configDir = "$mainDir/configs";
    imagesDir = "$mainDir/images";
    videosDir = "$mainDir/videos";
    audiosDir = "$mainDir/audios";
    logsDir = "$mainDir/logs";
    recordDir = "$mainDir/records";
    // 创建目录
    await createDirectory(logsDir);
    await createDirectory(recordDir);
    // 日志初始化
    LogPrinter.init(logsDir);
    // 删除ecg缓存数据
    deleteFilesInDirectory("$externalStorageDir/ECGDATA/DATA");
    deleteFilesInDirectory("$externalStorageDir/ECGDATA/RETURN");
    // deleteFilesInDirectory("$externalStorageDir/ECGDATA/LOG");
    // 加载配置文件
    await loadFile();
    // 范围
    await BodyRange().loadFile();
    await ControlMeasurePageUtils().load();

    DeviceSdkParamSetting().relayUsbPath = relayUsbPath;
    DeviceSdkParamSetting().relayUsbConverterVid = relayUsbConverterVid;
    DeviceSdkParamSetting().relayUsbConverterPid = relayUsbConverterPid;
    DeviceSdkParamSetting().relaySerialPath = relaySerialPath;
    DeviceSdkParamSetting().useSimulateUsbDevice = false;
    DeviceSdkParamSetting().replayIoCount = relayIoCount;
    DeviceSdkParamSetting().configDir = configDir;
    DeviceSdkParamSetting().totalHeight1 = totalHeight;
    DeviceSdkParamSetting().upDownIoStopTimeInterval = upDownIoStopTime;
    DeviceSdkParamSetting().relayCommType =
        RelayCommType.values.byName(AppConfig().relayCommType);
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
      LogPrinter.log('Error: $e text:$text');
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
