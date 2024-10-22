import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrintMap {
  static String codeToName(String code, BuildContext context) {
    if (context == null) {
      return 'Unknown'; // Or any default text
    }
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

      //   case 'bmi':
      //     return loc.bmi;
      //   case 'bodyFatPercentage':
      //     return loc.fat_percent;
      //   case 'bodyFatMass':
      //     return loc.fat_mass;
      //   case 'skeletalMusclePercentage':
      //     return loc.muscle_percent;
      //   case 'basalMetabolism':
      //     return loc.basal_meta;
      //   case 'visceralFatLevel':
      //     return loc.fat_lvl;
      //   case 'protein':
      //     return loc.protein;
      //   case 'bodyAge':
      //     return loc.body_age;
      //   case 'overall':
      //     return loc.overall;
      //   case 'mineral':
      //     return loc.mineral;
      //   case 'temperature':
      //     return loc.body_temp;
      //   case 'hr':
      //     return loc.spo2_heart_rate;
      //   case 'spo2':
      //     return loc.spo2;
      case 'bo_heartrate':
        return loc.bo_heartrate;
      //   case 'systolic':
      //     return loc.systolic;
      //   case 'diastolic':
      //     return loc.diastolic;
      //   case 'bpHeartRate':
      //     return loc.bpHeartRate;
      //   case 'ecg_hr':
      //     return loc.ecg_heart_rate;
      //   case 'ecg_rr':
      //     return loc.ecg_resp_rate;
      //   case 'ecg_p_width':
      //     return loc.ecg_pwave_width;
      //   case 'ecg_pr':
      //     return loc.ecg_pr_int;
      //   case 'ecg_qrs_dur':
      //     return loc.ecg_qrs_comp_dur;
      //   case 'ecg_qt':
      //     return loc.ecg_qt_int;
      //   case 'ecg_qtc':
      //     return loc.ecg_qtc_int;
      //   case 'ecg_p_axis':
      //     return loc.ecg_pwave_amp;
      //   case 'ecg_qrs_axis':
      //     return loc.ecg_qrs_amp;
      //   case 'ecg_t_axis':
      //     return loc.ecg_twave_amp;
      //   case 'ecg_cln':
      //     return loc.ecg_concl;
      //   case 'bp':
      //     return loc.bp;
      //   case 'ecg':
      //     return loc.ecg;
      default:
        return 'Unknown';
    }
  }
}
