import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:simple_kiosk_software/blocs/device/device_bloc.dart';
import 'package:simple_kiosk_software/blocs/device/device_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:simple_kiosk_software/remote/blocs/appointment/appointment_bloc.dart';

class TempMeasurement extends StatelessWidget {
  const TempMeasurement({super.key});

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
              AppLocalizations.of(context)!.temp_temperature,
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
          String temp = BlocProvider.of<AppointmentBloc>(context)
                  .getPatientBodyInfo()["temperature"] ??
              "- - -";
          if (state is DeviceDataLoading) {
            temp = AppLocalizations.of(context)!.loading;
          } else if (state is DeviceDataUpdated) {
            if (state.deviceData.data.containsKey("temperature")) {
              temp = state.deviceData.data["temperature"]!;
            }
            BlocProvider.of<AppointmentBloc>(context)
                .processNewData(state.deviceData.data);
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                temp,
                style: TextStyle(fontSize: 20.dp, color: Colors.blue),
              )
            ],
          );
        })
      ],
    );
  }
}
