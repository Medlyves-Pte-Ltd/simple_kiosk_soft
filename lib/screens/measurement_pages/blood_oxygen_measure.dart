import 'package:flutter/material.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:flutter_devices_sdk/view/colors.dart';
import 'package:simple_kiosk_software/screens/measurement_pages/base_measure_layout_widget.dart';

class BloodOxygenMeasure extends BaseMeasureLayoutWidget {
  ValueNotifier<String> _bloodOxygen = ValueNotifier('- - -');
  ValueNotifier<String> _pulseRate = ValueNotifier('- - -');

  BloodOxygenMeasure() {
    super.color = ColorPalette.colorheightWeight;
    super.startVideoFile = 'assets/videos/zh/spo2_measure_ZH.mp4';
    super.iconFile = "assets/images/spo2_icon.png";
    super.title = "Blood Oxygen";
    super.deviceType = DeviceType.BO_DEVICE;
    playVideoSwitch.value = super.startVideoFile;
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
                "Oxygen Saturation (%)",
                style:
                    TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 30),
              ValueListenableBuilder<String>(
                  valueListenable: _bloodOxygen,
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
                "Pulse Rate (bpm)",
                style:
                    TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 30),
              ValueListenableBuilder<String>(
                  valueListenable: _pulseRate,
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
