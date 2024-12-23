import 'package:flutter/material.dart';
import 'package:flutter_devices_sdk/device_data/blood_oxygen_data.dart';
import 'package:flutter_devices_sdk/device_data/blood_pressure_data.dart';
import 'package:flutter_devices_sdk/device_sdk_param_setting.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:flutter_devices_sdk/devices/device_config.dart';
import 'package:flutter_devices_sdk/devices/nhc/raycome_blood_pressure_device.dart';
import 'package:flutter_devices_sdk/devices/up_down_control.dart';
import 'package:flutter_devices_sdk/kiosk_type.dart';
import 'package:flutter_devices_sdk/log/log_printer.dart';
import 'package:simple_kiosk_software/common/range_widget.dart';
import 'package:simple_kiosk_software/remote/blocs/appointment/appointment_bloc.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:simple_kiosk_software/screens/measurement_pages/base_measure_layout_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_kiosk_software/blocs/device/device_bloc.dart';
import 'package:simple_kiosk_software/blocs/device/device_event.dart';
import 'package:simple_kiosk_software/blocs/device/device_state.dart';
import 'package:simple_kiosk_software/utils/app_config.dart';
import 'package:simple_kiosk_software/utils/body_range.dart';
import 'package:simple_kiosk_software/utils/control_measure_page_utils.dart';
import 'package:simple_kiosk_software/utils/kiosk_config.dart';
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
    heartRate = UserInfo().bpHeartRate.isNotEmpty
        ? UserInfo().bpHeartRate
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
    startStatus = true;
    DeviceConnectEvent connectEvent =
        DeviceConnectEvent(deviceType: DeviceType.BP_DEVICE);
    BlocProvider.of<DeviceBloc>(mainContext).add(connectEvent);
  }

  @override
  Future<void> onStop() async {
    startStatus = false;
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
        String heartRateStr = UserInfo().bpHeartRate =
            (state.deviceData as BloodPrssureData).heartRate;

        // int hr = 0;
        // try {
        //   hr = int.parse(heartRateStr);
        // } catch (e) {
        //   hr = 0;
        //   LogPrinter.log("Error: $e");
        //   systolic = diastolic = heartRate = dataDefaultValue;
        // }
        //
        // if (hr < 40) {
        //   if (heartRateStr != heartRate) {
        //     messageBox(mainContext, super.title,
        //         AppLocalizations.of(mainContext)!.please_click_start_again);
        //   }
        //   systolic = diastolic = heartRate = dataDefaultValue;
        // } else {
        systolic = UserInfo().systolic =
            (state.deviceData as BloodPrssureData).systolic;
        diastolic = UserInfo().diastolic =
            (state.deviceData as BloodPrssureData).diastolic;
        heartRate = UserInfo().bpHeartRate = heartRateStr;

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
                ControlMeasurePageUtils().measured
                    ? Text(
                        "$systolic / $diastolic",
                        style: TextStyle(
                            fontSize: dataFontSize,
                            fontWeight: FontWeight.bold,
                            color: (double.parse(systolic) >
                                        BodyRange().systolicMax ||
                                    double.parse(diastolic) >
                                        BodyRange().diastolicMax)
                                ? Colors.red
                                : ColorPalette.materialGreen),
                      )
                    : Text(
                        "$systolic / $diastolic",
                        style: TextStyle(
                            fontSize: dataFontSize,
                            fontWeight: FontWeight.bold,
                            color: ColorPalette.materialGreen),
                      ),
                Visibility(
                  child: Text(
                    "( < ${BodyRange().systolicMax}) / ( < ${BodyRange().diastolicMax})",
                    style: TextStyle(
                        fontSize: dataFontSize,
                        color: ColorPalette.materialGreen),
                  ),
                  visible: ControlMeasurePageUtils().measured,
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
                measureValueChangeColor(
                    heartRate,
                    BodyRange().heartRateMin.toString(),
                    BodyRange().heartRateMax.toString(),
                    dataFontSize,
                    true),
                rangeMeasureWidget(BodyRange().heartRateMin.toString(),
                    BodyRange().heartRateMax.toString(), dataFontSize, true)
              ],
            ),
            Visibility(
              visible: DeviceSdkParamSetting().kioskType == KioskType.stand,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      await UpDownControl().up();
                    },
                    child: Container(
                      height: height * 0.03,
                      width: width * 0.15,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: ColorPalette.materialGreen,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text("Up",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: height * 0.015,
                              color: Colors.white)),
                    ),
                  ),
                  SizedBox(width: width * 0.05),
                  InkWell(
                    onTap: () async {
                      await UpDownControl().down();
                    },
                    child: Container(
                      height: height * 0.03,
                      width: width * 0.15,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: ColorPalette.materialGreen,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text("Down",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: height * 0.015,
                              color: Colors.white)),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
