import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_kiosk_software/remote/blocs/appointment/appointment_bloc.dart';
import '../../../blocs/device/device_bloc.dart';
import '../../../blocs/device/device_state.dart';
import 'package:simple_kiosk_software/remote/utils/enum_device_type.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ECGMeasurement extends StatelessWidget {
  ECGMeasurement({super.key});
  double width = 0;
  double height = 0;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

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
                          fontSize: height * 0.02,
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
                              fontSize: height * 0.02,
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
              height: height * 0.3, // Set a fixed height for the GridView
              child: GridView.count(
                primary: false,
                // 一行几列
                crossAxisCount: 3,
                // 设置每子元素的大小（宽高比）
                childAspectRatio: 1.8,
                // 元素的左右的 距离
                crossAxisSpacing: width * 0.02,
                // 子元素上下的 距离
                mainAxisSpacing: height * 0.01,
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
            style: TextStyle(fontSize: height * 0.02, color: Colors.black),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Text(
            value,
            style: TextStyle(fontSize: height * 0.02, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
