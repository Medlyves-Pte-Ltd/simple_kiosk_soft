import 'package:base_kiosk_software/common/bf_measurement.dart';
import 'package:base_kiosk_software/common/bg_measurement.dart';
import 'package:base_kiosk_software/common/bo_measurement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:base_kiosk_software/blocs/device/device_bloc.dart';
import 'package:base_kiosk_software/blocs/device/device_state.dart';
import 'package:base_kiosk_software/common/bc_measurement.dart';
import 'package:base_kiosk_software/common/bp_measurement.dart';
import 'package:base_kiosk_software/common/buttons.dart';
import 'package:base_kiosk_software/common/htwt_measurement.dart';
import 'package:base_kiosk_software/common/layouts/layout1.dart';
import 'package:base_kiosk_software/common/layouts/layout2.dart';
import 'package:base_kiosk_software/common/layouts/layout3.dart';
import 'package:base_kiosk_software/common/video_widget.dart';
import 'package:base_kiosk_software/common/stepper.dart';
import 'package:base_kiosk_software/providers/locale_provider.dart';
import 'package:base_kiosk_software/utils/enum_measurement.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:base_kiosk_software/providers/stepperprovider.dart';
import 'package:provider/provider.dart';

import '../common/bt_measurement.dart';
import '../common/ecg_measurement.dart';

class MeasurementScreen extends StatefulWidget {
  const MeasurementScreen({Key? key}) : super(key: key);

  @override
  State<MeasurementScreen> createState() => _MeasurementScreenState();
}

class _MeasurementScreenState extends State<MeasurementScreen> {
  Measurement currentMeasurement = Measurement.HW;
  bool inProgress = false;

  String getVideoFileName(StepperProvider stepperProvider) {
    // final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    // String localeCode = localeProvider.locale.languageCode;
    // String basePath = 'assets/videos';
    // String upperLocaleCode = localeCode.toUpperCase();
    //
    // Map<Measurement, String> directoryNames = {
    //   Measurement.HW: "heightweight",
    //   Measurement.BC: "bodycomposition",
    //   Measurement.BP: "bloodpressure",
    //   Measurement.BF: "bloodfat",
    //   Measurement.BO: "bloodoxygen",
    //   Measurement.BG: "bloodglucose",
    //   Measurement.BT: "bodytemperature",
    //   Measurement.ECG: "electrocardiogram"
    // };
    //
    // String directoryName =
    //     directoryNames[stepperProvider.currentMeasurement] ?? "heightweight";
    //
    // String videoFileName = '${directoryName}_$upperLocaleCode.mp4';
    // String fullPath = '$basePath/$localeCode/$videoFileName';

    return "assets/videos/zh/welcome_ZH.mp4";
  }

  @override
  Widget build(BuildContext context) {
    StepperProvider stepperProvider = Provider.of<StepperProvider>(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Layout1(
            content1: Content1Body(
      stage: StageType.measurement,
      videoSpace: VideoWidget(
          key: ValueKey(getVideoFileName(stepperProvider)),
          videoName: getVideoFileName(stepperProvider),
          setLooping: false),
      content2Builder: (context) {
        return Content2Body(
            topWidget: const StepperIndicator(),
            content3Builder: (context) {
              return stepperProvider.currentMeasurement == Measurement.HW
                  ? const HeightWeightMeasurementCard()
                  : stepperProvider.currentMeasurement == Measurement.BC
                      ? const BodyCompositionMeasurementCard()
                      : stepperProvider.currentMeasurement == Measurement.BP
                          ? const BloodPressureMeasurementCard()
                          : stepperProvider.currentMeasurement == Measurement.BF
                              ? const BloodFatMeasurementCard()
                              : stepperProvider.currentMeasurement ==
                                      Measurement.BO
                                  ? const BloodOxygenMeasurementCard()
                                  : stepperProvider.currentMeasurement ==
                                          Measurement.BG
                                      ? const BloodGlucoseMeasurementCard()
                                      : stepperProvider.currentMeasurement ==
                                              Measurement.BT
                                          ? const BodyTemperatureMeasurementCard()
                                          : stepperProvider
                                                      .currentMeasurement ==
                                                  Measurement.ECG
                                              ? const ECGMeasurementCard()
                                              : const HeightWeightMeasurementCard();
            },
            navigSpace: BlocListener<DeviceBloc, DeviceState>(
              listener: (context, state) {
                if (state is DeviceConnected) {
                  setState(() {
                    inProgress = true;
                  });
                } else if (state is DeviceDataUpdated) {
                  handleStartButtonFunction(stepperProvider);
                } else if (state is DeviceDisconnected) {
                  setState(() {
                    inProgress = false;
                  });
                }
              },
              child: Row(
                children: [
                  GreenButton(
                      buttonText: AppLocalizations.of(context)!.back,
                      onTap: () {
                        handleBackButtonFunction(stepperProvider);
                      },
                      disabled: inProgress ||
                              stepperProvider.currentMeasurement ==
                                  Measurement.HW
                          ? true
                          : false,
                      buttontype: ButtonType.measure),
                  SizedBox(width: screenWidth * 0.03),
                  stepperProvider.currentMeasurement == Measurement.BP
                      ? GreenButton(
                          buttonText: AppLocalizations.of(context)!.results,
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/summary', (route) => false);
                          },
                          disabled: inProgress ||
                              !(stepperProvider.isComplete[Measurement.HW]! &&
                                  stepperProvider.isComplete[Measurement.BC]! &&
                                  stepperProvider.isComplete[Measurement.BP]! &&
                                  stepperProvider.isComplete[Measurement.BF]! &&
                                  stepperProvider.isComplete[Measurement.BO]! &&
                                  stepperProvider.isComplete[Measurement.BG]! &&
                                  stepperProvider.isComplete[Measurement.BT]! &&
                                  stepperProvider.isComplete[Measurement.ECG]!),
                          buttontype: ButtonType.measure)
                      : GreenButton(
                          buttonText: AppLocalizations.of(context)!.next,
                          disabled: inProgress ||
                              disableNextButtonFunction(stepperProvider),
                          //false,
                          onTap: () {
                            handleNextButtonFunction(stepperProvider);
                          },
                          buttontype: ButtonType.measure),
                ],
              ),
            ));
      },
    )));
  }

  void handleBackButtonFunction(StepperProvider stepperProvider) {
    if (stepperProvider.currentMeasurement == Measurement.HW) {
      //navigate to frailty login
    } else if (stepperProvider.currentMeasurement == Measurement.BC) {
      stepperProvider.currentMeasurement = Measurement.HW;
    } else if (stepperProvider.currentMeasurement == Measurement.BP) {
      stepperProvider.currentMeasurement = Measurement.BC;
    } else if (stepperProvider.currentMeasurement == Measurement.BF) {
      stepperProvider.currentMeasurement = Measurement.BP;
    } else if (stepperProvider.currentMeasurement == Measurement.BO) {
      stepperProvider.currentMeasurement = Measurement.BF;
    } else if (stepperProvider.currentMeasurement == Measurement.BG) {
      stepperProvider.currentMeasurement = Measurement.BO;
    } else if (stepperProvider.currentMeasurement == Measurement.BT) {
      stepperProvider.currentMeasurement = Measurement.BG;
    } else if (stepperProvider.currentMeasurement == Measurement.ECG) {
      stepperProvider.currentMeasurement = Measurement.BT;
    }
    stepperProvider.notifyListeners();
  }

  void handleNextButtonFunction(StepperProvider stepperProvider) {
    if (stepperProvider.currentMeasurement == Measurement.HW) {
      stepperProvider.currentMeasurement = Measurement.BC;
    } else if (stepperProvider.currentMeasurement == Measurement.BC) {
      stepperProvider.currentMeasurement = Measurement.BP;
    } else if (stepperProvider.currentMeasurement == Measurement.BP) {
      stepperProvider.currentMeasurement = Measurement.BC;
    } else if (stepperProvider.currentMeasurement == Measurement.BF) {
      stepperProvider.currentMeasurement = Measurement.BP;
    } else if (stepperProvider.currentMeasurement == Measurement.BO) {
      stepperProvider.currentMeasurement = Measurement.BF;
    } else if (stepperProvider.currentMeasurement == Measurement.BG) {
      stepperProvider.currentMeasurement = Measurement.BO;
    } else if (stepperProvider.currentMeasurement == Measurement.BT) {
      stepperProvider.currentMeasurement = Measurement.BG;
    } else if (stepperProvider.currentMeasurement == Measurement.ECG) {
      stepperProvider.currentMeasurement = Measurement.BT;
    }
    stepperProvider.notifyListeners();
  }

  bool disableNextButtonFunction(StepperProvider stepperProvider) {
    if (stepperProvider.currentMeasurement == Measurement.HW &&
        stepperProvider.isComplete[Measurement.HW] == true) {
      return false;
    } else if (stepperProvider.currentMeasurement == Measurement.BC &&
        stepperProvider.isComplete[Measurement.BC] == true) {
      return false;
    } else if (stepperProvider.currentMeasurement == Measurement.BP &&
        stepperProvider.isComplete[Measurement.BP] == true) {
      return false;
    } else if (stepperProvider.currentMeasurement == Measurement.BF &&
        stepperProvider.isComplete[Measurement.BF] == true) {
      return false;
    } else if (stepperProvider.currentMeasurement == Measurement.BO &&
        stepperProvider.isComplete[Measurement.BG] == true) {
      return false;
    } else if (stepperProvider.currentMeasurement == Measurement.BG &&
        stepperProvider.isComplete[Measurement.BT] == true) {
      return false;
    } else if (stepperProvider.currentMeasurement == Measurement.ECG &&
        stepperProvider.isComplete[Measurement.ECG] == true) {
      return false;
    } else {
      return true;
    }
  }
}

void handleStartButtonFunction(StepperProvider stepperProvider) {
  if (stepperProvider.currentMeasurement == Measurement.HW) {
    stepperProvider.isComplete[Measurement.HW] = true;
  } else if (stepperProvider.currentMeasurement == Measurement.BC &&
      stepperProvider.isComplete[Measurement.HW] == true) {
    stepperProvider.isComplete[Measurement.BC] = true;
  } else if (stepperProvider.currentMeasurement == Measurement.BP &&
      stepperProvider.isComplete[Measurement.BC] == true) {
    stepperProvider.isComplete[Measurement.BP] = true;
  } else if (stepperProvider.currentMeasurement == Measurement.BF &&
      stepperProvider.isComplete[Measurement.BP] == true) {
    stepperProvider.isComplete[Measurement.BF] = true;
  } else if (stepperProvider.currentMeasurement == Measurement.BO &&
      stepperProvider.isComplete[Measurement.BF] == true) {
    stepperProvider.isComplete[Measurement.BO] = true;
  } else if (stepperProvider.currentMeasurement == Measurement.BG &&
      stepperProvider.isComplete[Measurement.BO] == true) {
    stepperProvider.isComplete[Measurement.BG] = true;
  } else if (stepperProvider.currentMeasurement == Measurement.ECG &&
      stepperProvider.isComplete[Measurement.BG] == true) {
    stepperProvider.isComplete[Measurement.ECG] = true;
  }
  stepperProvider.notifyListeners();
}
