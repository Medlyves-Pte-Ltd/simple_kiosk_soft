// lib/blocs/appointment_state.dart

part of 'appointment_bloc.dart';

abstract class AppointmentState {
  final Appointment? appointment;

  AppointmentState({this.appointment});
}

class AppointmentInitial extends AppointmentState {}

class AppointmentLoading extends AppointmentState {}

class AppointmentTCReady extends AppointmentState {
  AppointmentTCReady(Appointment appointment) : super(appointment: appointment);
}

class AppointmentStartSent extends AppointmentState {
  AppointmentStartSent(Appointment appointment)
      : super(appointment: appointment);
}

class TeleconsultTokenReceived extends AppointmentState {
  final HmsDetails tcDetails;

  TeleconsultTokenReceived(this.tcDetails);
}

class AppointmentStartFailure extends AppointmentState {
  final String message;

  AppointmentStartFailure({super.appointment, required this.message});
}

class AppointmentFailure extends AppointmentState {}

class AppointmentEnd extends AppointmentState {}

class AppointmentInsufficientCredits extends AppointmentState {}
