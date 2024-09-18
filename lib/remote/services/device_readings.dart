import 'package:dio/dio.dart';
import 'package:simple_kiosk_software/remote/config/settings.dart';
import 'package:simple_kiosk_software/remote/models/vital_measurements.dart';
import 'package:simple_kiosk_software/remote/services/api_methods.dart';

class DeviceVitalReadings {
  static Future<dynamic> getDeviceReadings(String appointmentId) async {
    final options = Options();
    try {
      Response response = await ApiClient.getRequest(
          '$httpPrefix$host/device/appointment_summary/?appointment_id=$appointmentId',
          options);
      if (response.statusCode == 200) {
        List<dynamic> readingData = response.data;
        List<VitalReadings> vitalReadingsList =
            readingData.map((data) => VitalReadings.fromJson(data)).toList();

        // sort based on device ID, in ascending order
        vitalReadingsList.sort((a, b) => a.deviceId.compareTo(b.deviceId));

        return Success(
            code: response.statusCode, successResponse: vitalReadingsList);
      }
      return Failure(code: response.statusCode, errorResponse: response.data);
    } catch (error) {
      return Failure(code: -1, errorResponse: error.toString());
    }
  }
}
