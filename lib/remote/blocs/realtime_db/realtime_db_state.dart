part of 'realtime_db_bloc.dart';

class RealtimeDbState<T> extends Equatable {
  final String? docPath;
  final T? payload;
  final String? errorMessage;
  const RealtimeDbState({this.payload, this.docPath, this.errorMessage = ''});

  @override
  List<Object> get props =>
      [docPath ?? '', payload ?? Object(), errorMessage ?? ''];

  RealtimeDbState copyWith(
      {String? docPath,
      List<AppointmentNotification>? notifications,
      String? errorMessage}) {
    return RealtimeDbState(
      docPath: docPath ?? this.docPath,
      payload: notifications ?? this.payload,
      errorMessage: errorMessage,
    );
  }
}
