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
  // 温度
  String temperature = '';

  // 血压
  // 收缩压
  String systolic = '';
  // 舒张压
  String diastolic = '';
  // 心率
  String heartRate = '';

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
    bodyFatMass = '';
    heartRate = '';
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
    return {
      "height": height,
      "weight": weight,
      "temperature": temperature,
      "bloodPressure": "$systolic/$diastolic",
      "bp_pulse": heartRate,
      "bloodOxygen": bloodOxygen,
      "bo_heartrate": spo2HeartRate,
      // "IFCC": IFCC,
      // "eAG": eAG,
      // "chol": chol,
      // "trig": trig,
      // "hdl": hdl,
      // "ldl": ldl,
      "bodyFatPercentage": bodyFatPercentage,
      "boneMass": boneMass,
      "basalMetabolism": basalMetabolism,
      "visceralFatLevel": visceralFatLevel,
      "bodyWaterPercentage": bodyWaterPercentage,
      "proteinPercentage": proteinPercentage,
      "muscleMass": muscleMass,
      "bodyAge": bodyAge,
      "extracellularFluid": extracellularFluid,
      "protein": protein,
      "intracellularWaterPercentage": intracellularWaterPercentage,
      "totalMoisture": totalMoisture,
      "bodyFatMass": bodyFatMass,
      "skeletalMusclePercentage": skeletalMusclePercentage,
      "HR": HR,
      "P_Width": P_Width,
      "PR": PR,
      "QRS_Dur": QRS_Dur,
      "QT": QT,
      "QTc": QTc,
      "QRS_Axis": QRS_Axis,
      "P_Axis": P_Axis,
      "T_Axis": T_Axis,
    };
  }

  // 私有构造函数
  UserInfo._internal();
  // 保存单例
  static final UserInfo _instance = UserInfo._internal();
  // 工厂构造函数
  factory UserInfo() => _instance;
}
