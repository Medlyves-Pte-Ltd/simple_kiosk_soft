import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:simple_kiosk_software/remote/blocs/appointment/appointment_bloc.dart';
import '../../../blocs/device/device_bloc.dart';
import '../../../blocs/device/device_state.dart';

class BloodOxygenMeasurement extends StatelessWidget {
  const BloodOxygenMeasurement({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 2.h,
        ),
        // Container(
        //   padding: EdgeInsets.only(top: 1.h, bottom: 4.h),
        //   child: Center(child: Text(AppLocalizations.of(context)!.pulse_graph)),
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              AppLocalizations.of(context)!.bo_oxygen_staturation,
              style: TextStyle(
                fontSize: 14.dp,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.bo_heartrate,
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
          String spo2 = BlocProvider.of<AppointmentBloc>(context)
                  .getPatientBodyInfo()["spo2"] ??
              "- - -";
          String pr = BlocProvider.of<AppointmentBloc>(context)
                  .getPatientBodyInfo()["spo2HeartRate"] ??
              "- - -";
          if (state is DeviceDataLoading) {
            spo2 = AppLocalizations.of(context)!.loading;
            pr = AppLocalizations.of(context)!.loading;
          } else if (state is DeviceDataUpdated) {
            if (state.deviceData.data.containsKey("spo2")) {
              spo2 = state.deviceData.data["spo2"]!;
            }
            if (state.deviceData.data.containsKey("spo2HeartRate")) {
              pr = state.deviceData.data["spo2HeartRate"]!;
            }
            BlocProvider.of<AppointmentBloc>(context)
                .processNewData(state.deviceData.data);
          }
          return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  spo2,
                  style: TextStyle(fontSize: 20.dp, color: Colors.blue),
                ),
                Text(
                  pr,
                  style: TextStyle(fontSize: 20.dp, color: Colors.blue),
                ),
              ]);
        }),
      ],
    );
  }
}
