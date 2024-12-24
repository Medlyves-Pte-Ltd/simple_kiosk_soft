import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:flutter_devices_sdk/devices/device_config.dart';
import 'package:simple_kiosk_software/blocs/device/debug_device_bloc.dart';
import 'package:simple_kiosk_software/blocs/device/device_event.dart';

Future<void> createDirectory(String path) async {
  try {
    // 检查目录是否存在
    if (!await Directory(path).exists()) {
      // 如果不存在，则创建目录
      await Directory(path).create(recursive: true);
      print('Directory created at $path');
    } else {
      print('Directory already exists at $path');
    }
  } catch (e) {
    // 处理异常情况
    print('Error creating directory: $e');
  }
}

// List里面存储的是Map对象时遍历每一个对象，一定要调用Map.from(item)方法才会深拷贝
// When traversing each Map object stored in the List, it is necessary to call the Map. from (item) method to make a deep copy
List copyWithList(List list) {
  List copyList = [];
  for (var item in list) {
    if (item is Map) {
      // Map中如果有list， 需要先转换成json, 才能拷贝完全.
      // If there is a list in the Map, it needs to be converted to JSON first before it can be fully copied
      var json = jsonEncode(item);
      copyList.add(Map.from(jsonDecode(json)));
    } else if (item is List) {
      copyList.add(copyWithList(item));
    } else {
      copyList.add(item);
    }
  }
  return copyList;
}

// 打开扫码器
bool startScanner(BuildContext context) {
  if (DeviceConfig().deviceEnable(DeviceType.SCANNER_DEVICE)) {
    // autoStop 不会自动关闭扫码器
    DeviceConnectEvent connectEvent = DeviceConnectEvent(
        deviceType: DeviceType.SCANNER_DEVICE, autoStop: false);
    BlocProvider.of<DeviceBloc>(context).add(connectEvent);
    return true;
  }
  return false;
}

// 关闭扫码器
void stopScanner(BuildContext context) {
  if (DeviceConfig().deviceEnable(DeviceType.SCANNER_DEVICE)) {
    DeviceStopEvent stopEvent =
        DeviceStopEvent(deviceType: DeviceType.SCANNER_DEVICE);
    BlocProvider.of<DeviceBloc>(context).add(stopEvent);
  }
}
