part of 'liveness_bloc.dart';

abstract class LivenessEvent {}

class ServerContactableEvent extends LivenessEvent {}

class ServerUncontactableEvent extends LivenessEvent {
  final String reason;
  ServerUncontactableEvent({required this.reason});
}
