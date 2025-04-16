import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_kiosk_software/blocs/device/device_bloc.dart';
import 'package:simple_kiosk_software/blocs/device/device_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:simple_kiosk_software/remote/blocs/appointment/appointment_bloc.dart';

class TempMeasurement extends StatelessWidget {
  TempMeasurement({super.key});

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
              AppLocalizations.of(context)!.temp_temperature,
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
                style: TextStyle(fontSize: height * 0.02, color: Colors.blue),
              )
            ],
          );
        })
      ],
    );
  }
}
