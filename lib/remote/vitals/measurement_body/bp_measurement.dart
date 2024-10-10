import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:simple_kiosk_software/remote/utils/app_constants.dart';
import 'package:flutter_devices_sdk/device_type.dart';

import 'package:simple_kiosk_software/remote/blocs/appointment/appointment_bloc.dart';
import '../../../blocs/device/device_bloc.dart';
import '../../../blocs/device/device_state.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BPMeasurement extends StatelessWidget {
  const BPMeasurement({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 2.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              AppLocalizations.of(context)!.bp_bloodpressure,
              style: TextStyle(
                fontSize: 14.dp,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.bp_pulse,
              style: TextStyle(
                fontSize: 14.dp,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 1.5.h,
        ),
        BlocBuilder<DeviceBloc, DeviceState>(builder: (context, state) {
          LogPrinter.log("BP measurement received: ${state.toString()}");
          String systolic = BlocProvider.of<AppointmentBloc>(context)
                  .getPatientBodyInfo()["systolic"] ??
              "- - -";
          String diastolic = BlocProvider.of<AppointmentBloc>(context)
                  .getPatientBodyInfo()["diastolic"] ??
              "- - -";
          String pr = BlocProvider.of<AppointmentBloc>(context)
                  .getPatientBodyInfo()["bpHeartRate"] ??
              "- - -";
          if (state is DeviceDataLoading) {
            systolic = AppLocalizations.of(context)!.loading;
            diastolic = AppLocalizations.of(context)!.loading;
            pr = AppLocalizations.of(context)!.loading;
          } else if (state is DeviceDataUpdated) {
            if (state.deviceType == DeviceType.BP_DEVICE) {
              systolic = state.deviceData.data["systolic"];
              diastolic = state.deviceData.data["diastolic"];
              pr = state.deviceData.data["bpHeartRate"];
              BlocProvider.of<AppointmentBloc>(context)
                  .processNewData(state.deviceData.data);
            }
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Text(
                    systolic,
                    style: TextStyle(fontSize: 22.dp, color: Colors.blue),
                  ),
                  Text(
                    "/",
                    style: TextStyle(fontSize: 22.dp, color: Colors.black),
                  ),
                  Text(
                    diastolic,
                    style: TextStyle(fontSize: 22.dp, color: Colors.blue),
                  ),
                ],
              ),
              SizedBox(
                height: 0.5.h,
              ),
              Text(
                pr,
                style: TextStyle(fontSize: 22.dp, color: Colors.blue),
              ),
            ],
          );
        }),
      ],
    );
  }
}
