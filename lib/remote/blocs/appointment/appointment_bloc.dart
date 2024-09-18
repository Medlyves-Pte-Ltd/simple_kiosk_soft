import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_kiosk_software/remote/repositories/appointment_repository.dart';
import 'package:simple_kiosk_software/remote/models/tc_room_details.dart';
import 'package:simple_kiosk_software/remote/models/appointment.dart';
import 'package:simple_kiosk_software/remote/utils/exceptions/medlyves_exception.dart';
part 'appointment_event.dart';
part 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final AppointmentRepository appointmentRepository;

  AppointmentBloc(this.appointmentRepository) : super(AppointmentInitial()) {
    on<SendStartEvent>(_onSendStartEvent);
    on<GetTeleconsultToken>(_onGetTeleconsultToken);
    on<SendStopEvent>(_onSendStopEvent);
    on<SendReadyEvent>(_onSendReadyEvent);
  }

  Future<void> _onSendStartEvent(
      SendStartEvent event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());

    /**
     * Use regex to verify that the patient id has a valid suffix
     * Valid suffix:
     * "_TC"
     * "_HS"
     * "_walkin_TC"
     * "_walkin_HS"
     */
    final suffix = RegExp(r'_(walkin_)?(TC|HS)$');

    // Patient id is not valid
    if (!suffix.hasMatch(event.patientId)) {
      emit(AppointmentStartFailure(message: "Invalid QR code."));
      return;
    }

    // Patient id is valid
    try {
      await appointmentRepository.endKioskApptEvent(event.kioskId);
    } catch (e) {
      if (e is MedlyvesException) {
        if (e.errorCode == 'APT327') {
          // Appointment not in progress, cannot end.
        } else {
          emit(AppointmentStartFailure(
              message:
                  "Failed to start appointment. Error code ${e.errorCode}"));
        }
      }
    }
    try {
      final appointment = await appointmentRepository.sendStartEvent(
          event.patientId, event.kioskId);

      await appointmentRepository.getUserDetails(event.patientId);

      emit(AppointmentStartSent(appointment));
    } catch (e) {
      if (e is MedlyvesException) {
        if (e.errorCode == 'CRD305') {
          emit(AppointmentInsufficientCredits());
        } else {
          emit(AppointmentStartFailure(
              message:
                  "Failed to start appointment. Error code ${e.errorCode}"));
        }
      } else {
        emit(AppointmentStartFailure(
            message: "Failed to start appointment. Error code APT603"));
      }
    }
  }

  Future<void> _onGetTeleconsultToken(
      GetTeleconsultToken event, Emitter<AppointmentState> emit) async {
    try {
      final HmsDetails hmsDetails =
          await appointmentRepository.getTeleconsultToken(event.kioskId);
      emit(TeleconsultTokenReceived(hmsDetails));
    } catch (_) {}
  }

  Future<void> _onSendStopEvent(
      SendStopEvent event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    try {
      await appointmentRepository.sendStopEvent(event.kioskId);
    } catch (_) {
      log('Failed to send stop event to backend');
      emit(AppointmentFailure());
    } finally {
      emit(AppointmentEnd());
    }
  }

  Future<void> _onSendReadyEvent(
      SendReadyEvent event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    try {
      final appointment =
          await appointmentRepository.sendReadyEvent(event.kioskId);
      emit(AppointmentTCReady(appointment));
    } catch (_) {
      emit(AppointmentFailure());
    }
  }

  processNewData(Map<String, dynamic> newData) {
    appointmentRepository.uploadAndUpdateData(newData);
  }

  Map<String, dynamic> getPatientBodyInfo() {
    return appointmentRepository.getPatientBodyInfo;
  }

  uploadEcgDocument(File file, String conclusion) {
    appointmentRepository.uploadEcgDocument(file, conclusion);
  }
}
