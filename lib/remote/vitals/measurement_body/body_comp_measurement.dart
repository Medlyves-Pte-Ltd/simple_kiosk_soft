import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_devices_sdk/device_data/body_composition_data.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:simple_kiosk_software/blocs/device/device_bloc.dart';

import 'package:simple_kiosk_software/remote/blocs/appointment/appointment_bloc.dart';
import '../../../blocs/device/device_state.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BodyCompMeasurement extends StatelessWidget {
  BodyCompMeasurement({
    Key? key,
  }) : super(key: key);

  double width = 0;
  double height = 0;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        BlocBuilder<DeviceBloc, DeviceState>(builder: (context, state) {
          String bodyFatPercentage = BlocProvider.of<AppointmentBloc>(context)
                  .getPatientBodyInfo()["bodyFatPercentage"] ??
              "- - -";
          String bodyFatMass = BlocProvider.of<AppointmentBloc>(context)
                  .getPatientBodyInfo()["bodyFatMass"] ??
              "- - -";
          String basalMetabolism = BlocProvider.of<AppointmentBloc>(context)
                  .getPatientBodyInfo()["basalMetabolism"] ??
              "- - -";
          String bodyWaterPercentage = BlocProvider.of<AppointmentBloc>(context)
                  .getPatientBodyInfo()["bodyWaterPercentage"] ??
              "- - -";
          String skeletalMusclePercentage =
              BlocProvider.of<AppointmentBloc>(context)
                      .getPatientBodyInfo()["skeletalMusclePercentage"] ??
                  "- - -";
          String visceralFatLevel = BlocProvider.of<AppointmentBloc>(context)
                  .getPatientBodyInfo()["visceralFatLevel"] ??
              "- - -";
          // String extracellularWaterPercentage =
          //     BlocProvider.of<AppointmentBloc>(context)
          //             .getPatientBodyInfo()["extracellularWaterPercentage"] ??
          //         "- - -";
          // String intracellularWaterPercentage =
          //     BlocProvider.of<AppointmentBloc>(context)
          //             .getPatientBodyInfo()["intracellularWaterPercentage"] ??
          //         "- - -";
          // String totalMoisture = BlocProvider.of<AppointmentBloc>(context)
          //         .getPatientBodyInfo()["totalMoisture"] ??
          //     "- - -";
          // String extracellularWaterPercentage =
          //     BlocProvider.of<AppointmentBloc>(context)
          //             .getPatientBodyInfo()["extracellularWaterPercentage"] ??
          //         "- - -";
          // String intracellularWaterPercentage =
          //     BlocProvider.of<AppointmentBloc>(context)
          //             .getPatientBodyInfo()["intracellularWaterPercentage"] ??
          //         "- - -";
          // String totalMoisture = BlocProvider.of<AppointmentBloc>(context)
          //         .getPatientBodyInfo()["totalMoisture"] ??
          //     "- - -";
          String protein = BlocProvider.of<AppointmentBloc>(context)
                  .getPatientBodyInfo()["protein"] ??
              "- - -";
          String mineral = BlocProvider.of<AppointmentBloc>(context)
                  .getPatientBodyInfo()["mineral"] ??
              "- - -";
          // String bodyAge = BlocProvider.of<AppointmentBloc>(context)
          //         .getPatientBodyInfo()["bodyAge"] ??
          //     "- - -";
          // String overall = BlocProvider.of<AppointmentBloc>(context)
          //         .getPatientBodyInfo()["overall"] ??
          //     "- - -";
          // String bodyAge = BlocProvider.of<AppointmentBloc>(context)
          //         .getPatientBodyInfo()["bodyAge"] ??
          //     "- - -";
          // String overall = BlocProvider.of<AppointmentBloc>(context)
          //         .getPatientBodyInfo()["overall"] ??
          //     "- - -";
          if (state is DeviceDataLoading) {
            bodyFatPercentage = AppLocalizations.of(context)!.loading;
            bodyFatMass = AppLocalizations.of(context)!.loading;
            basalMetabolism = AppLocalizations.of(context)!.loading;
            skeletalMusclePercentage = AppLocalizations.of(context)!.loading;
            visceralFatLevel = AppLocalizations.of(context)!.loading;
            protein = AppLocalizations.of(context)!.loading;
            mineral = AppLocalizations.of(context)!.loading;
            bodyWaterPercentage = AppLocalizations.of(context)!.loading;
            // extracellularWaterPercentage =
            //     AppLocalizations.of(context)!.reading;
            // intracellularWaterPercentage =
            //     AppLocalizations.of(context)!.reading;
            // totalMoisture = AppLocalizations.of(context)!.reading;
            // bodyAge = AppLocalizations.of(context)!.reading;
            // overall = AppLocalizations.of(context)!.reading;
          } else if (state is DeviceDataUpdated) {
            if (state.deviceType == DeviceType.BC_DEVICE &&
                state.deviceData is BodyCompositionData) {
              BodyCompositionData bodyCompositionData =
                  state.deviceData as BodyCompositionData;
              bodyFatPercentage = bodyCompositionData.bodyFatPercentage ?? "";
              basalMetabolism = bodyCompositionData.basalMetabolism ?? "";
              visceralFatLevel = bodyCompositionData.visceralFatLevel ?? "";
              protein = bodyCompositionData.proteinPercentage ?? "";
              bodyWaterPercentage =
                  bodyCompositionData.bodyWaterPercentage ?? "";

              BlocProvider.of<AppointmentBloc>(context).processNewData({
                'bodyFatPercentage': bodyFatPercentage,
                'basalMetabolism': basalMetabolism,
                'visceralFatLevel': visceralFatLevel,
                'protein': protein,
                "bodyWaterPercentage": bodyWaterPercentage
              });
            }
          }
          return GridView.count(
            // 一行几列
            crossAxisCount: 2,
            // 设置每子元素的大小（宽高比）
            childAspectRatio: 2,
            // 元素的左右的 距离
            crossAxisSpacing: width * 0.02,
            // 子元素上下的 距离
            mainAxisSpacing: height * 0.015,
            physics:
                const NeverScrollableScrollPhysics(), // Disable GridView scrolling
            shrinkWrap: true,
            children: [
              _buildGridItem(
                  AppLocalizations.of(context)!.bcm_fat, bodyFatPercentage),
              _buildGridItem(AppLocalizations.of(context)!.bcm_metabolism,
                  basalMetabolism),
              _buildGridItem(AppLocalizations.of(context)!.bcm_visceralfat,
                  visceralFatLevel),
              // _buildGridItem(
              //     AppLocalizations.of(context)!.bcm_bone_mass, boneMass),
              // _buildGridItem(
              //     AppLocalizations.of(context)!.bcm_water, bodyWaterPercentage),
              _buildGridItem(
                  AppLocalizations.of(context)!.bcm_protein_percentage,
                  protein),
              _buildGridItem(AppLocalizations.of(context)!.water_percent,
                  bodyWaterPercentage),
              // _buildGridItem(AppLocalizations.of(context)!.extrac_fluid,
              //     extracellularWaterPercentage),
              // _buildGridItem(AppLocalizations.of(context)!.intrac_fluid,
              // intracellularWaterPercentage),
              // _buildGridItem(
              //     AppLocalizations.of(context)!.moisture, totalMoisture),
              // _buildGridItem(AppLocalizations.of(context)!.body_age, bodyAge),
              // _buildGridItem(AppLocalizations.of(context)!.overall, overall),
              // Add more GridView items here as needed
            ],
          );
        })
      ],
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
