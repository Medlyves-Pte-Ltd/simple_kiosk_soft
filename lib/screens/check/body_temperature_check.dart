import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_devices_sdk/device_data/body_temperature_data.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:simple_kiosk_software/screens/check/base_check_widget.dart';
import 'package:simple_kiosk_software/blocs/device/device_bloc.dart';
import 'package:simple_kiosk_software/blocs/device/device_event.dart';
import 'package:simple_kiosk_software/blocs/device/device_state.dart';
import 'package:simple_kiosk_software/utils/user_info.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BodyTemperatureCheck extends BaseCheckWidget {
  late String temperature;

  BodyTemperatureCheck() {
    temperature = UserInfo().temperature.isNotEmpty
        ? UserInfo().temperature
        : dataDefaultValue;
  }

  @override
  void init() {
    super.title = AppLocalizations.of(mainContext)!.temperature;
    iconFile = "assets/images/temperature_icon.png";
    underlineColor = ColorPalette.colorbodytemperature;
  }

  @override
  Future<void> onStart() async {
    DeviceConnectEvent connectEvent =
        DeviceConnectEvent(deviceType: DeviceType.TEMP_DEVICE);
    BlocProvider.of<DeviceBloc>(mainContext).add(connectEvent);
  }

  @override
  Future<void> onStop() async {
    DeviceStopEvent stopEvent =
        DeviceStopEvent(deviceType: DeviceType.TEMP_DEVICE);
    BlocProvider.of<DeviceBloc>(mainContext).add(stopEvent);
  }

  @override
  bool needUpdate(DeviceType? type) {
    return type == DeviceType.TEMP_DEVICE;
  }

  @override
  Widget buildCardDataShowArea() {
    double titleFontSize = height * 0.01;
    double dataFontSize = height * 0.01;

    return BlocBuilder<DeviceBloc, DeviceState>(buildWhen: (previous, state) {
      if (!needUpdate(state.deviceType)) {
        return false;
      }

      bool update = false;

      if (state is DeviceConnected) {
        measured = false;
        temperature = dataDefaultValue;
        UserInfo().temperature = '';
        update = true;
      } else if (state is DeviceDataLoading) {
        temperature = AppLocalizations.of(mainContext)!.loading;
        update = true;
      } else if (state is DeviceDataUpdated &&
          state.deviceData is BodyTemperatureData) {
        temperature = UserInfo().temperature =
            (state.deviceData as BodyTemperatureData).temperature;
        measured = true;
        update = true;
      } else if (state is DeviceDisconnected) {
        if (!measured) {
          temperature = dataDefaultValue;
          update = true;
        }
      }

      return update;
    }, builder: (context, state) {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(mainContext)!.temp_temperature,
                  style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: height * 0.02),
                Text(
                  temperature,
                  style: TextStyle(
                      fontSize: dataFontSize,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.materialGreen),
                )
              ],
            ),
          ],
        ),
      );
    });
  }
}
