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
  late String bodyBmi;
  double width = 0;
  double height = 0;

  @override
  Widget build(BuildContext context) {
    bodyHeight = BlocProvider.of<AppointmentBloc>(context)
            .getPatientBodyInfo()["height"] ??
        "- - -";
    bodyWeight = BlocProvider.of<AppointmentBloc>(context)
            .getPatientBodyInfo()["weight"] ??
        "- - -";
    bodyBmi =
        BlocProvider.of<AppointmentBloc>(context).getPatientBodyInfo()["bmi"] ??
            "- - -";
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        SizedBox(
          height: height * 0.01,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              AppLocalizations.of(context)!.hw_height,
              style: TextStyle(
                fontSize: height * 0.02,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.hw_weight,
              style: TextStyle(
                fontSize: height * 0.02,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.hw_bmi,
              style: TextStyle(
                fontSize: height * 0.02,
              ),
            ),
          ],
        ),
        SizedBox(
          height: height * 0.01,
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
            bodyBmi = BlocProvider.of<AppointmentBloc>(context)
                    .getPatientBodyInfo()["bmi"] ??
                "- - -";
            update = true;
          } else if (state is DeviceDataLoading &&
              state.deviceType == DeviceType.HEIGHT_DEVICE) {
            bodyHeight =
                bodyWeight = bodyBmi = AppLocalizations.of(context)!.loading;
            update = true;
          } else if (state is DeviceDataUpdated) {
            if (state.deviceData is HeightData) {
              heightMeasured = true;
              bodyHeight = (state.deviceData as HeightData).height;
              bodyHeight = "${double.parse(bodyHeight).toStringAsFixed(1)}";
              // 如果收到身高数据，先关闭身高设备，再打开体重设备
              Future.delayed(const Duration(milliseconds: 500), () {
                DeviceConnectEvent connectEvent =
                    DeviceConnectEvent(deviceType: DeviceType.WEIGHT_DEVICE);
                BlocProvider.of<DeviceBloc>(context).add(connectEvent);
              });
            } else if (state.deviceData is WeightData) {
              bodyWeight = (state.deviceData as WeightData).weight;
              // bmi
              double height_m = double.parse(bodyHeight) / 100.0;
              bodyBmi = (double.parse(bodyWeight) / (height_m * height_m))
                  .toStringAsFixed(1);

              weightMeasured = true;
              update = true;
              BlocProvider.of<AppointmentBloc>(context).processNewData(
                  {"height": bodyHeight, "weight": bodyWeight, "bmi": bodyBmi});
            }
          }

          return update;
        }, builder: (context, state) {
          return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  bodyHeight,
                  style: TextStyle(fontSize: height * 0.02, color: Colors.blue),
                ),
                Text(
                  bodyWeight,
                  style: TextStyle(fontSize: height * 0.02, color: Colors.blue),
                ),
                Text(
                  bodyBmi,
                  style: TextStyle(fontSize: height * 0.02, color: Colors.blue),
                ),
              ]);
        })
      ],
    );
  }
}
