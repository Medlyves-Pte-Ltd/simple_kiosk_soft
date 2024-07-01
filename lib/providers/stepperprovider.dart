import 'package:flutter/material.dart';
import 'package:base_kiosk_software/utils/enum_measurement.dart';

class StepperProvider extends ChangeNotifier {
  Measurement currentMeasurement =
      Measurement.HW; //set currentMeasurement to heightweight initially

  Map<Measurement, bool> isComplete = {
    // Measurement.HW : false,
    // Measurement.BC : false,
    // Measurement.BP : false,
  };
  StepperProvider() {
    for (Measurement m in Measurement.values) {
      isComplete[m] = false;
    }
  }

  void setCurrentMeasurement(Measurement measurementType) {
    currentMeasurement = measurementType;
    notifyListeners();
  }

  bool showFooter = true;
  bool get footerVisibility => showFooter;

  void setFooterVisibility(bool val) {
    showFooter = val;
    notifyListeners();
  }

  void resetFrailty() {
    for (Measurement m in Measurement.values) {
      isComplete[m] = false;
    }
    currentMeasurement = Measurement.HW;
    notifyListeners();
  }
}
