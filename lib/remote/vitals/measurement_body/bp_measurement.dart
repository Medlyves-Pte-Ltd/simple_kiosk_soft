import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_devices_sdk/log/log_printer.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:simple_kiosk_software/remote/utils/app_constants.dart';
import 'package:flutter_devices_sdk/device_type.dart';

import 'package:simple_kiosk_software/remote/blocs/appointment/appointment_bloc.dart';
import '../../../blocs/device/device_bloc.dart';
import '../../../blocs/device/device_state.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BPMeasurement extends StatelessWidget {
  BPMeasurement({super.key});

  double width = 0;
  double height = 0;

  @override
  Widget build(BuildContext context) {
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
              AppLocalizations.of(context)!.bp_bloodpressure,
              style: TextStyle(
                fontSize: height * 0.02,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.bp_pulse,
              style: TextStyle(
                fontSize: height * 0.02,
              ),
            ),
          ],
        ),
        SizedBox(
          height: height * 0.01,
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
                    style:
                        TextStyle(fontSize: height * 0.02, color: Colors.blue),
                  ),
                  Text(
                    "/",
                    style:
                        TextStyle(fontSize: height * 0.02, color: Colors.black),
                  ),
                  Text(
                    diastolic,
                    style:
                        TextStyle(fontSize: height * 0.02, color: Colors.blue),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Text(
                pr,
                style: TextStyle(fontSize: height * 0.02, color: Colors.blue),
              ),
            ],
          );
        }),
      ],
    );
  }
}
