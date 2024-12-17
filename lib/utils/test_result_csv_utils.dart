import 'dart:core';
import 'dart:io';
import 'package:flutter_devices_sdk/log/log_printer.dart';
import 'package:simple_kiosk_software/utils/app_config.dart';
import 'package:simple_kiosk_software/utils/user_info.dart';

// 性别 0:女性 1:男性
class TestResultCsv {
  //表头
  List<String> header = [
    '时间',
    '姓名',
    '年龄',
    '性别',
    '身高(cm)',
    '体重(kg)',
    'BMI',
    '体温(℃)',
    '血压(mmHg)',
    '血氧(%)',
    '体脂率(%)',
    '骨量(kg)',
    '基础代谢(kcal)',
    '内脏脂肪等级',
    '水含量(%)',
    '蛋白率(kg)',
    '肌肉量()',
    '身体年龄',
    '细胞外液(%)',
    '蛋白质(kg)',
    '细胞内液(%)',
    '总水分(kg)',
    '脂肪量(kg)',
    '心率(bpm)',
    'P',
    'PR',
    'QRS',
    'QT',
    'QTc',
    'QRS Axis',
    'P Axis',
    'T Axis'
  ];
  final fileSuffix = '.csv';
  String path = "";

  // 当前时间
  String getNow() {
    DateTime time = DateTime.now();
    String nowLogName = '${time.hour}:${time.minute}:${time.second}';
    return nowLogName;
  }

  // 将表头和测试数据写入CSV文件
  Future<void> writeTestDataToCsv() async {
    path = AppConfig().mainDir;
    //数据列表
    List<String> Rows = [
      getNow(),
      UserInfo().name,
      UserInfo().age,
      UserInfo().gender == 1 ? '男' : '女',
      UserInfo().height,
      UserInfo().weight,
      UserInfo().bmi,
      UserInfo().temperature,
      UserInfo().systolic + '/' + UserInfo().diastolic,
      UserInfo().bloodOxygen,
      UserInfo().bodyFatPercentage,
      UserInfo().boneMass,
      UserInfo().basalMetabolism,
      UserInfo().visceralFatLevel,
      UserInfo().bodyWaterPercentage,
      UserInfo().proteinPercentage,
      UserInfo().muscleMass,
      UserInfo().bodyAge,
      UserInfo().extracellularFluid,
      UserInfo().protein,
      UserInfo().intracellularWaterPercentage,
      UserInfo().totalMoisture,
      UserInfo().bodyFatMass,
      UserInfo().bpHeartRate,
      UserInfo().P_Width,
      UserInfo().PR,
      UserInfo().QRS_Dur,
      UserInfo().QT,
      UserInfo().QTc,
      UserInfo().QRS_Axis,
      UserInfo().P_Axis,
      UserInfo().T_Axis
    ];

    // 获取文件路径
    String filePath = _getFileLogPath(DateTime.now());
    File file = File(filePath);

    // 判断文件是否存在
    bool fileExists = await file.exists();

    // 如果文件不存在，则添加表头
    if (!fileExists) {
      String headerString = header.join(',');
      await file.writeAsString(headerString + '\n', mode: FileMode.write);
    }

    // 追加数据行到文件
    try {
      String rowsString = Rows.join(',');
      await file.writeAsString(rowsString + '\n', mode: FileMode.append);
      print('文件写入成功: $filePath');
    } catch (e) {
      // 捕获并打印异常
      LogPrinter.log('写入文件时发生错误: $e');
    }
  }

  String _getFileLogPath(DateTime time) {
    final nowLogName = '${time.year}-${time.month}-${time.day}$fileSuffix';
    return '$path/$nowLogName';
  }
}
