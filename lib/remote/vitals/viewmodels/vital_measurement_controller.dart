import 'package:flutter/foundation.dart';
import 'package:simple_kiosk_software/remote/models/vital_measurements.dart';
import 'package:simple_kiosk_software/remote/services/api_methods.dart';
import 'package:simple_kiosk_software/remote/services/device_readings.dart';
import 'package:simple_kiosk_software/remote/utils/shared_prefs.dart';
import 'dart:developer';

class VitalMeasurementsController extends ChangeNotifier {
  bool _verifyloading = false;
  bool get getVerifyLoader => _verifyloading;

  void setLoader(bool val) {
    _verifyloading = val;
    notifyListeners();
  }

  List<VitalReadings> vitalData = [];
  dynamic setVitalData(List<VitalReadings> model) {
    vitalData = model;
    notifyListeners();
  }

  List<VitalReadings> getVitalData() {
    return vitalData;
  }

  Future<dynamic> fetchVitalMeasurements() async {
    setLoader(true);
    final appointmentId = await SharedPrefs.getData('appointmentId');
    final response = await DeviceVitalReadings.getDeviceReadings(appointmentId);
    vitalData = [];

    if (response is Success) {
      final readingsResponse = response.successResponse as List<VitalReadings>;
      setVitalData(readingsResponse);
      getVitalData();
      if (getVerifyLoader) {
        print("vital reading success");
        print(readingsResponse);
        for (var reading in readingsResponse) {
          log(reading.toString());
        }
      }
    } else if (response is Failure) {
      if (kDebugMode) {
        print("vital reading failure");
        print(response.errorResponse['message'].toString());
      }
      setLoader(false);
    }
    setLoader(false);
  }
}
