import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:simple_kiosk_software/remote/blocs/appointment/appointment_bloc.dart';

import '../../../blocs/device/device_bloc.dart';
import '../../../blocs/device/device_state.dart';
import 'package:simple_kiosk_software/remote/utils/app_constants.dart';
import 'package:simple_kiosk_software/remote/utils/enum_device_type.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HtWtMeasurement extends StatelessWidget {
  const HtWtMeasurement({super.key});

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
        BlocBuilder<DeviceBloc, DeviceState>(builder: (context, state) {
          String height = BlocProvider.of<AppointmentBloc>(context)
                  .getPatientBodyInfo()["height"] ??
              "- - -";
          String weight = BlocProvider.of<AppointmentBloc>(context)
                  .getPatientBodyInfo()["weight"] ??
              "- - -";
          LogPrinter.log("HW measurement received: ${state.toString()}");
          if (state is DeviceDataLoading) {
            height = AppLocalizations.of(context)!.loading;
            weight = AppLocalizations.of(context)!.loading;
          } else if (state is DeviceDataUpdated) {
            if (state.deviceType == DeviceType.HW_DEVICE) {
              height = state.deviceData.data["height"]!;
              weight = state.deviceData.data["weight"]!;
              BlocProvider.of<AppointmentBloc>(context)
                  .processNewData(state.deviceData.data);
            }
          }
          return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  height,
                  style: TextStyle(fontSize: 20.dp, color: Colors.blue),
                ),
                Text(
                  weight,
                  style: TextStyle(fontSize: 20.dp, color: Colors.blue),
                ),
              ]);
        }),
      ],
    );
  }
}
