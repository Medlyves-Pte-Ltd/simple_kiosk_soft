import 'package:flutter/material.dart';
import 'package:flutter_devices_sdk/device_data/blood_pressure_data.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:simple_kiosk_software/screens/check/base_check_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_kiosk_software/blocs/device/device_bloc.dart';
import 'package:simple_kiosk_software/blocs/device/device_event.dart';
import 'package:simple_kiosk_software/blocs/device/device_state.dart';
import 'package:simple_kiosk_software/utils/control_measure_page_utils.dart';
import 'package:simple_kiosk_software/utils/user_info.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BloodPressureCheck extends BaseCheckWidget {
  // 收缩压
  String systolic = '';
  // 舒张压
  String diastolic = '';
  // 心率
  String heartRate = '';

  BloodPressureCheck() {
    iconFile = "assets/images/bloodpressure_logo.png";
    underlineColor = ColorPalette.colorbloodPressure;
    systolic =
        UserInfo().systolic.isNotEmpty ? UserInfo().systolic : dataDefaultValue;
    diastolic = UserInfo().diastolic.isNotEmpty
        ? UserInfo().diastolic
        : dataDefaultValue;
    heartRate = UserInfo().bpHeartRate.isNotEmpty
        ? UserInfo().bpHeartRate
        : dataDefaultValue;
  }

  @override
  void init() {
    super.title = AppLocalizations.of(mainContext)!.blood_pressure;
  }

  @override
  Future<void> onStart() async {
    DeviceConnectEvent connectEvent =
        DeviceConnectEvent(deviceType: DeviceType.BP_DEVICE);
    BlocProvider.of<DeviceBloc>(mainContext).add(connectEvent);
  }

  @override
  Future<void> onStop() async {
    DeviceStopEvent stopEvent =
        DeviceStopEvent(deviceType: DeviceType.BP_DEVICE);
    BlocProvider.of<DeviceBloc>(mainContext).add(stopEvent);
  }

  @override
  bool needUpdate(DeviceType? type) {
    return type == DeviceType.BP_DEVICE;
  }

  @override
  Widget buildCardDataShowArea() {
    double titleFontSize = height * 0.01;
    double dataFontSize = height * 0.01;

    return BlocBuilder<DeviceBloc, DeviceState>(buildWhen: (previous, state) {
      if (!needUpdate(state.deviceType)) {
        return false;
      }

      bool update = false;

      if (state is DeviceConnected) {
        measured = false;
        systolic = diastolic = heartRate = dataDefaultValue;
        UserInfo().systolic = "";
        UserInfo().diastolic = "";
        UserInfo().bpHeartRate = "";
        update = true;
      } else if (state is DeviceDataLoading) {
        systolic =
            diastolic = heartRate = AppLocalizations.of(mainContext)!.loading;
        update = true;
      } else if (state is DeviceDataUpdated &&
          state.deviceData is BloodPrssureData) {
        systolic = UserInfo().systolic =
            (state.deviceData as BloodPrssureData).systolic;
        diastolic = UserInfo().diastolic =
            (state.deviceData as BloodPrssureData).diastolic;
        heartRate = UserInfo().bpHeartRate =
            (state.deviceData as BloodPrssureData).heartRate;

        measured = true;
        update = true;
      } else if (state is DeviceDisconnected) {
        if (!measured) {
          systolic = diastolic = heartRate = dataDefaultValue;
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
                  AppLocalizations.of(mainContext)!.bp_bloodpressure,
                  style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: height * 0.02),
                Text(
                  "$systolic/$diastolic",
                  style: TextStyle(
                      fontSize: dataFontSize,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.materialGreen),
                )
              ],
            ),
            SizedBox(height: height * 0.02),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(mainContext)!.bp_pulse,
                  style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: height * 0.02),
                Text(
                  heartRate,
                  style: TextStyle(
                      fontSize: dataFontSize,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.materialGreen),
                )
              ],
            )
          ],
        ),
      );
    });
  }
}
