class UserInfo {
  // 患者ID
  String patientId = '';
  // 姓名
  String name = '';
  // 性别
  String gender = '';
  // 年龄
  String age = '';
  // 身高
  String height = '';
  // 体重
  String weight = '';
  // 收缩压
  String systolic = '';
  // 舒张压
  String diastolic = '';
  // 心率
  String heartRate = '';
  // Body Fat Rate (脂肪率)
  String bodyFatPercentage = '';
  // Body Fat Mass (脂肪量)
  String bodyFatMass = '';
  // Basal Metabolism (基础代谢)
  String basalMetabolism = '';
  // Skeletal Muscle Rate (骨骼肌率)
  String skeletalMusclePercentage = '';
  // Visceral Fat Level (内脏脂肪等级)
  String visceralFatLevel = '';
  // Protein (蛋白质)
  String protein = '';
  // Mineral (无机盐)
  String mineral = '';
  // 血氧
  String bloodOxygen = '';
  String bloodOxygenHeartRate = '';
  // 温度
  String temperature = '';
  // 水分含量
  String bodyWaterPercentage = '';
  // 胆固醇
  String chol = '';
  // 高密度脂蛋白
  String hdl = '';
  // 甘油三酯
  String trig = '';
  // 低密度脂蛋白
  String ldl = '';

  void clearUserInfo() {
    name = '';
    patientId = '';
    gender = '';
    age = '';
  }

  void clearResult() {
    bodyFatPercentage = '';
    ldl = '';
    trig = '';
    hdl = '';
    chol = '';
    bodyWaterPercentage = '';
    temperature = '';
    bloodOxygen = '';
    bloodOxygenHeartRate = '';
    mineral = '';
    protein = '';
    visceralFatLevel = '';
    skeletalMusclePercentage = '';
    basalMetabolism = '';
    bodyFatMass = '';
    heartRate = '';
    height = '';
    weight = '';
    systolic = '';
    diastolic = '';
  }

  // 私有构造函数
  UserInfo._internal();
  // 保存单例
  static final UserInfo _instance = UserInfo._internal();
  // 工厂构造函数
  factory UserInfo() => _instance;
}
