import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_devices_sdk/log/log_printer.dart';
import 'package:flutter_devices_sdk/view/colors.dart';
import 'package:simple_kiosk_software/utils/control_measure_page_utils.dart';

Widget measureValueChangeColor(
    String data, String min, String max, double fontSize, bool compare) {
  if (!compare) {
    return Text(
      data,
      style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: ColorPalette.materialGreen),
    );
  }

  if (ControlMeasurePageUtils().measured) {
    double value = 0.0;
    try {
      value = double.parse(data);
    } catch (e) {
      LogPrinter.log("$e");
    }

    return Text(
      data,
      style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: data.isNotEmpty &&
                  min.isNotEmpty &&
                  max.isNotEmpty &&
                  (value > double.parse(max) || value < double.parse(min))
              ? Colors.red
              : ColorPalette.materialGreen),
    );
  } else {
    return Text(
      data,
      style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: ColorPalette.materialGreen),
    );
  }
}

Widget summaryValueChangeColor(
    String data, String min, String max, double fontSize, bool compare) {
  return Text(
    data,
    style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: data.isNotEmpty &&
                min.isNotEmpty &&
                max.isNotEmpty &&
                ((double.parse(data) > double.parse(max) ||
                    double.parse(data) < double.parse(min)))
            ? Colors.red
            : ColorPalette.materialGreen),
  );
}

Widget rangeMeasureWidget(
    String min, String max, double fontSize, bool compare) {
  if (!compare) {
    return const SizedBox.shrink();
  }

  return Visibility(
    child: Text(
      "($min ~ $max)",
      style: TextStyle(fontSize: fontSize, color: ColorPalette.materialGreen),
    ),
    visible: ControlMeasurePageUtils().measured,
  );
}

Widget rangeSummaryWidget(String min, String max, double fontSize) {
  return Text(
    "($min ~ $max)",
    style: TextStyle(fontSize: fontSize, color: ColorPalette.materialGreen),
  );
}
