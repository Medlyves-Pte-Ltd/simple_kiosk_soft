import 'dart:async';

import 'package:simple_kiosk_software/remote/config/settings.dart';
import 'package:simple_kiosk_software/remote/services/api_methods.dart';
import 'package:simple_kiosk_software/remote/services/kiosk_api.dart';
import 'package:simple_kiosk_software/remote/utils/app_constants.dart';

class KioskRepository {
  final KioskApi api;

  KioskRepository(this.api);

  Timer beginLivenessUpdate() {
    KioskApi api = KioskApi();
    int errorCount = 0;
    const oneMinute = Duration(minutes: 1);
    return Timer.periodic(oneMinute, (Timer _) async {
      dynamic result = await api.pingKiosk(kioskId);
      if (result is Failure) {
        errorCount += 1;
        if (errorCount % 5 == 0) {
          LogPrinter.err(
              'Failed to ping kiosk server $errorCount consecutive times:\n${result.errorResponse.toString()}');
        } else {
          LogPrinter.log('Failed to ping kiosk server');
        }
      } else if (result is Success) {
        errorCount = 0;
      }
    });
  }
}
