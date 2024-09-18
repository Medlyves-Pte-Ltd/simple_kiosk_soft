import 'dart:async';
import 'dart:convert';

import 'package:simple_kiosk_software/remote/services/api_methods.dart';
import 'package:http/http.dart' as http;
import '../config/settings.dart';

class KioskApi {
  static final kioskLivenessUrl = Uri.parse('$httpPrefix$host/kiosk/liveness/');

  Future<dynamic> pingKiosk(String kioskId) async {
    // API Docs
    // https://medlyves-api-5hohk5qryq-as.a.run.app/docs#/kiosk/read_kiosk_kiosk_liveness__kiosk_id__get
    try {
      final response = await http
          .get(Uri.parse('$kioskLivenessUrl$kioskId'))
          .timeout(const Duration(seconds: 10));
      final statusCode = response.statusCode;
      dynamic responseData = jsonDecode(response.body);
      //if (responseData != null && statusCode == 200) { //allow null since pingkiosk is disabled and returns null. should use this when backend is enabled again
      if (statusCode == 200) {
        return Success(code: statusCode, successResponse: responseData);
      }
      return Failure(code: statusCode, errorResponse: responseData);
    } on Exception catch (e) {
      return Failure(code: 504, errorResponse: e);
    }
  }
}
