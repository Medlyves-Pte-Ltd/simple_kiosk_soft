import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_kiosk_software/utils/body_range.dart';

class PrintMap {
  static String codeToRange(String code) {
    switch (code) {
      case 'height':
        return "";
      case 'weight':
        return "(${BodyRange().weightMin.toStringAsFixed(1)} ~ ${BodyRange().weightMax.toStringAsFixed(1)})";
      case 'bmi':
        return "(${BodyRange().bmiMin.toStringAsFixed(1)} ~ ${BodyRange().bmiMax.toStringAsFixed(1)})";
      case 'temperature':
        return "(${BodyRange().temperatureMin.toStringAsFixed(1)} ~ ${BodyRange().temperatureMax.toStringAsFixed(1)})";
      case 'bloodPressure':
        return "( < ${BodyRange().systolicMax})/( < ${BodyRange().diastolicMax})";
      case 'bp_pulse':
        return "(${BodyRange().heartRateMin.toString()} ~ ${BodyRange().heartRateMax.toString()})";
      case 'bloodOxygen':
        return "(${BodyRange().spo2Min.toString()} ~ ${BodyRange().spo2Max.toString()})";
      case "IFCC":
        return "";
      case "eAG":
        return "";
      case "chol":
        return "";
      case "trig":
        return "";
      case "hdl":
        return "";
      case "ldl":
        return "";

      // 人体成分
      case "bodyFatPercentage":
        return "(${BodyRange().fatRateMin.toString()} ~ ${BodyRange().fatRateMax.toString()})";
      case "skeletalMusclePercentage":
        return "(${BodyRange().skeletalRateMin.toStringAsFixed(1)} ~ ${BodyRange().skeletalRageMax.toStringAsFixed(1)})";
      case "basalMetabolism":
        return "(${BodyRange().basalMetabolismMin.toString()} ~ ${BodyRange().basalMetabolismMax.toString()})";
      case "visceralFatLevel":
        return "(${BodyRange().visceralFatLevelMin.toString()} ~ ${BodyRange().visceralFatLevelMax.toString()})";
      case "bodyWaterPercentage":
        return "(${BodyRange().waterRateMin.toStringAsFixed(1)} ~ ${BodyRange().waterRateMax.toStringAsFixed(1)})";
      case "protein":
        return "(${BodyRange().proteinMin.toStringAsFixed(1)} ~ ${BodyRange().proteinMax.toStringAsFixed(1)})";
      case "proteinPercentage":
        return "(${BodyRange().proteinRateMin.toStringAsFixed(1)} ~ ${BodyRange().proteinRateMax.toStringAsFixed(1)})";
      case "boneMass":
        return "(${BodyRange().boneMassMin.toStringAsFixed(1)} ~ ${BodyRange().boneMassMax.toStringAsFixed(1)})";
      case "muscleMass":
        return "(${BodyRange().muscleMassMin.toStringAsFixed(1)} ~ ${BodyRange().muscleMassMax.toStringAsFixed(1)})";
      case "bodyAge":
        return "";
      case "extracellularFluid":
        return "(${BodyRange().extracellularWaterRateMin.toStringAsFixed(1)} ~ ${BodyRange().extracellularWaterRateMax.toStringAsFixed(1)})";
      case "intracellularWaterPercentage":
        return "(${BodyRange().intracellularWaterRateMin.toStringAsFixed(1)} ~ ${BodyRange().intracellularWaterRateMax.toStringAsFixed(1)})";
      case "totalMoisture":
        return "(${BodyRange().totalMoistureMin.toStringAsFixed(1)} ~ ${BodyRange().totalMoistureMax.toStringAsFixed(1)})";
      case "bodyFatMass":
        return "(${BodyRange().bodyFatMassMin.toStringAsFixed(1)} ~ ${BodyRange().bodyFatMassMax.toStringAsFixed(1)})";

      // 心电图
      case "HR":
        return "";
      case "PR":
        return "";
      case "QT":
        return "";
      case "QTc":
        return "";
      case "P_Width":
        return "";
      case "QRS_Dur":
        return "";
      case "P_Axis":
        return "";
      case "QRS_Axis":
        return "";
      case "T_Axis":
        return "";

      case 'bo_heartrate':
        return "(${BodyRange().heartRateMin.toString()} ~ ${BodyRange().heartRateMax.toString()})";
      default:
        return '';
    }
  }

  static String codeToName(String code, BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    switch (code) {
      case 'height':
        return loc.hw_height;
      case 'weight':
        return loc.hw_weight;
      case 'bmi':
        return loc.hw_bmi;
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
