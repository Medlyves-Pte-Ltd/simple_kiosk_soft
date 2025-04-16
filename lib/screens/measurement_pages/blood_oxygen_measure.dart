import 'package:flutter/material.dart';
import 'package:flutter_devices_sdk/device_data/blood_oxygen_data.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:simple_kiosk_software/common/range_widget.dart';
import 'package:simple_kiosk_software/remote/blocs/appointment/appointment_bloc.dart';
import 'package:simple_kiosk_software/screens/measurement_pages/base_measure_layout_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_kiosk_software/blocs/device/device_bloc.dart';
import 'package:simple_kiosk_software/blocs/device/device_event.dart';
import 'package:simple_kiosk_software/blocs/device/device_state.dart';
import 'package:simple_kiosk_software/utils/body_range.dart';
import 'package:simple_kiosk_software/utils/control_measure_page_utils.dart';
import 'package:simple_kiosk_software/utils/kiosk_config.dart';
import 'package:simple_kiosk_software/utils/user_info.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BloodOxygenMeasure extends BaseMeasureLayoutWidget {
  late String _bloodOxygen;
  late String spo2HeartRate;
  BloodOxygenMeasure() {
    _bloodOxygen = UserInfo().bloodOxygen.isNotEmpty
        ? UserInfo().bloodOxygen
        : dataDefaultValue;
    spo2HeartRate = UserInfo().spo2HeartRate.isNotEmpty
        ? UserInfo().spo2HeartRate
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
  Future<void> onStart() async {
    startStatus = true;
    DeviceConnectEvent connectEvent =
        DeviceConnectEvent(deviceType: DeviceType.BO_DEVICE);
    BlocProvider.of<DeviceBloc>(mainContext).add(connectEvent);
  }

  @override
  Future<void> onStop() async {
    startStatus = false;
    DeviceStopEvent stopEvent =
        DeviceStopEvent(deviceType: DeviceType.BO_DEVICE);
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
        measured = false;
        _bloodOxygen = dataDefaultValue;
        spo2HeartRate = dataDefaultValue;
        UserInfo().bloodOxygen = "";
        UserInfo().spo2HeartRate = "";
        update = true;
      } else if (state is DeviceDataLoading) {
        _bloodOxygen = AppLocalizations.of(mainContext)!.loading;
        spo2HeartRate = AppLocalizations.of(mainContext)!.loading;
        update = true;
      } else if (state is DeviceDataUpdated &&
          state.deviceData is BloodOxygenData) {
        String spo2Str = (state.deviceData as BloodOxygenData).spo2;
        String heartRateStr = (state.deviceData as BloodOxygenData).heartRate;

        // int spo2 = 0;
        // try {
        //   spo2 = int.parse(spo2Str);
        // } catch (e) {
        //   spo2 = 0;
        //   LogPrinter.log("Error: $e");
        //   _bloodOxygen = spo2HeartRate = dataDefaultValue;
        // }
        //
        // int heartRate = 0;
        // try {
        //   heartRate = int.parse(heartRateStr);
        // } catch (e) {
        //   heartRate = 0;
        //   LogPrinter.log("Error: $e");
        //   _bloodOxygen = spo2HeartRate = dataDefaultValue;
        // }
        //
        // if (spo2 < 80 || heartRate < 40) {
        //   if (spo2HeartRate != heartRateStr || _bloodOxygen != spo2Str) {
        //     messageBox(mainContext, super.title,
        //         AppLocalizations.of(mainContext)!.please_click_start_again);
        //   }
        //   _bloodOxygen = spo2HeartRate = dataDefaultValue;
        // } else {
        _bloodOxygen = UserInfo().bloodOxygen = spo2Str;
        spo2HeartRate = UserInfo().spo2HeartRate = heartRateStr;

        if (KioskConfig().healthScreeningMode == HealthScreeningMode.online) {
          BlocProvider.of<AppointmentBloc>(mainContext)
              .processNewData(state.deviceData.data);
        }

        ControlMeasurePageUtils().measured = true;
        //}

        measured = true;
        update = true;
      } else if (state is DeviceDisconnected) {
        startStatus = false;
        if (!measured) {
          _bloodOxygen = dataDefaultValue;
          spo2HeartRate = dataDefaultValue;
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
                  AppLocalizations.of(mainContext)!.bo_oxygen_staturation,
                  style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: height * 0.02),
                measureValueChangeColor(
                    _bloodOxygen,
                    BodyRange().spo2Min.toString(),
                    BodyRange().spo2Max.toString(),
                    dataFontSize,
                    true),
                rangeMeasureWidget(BodyRange().spo2Min.toString(),
                    BodyRange().spo2Max.toString(), dataFontSize, true)
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
                measureValueChangeColor(
                    spo2HeartRate,
                    BodyRange().heartRateMin.toString(),
                    BodyRange().heartRateMax.toString(),
                    dataFontSize,
                    true),
                rangeMeasureWidget(BodyRange().heartRateMin.toString(),
                    BodyRange().heartRateMax.toString(), dataFontSize, true)
              ],
            )
          ],
        ),
      );
    });
  }
}
