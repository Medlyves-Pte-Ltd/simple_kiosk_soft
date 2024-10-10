import 'dart:io';

import 'package:simple_kiosk_software/remote/utils/app_constants.dart';
import 'package:simple_kiosk_software/remote/utils/shared_prefs.dart';

import '../services/appointment_api.dart';
import '../utils/enum_event.dart';
import '../models/tc_room_details.dart';
import '../models/appointment.dart';
import '../utils/device_id_map.dart';

class AppointmentRepository {
  final AppointmentApi api;
  String? patientId;
  Map<String, dynamic> data = {};

  AppointmentRepository(this.api);

  // Helper method to convert enum to string
  String eventToString(Event event) {
    switch (event) {
      case Event.START:
        return 'START';
      case Event.END:
        return 'END';
      case Event.READY:
        return 'READY';
      default:
        throw Exception('Invalid event');
    }
  }

  Future<Appointment> sendStartEvent(String patientId, String kioskId) async {
    this.patientId = patientId;
    final response = await api.sendAppointmentEvent(
        patientId, kioskId, eventToString(Event.START));
    data = {...data, ...response}; // Update data with info from response
    return Appointment.fromJson(response);
  }

  Future<Appointment> sendReadyEvent(String kioskId) async {
    if (patientId != null) {
      final response = await api.sendAppointmentEvent(
          patientId!, kioskId, eventToString(Event.READY));

      return Appointment.fromJson(response);
    } else {
      // Handle the case when patientId is null
      throw Exception('Patient ID is null');
    }
  }

  Future getUserDetails(String patientId) async {
    this.patientId = patientId;
    final Map<String, dynamic> patientDetails =
        await api.getUserDetails(patientId);
    final String name = patientDetails['name'].toString();
    final String age = patientDetails['age'].toString();
    final String gender = patientDetails['gender'];

    data = {
      ...data,
      'name': name,
      'age': age,
      'gender': gender,
    };

    LogPrinter.log(
        'user details: Name: ${data["name"]}, Age: ${data["age"]}, Gender: ${data["gender"]}');
    LogPrinter.log(data.toString());
  }

  Future<void> sendStopEvent(String kioskId) {
    if (patientId != null) {
      return api
          .sendAppointmentEvent(patientId!, kioskId, eventToString(Event.END))
          .then((_) {
        patientId = null; // Set patientId to null after the API call
        //remove the locally saved appointment id
        SharedPrefs.removeData('appointmentId');
        SharedPrefs.removeData('mode');
        SharedPrefs.removeData('patientId');
        data = {}; // Set appointment data to empty after the API call
        // TODO: Clear data when appointment ended by the doctor
      });
    } else {
      // Handle the case when patientId is null
      throw Exception('Patient ID is null');
    }
  }

  Future<void> endKioskApptEvent(String kioskId) async {
    await api.sendAppointmentEvent("", kioskId, eventToString(Event.END));

    patientId = null; // Set patientId to null after the API call
    //remove the locally saved appointment id
    SharedPrefs.removeData('appointmentId');
    SharedPrefs.removeData('mode');
    SharedPrefs.removeData('patientId');
    data = {}; // Set appointment data to empty after the API call
    // TODO: Clear data when appointment ended by the doctor
  }

  Future<HmsDetails> getTeleconsultToken(String kioskId) async {
    final response = await api.getTeleconsultToken(kioskId);
    return HmsDetails.fromJson(response);
  }

  uploadAndUpdateData(Map<String, dynamic> newData) {
    List<dynamic> readings = [];
    newData.forEach((key, value) {
      if (key != 'ecg_cln' && key != 'ecg_img') {
        readings.add({
          'device_id': DeviceMap.CODETOID[key],
          'value': value == "" ? 0.0 : double.parse(value),
          'units': DeviceMap.CODETOUNIT[key]
        });
      }
    });
    api.uploadDeviceData(data['id'], readings); // Upload data
    data = {...data, ...newData}; // Update data
  }

  Map<String, dynamic> get getPatientBodyInfo => data;

  uploadEcgDocument(File file, String conclusion) {
    String patientId = data['patient_id'];
    DateTime now = DateTime.now();
    String timestamp = now.toIso8601String();
    String appointmentId = data['id'];
    // String conclusion = data['ecg_cln'];
    api.addEcgDocument(file, patientId, timestamp, appointmentId, conclusion);
  }
}
