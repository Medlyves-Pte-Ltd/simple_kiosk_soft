import 'dart:convert';
import 'dart:io';

import 'package:flutter_devices_sdk/log/log_printer.dart';

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
