import 'dart:core';
import 'dart:io';
import 'package:flutter_devices_sdk/log/log_printer.dart';
import 'package:simple_kiosk_software/utils/app_config.dart';
import 'package:simple_kiosk_software/utils/user_info.dart';

// 人体成分
// Body Fat Rate (脂肪率) %
String bodyFatPercentage = '';
// 水分含量 %
String bodyWaterPercentage = '';
// 肌肉量 kg
String muscleMass = ''; //
// 骨量 kg
String boneMass = "";
// Basal Metabolism (基础代谢)
String basalMetabolism = '';
// Visceral Fat Level (内脏脂肪等级)
String visceralFatLevel = '';
// 身体年龄
String bodyAge = ""; //
// Protein Rate (蛋白质率) %
String proteinPercentage = '';
// Extracellular Water Rate (细胞外液率) %
String extracellularFluid = ''; //
// Protein (蛋白质)
String protein = '';
// Intracellular Water Rate (细胞内液率)
String intracellularWaterPercentage = '';
// Total moisture (总水分)
String totalMoisture = '';
// Body Fat Mass (脂肪量)
String bodyFatMass = '';
// Skeletal Muscle Rate (骨骼肌率)
String skeletalMusclePercentage = '';

// 性别 0:女性 1:男性
class TestResultCsv {
  //表头
  List<String> header = [
    'Time',
    'Name',
    'Age',
    'Gender',
    'Height(cm)',
    'Weight(kg)',
    'BMI',
    'Temperature(℃)',
    'BloodPressure(mmHg)',
    'BloodOxygen(%)',
    'BodyFatRate(%)',
    'BoneMass(kg)',
    'BasalMetabolism(kcal)',
    'VisceralFatLevel',
    'BodyWaterRate(%)',
    'ProteinRate(kg)',
    'MuscleMass(kg)',
    'BodyAge',
    'ExtracellularFluidRate(%)',
    'Protein(kg)',
    'IntracellularWaterRate(%)',
    'TotalMoisture(kg)',
    'FatMass(kg)',
    'HeartRate(bpm)',
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
    path = AppConfig().recordDir;
    //数据列表
    List<String> Rows = [
      getNow(),
      UserInfo().name,
      UserInfo().age,
      UserInfo().gender == 1 ? 'Male' : 'Female',
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
