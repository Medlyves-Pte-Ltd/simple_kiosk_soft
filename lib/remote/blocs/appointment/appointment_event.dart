// lib/blocs/appointment_event.dart

part of 'appointment_bloc.dart';

abstract class AppointmentEvent {
  final String kioskId;
  AppointmentEvent({required this.kioskId});
}

class SendStartEvent extends AppointmentEvent {
  final String patientId;

  SendStartEvent({required this.patientId, required kioskId})
      : super(kioskId: kioskId);
}

class GetTeleconsultToken extends AppointmentEvent {
  GetTeleconsultToken({required kioskId}) : super(kioskId: kioskId);
}

class SendStopEvent extends AppointmentEvent {
  SendStopEvent({required kioskId}) : super(kioskId: kioskId);
}

class SendReadyEvent extends AppointmentEvent {
  SendReadyEvent({required kioskId}) : super(kioskId: kioskId);
}
