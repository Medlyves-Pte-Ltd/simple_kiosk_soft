import 'package:flutter/material.dart';
import 'package:flutter_devices_sdk/device_data/blood_oxygen_data.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:simple_kiosk_software/screens/measurement_pages/base_measure_layout_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_kiosk_software/blocs/device/device_bloc.dart';
import 'package:simple_kiosk_software/blocs/device/device_event.dart';
import 'package:simple_kiosk_software/blocs/device/device_state.dart';
import 'package:simple_kiosk_software/utils/control_measure_page_utils.dart';
import 'package:simple_kiosk_software/utils/user_info.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BloodOxygenMeasure extends BaseMeasureLayoutWidget {
  late String _bloodOxygen;
  late String _pulseRate;

  BloodOxygenMeasure() {
    super.startVideoFile = 'assets/videos/zh/spo2_measure_ZH.mp4';
    super.endVideoFile = 'assets/videos/zh/spo2_completed_ZH.mp4';
    _bloodOxygen = UserInfo().bloodOxygen.isNotEmpty
        ? UserInfo().bloodOxygen
        : dataDefaultValue;
    _pulseRate = UserInfo().bloodOxygenHeartRate.isNotEmpty
        ? UserInfo().bloodOxygenHeartRate
        : dataDefaultValue;
  }

  @override
  void init() {
    super.title = AppLocalizations.of(mainContext)!.bo;
    if (super.startVideoFile.isEmpty) {
      super.startVideoFile = getVideoFileName(DeviceType.BO_DEVICE, false);
    }
    if (super.endVideoFile.isEmpty) {
      super.endVideoFile = getVideoFileName(DeviceType.BO_DEVICE, true);
    }
  }

  @override
  void onStart() async {
    DeviceConnectEvent connectEvent =
        DeviceConnectEvent(deviceType: DeviceType.BO_DEVICE);
    BlocProvider.of<DeviceBloc>(mainContext).add(connectEvent);
  }

  @override
  void onStop() async {
    DeviceStopEvent stopEvent =
        DeviceStopEvent(deviceType: DeviceType.BO_DEVICE);
    BlocProvider.of<DeviceBloc>(mainContext).add(stopEvent);
  }

  @override
  Widget buildCardDataShowArea() {
    double titleFontSize = height * 0.02;
    double dataFontSize = height * 0.02;

    return BlocBuilder<DeviceBloc, DeviceState>(builder: (context, state) {
      if (state is DeviceDataLoading) {
        _bloodOxygen = _pulseRate = AppLocalizations.of(context)!.loading;
      } else if (state is DeviceDataUpdated) {
        if (state.deviceData is BloodOxygenData) {
          _bloodOxygen = (state.deviceData as BloodOxygenData).spo2;
          _pulseRate = (state.deviceData as BloodOxygenData).heartRate;
          UserInfo().bloodOxygen = _bloodOxygen;
          UserInfo().bloodOxygenHeartRate = _pulseRate;

          ControlMeasurePageUtils().measured = true;
        }
      }

      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(mainContext)!.bo_oxygen_staturation,
                  style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: height * 0.02),
                Text(
                  _bloodOxygen,
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
                  AppLocalizations.of(mainContext)!.bo_heartrate,
                  style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: height * 0.02),
                Text(
                  _pulseRate,
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
