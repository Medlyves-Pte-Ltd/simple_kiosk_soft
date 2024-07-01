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

  MeasurementConfiguration(
      {required this.measurementLabels, required this.readingLabels});
}

class BloodFatMeasurementCard extends StatefulWidget {
  const BloodFatMeasurementCard({super.key});

  @override
  BloodFatMeasurementCardState createState() => BloodFatMeasurementCardState();
}

class BloodFatMeasurementCardState extends State<BloodFatMeasurementCard> {
  Map<String, dynamic> userDetails = {
    'patientId': '',
    'age': '',
    'gender': '',
    'Total cholesterol': '',
    'triglyceride': '',
    'High density lipoprotein cholesterol': '',
    'Low density lipoprotein cholesterol': '',
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
                        image: const AssetImage(
                            'assets/images/heightweight_logo.png'),
                        width: screenWidth * 0.0926),
                    SizedBox(width: cardWidth * 0.04),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: IntrinsicWidth(
                        child: Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.bf,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize,
                              ),
                            ),
                            Container(
                              color: ColorPalette.colorbloodFat,
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
                              ? ColorPalette.colorbloodPressure
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
              const Spacer(),
              _buildBottomBorder(),
              ClientDetails(
                userDetails: userDetails,
              ),
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
    String totalCholesterol = userDetails['Total cholesterol'] == ''
        ? '- - -'
        : userDetails['Total cholesterol'];
    String triglyceride = userDetails['triglyceride'] == ''
        ? '- - -'
        : userDetails['Triglyceride'];
    String highDensitylipoproteincholesterol =
        userDetails['High density lipoprotein cholesterol'] == ''
            ? '- - -'
            : userDetails['High density lipoprotein cholesterol'];
    String LowDensitylipoproteincholesterol =
        userDetails['Low density lipoprotein cholesterol'] == ''
            ? '- - -'
            : userDetails['Low density lipoprotein cholesterol'];

    if (state.deviceType == DeviceType.BF_DEVICE) {
      if (state is DeviceDataLoading) {
        totalCholesterol = triglyceride = highDensitylipoproteincholesterol =
            LowDensitylipoproteincholesterol =
                AppLocalizations.of(context)!.loading;
      } else if (state is DeviceDataUpdated) {
        Map<String, String> updatedData = state.deviceData.data;
        StorageUtils.saveData(updatedData);
        userDetails = {...userDetails, ...updatedData};
        totalCholesterol = updatedData["Total cholesterol "]!;
        triglyceride = updatedData["triglyceride"]!;
        highDensitylipoproteincholesterol =
            updatedData["High density lipoprotein cholesterol"]!;
        LowDensitylipoproteincholesterol =
            updatedData["Low density lipoprotein cholesterol"]!;
      }
    }

    return MeasurementConfiguration(
      measurementLabels: [
        AppLocalizations.of(context)!.bf_totalCholesterol,
        AppLocalizations.of(context)!.bf_triglyceride,
        AppLocalizations.of(context)!.bf_highDensitylipoproteincholesterol,
        AppLocalizations.of(context)!.bf_LowDensitylipoproteincholesterol,
      ],
      readingLabels: [
        totalCholesterol,
        triglyceride,
        highDensitylipoproteincholesterol,
        LowDensitylipoproteincholesterol
      ],
    );
  }

  void _onStartStopButtonPressed() {
    DeviceType deviceType = DeviceType.BF_DEVICE;
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
