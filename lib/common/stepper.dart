import 'package:flutter/material.dart';
import 'package:simple_kiosk_software/common/stepper_icon.dart';
import 'package:simple_kiosk_software/utils/enum_measurement.dart';
import 'package:provider/provider.dart';
import 'package:simple_kiosk_software/providers/stepperprovider.dart';

class StepperIndicator extends StatefulWidget {
  const StepperIndicator();

  @override
  State<StepperIndicator> createState() => _StepperIndicatorState();
}

class _StepperIndicatorState extends State<StepperIndicator> {
  @override
  Widget build(BuildContext context) {
    late Widget progressindicator;
    final stepperProvider = Provider.of<StepperProvider>(context);
    List<Measurement> availableMeasurements = [];
    List<Widget> stepperIcons = [];

    availableMeasurements = [Measurement.HW, Measurement.BC, Measurement.BP];

    for (Measurement measurement in availableMeasurements) {
      stepperIcons.add(StepperIcon(
          measurement: measurement,
          icontype: stepperProvider.isComplete[measurement]!
              ? IconType.completed
              : stepperProvider.currentMeasurement == measurement
                  ? IconType.current
                  : IconType.greyed,
          number: availableMeasurements.indexOf(measurement) + 1));
    }
    progressindicator = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: stepperIcons,
      ),
    );

    return Center(
      child: progressindicator,
    );
  }
}
