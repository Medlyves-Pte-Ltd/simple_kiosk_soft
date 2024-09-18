import 'dart:convert';

List<VitalReadings> vitalReadingsFromJson(String str) =>
    List<VitalReadings>.from(
        json.decode(str).map((x) => VitalReadings.fromJson(x)));

String vitalReadingsToJson(List<VitalReadings> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VitalReadings {
  dynamic deviceId;
  dynamic appointmentId;
  dynamic observationId;
  DateTime? timestamp;
  num? value;
  dynamic units;
  dynamic id;
  dynamic name;

  VitalReadings({
    this.deviceId,
    this.appointmentId,
    this.observationId,
    this.timestamp,
    this.value,
    this.units,
    this.id,
    this.name,
  });

  factory VitalReadings.fromJson(Map<String, dynamic> json) {
    final Set<int> intDeviceIds = {11, 12, 15, 16, 18, 19, 20, 21, 22};
    /*change double to integer for basal metabolism, visceral fat level, body age, score, systolic
     & diastolic blood pressure, blood pressure heart rate, blood oxygen, blood oxygen heart rate*/
    final deviceId = json["device_id"] as dynamic;
    final isIntegerValue = intDeviceIds.contains(deviceId);
    return VitalReadings(
      deviceId: deviceId,
      appointmentId: json["appointment_id"] as dynamic,
      observationId: json["observation_id"] as dynamic,
      timestamp: DateTime.tryParse(json["timestamp"] as dynamic),
      value: isIntegerValue
          ? (json["value"] as num?)?.toInt()
          : (json["value"] as num?)?.toDouble(),
      units: json["units"] as dynamic,
      id: json["id"] as dynamic,
      name: json["name"] as dynamic,
    );
  }

  Map<String, dynamic> toJson() => {
        "device_id": deviceId,
        "appointment_id": appointmentId,
        "observation_id": observationId,
        "timestamp": timestamp!.toIso8601String(),
        "value": value,
        "units": units,
        "id": id,
        "name": name,
      };
}
