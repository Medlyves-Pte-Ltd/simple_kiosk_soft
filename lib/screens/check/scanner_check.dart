import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_devices_sdk/device_data/code_scanner_data.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:simple_kiosk_software/common/common.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:simple_kiosk_software/screens/check/base_check_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_kiosk_software/blocs/device/device_state.dart';
import 'package:simple_kiosk_software/blocs/device/device_bloc.dart';
import 'package:simple_kiosk_software/blocs/device/device_event.dart';
import 'package:simple_kiosk_software/utils/app_config.dart';

class ScannerCheck extends BaseCheckWidget {
  String scannerData = "";

  ScannerCheck() {
    scannerData = dataDefaultValue;
  }

  @override
  void init() {
    super.title = AppLocalizations.of(mainContext)!.scanner;
    iconFile = "assets/images/scanner.png";
    underlineColor = ColorPalette.colorheightWeight;
  }

  @override
  Future<void> onStart() async {
    if (AppConfig().useScanner) {
      stopScanner(mainContext);
      AppConfig().useScanner = false;
    }
    startScanner(mainContext);
  }

  @override
  Future<void> onStop() async {
    stopScanner(mainContext);
    AppConfig().useScanner = false;
  }

  @override
  bool needUpdate(DeviceType? type) {
    return type == DeviceType.SCANNER_DEVICE;
  }

  @override
  Widget buildCardDataShowArea() {
    double dataFontSize = height * 0.01;
    return BlocBuilder<DeviceBloc, DeviceState>(buildWhen: (previous, state) {
      if (!needUpdate(state.deviceType)) {
        return false;
      }

      bool update = false;
      if (state is DeviceConnected) {
        measured = false;
        scannerData = dataDefaultValue;
        update = true;
      } else if (state is DeviceDataLoading) {
        scannerData = AppLocalizations.of(mainContext)!.loading;
        update = true;
      } else if (state is DeviceDataUpdated &&
          state.deviceData is CodeScannerData) {
        scannerData = (state.deviceData as CodeScannerData).scanner;
        measured = true;
        update = true;
      } else if (state is DeviceDisconnected) {
        if (!measured) {
          scannerData = dataDefaultValue;
          update = true;
        }
      }

      return update;
    }, builder: (context, state) {
      return Center(
        child: SizedBox(
            width: width * 0.25,
            child: Text(
              textAlign: TextAlign.center,
              scannerData,
              softWrap: true,
              maxLines: 8,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: dataFontSize,
                  fontWeight: FontWeight.bold,
                  color: ColorPalette.materialGreen),
            )),
      );
    });
  }
}
