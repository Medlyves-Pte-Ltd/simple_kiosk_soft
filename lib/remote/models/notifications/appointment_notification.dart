// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

class AppointmentNotification extends Equatable {
  final String? appointment_id;
  final String? creation_datetime;
  final int? device;
  final String? status;
  final String? last_updated;
  final Map<dynamic, dynamic> raw;

  @override
  List<Object> get props => [raw];

  const AppointmentNotification(
      {this.appointment_id,
      this.creation_datetime,
      this.device,
      this.status,
      this.last_updated,
      this.raw = const {}});

  factory AppointmentNotification.fromJson(Map<dynamic, dynamic> json) {
    return AppointmentNotification(
        appointment_id: json['appointment_id'],
        creation_datetime: json['creation_datetime'],
        device: json['device'],
        status: json['status'],
        last_updated: json['last_updated'],
        raw: json);
  }

  Map<dynamic, dynamic> toJson() {
    return raw;
  }
}
