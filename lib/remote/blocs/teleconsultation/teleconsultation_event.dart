// teleconsultation_event.dart
part of 'teleconsultation_bloc.dart';

abstract class TeleconsultationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// class TeleconsultationConnectEvent extends TeleconsultationEvent {
//   final String appointment_id;
//   final WebSocketEvent webSocketEvent;

//   TeleconsultationConnectEvent(this.appointment_id, this.webSocketEvent);

//   @override
//   List<Object> get props => [appointment_id];
// }

class StartDeviceEvent extends TeleconsultationEvent {
  final DeviceType deviceType;
  StartDeviceEvent(this.deviceType);
}

class StopDeviceEvent extends TeleconsultationEvent {
  final DeviceType deviceType;
  StopDeviceEvent(this.deviceType);
}

class EndTeleconsultEvent extends TeleconsultationEvent {}

class UnknownEvent extends TeleconsultationEvent {}
