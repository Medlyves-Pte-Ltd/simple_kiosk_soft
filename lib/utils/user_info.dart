class UserInfo {
  // 是否远程医疗
  bool teleconsultation = true;
  // 患者ID
  String patientId = '';
  // 姓名
  String name = '';
  // 性别 0:女性 1:男性
  int gender = 1;
  // 年龄
  String age = '';
  // 身高 cm
  String height = '';
  // 体重 kg
  String weight = '';
  // bmi
  String bmi = '';
  // 温度
  String temperature = '';

  // 血压
  // 收缩压
  String systolic = '';
  // 舒张压
  String diastolic = '';
  // 心率
  String bpHeartRate = '';

  // 血氧
  String bloodOxygen = '';
  String spo2HeartRate = "";
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

  // Mineral (无机盐)
  String mineral = '';

  // 血脂
  // 胆固醇
  String chol = '';
  // 高密度脂蛋白
  String hdl = '';
  // 甘油三酯
  String trig = '';
  // 低密度脂蛋白
  String ldl = '';

  // 血糖
  // 糖化血红蛋白
  String IFCC = '';
  // 平均血糖
  String eAG = '';

  // 心电图数据
  String HR = '';
  String P_Width = '';
  String PR = '';
  String QRS_Dur = '';
  String QT = '';
  String QTc = "";
  String QRS_Axis = "";
  String P_Axis = "";
  String T_Axis = "";
  String RR = "";
  String Conclusion = "";
  String ResultImage = "";

  void clearUserInfo() {
    name = '';
    patientId = '';
    gender = 1;
    age = '';
  }

  void clearResult() {
    bmi = "";
    extracellularFluid = "";
    bodyAge = "";
    bodyFatPercentage = '';
    intracellularWaterPercentage = "";
    totalMoisture = "";
    protein = "";
    skeletalMusclePercentage = "";
    bodyFatMass = "";
    muscleMass = '';
    ldl = '';
    trig = '';
    hdl = '';
    chol = '';
    bodyWaterPercentage = '';
    temperature = '';
    bloodOxygen = '';
    spo2HeartRate = "";
    mineral = '';
    visceralFatLevel = '';
    basalMetabolism = '';
    bpHeartRate = '';
    height = '';
    weight = '';
    systolic = '';
    diastolic = '';
    IFCC = '';
    eAG = '';
    proteinPercentage = '';
    boneMass = '';
    HR = '';
    P_Width = '';
    PR = '';
    QRS_Dur = '';
    QT = '';
    QTc = "";
    QRS_Axis = "";
    P_Axis = "";
    T_Axis = "";
    RR = "";
    Conclusion = "";
    ResultImage = "";
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    if (height.isNotEmpty) {
      map["height"] = height;
    }
    if (weight.isNotEmpty) {
      map["weight"] = weight;
    }
    if (bmi.isNotEmpty) {
      map["bmi"] = bmi;
    }
    if (temperature.isNotEmpty) {
      map["temperature"] = temperature;
    }
    if (systolic.isNotEmpty && diastolic.isNotEmpty) {
      map["bloodPressure"] = "$systolic / $diastolic";
    }
    if (bloodOxygen.isNotEmpty) {
      map["bloodOxygen"] = bloodOxygen;
    }
    if (IFCC.isNotEmpty) {
      map["IFCC"] = IFCC;
    }
    if (eAG.isNotEmpty) {
      map["eAG"] = eAG;
    }
    if (chol.isNotEmpty) {
      map["chol"] = chol;
    }
    if (trig.isNotEmpty) {
      map["trig"] = trig;
    }
    if (hdl.isNotEmpty) {
      map["hdl"] = hdl;
    }
    if (ldl.isNotEmpty) {
      map["ldl"] = ldl;
    }
    if (bodyFatPercentage.isNotEmpty) {
      map["bodyFatPercentage"] = bodyFatPercentage;
    }
    if (boneMass.isNotEmpty) {
      map["boneMass"] = boneMass;
    }
    if (basalMetabolism.isNotEmpty) {
      map["basalMetabolism"] = basalMetabolism;
    }
    if (visceralFatLevel.isNotEmpty) {
      map["visceralFatLevel"] = visceralFatLevel;
    }
    if (bodyWaterPercentage.isNotEmpty) {
      map["bodyWaterPercentage"] = bodyWaterPercentage;
    }
    if (proteinPercentage.isNotEmpty) {
      map["proteinPercentage"] = proteinPercentage;
    }
    if (muscleMass.isNotEmpty) {
      map["muscleMass"] = muscleMass;
    }
    if (bodyAge.isNotEmpty) {
      map["bodyAge"] = bodyAge;
    }
    if (extracellularFluid.isNotEmpty) {
      map["extracellularFluid"] = extracellularFluid;
    }
    if (protein.isNotEmpty) {
      map["protein"] = protein;
    }
    if (intracellularWaterPercentage.isNotEmpty) {
      map["intracellularWaterPercentage"] = intracellularWaterPercentage;
    }
    if (totalMoisture.isNotEmpty) {
      map["totalMoisture"] = totalMoisture;
    }
    if (bodyFatMass.isNotEmpty) {
      map["bodyFatMass"] = bodyFatMass;
    }

    // 没有骨骼肌率
    // if (skeletalMusclePercentage.isNotEmpty) {
    //   map["skeletalMusclePercentage"] = skeletalMusclePercentage;
    // }

    if (HR.isNotEmpty) {
      map["bp_pulse"] = HR;
    } else if (bpHeartRate.isNotEmpty) {
      map["bp_pulse"] = bpHeartRate;
    } else if (spo2HeartRate.isNotEmpty) {
      map["bp_pulse"] = spo2HeartRate;
    }

    if (P_Width.isNotEmpty) {
      map["P_Width"] = P_Width;
    }
    if (PR.isNotEmpty) {
      map["PR"] = PR;
    }
    if (QRS_Dur.isNotEmpty) {
      map["QRS_Dur"] = QRS_Dur;
    }
    if (QT.isNotEmpty) {
      map["QT"] = QT;
    }
    if (QTc.isNotEmpty) {
      map["QTc"] = QTc;
    }
    if (QRS_Axis.isNotEmpty) {
      map["QRS_Axis"] = QRS_Axis;
    }
    if (P_Axis.isNotEmpty) {
      map["P_Axis"] = P_Axis;
    }
    if (T_Axis.isNotEmpty) {
      map["T_Axis"] = T_Axis;
    }
    return map;
  }

  // 私有构造函数
  UserInfo._internal();
  // 保存单例
  static final UserInfo _instance = UserInfo._internal();
  // 工厂构造函数
  factory UserInfo() => _instance;
}
