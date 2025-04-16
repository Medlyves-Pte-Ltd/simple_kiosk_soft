import 'dart:async';
import 'package:flutter_devices_sdk/log/log_printer.dart';
import 'package:simple_kiosk_software/remote/services/api_methods.dart';
import 'package:simple_kiosk_software/remote/services/kiosk_api.dart';
import 'package:simple_kiosk_software/utils/kiosk_config.dart';

class KioskRepository {
  final KioskApi api;

  KioskRepository(this.api);

  Timer beginLivenessUpdate() {
    KioskApi api = KioskApi();
    int errorCount = 0;
    const oneMinute = Duration(minutes: 1);
    return Timer.periodic(oneMinute, (Timer _) async {
      dynamic result = await api.pingKiosk(KioskConfig().kioskId);
      if (result is Failure) {
        errorCount += 1;
        if (errorCount % 5 == 0) {
          LogPrinter.log(
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
