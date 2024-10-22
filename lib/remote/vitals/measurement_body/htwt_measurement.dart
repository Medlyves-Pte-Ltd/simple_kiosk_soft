import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_devices_sdk/device_data/height_data.dart';
import 'package:flutter_devices_sdk/device_data/weight_data.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:simple_kiosk_software/blocs/device/device_event.dart';
import 'package:simple_kiosk_software/remote/blocs/appointment/appointment_bloc.dart';

import '../../../blocs/device/device_bloc.dart';
import '../../../blocs/device/device_state.dart';
import 'package:simple_kiosk_software/remote/utils/app_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_devices_sdk/device_type.dart';

class HtWtMeasurement extends StatelessWidget {
  HtWtMeasurement({super.key});

  bool heightMeasured = false;
  bool weightMeasured = false;
  late String bodyHeight;
  late String bodyWeight;

  @override
  Widget build(BuildContext context) {
    bodyHeight = BlocProvider.of<AppointmentBloc>(context)
            .getPatientBodyInfo()["height"] ??
        "- - -";
    bodyWeight = BlocProvider.of<AppointmentBloc>(context)
            .getPatientBodyInfo()["weight"] ??
        "- - -";

    return Column(
      children: [
        SizedBox(
          height: 2.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              AppLocalizations.of(context)!.hw_height,
              style: TextStyle(
                fontSize: 14.dp,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.hw_weight,
              style: TextStyle(
                fontSize: 14.dp,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 1.5.h,
        ),
        BlocBuilder<DeviceBloc, DeviceState>(buildWhen: (previous, state) {
          bool update = false;

          if (state is DeviceConnected &&
              state.deviceType == DeviceType.HEIGHT_DEVICE) {
            heightMeasured = weightMeasured = false;
            bodyHeight = BlocProvider.of<AppointmentBloc>(context)
                    .getPatientBodyInfo()["height"] ??
                "- - -";
            bodyWeight = BlocProvider.of<AppointmentBloc>(context)
                    .getPatientBodyInfo()["weight"] ??
                "- - -";
            update = true;
          } else if (state is DeviceDataLoading &&
              state.deviceType == DeviceType.HEIGHT_DEVICE) {
            bodyHeight = bodyWeight = AppLocalizations.of(context)!.loading;
            update = true;
          } else if (state is DeviceDataUpdated) {
            if (state.deviceData is HeightData) {
              heightMeasured = true;
              bodyHeight = (state.deviceData as HeightData).height;
              bodyHeight = "${double.parse(bodyHeight).toStringAsFixed(1)}";
              // 如果收到身高数据，先关闭身高设备，再打开体重设备
              Future.delayed(const Duration(milliseconds: 300), () {
                DeviceConnectEvent connectEvent =
                    DeviceConnectEvent(deviceType: DeviceType.WEIGHT_DEVICE);
                BlocProvider.of<DeviceBloc>(context).add(connectEvent);
              });
            } else if (state.deviceData is WeightData) {
              bodyWeight = (state.deviceData as WeightData).weight;
              weightMeasured = true;
              update = true;
              BlocProvider.of<AppointmentBloc>(context)
                  .processNewData({"height": bodyHeight, "weight": bodyWeight});
            }
          }

          return update;
        }, builder: (context, state) {
          return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  bodyHeight,
                  style: TextStyle(fontSize: 20.dp, color: Colors.blue),
                ),
                Text(
                  bodyWeight,
                  style: TextStyle(fontSize: 20.dp, color: Colors.blue),
                ),
              ]);
        })
      ],
    );
  }
}
