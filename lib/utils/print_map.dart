import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrintMap {
  static String codeToName(String code, BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    switch (code) {
      case 'height':
        return loc.hw_height;
      case 'weight':
        return loc.hw_weight;
      case 'temperature':
        return loc.temp_temperature;
      case 'bloodPressure':
        return loc.bp_bloodpressure;
      case 'bp_pulse':
        return loc.bp_pulse;
      case 'bloodOxygen':
        return loc.bo_oxygen_staturation;
      case "IFCC":
        return loc.bg_ifcc;
      case "eAG":
        return loc.bg_bloodglucose;
      case "chol":
        return loc.bf_totalCholesterol;
      case "trig":
        return loc.bf_triglyceride;
      case "hdl":
        return loc.bf_hgl;
      case "ldl":
        return loc.bf_ldl;

      // 人体成分
      case "bodyFatPercentage":
        return loc.bcm_fat;
      case "skeletalMusclePercentage":
        return loc.bcm_skeletal;
      case "basalMetabolism":
        return loc.bcm_metabolism;
      case "visceralFatLevel":
        return loc.bcm_visceralfat;
      case "bodyWaterPercentage":
        return loc.bcm_water;
      case "protein":
        return loc.bcm_protein;
      case "proteinPercentage":
        return loc.bcm_protein_percentage;
      case "boneMass":
        return loc.bcm_bone_mass;
      case "muscleMass":
        return loc.bcm_muscle_mass;
      case "bodyAge":
        return loc.body_age;
      case "extracellularFluid":
        return loc.bcm_extrac_fluid;
      case "intracellularWaterPercentage":
        return loc.bcm_intrac_fluid;
      case "totalMoisture":
        return loc.bcm_moisture;
      case "bodyFatMass":
        return loc.bcm_fatmass;
      case "skeletalMusclePercentage":
        return loc.bcm_skeletal;

      // 心电图
      case "HR":
        return loc.ecg_hr;
      case "PR":
        return loc.ecg_pr;
      case "QT":
        return loc.ecg_qt;
      case "QTc":
        return loc.ecg_qtc;
      case "P_Width":
        return loc.ecg_p_width;
      case "QRS_Dur":
        return loc.ecg_qrs_dur;
      case "P_Axis":
        return loc.ecg_p_axis;
      case "QRS_Axis":
        return loc.ecg_qrs_axis;
      case "T_Axis":
        return loc.ecg_t_axis;

      case 'bo_heartrate':
        return loc.bo_heartrate;
      default:
        return 'Unknown';
    }
  }
}
