import 'package:flutter_devices_sdk/log/log_printer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:simple_kiosk_software/utils/user_info.dart';

class MptApi {
  static String _apiBase =
      'https://tpp-dev-api-1039339270759.asia-southeast1.run.app';
  static String? _jwtToken;

  static Future<void> retrieveJwtToken() async {
    String endpoint = '${_apiBase}/dev/token';
    String uid = 'vNkS9Rd78kWzFeeZ1IoQoEzqeKv2';
    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'username': uid,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      _jwtToken = data['access_token'];
    } else {
      throw Exception('Failed to retrieve JWT token');
    }
  }

  static Future<void> uploadData() async {
    String endpoint = '${_apiBase}/observation';
    final fixedPayload = {
      'hcode': 'mpt',
      'hname': 'mpt',
      'tablet_unique_id': 'mpt-009',
      'observation_datetime': DateTime.now().toUtc().toIso8601String(),
    };

    final payload = [
      {
        ...fixedPayload,
        ..._getPatientData(),
      }
    ];

    LogPrinter.log(payload.toString());

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_jwtToken',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      LogPrinter.log(response.body);
      throw Exception(response.body);
    }
  }

  static _getPatientData() {
    var proccessedUserInfo = UserInfo().toJson();

    if (proccessedUserInfo.containsKey('bloodPressure')) {
      final bp = proccessedUserInfo['bloodPressure'].split(' / ');
      proccessedUserInfo['systolic'] = bp[0];
      proccessedUserInfo['diastolic'] = bp[1];
      proccessedUserInfo.remove('bloodPressure');
    }

    proccessedUserInfo = proccessedUserInfo.map((k, v) {
      if (_deviceTypeIds.containsKey(k)) {
        final id = _deviceTypeIds[k];
        final unit = _deviceTypeUnits[id];
        return MapEntry(k, {
          'medical_device_type_id': id,
          'value': double.parse(v),
          'units': unit,
        });
      } else {
        return MapEntry(k, '');
      }
    });

    proccessedUserInfo.removeWhere((k, v) => v is String);

    final readings = proccessedUserInfo.values.toList();

    final data = {
      'thai_national_id': UserInfo().patientId,
      'salutation': UserInfo().gender == 1 ? 'Mr' : 'Ms',
      'name': UserInfo().name,
      'date_of_birth': DateTime.now()
          .subtract(Duration(days: 365 * int.parse(UserInfo().age)))
          .toIso8601String()
          .split('T')[0],
      'gender': UserInfo().gender == 1 ? 'Male' : 'Female',
      'readings': readings,
    };

    return data;
  }

  static final Map<String, int> _deviceTypeIds = {
    "bloodOxygen": 1,
    "temperature": 2,
    "systolic": 3,
    "diastolic": 4,
    "bp_pulse": 5,
    "IFCC": 6,
    "chol": 7,
    "hdl": 8,
    "ldl": 9,
    "trig": 10,
    "height": 11,
    "weight": 12,
    "bmi": 13,
    "WAIST-SIZE": 14,
    "RESPIRATORY-RATE": 15,
    "bodyFatPercentage": 16,
    "bodyFatMass": 17,
    "muscleMass": 18,
    "bodyWaterPercentage": 19,
    "totalMoisture": 20,
    "extracellularFluid": 21,
    "intracellularWaterPercentage": 22,
    "basalMetabolism": 23,
    "visceralFatLevel": 24,
    "protein": 25,
    "boneMass": 26,
    "bodyAge": 27,
    "SCORE": 28,
  };

  static final _deviceTypeUnits = {
    1: '%',
    2: '°C',
    3: 'mm Hg',
    4: 'mm Hg',
    5: 'bpm',
    6: '%',
    7: 'mg/dL',
    8: 'mg/dL',
    9: 'mg/dL',
    10: 'mg/dL',
    11: 'cm',
    12: 'kg',
    13: '',
    14: 'cm',
    15: 'bpm',
    16: '%',
    17: 'kg',
    18: '%',
    19: '%',
    20: 'L',
    21: 'L',
    22: 'L',
    23: 'kcal',
    24: '',
    25: 'kg',
    26: 'kg',
    27: '',
    28: '',
  };
}
