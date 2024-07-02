import 'package:flutter/material.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:flutter_devices_sdk/view/colors.dart';
import 'package:simple_kiosk_software/screens/measurement_pages/base_measure_layout_widget.dart';

class HeightWeightMeasure extends BaseMeasureLayoutWidget {
  ValueNotifier<String> _height = ValueNotifier('- - -');
  ValueNotifier<String> _weight = ValueNotifier('- - -');

  HeightWeightMeasure({super.key}) {
    super.color = ColorPalette.colorheightWeight;
    super.videoFile = 'assets/videos/zh/heightweight_ZH.mp4';
    super.iconFile = "assets/images/heightweight_logo.png";
    super.title = "Height & Weight";
    super.deviceType = DeviceType.HW_DEVICE;
  }

  @override
  Widget buildCardDataShowArea() {
    double fontSize = height * 0.02;

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
                style:
                    TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 30),
              ValueListenableBuilder<String>(
                  valueListenable: _height,
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
          ),
          const SizedBox(width: 30),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Weight (kg)",
                style:
                    TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 30),
              ValueListenableBuilder<String>(
                  valueListenable: _weight,
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
          )
        ],
      ),
    );
  }
}
