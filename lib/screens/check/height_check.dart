import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_devices_sdk/device_data/height_data.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:simple_kiosk_software/screens/check/base_check_widget.dart';
import 'package:simple_kiosk_software/utils/user_info.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_kiosk_software/blocs/device/device_state.dart';
import 'package:simple_kiosk_software/blocs/device/device_bloc.dart';
import 'package:simple_kiosk_software/blocs/device/device_event.dart';

class HeightCheck extends BaseCheckWidget {
  late String bodyHeight;

  HeightCheck() {
    bodyHeight =
        UserInfo().height.isNotEmpty ? UserInfo().height : dataDefaultValue;
  }

  @override
  void init() {
    super.title = AppLocalizations.of(mainContext)!.height;
    iconFile = "assets/images/heightweight_logo.png";
    underlineColor = ColorPalette.colorheightWeight;
  }

  @override
  Future<void> onStart() async {
    DeviceConnectEvent connectEvent =
        DeviceConnectEvent(deviceType: DeviceType.HEIGHT_DEVICE);
    BlocProvider.of<DeviceBloc>(mainContext).add(connectEvent);
  }

  @override
  Future<void> onStop() async {
    DeviceStopEvent stopEvent =
        DeviceStopEvent(deviceType: DeviceType.HEIGHT_DEVICE);
    BlocProvider.of<DeviceBloc>(mainContext).add(stopEvent);
  }

  @override
  bool needUpdate(DeviceType? type) {
    return type == DeviceType.HEIGHT_DEVICE;
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
        bodyHeight = dataDefaultValue;
        UserInfo().height = '';
        update = true;
      } else if (state is DeviceDataLoading) {
        bodyHeight = AppLocalizations.of(mainContext)!.loading;
        update = true;
      } else if (state is DeviceDataUpdated && state.deviceData is HeightData) {
        UserInfo().height = (state.deviceData as HeightData).height;
        bodyHeight =
            (double.parse(UserInfo().height) / 100.0).toStringAsFixed(2);
        measured = true;
        update = true;
      } else if (state is DeviceDisconnected) {
        if (!measured) {
          bodyHeight = dataDefaultValue;
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
                  AppLocalizations.of(mainContext)!.hw_height,
                  style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: height * 0.02),
                Text(
                  bodyHeight,
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
