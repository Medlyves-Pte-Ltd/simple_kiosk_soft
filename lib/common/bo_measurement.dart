import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:base_kiosk_software/blocs/device/device_bloc.dart';
import 'package:base_kiosk_software/blocs/device/device_event.dart';
import 'package:base_kiosk_software/blocs/device/device_state.dart';
import 'package:base_kiosk_software/common/client_details.dart';
import 'package:base_kiosk_software/common/start_stop_button.dart';
import 'package:base_kiosk_software/constants/app_constants.dart';
import 'package:base_kiosk_software/constants/colors.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:base_kiosk_software/utils/storage_utils.dart';

class MeasurementConfiguration {
  final List<String> measurementLabels;
  final List<String> readingLabels;

  MeasurementConfiguration({
    required this.measurementLabels,
    required this.readingLabels,
  });
}

class BloodOxygenMeasurementCard extends StatefulWidget {
  const BloodOxygenMeasurementCard({
    super.key,
  });

  @override
  BloodOxygenMeasurementCardState createState() =>
      BloodOxygenMeasurementCardState();
}

class BloodOxygenMeasurementCardState
    extends State<BloodOxygenMeasurementCard> {
  Map<String, dynamic> userDetails = {
    'patientId': '',
    'age': '',
    'gender': '',
    'blood oxygen percent': '',
    'heart rate': ''
  };
  bool startButtonPressed = false;

  @override
  void initState() {
    super.initState();

    StorageUtils.getData(userDetails.keys.toSet()).then((userDetailsData) {
      setState(() {
        userDetails = userDetailsData;
      });
    }).catchError((error) {
      print("Error fetching user details: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final cardHeight = screenHeight * 0.396;
    final cardWidth = screenWidth * 0.87;
    final fontSize = screenHeight * 0.0185;

    return BlocBuilder<DeviceBloc, DeviceState>(
      builder: (context, state) {
        MeasurementConfiguration config = getConfiguration(state);
        return Container(
          height: cardHeight,
          width: cardWidth,
          padding: EdgeInsets.symmetric(horizontal: cardWidth * 0.03),
          decoration: BoxDecoration(
            border: Border.all(
                color: ColorPalette.greyDisabledButtonWidgetBorder, width: 1.0),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              SizedBox(
                height: cardHeight * 0.18,
                child: Row(
                  children: [
                    Image(
                        image: const AssetImage(' '),
                        width: screenWidth * 0.0926),
                    SizedBox(width: cardWidth * 0.04),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: IntrinsicWidth(
                        child: Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.bo,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSize),
                            ),
                            Container(
                              color: ColorPalette.colorbloodoxygen,
                              height: 1.5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    BlocListener<DeviceBloc, DeviceState>(
                      listener: (context, state) {
                        LogPrinter.log(state.toString());
                        if (state is DeviceDisconnected) {
                          LogPrinter.log("Device is disconnected.");
                          setState(() {
                            startButtonPressed = false;
                          });
                        }
                      },
                      child: StartStopButton(
                          color: startButtonPressed
                              ? ColorPalette.colorbloodoxygen
                              : ColorPalette.materialGreen,
                          buttonName: startButtonPressed
                              ? AppLocalizations.of(context)!.stop
                              : AppLocalizations.of(context)!.start,
                          onPressed: () {
                            _onStartStopButtonPressed();
                          }),
                    ),
                    SizedBox(width: cardWidth * 0.02),
                  ],
                ),
              ),
              SizedBox(height: cardHeight * 0.07),
              Container(
                child: measurementDetailsWidget(
                    config, screenWidth, cardWidth, cardHeight, fontSize),
              ),
              // Conditional inclusion of ClientDetails based on mode
              const Spacer(),
              _buildBottomBorder(),
              ClientDetails(userDetails: userDetails),
            ],
          ),
        );
      },
    );
  }

  Widget measurementDetailsWidget(
    MeasurementConfiguration config,
    double screenWidth,
    double cardWidth,
    double cardHeight,
    double fontSize,
  ) {
    return SizedBox(
      height: cardHeight * 0.47,
      width: cardWidth * 0.9,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
                config.measurementLabels.length,
                (index) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(config.measurementLabels[index],
                            style: TextStyle(fontSize: fontSize)),
                        Text(config.readingLabels[index],
                            style: TextStyle(
                                color: config.readingLabels[index] == '- - -' ||
                                        config.readingLabels[index] ==
                                            AppLocalizations.of(context)!
                                                .loading
                                    ? ColorPalette.materialGreen
                                    : ColorPalette.blackColor,
                                fontWeight: FontWeight.bold,
                                fontSize: config.readingLabels[index] == '- - -'
                                    ? fontSize * 1.5
                                    : fontSize)),
                      ],
                    )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBorder() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: ColorPalette.greyDisabledButtonWidgetBorder, width: 1.0),
        ),
      ),
    );
  }

  MeasurementConfiguration getConfiguration(DeviceState state) {
    String Bloodoxygenpercent = userDetails['blood oxygen percent'] == ''
        ? '- - -'
        : userDetails['blood oxygen percent'];
    String Heartrate =
        userDetails['heart rate'] == '' ? '- - -' : userDetails['heart rate'];

    if (state.deviceType == DeviceType.BO_DEVICE) {
      if (state is DeviceDataLoading) {
        Bloodoxygenpercent = Heartrate = AppLocalizations.of(context)!.loading;
      } else if (state is DeviceDataUpdated) {
        Map<String, String> updatedData = state.deviceData.data;
        StorageUtils.saveData(updatedData);
        userDetails = {...userDetails, ...updatedData};
        Bloodoxygenpercent = updatedData["bloodoxygenpercent"]!;
        Heartrate = updatedData['heart rate']!;
      }
    }

    return MeasurementConfiguration(measurementLabels: [
      AppLocalizations.of(context)!.bo_bloodpressure,
      AppLocalizations.of(context)!.bo_heartrate, //显示检测出的血氧浓度，心率
    ], readingLabels: [
      Bloodoxygenpercent,
      Heartrate
    ]);
  }

  void _onStartStopButtonPressed() {
    DeviceType deviceType = DeviceType.BO_DEVICE;
    if (!startButtonPressed) {
      DeviceConnectEvent connectEvent =
          DeviceConnectEvent(deviceType: deviceType);
      BlocProvider.of<DeviceBloc>(context).add(connectEvent);
    } else {
      DeviceStopEvent stopEvent = DeviceStopEvent(deviceType: deviceType);
      BlocProvider.of<DeviceBloc>(context).add(stopEvent);
    }
    setState(() {
      startButtonPressed = !startButtonPressed;
    });
  }
}
