import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:simple_kiosk_software/remote/config/settings.dart';
import 'package:simple_kiosk_software/remote/models/notifications/appointment_notification.dart';
part 'realtime_db_event.dart';
part 'realtime_db_state.dart';

class RealtimeDbBloc extends Bloc<RealtimeDbEvent, RealtimeDbState> {
  RealtimeDbBloc(String? docPath)
      : super(RealtimeDbState(payload: const {}, docPath: docPath)) {
    on<UpdateFailedEvent>(_onUpdateFailedEvent);
    on<DocsUpdatedEvent>(_onDocsUpdatedEvent);
    if (docPath == null) {
      return;
    }
    init(docPath);
  }

  Future<void> init(String docPath) async {
    try {
      final firebaseApp = Firebase.app();
      final rtdb = FirebaseDatabase.instanceFor(
          app: firebaseApp, databaseURL: firebaseRdbUrl);

      final rtdbValues = rtdb.ref("/$docPath");

      rtdbValues.onValue.listen((DatabaseEvent event) {
        add(DocsUpdatedEvent(payload: event.snapshot.value));
      }, onError: (Object error) {
        debugPrint('[RDB] RDB602: RealtimeDB error: ${error.toString()}');
        add(UpdateFailedEvent(
            message: "RDB602 Unexpected error lsitening to realtime updates"));
      });
    } catch (e) {
      debugPrint(
          '[RDB] RDB601 Unexpected error occured subscribing to realtime updates $e');
    }
  }

  Future<void> _onUpdateFailedEvent(
      UpdateFailedEvent event, Emitter<RealtimeDbState> emit) async {
    debugPrint('[RDB] update failed: ${event.message}');
    emit(state.copyWith(errorMessage: event.message));
  }

  Future<void> _onDocsUpdatedEvent(
      DocsUpdatedEvent event, Emitter<RealtimeDbState> emit) async {
    debugPrint('[RDB] document updated: ${event.payload}');
    emit(RealtimeDbState(payload: event.payload));
  }
}
