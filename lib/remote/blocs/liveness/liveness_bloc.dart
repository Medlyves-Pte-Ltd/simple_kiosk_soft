import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_devices_sdk/log/log_printer.dart';
import 'package:simple_kiosk_software/remote/services/api_methods.dart';
import 'package:simple_kiosk_software/remote/services/kiosk_api.dart';
import 'package:simple_kiosk_software/remote/utils/app_constants.dart';
import 'package:simple_kiosk_software/utils/kiosk_config.dart';
part 'liveness_event.dart';
part 'liveness_state.dart';

class LivenessBloc extends Bloc<LivenessEvent, LivenessState> {
  KioskApi api = KioskApi();

  LivenessBloc() : super(const LivenessState(isConnected: false)) {
    const duration = Duration(minutes: 0, seconds: 15);
    Timer.periodic(duration, (Timer _) async {
      dynamic result = await api.pingKiosk(KioskConfig().kioskId);
      if (result is Failure) {
        add(ServerUncontactableEvent(reason: result.errorResponse.toString()));
      } else if (result is Success) {
        add(ServerContactableEvent());
      }
    });
    on<ServerContactableEvent>(_onServerContactableEvent);
    on<ServerUncontactableEvent>(_onServerUncontactableEvent);
  }

  Future<void> _onServerContactableEvent(
      ServerContactableEvent event, Emitter<LivenessState> emit) async {
    emit(const LivenessState(isConnected: true, errorCount: 0));
  }

  Future<void> _onServerUncontactableEvent(
      ServerUncontactableEvent event, Emitter<LivenessState> emit) async {
    int newErrorCount = state.errorCount + 1;
    print('ping kiosk count ${newErrorCount}');
    if (newErrorCount % 5 == 0) {
      LogPrinter.err(
          'Failed to ping kiosk server $newErrorCount consecutive times:\n${event.reason}');
      emit(LivenessState(isConnected: false, errorCount: newErrorCount));
    } else {
      LogPrinter.log('Failed to ping kiosk server\n${event.reason}');
      emit(state.copyWith(errorCount: newErrorCount));
    }
  }
}
