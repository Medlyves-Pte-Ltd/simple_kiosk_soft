import 'package:flutter/foundation.dart';
import 'package:flutter_devices_sdk/log/log_printer.dart';
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
    LogPrinter.log("start vital reading");
    setLoader(true);
    final appointmentId = await SharedPrefs.getData('appointmentId');
    final response = await DeviceVitalReadings.getDeviceReadings(appointmentId);
    vitalData = [];

    if (response is Success) {
      final readingsResponse = response.successResponse as List<VitalReadings>;

      setVitalData(readingsResponse);

      if (getVerifyLoader) {
        LogPrinter.log(
            "vital reading success, readingsResponse size: ${readingsResponse.length}");

        for (var reading in readingsResponse) {
          print(reading.toString());
        }
      }

      for (var reading in vitalData) {
        LogPrinter.log("get measure data: ${reading.toJson()}");
      }
    } else if (response is Failure) {
      LogPrinter.log("vital reading failure");
      LogPrinter.log(response.errorResponse['message'].toString());
      setLoader(false);
    }
    setLoader(false);
  }
}
