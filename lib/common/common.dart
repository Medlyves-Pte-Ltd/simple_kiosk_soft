import 'dart:io';

import 'package:flutter_devices_sdk/utils/app_constants.dart';

Future<void> createDirectory(String path) async {
  try {
    // 检查目录是否存在
    if (!await Directory(path).exists()) {
      // 如果不存在，则创建目录
      await Directory(path).create(recursive: true);
      LogPrinter.log('Directory created at $path');
    } else {
      LogPrinter.log('Directory already exists at $path');
    }
  } catch (e) {
    // 处理异常情况
    LogPrinter.log('Error creating directory: $e');
  }
}
