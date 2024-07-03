import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_devices_sdk/device_data/height_data.dart';
import 'package:flutter_devices_sdk/device_data/weight_data.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:flutter_devices_sdk/view/colors.dart';
import 'package:simple_kiosk_software/blocs/device/device_bloc.dart';
import 'package:simple_kiosk_software/blocs/device/device_event.dart';
import 'package:simple_kiosk_software/blocs/device/device_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_kiosk_software/screens/measurement_pages/base_measure_layout_widget.dart';
import 'package:simple_kiosk_software/utils/user_info.dart';

class HeightWeightMeasure extends BaseMeasureLayoutWidget {
  String bodyheight = "- - -";
  String bodyWeight = "- - -";

  HeightWeightMeasure() {
    super.color = ColorPalette.colorheightWeight;
    super.startVideoFile = 'assets/videos/zh/heightweight_ZH.mp4';
    super.endVideoFile = 'assets/videos/zh/heightweight_completed_ZH.mp4';
    super.iconFile = "assets/images/heightweight_logo.png";
    super.title = "Height & Weight";
    super.deviceType = DeviceType.HEIGHT_DEVICE;
    playVideoSwitch.value = super.startVideoFile;
    bodyheight = UserInfo().height.isNotEmpty ? UserInfo().height : "- - -";
    bodyWeight = UserInfo().weight.isNotEmpty ? UserInfo().weight : "- - -";
  }

  @override
  void onStart() async {
    bodyheight = "- - -";
    bodyWeight = "- - -";

    // if (!startButtonPressed.value) {
    //   DeviceConnectEvent connectEvent =
    //       DeviceConnectEvent(deviceType: deviceType);
    //   BlocProvider.of<DeviceBloc>(mainContext).add(connectEvent);
    // } else {
    //   DeviceStopEvent stopEvent = DeviceStopEvent(deviceType: deviceType);
    //   BlocProvider.of<DeviceBloc>(mainContext).add(stopEvent);
    // }

    startButtonPressed.value = !startButtonPressed.value;
    playVideoSwitch.value = super.startVideoFile;

    BlocProvider.of<DeviceBloc>(mainContext).add(TestUpdateDataEvent(
        deviceType: DeviceType.HEIGHT_DEVICE, deviceData: HeightData("1.76")));

    Future.delayed(
        const Duration(milliseconds: 100),
        () => (BlocProvider.of<DeviceBloc>(mainContext).add(TestUpdateDataEvent(
            deviceType: DeviceType.WEIGHT_DEVICE,
            deviceData: WeightData("81")))));
  }

  @override
  void onStop() async {
    startButtonPressed.value = !startButtonPressed.value;
    playVideoSwitch.value = super.endVideoFile;
  }

  @override
  Widget buildCardDataShowArea() {
    double titleFontSize = height * 0.02;
    double dataFontSize = height * 0.02;

    return BlocBuilder<DeviceBloc, DeviceState>(builder: (context, state) {
      if (state is DeviceDataLoading) {
        bodyheight = bodyWeight = AppLocalizations.of(context)!.loading;
      } else if (state is DeviceDataUpdated) {
        if (state.deviceData is HeightData) {
          bodyheight = (state.deviceData as HeightData).height;
          UserInfo().height = bodyheight;
        }
        if (state.deviceData is WeightData) {
          bodyWeight = (state.deviceData as WeightData).weight;
          UserInfo().weight = bodyWeight;
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
                  "Height (m)",
                  style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: height * 0.02),
                Text(
                  bodyheight,
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
                  "Weight (kg)",
                  style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: height * 0.02),
                Text(
                  bodyWeight,
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
