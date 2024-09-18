class Appointment {
  final String id;
  final String mode;
  final String patientId;
  final String patientName;

  Appointment(
      {required this.id,
      required this.mode,
      required this.patientId,
      required this.patientName});

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      mode: json['mode'],
      patientId: json['patient_id'],
      patientName: json['patient_name'],
    );
  }
}
