import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_devices_sdk/device_data/height_data.dart';
import 'package:flutter_devices_sdk/device_data/weight_data.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:simple_kiosk_software/blocs/device/device_bloc.dart';
import 'package:simple_kiosk_software/blocs/device/device_event.dart';
import 'package:simple_kiosk_software/blocs/device/device_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_kiosk_software/screens/measurement_pages/base_measure_layout_widget.dart';
import 'package:simple_kiosk_software/utils/user_info.dart';

class HeightWeightMeasure extends BaseMeasureLayoutWidget {
  late String bodyHeight;
  late String bodyWeight;

  HeightWeightMeasure() {
    super.color = ColorPalette.colorheightWeight;
    super.startVideoFile = 'assets/videos/zh/heightweight_ZH.mp4';
    super.endVideoFile = 'assets/videos/zh/heightweight_completed_ZH.mp4';
    super.iconFile = "assets/images/heightweight_logo.png";
    super.deviceType = DeviceType.HEIGHT_DEVICE;
    bodyHeight =
        UserInfo().height.isNotEmpty ? UserInfo().height : dataDefaultValue;
    bodyWeight =
        UserInfo().weight.isNotEmpty ? UserInfo().weight : dataDefaultValue;
  }

  @override
  void init() {
    super.title = AppLocalizations.of(mainContext)!.hw;
  }

  @override
  void onStart() async {
    bodyHeight = dataDefaultValue;
    bodyWeight = dataDefaultValue;

    DeviceConnectEvent connectEvent =
        DeviceConnectEvent(deviceType: DeviceType.HEIGHT_DEVICE);
    BlocProvider.of<DeviceBloc>(mainContext).add(connectEvent);

    // BlocProvider.of<DeviceBloc>(mainContext).add(TestUpdateDataEvent(
    //     deviceType: DeviceType.HEIGHT_DEVICE, deviceData: HeightData("1.76")));

    // Future.delayed(
    //     const Duration(milliseconds: 100),
    //     () => (BlocProvider.of<DeviceBloc>(mainContext).add(TestUpdateDataEvent(
    //         deviceType: DeviceType.WEIGHT_DEVICE,
    //         deviceData: WeightData("81")))));
  }

  @override
  void onStop() async {
    DeviceStopEvent stopEvent =
        DeviceStopEvent(deviceType: DeviceType.HEIGHT_DEVICE);
    BlocProvider.of<DeviceBloc>(mainContext).add(stopEvent);

    stopEvent = DeviceStopEvent(deviceType: DeviceType.WEIGHT_DEVICE);
    BlocProvider.of<DeviceBloc>(mainContext).add(stopEvent);
  }

  @override
  Widget buildCardDataShowArea() {
    double titleFontSize = height * 0.02;
    double dataFontSize = height * 0.02;

    return BlocListener<DeviceBloc, DeviceState>(listener: (context, state) {
      if (state is DeviceDataUpdated) {
        if (state.deviceData is HeightData) {
          bodyHeight = (state.deviceData as HeightData).height;
          UserInfo().height = bodyHeight;

          // 如果收到身高数据，先关闭身高设备，再打开体重设备
          DeviceStopEvent stopEvent =
              DeviceStopEvent(deviceType: DeviceType.HEIGHT_DEVICE);
          BlocProvider.of<DeviceBloc>(mainContext).add(stopEvent);

          Future.delayed(const Duration(milliseconds: 100), () {
            DeviceConnectEvent connectEvent =
                DeviceConnectEvent(deviceType: DeviceType.WEIGHT_DEVICE);
            BlocProvider.of<DeviceBloc>(mainContext).add(connectEvent);
          });

          // BlocProvider.of<DeviceBloc>(mainContext).add(TestUpdateDataEvent(
          //     deviceType: DeviceType.WEIGHT_DEVICE,
          //     deviceData: WeightData("81")));
        } else if (state.deviceData is WeightData) {
          bodyWeight = (state.deviceData as WeightData).weight;
          UserInfo().weight = bodyWeight;
        }
      } else {
        bodyHeight = bodyWeight = AppLocalizations.of(context)!.loading;
      }
    }, child: BlocBuilder<DeviceBloc, DeviceState>(builder: (context, state) {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.hw_height,
                  style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: height * 0.02),
                Text(
                  bodyHeight,
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
                  AppLocalizations.of(context)!.hw_weight,
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
    }));

    return BlocBuilder<DeviceBloc, DeviceState>(builder: (context, state) {
      if (state is DeviceDataLoading) {
        bodyHeight = bodyWeight = AppLocalizations.of(context)!.loading;
      } else if (state is DeviceDataUpdated) {
        if (state.deviceData is HeightData) {
          bodyHeight = (state.deviceData as HeightData).height;
          UserInfo().height = bodyHeight;
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
                  bodyHeight,
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
