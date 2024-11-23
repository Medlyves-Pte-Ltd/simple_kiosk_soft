part of 'realtime_db_bloc.dart';

abstract class RealtimeDbEvent<T> {}

class UpdateFailedEvent extends RealtimeDbEvent {
  final String message;
  UpdateFailedEvent({required this.message});
}

class DocsUpdatedEvent<T> extends RealtimeDbEvent<T> {
  final T payload;
  DocsUpdatedEvent({required this.payload});
}
