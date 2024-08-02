import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_devices_sdk/device_data/blood_glucose_data.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:simple_kiosk_software/screens/measurement_pages/base_measure_layout_widget.dart';
import 'package:simple_kiosk_software/blocs/device/device_bloc.dart';
import 'package:simple_kiosk_software/blocs/device/device_event.dart';
import 'package:simple_kiosk_software/blocs/device/device_state.dart';
import 'package:simple_kiosk_software/utils/control_measure_page_utils.dart';
import 'package:simple_kiosk_software/utils/user_info.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BloodGlucoseMeasure extends BaseMeasureLayoutWidget {
  late String IFCC;
  late String eAG;

  BloodGlucoseMeasure() {
    IFCC = UserInfo().IFCC.isNotEmpty ? UserInfo().IFCC : dataDefaultValue;
    eAG = UserInfo().eAG.isNotEmpty ? UserInfo().eAG : dataDefaultValue;
  }

  @override
  Widget buildVideoArea() {
    return Image.asset(
      "assets/images/blood_glucose_info.jpg",
      fit: BoxFit.fill,
      width: width,
      height: width * 9 / 16,
    );
  }

  @override
  void init() {
    super.title = AppLocalizations.of(mainContext)!.bg;
    if (super.startVideoFile.isEmpty) {
      super.startVideoFile = getVideoFileName(DeviceType.BG_DEVICE, false);
    }
    if (super.endVideoFile.isEmpty) {
      super.endVideoFile = getVideoFileName(DeviceType.BG_DEVICE, true);
    }
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
  Widget buildCardDataShowArea() {
    double titleFontSize = height * 0.02;
    double dataFontSize = height * 0.02;

    return BlocBuilder<DeviceBloc, DeviceState>(buildWhen: (previous, state) {
      bool update = false;

      if (state is DeviceConnected) {
        ControlMeasurePageUtils().measured = false;
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
      } else if (state is DeviceDataUpdated &&
          state.deviceData is BloodGlucoseData) {
        String ifcc = (state.deviceData as BloodGlucoseData).IFCC;
        IFCC = UserInfo().IFCC = (double.parse(ifcc) / 10.0).toStringAsFixed(1);
        eAG = UserInfo().eAG = (state.deviceData as BloodGlucoseData).eAG;
        ControlMeasurePageUtils().measured = true;
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
        child: Row(
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
