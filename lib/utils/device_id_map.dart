import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeviceMap {
  static Map<String, int> CODETOID = {
    'height': 1,
    'weight': 2,
    'bmi': 3,
    'bodyFatPercentage': 4,
    'bodyFatMass': 5,
    'skeletalMusclePercentage': 6,
    'bodyWaterPercentage': 7,
    'totalMoisture': 8,
    'extracellularWaterPercentage': 9,
    'intracellularWaterPercentage': 10,
    'basalMetabolism': 11,
    'visceralFatLevel': 12,
    'protein': 13,
    'mineral': 14,
    'bodyAge': 15,
    'overall': 16,
    'temperature': 17,
    'systolic': 18,
    'diastolic': 19,
    'bpHeartRate': 20,
    'spo2': 21,
    'spo2HeartRate': 22,
    'ecg_img': 23,
    'ecg_hr': 24,
    'ecg_rr': 25,
    'ecg_p_width': 26,
    'ecg_pr': 27,
    'ecg_qrs_dur': 28,
    'ecg_qt': 29,
    'ecg_qtc': 30,
    'ecg_p_axis': 31,
    'ecg_qrs_axis': 32,
    'ecg_t_axis': 33,
    'ecg_cln': 34
  };

  static Map<String, String> CODETOUNIT = {
    'height': 'cm',
    'weight': 'kg',
    'bmi': 'N.A.',
    'bodyFatPercentage': '%',
    'bodyFatMass': 'N.A.',
    'skeletalMusclePercentage': '%',
    'bodyWaterPercentage': '%',
    'totalMoisture': 'N.A.',
    'extracellularWaterPercentage': 'N.A.',
    'intracellularWaterPercentage': 'N.A.',
    'basalMetabolism': 'N.A.',
    'visceralFatLevel': 'N.A.',
    'protein': 'N.A.',
    'bodyAge': 'N.A.',
    'overall': 'N.A.',
    'mineral': 'N.A.',
    'temperature': '°C',
    'systolic': 'mmHg',
    'diastolic': 'mmHg',
    'bpHeartRate': 'bpm',
    'spo2': '%',
    'spo2HeartRate': 'bpm',
    'ecg_img': 'N.A.',
    'ecg_hr': 'bpm',
    'ecg_rr': 'ms',
    'ecg_p_width': 'ms',
    'ecg_pr': 'ms',
    'ecg_qrs_dur': 'ms',
    'ecg_qt': 'ms',
    'ecg_qtc': 'ms',
    'ecg_p_axis': 'N.A.',
    'ecg_qrs_axis': 'N.A.',
    'ecg_t_axis': 'N.A.',
    'ecg_cln': 'N.A.',
    'bp': 'mmHg',
    'hr': 'bpm',
  };

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
      //   case 'spo2HeartRate':
      //     return loc.spo2_heart_rate;
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

  static String IDTONAME(BuildContext context, int id) {
    final loc = AppLocalizations.of(context)!;
    return "xxx";
    // switch (id) {
    //   case 1:
    //     return loc.height;
    //   case 2:
    //     return loc.weight;
    //   case 3:
    //     return loc.bmi;
    //   case 4:
    //     return loc.fat_percent;
    //   case 5:
    //     return loc.fat_mass;
    //   case 6:
    //     return loc.muscle_percent;
    //   case 7:
    //     return loc.water_percent;
    //   case 8:
    //     return loc.moisture;
    //   case 9:
    //     return loc.extrac_fluid;
    //   case 10:
    //     return loc.intrac_fluid;
    //   case 11:
    //     return loc.basal_meta;
    //   case 12:
    //     return loc.fat_lvl;
    //   case 13:
    //     return loc.protein;
    //   case 14:
    //     return loc.mineral;
    //   case 15:
    //     return loc.body_age;
    //   case 16:
    //     return loc.overall;
    //   case 17:
    //     return loc.temp;
    //   case 18:
    //     return loc.systolic;
    //   case 19:
    //     return loc.diastolic;
    //   case 20:
    //     return loc.bp_pulse;
    //   case 21:
    //     return loc.bo;
    //   case 22:
    //     return loc.spo2_heart_rate;
    //   // case 23:
    //   // return loc.ecg_img;
    //   case 24:
    //     return loc.ecg_hr;
    //   case 25:
    //     return loc.ecg_rr;
    //   case 26:
    //     return loc.ecg_p_width;
    //   case 27:
    //     return loc.ecg_pr;
    //   case 28:
    //     return loc.ecg_qrs_dur;
    //   case 29:
    //     return loc.ecg_qt;
    //   case 30:
    //     return loc.ecg_qtc;
    //   case 31:
    //     return loc.ecg_p_axis;
    //   case 32:
    //     return loc.ecg_qrs_axis;
    //   case 33:
    //     return loc.ecg_t_axis;
    //   case 34:
    //     return loc.ecg_concl;
    //   default:
    //     return 'Unknown';
    // }
  }

  static Map<String, int> ruiYiDaDevicesMap = {
    "11": 1,
    "12": 2,
    "14": 3,
    "13": 4,
    "15": 5,
    "1": 6,
    "4": 7,
    "151": 8,
    "152": 9,
    "153": 10,
    "154": 11,
    "155": 12,
    "156": 13,
    "157": 14,
    "131": 15,
    "132": 16,
    "133": 17,
    "134": 18,
    "135": 19,
  };
}
