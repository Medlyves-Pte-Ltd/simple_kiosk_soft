import 'dart:io';

import 'package:flutter_devices_sdk/log/log_printer.dart';
import 'package:simple_kiosk_software/remote/models/tc_room_details.dart';
import 'package:simple_kiosk_software/remote/utils/exceptions/medlyves_exception.dart';
import 'package:simple_kiosk_software/remote/utils/shared_prefs.dart';
import 'package:http/http.dart' as http;
import 'package:medlyves_mobile_components/medlyves_mobile_components.dart'
    as mobile_components;
import 'package:path/path.dart';
import 'package:simple_kiosk_software/utils/app_config.dart';
import 'package:simple_kiosk_software/utils/kiosk_config.dart';
import 'dart:convert';
import 'dart:developer';
import '../config/settings.dart';
import '../utils/app_constants.dart';

class AppointmentApi {
  static final appoinmentEventUrl =
      Uri.parse('$httpPrefix$host/appointment/event/');
  static final uploadDataUrl = Uri.parse('$httpPrefix$host/device/readings/');
  static final uploadEcgDocumentUrl = Uri.parse('$httpPrefix$host/device/ecg/');
  static final tcTokenUrl = Uri.parse('$httpPrefix$host/teleconsult/v2/kiosk/');

  Future<dynamic> sendAppointmentEvent(
      String patientId, String kioskId, String event) async {
    final body = patientId.isNotEmpty
        ? {
            'patient_id': patientId,
            'kiosk_id': kioskId,
            'event': event,
          }
        : {
            'kiosk_id': kioskId,
            'event': event,
          };
    log(appoinmentEventUrl.toString());
    final response = await http.post(
      appoinmentEventUrl,
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
    mobile_components.Result result =
        mobile_components.MedlyvesService.parseJSONResponse(response);
    if (result is mobile_components.Failure &&
        result.errorCode != 'APT327' &&
        result.errorCode != 'OTH602') {
      // TODO: Temporary fix for ending ended appointment
      throw MedlyvesException(result.errorCode,
          errorMessage: result.errorMessage);
    } else if (result is mobile_components.Success) {
      String? appointmentId = result.data['id'];
      String? screeningMode = result.data['mode'];
      if (appointmentId == null || screeningMode == null) {
        throw MedlyvesException('APT601');
      }
      SharedPrefs.setData('appointmentId', appointmentId);
      SharedPrefs.setData('mode', screeningMode);
      return result.data;
    }
    return {};
  }

  Future<Map<String, dynamic>> getTeleconsultToken(String kioskId) async {
    // API Docs
    // https://medlyves-api-5hohk5qryq-as.a.run.app/docs#/teleconsult/start_kiosk_TC_video_teleconsult_kiosk__post
    // this api is called together with `READY` event when the patient is ready for
    // teleconsult
    // the data and token inside the response is used for calling jitsi apis

    final body = {
      'kiosk_id': kioskId,
    };

    print(
        'calling tc token api for $kioskId response: $body and url $tcTokenUrl');
    final response = await http.post(tcTokenUrl,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(body));
    print(
        'get tc token api for $kioskId response: ${response.body} and status code ${response.statusCode}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error getting teleconsult token');
    }
  }

  static Future<HmsDetails> getTeleconsultTokenV2(String kioskId) async {
    try {
      final body = {'kiosk_id': kioskId};
      final response = await http.post(
        tcTokenUrl,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String? status = responseData["status"];
        final dynamic data = responseData["data"];

        print("Response status: $status");
        print("Response data: $data");

        if (status == "success" && data != null) {
          if (data is Map<String, dynamic>) {
            return HmsDetails.fromJson(data);
          } else if (data is String) {
            final Map<String, dynamic> parsedData = jsonDecode(data);
            return HmsDetails.fromJson(parsedData);
          } else {
            throw "Unexpected data format";
          }
        } else {
          String eMessage =
              "Failed to retrieve token: status=$status, data=$data";
          print(eMessage);
          throw eMessage;
        }
      } else {
        String eMessage = "HTTP Error: ${response.statusCode}";
        print(eMessage);
        throw eMessage;
      }
    } catch (e) {
      print("Exception: ${e.toString()}");
      throw e;
    }
  }

  uploadDeviceData(String apptID, List<dynamic> data) async {
    // API Docs
    // https://medlyves-api-5hohk5qryq-as.a.run.app/docs#/device/create_reading_device_readings__post
    // this api is called when a device reading is ready for upload

    String now = DateTime.now().toUtc().toIso8601String();

    final body = {'appointment_id': apptID, 'timestamp': now, 'readings': data};

    LogPrinter.log(jsonEncode(body));

    final response = await http.post(uploadDataUrl,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(body));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error uploading device data');
    }
  }

  addEcgDocument(File file, String patientID, String timestamp,
      String appointmentId, String conclusion) async {
    // // Query Parameters
    //  final queryParams = {'category': 'ECG_REPORTS', 'patient_id': patientID};

    // Request headers
    final headers = {
      'accept': 'application/json',
      'Content-Type': 'multipart/form-data',
    };

    try {
      // Create a multipart request
      var request = http.MultipartRequest(
        'POST',
        uploadEcgDocumentUrl,
      );
      request.headers.addAll(headers);

      // Add the file to the request
      var stream = http.ByteStream(file.openRead());
      stream.cast();
      var length = await file.length();
      var multipartFile = http.MultipartFile(
        'image', // Consider changing 'file' to the name of the parameter expected by the server
        stream,
        length,
        filename: basename(file.path),
      );

      //Add the file to the request
      request.files.add(multipartFile);
      LogPrinter.log("Added file.");

      //Add fields to the request body
      request.fields['timestamp'] = timestamp;
      request.fields['appointment_id'] = appointmentId;
      request.fields['conclusion'] = conclusion;
      LogPrinter.log("Added payload.");

      LogPrinter.log("Sending request.");
      // Send the request
      var response = await request.send();
      LogPrinter.log("response received.");

      // Handle the response
      if (response.statusCode == 200) {
        LogPrinter.log('Uploaded!');
      } else {
        LogPrinter.log('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      LogPrinter.log("Error at uploadEcgDocument: ${e.toString()}");
    }
  }

  Future<Map<String, dynamic>> getUserDetails(String patientId) async {
    if (patientId.contains('_')) {
      List<String> patientIdParts = patientId.split('_');
      patientId = patientIdParts[0];
    }

    final response = await http.get(
      Uri.parse(
          '$httpPrefix$host/appointment/current/?kiosk_id=${KioskConfig().kioskId}&detail=patient'),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    mobile_components.Result result =
        mobile_components.MedlyvesService.parseJSONResponse(response);
    if (result is mobile_components.Failure) {
      throw MedlyvesException(result.errorCode,
          errorMessage: result.errorMessage);
    }
    if (result is mobile_components.Success) {
      if (!result.data.containsKey('patient_details')) {
        throw MedlyvesException('APT602');
      }
      final Map<String, dynamic> patientDetails =
          result.data['patient_details'];
      final String name =
          '${patientDetails['first_name']} ${patientDetails['last_name']}';
      final String age = patientDetails['age'].toString();
      final String gender = patientDetails['gender'] ?? '';
      return {'name': name, 'age': age, 'gender': gender};
    }
    return {};
  }
}
