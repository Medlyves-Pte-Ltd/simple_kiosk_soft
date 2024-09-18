import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:simple_kiosk_software/remote/blocs/appointment/appointment_bloc.dart';
import '../../../blocs/device/device_bloc.dart';
import '../../../blocs/device/device_state.dart';
import 'package:simple_kiosk_software/remote/utils/enum_device_type.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ECGMeasurement extends StatelessWidget {
  const ECGMeasurement({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceBloc, DeviceState>(
      builder: (context, state) {
        String hr = BlocProvider.of<AppointmentBloc>(context)
                .getPatientBodyInfo()["ecg_hr"] ??
            "- - -";
        String pr = BlocProvider.of<AppointmentBloc>(context)
                .getPatientBodyInfo()["ecg_pr"] ??
            "- - -";
        String pWidth = BlocProvider.of<AppointmentBloc>(context)
                .getPatientBodyInfo()["ecg_p_width"] ??
            "- - -";
        String qrsDur = BlocProvider.of<AppointmentBloc>(context)
                .getPatientBodyInfo()["ecg_qrs_dur"] ??
            "- - -";
        String qt = BlocProvider.of<AppointmentBloc>(context)
                .getPatientBodyInfo()["ecg_qt"] ??
            "- - -";
        String qtc = BlocProvider.of<AppointmentBloc>(context)
                .getPatientBodyInfo()["ecg_qtc"] ??
            "- - -";
        String pAxis = BlocProvider.of<AppointmentBloc>(context)
                .getPatientBodyInfo()["ecg_p_axis"] ??
            "- - -";
        String qrsAxis = BlocProvider.of<AppointmentBloc>(context)
                .getPatientBodyInfo()["ecg_qrs_axis"] ??
            "- - -";
        String tAxis = BlocProvider.of<AppointmentBloc>(context)
                .getPatientBodyInfo()["ecg_t_axis"] ??
            "- - -";
        String rr = BlocProvider.of<AppointmentBloc>(context)
                .getPatientBodyInfo()["ecg_rr"] ??
            "- - -";
        String cln = BlocProvider.of<AppointmentBloc>(context)
                .getPatientBodyInfo()["ecg_cln"] ??
            "- - -";
        if (state is DeviceDataUpdated) {
          if (state.deviceType == DeviceType.ECG_DEVICE) {
            hr = state.deviceData.data["ecg_hr"];
            pr = state.deviceData.data["ecg_pr"];
            pWidth = state.deviceData.data["ecg_p_width"];
            qrsDur = state.deviceData.data["ecg_qrs_dur"];
            qt = state.deviceData.data["ecg_qt"];
            qtc = state.deviceData.data["ecg_qtc"];
            pAxis = state.deviceData.data["ecg_p_axis"];
            qrsAxis = state.deviceData.data["ecg_qrs_axis"];
            tAxis = state.deviceData.data["ecg_t_axis"];
            rr = state.deviceData.data["ecg_rr"];
            cln = state.deviceData.data["ecg_cln"];
            BlocProvider.of<AppointmentBloc>(context)
                .processNewData(state.deviceData.data);
          }
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.blue,
                  width: 0.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(
                    8.0), // Padding for the entire container content
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        AppLocalizations.of(context)!.results,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.dp,
                          color: Colors
                              .blue, // Choose a color that fits your app theme
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Wrap(
                        children: [
                          Text(
                            cln,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 10.dp,
                              color: Colors
                                  .black87, // Adjust the color to match your theme
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 40.0.h, // Set a fixed height for the GridView
              child: GridView.count(
                primary: false,
                //padding: EdgeInsets.all(0),
                crossAxisCount: 3,
                mainAxisSpacing: 1.w,
                crossAxisSpacing: 1.w,
                childAspectRatio: 1.7,
                physics:
                    const NeverScrollableScrollPhysics(), // Disable GridView scrolling
                shrinkWrap: true,
                children: [
                  _buildGridItem(AppLocalizations.of(context)!.ecg_hr, hr),
                  _buildGridItem(AppLocalizations.of(context)!.ecg_pr, pr),
                  _buildGridItem(AppLocalizations.of(context)!.ecg_qt, qt),
                  _buildGridItem(AppLocalizations.of(context)!.ecg_qtc, qtc),
                  _buildGridItem(
                      AppLocalizations.of(context)!.ecg_p_width, pWidth),
                  _buildGridItem(
                      AppLocalizations.of(context)!.ecg_qrs_dur, qrsDur),
                  _buildGridItem(
                      AppLocalizations.of(context)!.ecg_p_axis, pAxis),
                  _buildGridItem(
                      AppLocalizations.of(context)!.ecg_qrs_axis, qrsAxis),
                  _buildGridItem(
                      AppLocalizations.of(context)!.ecg_t_axis, tAxis),
                  //_buildGridItem(AppLocalizations.of(context)!.ecg_rr, rr),
                  // Add more GridView items here as needed
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGridItem(String label, String value) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 10.dp, color: Colors.black),
          ),
          SizedBox(
            height: 1.5.h,
          ),
          Text(
            value,
            style: TextStyle(fontSize: 20.dp, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
