import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:simple_kiosk_software/blocs/device/device_event.dart';
import 'package:simple_kiosk_software/remote/config/settings.dart';
import 'package:simple_kiosk_software/remote/repositories/appointment_repository.dart';
import 'dart:developer';
import 'package:simple_kiosk_software/remote/utils/enum_websocket.dart';
import 'package:simple_kiosk_software/blocs/device/device_bloc.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:simple_kiosk_software/utils/app_config.dart';
import 'package:simple_kiosk_software/utils/kiosk_config.dart';
part 'teleconsultation_event.dart';
part 'teleconsultation_state.dart';

class TeleconsultationBloc
    extends Bloc<TeleconsultationEvent, TeleconsultationState> {
  final DeviceBloc deviceBloc;

  final AppointmentRepository appointmentRepository;

  TeleconsultationBloc(this.deviceBloc, this.appointmentRepository)
      : super(
            const TeleconsultationState(socketEvent: WebSocketEvent.UNKNOWN)) {
    on<StartDeviceEvent>((event, emit) async {
      deviceBloc.add(DeviceConnectEvent(deviceType: event.deviceType));
      emit(DeviceStarted());
    });

    on<StopDeviceEvent>((event, emit) async {
      deviceBloc.add(DeviceStopEvent(deviceType: event.deviceType));
      emit(DeviceStopped());
    });

    on<EndTeleconsultEvent>((event, emit) async {
      try {
        await appointmentRepository.sendStopEvent(KioskConfig().kioskId);
      } catch (_) {
        log('Failed to send stop event to backend');
      } finally {
        emit(TeleconsultEnded());
      }
    });
  }
}
