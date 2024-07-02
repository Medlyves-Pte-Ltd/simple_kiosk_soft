import 'package:flutter/material.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:flutter_devices_sdk/view/colors.dart';
import 'package:simple_kiosk_software/screens/measurement_pages/base_measure_layout_widget.dart';

class BodyTemperatureMeasure extends BaseMeasureLayoutWidget {
  ValueNotifier<String> temperature = ValueNotifier('- - -');

  BodyTemperatureMeasure({super.key}) {
    super.color = ColorPalette.colorbodytemperature;
    super.videoFile = 'assets/videos/zh/temperature_measure_ZH.mp4';
    super.iconFile = "assets/images/temperature_icon.png";
    super.title = "Temperature";
    super.deviceType = DeviceType.TEMP_DEVICE;
  }

  @override
  Widget buildCardDataShowArea() {
    double fontSize = height * 0.02;
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Temperature (°C)",
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 30),
        ValueListenableBuilder<String>(
            valueListenable: temperature,
            builder: (context, value, child) {
              return Text(
                value,
                style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: ColorPalette.materialGreen),
              );
            })
      ],
    ));
  }
}
