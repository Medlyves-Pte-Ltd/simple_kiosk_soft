import 'package:flutter_devices_sdk/device_data/code_scanner_data.dart';
import 'package:flutter_devices_sdk/device_manager.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:flutter_devices_sdk/devices/device_base_model.dart';
import 'package:flutter_devices_sdk/log/log_printer.dart';

class ScannerUtils {
  // 扫码器设备
  DeviceBaseModel? scanner;
  Function? listenData;

  Future<void> connect() async {
    if (scanner != null) {
      return;
    }

    scanner = DeviceManager().getDevice(DeviceType.SCANNER_DEVICE);
    scanner?.onDataReady.listen((event) {
      String data = (event as CodeScannerData).scanner;
      LogPrinter.log("qr code orign data:$data");
      if (listenData != null) {
        listenData!(data);
      }
    });

    await scanner?.connect();
    await scanner?.start();
  }

  Future<void> disconnect() async {
    await scanner?.stop();
    await scanner?.disconnect();
  }

  // 私有构造函数
  ScannerUtils._internal();
  // 保存单例
  static final ScannerUtils _instance = ScannerUtils._internal();
  // 工厂构造函数
  factory ScannerUtils() => _instance;
}
