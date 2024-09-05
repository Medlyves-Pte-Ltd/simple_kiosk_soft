import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_devices_sdk/device_data/blood_glucose_data.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:simple_kiosk_software/screens/check/base_check_widget.dart';
import 'package:simple_kiosk_software/blocs/device/device_bloc.dart';
import 'package:simple_kiosk_software/blocs/device/device_event.dart';
import 'package:simple_kiosk_software/blocs/device/device_state.dart';
import 'package:simple_kiosk_software/utils/control_measure_page_utils.dart';
import 'package:simple_kiosk_software/utils/user_info.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BloodGlucoseCheck extends BaseCheckWidget {
  late String IFCC;
  late String eAG;

  BloodGlucoseCheck() {
    iconFile = "assets/images/blood_glucose.png";
    underlineColor = ColorPalette.colorbloodGlucose;
    IFCC = UserInfo().IFCC.isNotEmpty ? UserInfo().IFCC : dataDefaultValue;
    eAG = UserInfo().eAG.isNotEmpty ? UserInfo().eAG : dataDefaultValue;
  }

  @override
  void init() {
    super.title = AppLocalizations.of(mainContext)!.bg;
  }

  @override
  Future<void> onStart() async {
    DeviceConnectEvent connectEvent =
        DeviceConnectEvent(deviceType: DeviceType.BG_DEVICE);
    BlocProvider.of<DeviceBloc>(mainContext).add(connectEvent);
  }

  @override
  Future<void> onStop() async {
    DeviceStopEvent stopEvent =
        DeviceStopEvent(deviceType: DeviceType.BG_DEVICE);
    BlocProvider.of<DeviceBloc>(mainContext).add(stopEvent);
  }

  @override
  bool needUpdate(DeviceType? type) {
    return type == DeviceType.BG_DEVICE;
  }

  @override
  Widget buildCardDataShowArea() {
    double titleFontSize = height * 0.01;
    double dataFontSize = height * 0.01;

    return BlocBuilder<DeviceBloc, DeviceState>(buildWhen: (previous, state) {
      bool update = false;

      if (!needUpdate(state.deviceType)) {
        return false;
      }

      if (state is DeviceConnected) {
        measured = false;
        IFCC = dataDefaultValue;
        eAG = dataDefaultValue;
        UserInfo().IFCC = '';
        UserInfo().eAG = '';
        update = true;
      } else if (state is DeviceDataLoading) {
        IFCC = AppLocalizations.of(mainContext)!.loading;
        eAG = AppLocalizations.of(mainContext)!.loading;
        update = true;
      } else if (state is DeviceDataUpdated) {
        String ifcc = (state.deviceData as BloodGlucoseData).IFCC;
        IFCC = UserInfo().IFCC = (double.parse(ifcc) / 10.0).toStringAsFixed(1);
        eAG = UserInfo().eAG = (state.deviceData as BloodGlucoseData).eAG;
        measured = true;
        update = true;
      } else if (state is DeviceDisconnected) {
        if (!measured) {
          IFCC = eAG = dataDefaultValue;
          update = true;
        }
      }

      return update;
    }, builder: (context, state) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(mainContext)!.bg_ifcc,
                  style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: height * 0.02),
                Text(
                  IFCC,
                  style: TextStyle(
                      fontSize: dataFontSize,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.materialGreen),
                )
              ],
            ),
            SizedBox(width: width * 0.1),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(mainContext)!.bg_bloodglucose,
                  style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: height * 0.02),
                Text(
                  eAG,
                  style: TextStyle(
                      fontSize: dataFontSize,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.materialGreen),
                )
              ],
            ),
          ],
        ),
      );
    });
  }
}
