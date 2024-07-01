import 'package:flutter/material.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:simple_kiosk_software/utils/enum_measurement.dart';

enum IconType { greyed, current, completed }

class StepperIcon extends StatelessWidget {
  final IconType icontype;
  final Measurement measurement;
  final int number;

  const StepperIcon({
    super.key,
    required this.measurement,
    required this.icontype,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    Color iconColour = Colors.white;
    Widget? childWidget;

    switch (icontype) {
      case IconType.greyed:
        iconColour = ColorPalette.greyDisabledButtonWidgetBorder;
        childWidget = Text(
          number.toString(),
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          textScaler: const TextScaler.linear(1.5),
        );
        break;
      case IconType.current:
        switch (measurement) {
          case Measurement.HW:
            iconColour = ColorPalette.colorheightWeight;
            childWidget = Image.asset('assets/images/heightweight_logo.png');
            break;
          case Measurement.BC:
            iconColour = ColorPalette.colorbodyComp;
            childWidget = Image.asset('assets/images/bodycomposition_logo.png');
            break;
          case Measurement.BP:
            iconColour = ColorPalette.colorbloodPressure;
            childWidget = Image.asset('assets/images/bloodpressure_logo.png');
            break;
          case Measurement.BG:
            iconColour = ColorPalette.colorbloodGlucose;
            childWidget = Image.asset('assets/images/bloodpressure_logo.png');
            break;
          case Measurement.BF:
            iconColour = ColorPalette.colorbloodFat;
            childWidget = Image.asset('assets/images/bloodpressure_logo.png');
            break;
          case Measurement.BT:
            break;
          case Measurement.BO:
            break;
          case Measurement.ECG:
            break;
        }
        break;
      case IconType.completed:
        switch (measurement) {
          case Measurement.HW:
            iconColour = ColorPalette.colorheightWeight;
            childWidget = const Text(
              '1',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              textScaler: TextScaler.linear(1.5),
            );
            break;
          case Measurement.BC:
            iconColour = ColorPalette.colorbodyComp;
            childWidget = const Text(
              '2',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              textScaler: TextScaler.linear(1.5),
            );
            break;
          case Measurement.BP:
            iconColour = ColorPalette.colorbloodPressure;
            childWidget = const Text(
              '3',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              textScaler: TextScaler.linear(1.5),
            );
            break;
          case Measurement.BG:
            iconColour = ColorPalette.colorbloodPressure;
            childWidget = const Text(
              '4',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              textScaler: TextScaler.linear(1.5),
            );
            break;
          case Measurement.BF:
            iconColour = ColorPalette.colorbloodPressure;
            childWidget = const Text(
              '3',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              textScaler: TextScaler.linear(1.5),
            );
            break;
          case Measurement.BT:
            break;
          case Measurement.BO:
            break;
          case Measurement.ECG:
            break;
        }
        break;
    }

    return Container(
      width: screenWidth * 0.085,
      height: screenWidth * 0.085,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: iconColour,
      ),
      child: Center(child: childWidget),
    );
  }
}
