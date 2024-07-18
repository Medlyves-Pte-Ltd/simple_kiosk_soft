import 'package:flutter/material.dart';
import 'package:flutter_devices_sdk/device_data/blood_oxygen_data.dart';
import 'package:flutter_devices_sdk/device_data/blood_pressure_data.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:flutter_devices_sdk/devices/nhc/raycome_blood_pressure_device.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:simple_kiosk_software/screens/measurement_pages/base_measure_layout_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_kiosk_software/blocs/device/device_bloc.dart';
import 'package:simple_kiosk_software/blocs/device/device_event.dart';
import 'package:simple_kiosk_software/blocs/device/device_state.dart';
import 'package:simple_kiosk_software/utils/control_measure_page_utils.dart';
import 'package:simple_kiosk_software/utils/user_info.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BloodPressureMeasure extends BaseMeasureLayoutWidget {
  // 收缩压
  String systolic = '';
  // 舒张压
  String diastolic = '';
  // 心率
  String heartRate = '';

  BloodPressureMeasure() {
    systolic =
        UserInfo().systolic.isNotEmpty ? UserInfo().systolic : dataDefaultValue;
    diastolic = UserInfo().diastolic.isNotEmpty
        ? UserInfo().diastolic
        : dataDefaultValue;
    heartRate = UserInfo().heartRate.isNotEmpty
        ? UserInfo().heartRate
        : dataDefaultValue;
  }

  @override
  void init() {
    super.title = AppLocalizations.of(mainContext)!.blood_pressure;
    if (super.startVideoFile.isEmpty) {
      super.startVideoFile = getVideoFileName(DeviceType.BP_DEVICE, false);
    }
    if (super.endVideoFile.isEmpty) {
      super.endVideoFile = getVideoFileName(DeviceType.BP_DEVICE, true);
    }
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
  Widget buildCardDataShowArea() {
    double titleFontSize = height * 0.02;
    double dataFontSize = height * 0.02;

    return BlocBuilder<DeviceBloc, DeviceState>(buildWhen: (previous, state) {
      bool update = false;

      if (state is DeviceConnected) {
        ControlMeasurePageUtils().measured = false;
        systolic = diastolic = heartRate = dataDefaultValue;
        UserInfo().systolic = "";
        UserInfo().diastolic = "";
        UserInfo().heartRate = "";
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
        heartRate = UserInfo().heartRate =
            (state.deviceData as BloodPrssureData).heartRate;

        ControlMeasurePageUtils().measured = true;
        update = true;
      } else if (state is DeviceDisconnected) {
        if (ControlMeasurePageUtils().measured == false) {
          systolic = diastolic = heartRate = dataDefaultValue;
          update = true;
        }
      }

      return update;
    }, builder: (context, state) {
      return Center(
        child: Row(
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
            SizedBox(width: width * 0.1),
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
