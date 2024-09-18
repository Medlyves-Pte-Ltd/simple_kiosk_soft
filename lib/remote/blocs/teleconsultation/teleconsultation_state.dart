// teleconsultation_state.dart
part of 'teleconsultation_bloc.dart';

class TeleconsultationState extends Equatable {
  final WebSocketEvent socketEvent;
  const TeleconsultationState({this.socketEvent = WebSocketEvent.UNKNOWN});

  @override
  List<Object> get props => [socketEvent];

  TeleconsultationState copyWith({WebSocketEvent? socketEvent}) {
    return TeleconsultationState(
      socketEvent: socketEvent ?? this.socketEvent,
    );
  }
}

class TeleconsultationInitial extends TeleconsultationState {}

class DeviceStarted extends TeleconsultationState {}

class DeviceStopped extends TeleconsultationState {}

class TeleconsultEnded extends TeleconsultationState {}

class UnknownState extends TeleconsultationState {}
