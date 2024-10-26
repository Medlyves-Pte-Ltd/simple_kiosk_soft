import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:simple_kiosk_software/utils/user_info.dart';

class BodyRange {
  Map<String, dynamic> rangeMap = {};
  void init() async {
    String? json =
        await rootBundle.loadString("assets/configs/result_range.json");
    rangeMap = UserInfo().gender == 1
        ? jsonDecode(json)["male"]
        : jsonDecode(json)["female"];
  }

  // 标准体重
  double standWeight = 0;
  // 实际体重
  double actualWeight = 0;
  // 计算标准体重
  void calculateStandWeight() {
    actualWeight = double.parse(UserInfo().height) / 100.0;
    standWeight =
        (rangeMap["stand_weight"] as int) * actualWeight * actualWeight;
  }

  double get weightMin {
    if (UserInfo().height.isEmpty) {
      return 0;
    }
    double height = double.parse(UserInfo().height) / 100.0;
    return (rangeMap["weight_min"] as double) * height * height;
  }

  double get weightMax {
    if (UserInfo().height.isEmpty) {
      return 0;
    }
    double height = double.parse(UserInfo().height) / 100.0;
    return (rangeMap["weight_max"] as double) * height * height;
  }

  double get temperatureMin {
    return (rangeMap["temperature_min"] as double);
  }

  double get temperatureMax {
    return (rangeMap["temperature_max"] as double);
  }

  double get muscleMassMin {
    return (rangeMap["muscle_mass_min"] as double) * standWeight;
  }

  double get muscleMassMax {
    return (rangeMap["muscle_mass_max"] as double) * standWeight;
  }

  double get waterRateMin {
    return (rangeMap["water_rate_min"] as double);
  }

  double get waterRateMax {
    return (rangeMap["water_rate_max"] as double);
  }

  double get boneMassMin {
    return (rangeMap["bone_mass_min"] as double) * standWeight;
  }

  double get boneMassMax {
    return (rangeMap["bone_mass_max"] as double) * standWeight;
  }

  int get fatRateMin {
    return (rangeMap["fat_rate_min"] as int);
  }

  int get fatRateMax {
    return (rangeMap["fat_rate_max"] as int);
  }

  double get extracellularWaterRateMin {
    return (rangeMap["extracellular_water_rate_min"] as double) * standWeight;
  }

  double get extracellularWaterRateMax {
    return (rangeMap["extracellular_water_rate_max"] as double) * standWeight;
  }

  double get proteinRateMin {
    return (rangeMap["protein_rate_min"] as double) *
        standWeight /
        actualWeight;
  }

  double get proteinRateMax {
    return (rangeMap["protein_rate_max"] as double) *
        standWeight /
        actualWeight;
  }

  int get visceralFatLevelMin {
    return (rangeMap["visceral_fat_level_min"] as int);
  }

  int get visceralFatLevelMax {
    return (rangeMap["visceral_fat_level_max"] as int);
  }

  int get basalMetabolismMin {
    return (rangeMap["basal_metabolism_min"] as int);
  }

  int get basalMetabolismMax {
    return (rangeMap["basal_metabolism_max"] as int);
  }

  double get skeletalRateMin {
    return (rangeMap["skeletal_rate_min"] as double);
  }

  double get skeletalRageMax {
    return (rangeMap["skeletal_rage_max"] as double);
  }

  double get bodyFatMassMin {
    return (rangeMap["body_fat_mass_min"] as double) * standWeight;
  }

  double get bodyFatMassMax {
    return (rangeMap["body_fat_mass_max"] as double) * standWeight;
  }

  double get totalMoistureMin {
    return (rangeMap["total_moisture_min"] as double) * standWeight;
  }

  double get totalMoistureMax {
    return (rangeMap["total_moisture_max"] as double) * standWeight;
  }

  double get proteinMin {
    return (rangeMap["protein_min"] as double) * standWeight;
  }

  double get proteinMax {
    return (rangeMap["protein_max"] as double) * standWeight;
  }

  double get intracellularWaterRateMin {
    return (rangeMap["intracellular_water_rate_min"] as double) * standWeight;
  }

  double get intracellularWaterRateMax {
    return (rangeMap["intracellular_water_rate_max"] as double) * standWeight;
  }

  int get spo2Min {
    return (rangeMap["spo2_min"] as int);
  }

  int get spo2Max {
    return (rangeMap["spo2_max"] as int);
  }

  int get heartRateMin {
    return (rangeMap["heart_rate_min"] as int);
  }

  int get heartRateMax {
    return (rangeMap["heart_rate_max"] as int);
  }

  int get systolicMax {
    return (rangeMap["systolic_max"] as int);
  }

  int get diastolicMax {
    return (rangeMap["diastolic_max"] as int);
  }

  // 私有构造函数
  BodyRange._internal();
  // 保存单例
  static final BodyRange _instance = BodyRange._internal();
  // 工厂构造函数
  factory BodyRange() => _instance;
}
