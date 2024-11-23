import 'package:flutter/material.dart';
import 'package:simple_kiosk_software/remote/vitals/measurement_body/body_comp_measurement.dart';
import 'package:simple_kiosk_software/remote/vitals/measurement_body/bp_measurement.dart';
import 'package:simple_kiosk_software/remote/vitals/measurement_body/ecg_measurement.dart';
import 'package:simple_kiosk_software/remote/vitals/measurement_body/htwt_measurement.dart';
import 'package:simple_kiosk_software/remote/vitals/measurement_body/blood_oxygen_measurement.dart';
import 'package:simple_kiosk_software/remote/vitals/measurement_body/temp_measurement.dart';
import 'package:simple_kiosk_software/utils/app_config.dart';

class VideoClip {
  final String startMeasureVid;
  final String endMeasureVid;

  VideoClip(this.startMeasureVid, this.endMeasureVid);
}

enum MeasurementType {
  heightWeight,
  temperature,
  bloodPressure,
  bodyComposition,
  spo2,
  ecg,
  // hbA1C,
  // lipid,
  // kh,
  // lh,
  // kl,
  // lo,
}

class MeasurementTypeInfo {
  final int index;
  late String title;
  final Map<String, VideoClip>
      videos; // Map to store videos for different languages
  final Widget measurementBody;

  MeasurementTypeInfo(
      this.title, this.videos, this.index, this.measurementBody);
}

Map<MeasurementType, MeasurementTypeInfo> measurementTypeVideos = {
  MeasurementType.heightWeight: MeasurementTypeInfo(
      'Height & Weight',
      {
        'English': VideoClip("${AppConfig().videosDir}/en/heightweight_EN.mp4",
            "${AppConfig().videosDir}/en/completed_next_EN.mp4"),
        'Thai': VideoClip("${AppConfig().videosDir}/th/heightweight_TH.mp4",
            "${AppConfig().videosDir}/th/completed_next_TH.mp4"),
        'Chinese': VideoClip("${AppConfig().videosDir}/zh/heightweight_ZH.mp4",
            "${AppConfig().videosDir}/zh/heightweight_completed_ZH.mp4"),
        // Add more languages if needed
      },
      0,
      HtWtMeasurement()),
  MeasurementType.temperature: MeasurementTypeInfo(
      'Temperature',
      {
        'English': VideoClip("${AppConfig().videosDir}/en/temperature_EN.mp4",
            "${AppConfig().videosDir}/en/completed_next_EN.mp4"),
        'Thai': VideoClip("${AppConfig().videosDir}/th/temperature_TH.mp4",
            "${AppConfig().videosDir}/th/completed_next_TH.mp4"),
        'Chinese': VideoClip("${AppConfig().videosDir}/zh/temperature_ZH.mp4",
            "${AppConfig().videosDir}/zh/temperature_completed_ZH.mp4"),
        // Add more languages if needed
      },
      1,
      const TempMeasurement()),
  MeasurementType.bloodPressure: MeasurementTypeInfo(
      'Blood Pressure',
      {
        'English': VideoClip("${AppConfig().videosDir}/en/bloodpressure_EN.mp4",
            "${AppConfig().videosDir}/en/completed_next_EN.mp4"),
        'Thai': VideoClip("${AppConfig().videosDir}/th/bloodpressure_TH.mp4",
            "${AppConfig().videosDir}/th/completed_next_TH.mp4"),
        'Chinese': VideoClip("${AppConfig().videosDir}/zh/bloodpressure_ZH.mp4",
            "${AppConfig().videosDir}/zh/bloodpressure_completed_ZH.mp4"),
        // Add more languages if needed
      },
      2,
      const BPMeasurement()),
  MeasurementType.bodyComposition: MeasurementTypeInfo(
      'Body Composition',
      {
        'English': VideoClip(
            "${AppConfig().videosDir}/en/bodycomposition_EN.mp4",
            "${AppConfig().videosDir}/en/completed_next_EN.mp4"),
        'Thai': VideoClip("${AppConfig().videosDir}/th/bodycomposition_TH.mp4",
            "${AppConfig().videosDir}/th/completed_next_TH.mp4"),
        'Chinese': VideoClip(
            "${AppConfig().videosDir}/zh/bodycomposition_ZH.mp4",
            "${AppConfig().videosDir}/zh/bodycomposition_completed_ZH.mp4"),
        // Add more languages if needed
      },
      3,
      const BodyCompMeasurement()),
  MeasurementType.spo2: MeasurementTypeInfo(
      'Oxygen Saturation',
      {
        'English': VideoClip("${AppConfig().videosDir}/en/spo2_EN.mp4",
            "${AppConfig().videosDir}/en/completed_next_EN.mp4"),
        'Thai': VideoClip("${AppConfig().videosDir}/th/spo2_TH.mp4",
            "${AppConfig().videosDir}/th/completed_next_TH.mp4"),
        'Chinese': VideoClip("${AppConfig().videosDir}/zh/spo2_ZH.mp4",
            "${AppConfig().videosDir}/zh/spo2_completed_ZH.mp4"),
        // Add more languages if needed
      },
      4,
      const BloodOxygenMeasurement()),
  MeasurementType.ecg: MeasurementTypeInfo(
      'ECG',
      {
        'English': VideoClip("a${AppConfig().videosDir}/en/ecg_EN.mp4",
            "${AppConfig().videosDir}/en/completed_next_EN.mp4"),
        'Thai': VideoClip("${AppConfig().videosDir}/th/ecg_TH.mp4",
            "${AppConfig().videosDir}/th/completed_next_TH.mp4"),
        'Chinese': VideoClip("${AppConfig().videosDir}/zh/ecg_ZH.mp4",
            "${AppConfig().videosDir}/zh/ecg_completed_ZH.mp4"),
        // Add more languages if needed
      },
      5,
      const ECGMeasurement()),
};

class VitalTitle {
  static String getHeaderText(int step) {
    MeasurementType type = MeasurementType.values[step];

    // Retrieve the MeasurementTypeInfo object for the given MeasurementType
    MeasurementTypeInfo? info = measurementTypeVideos[type];

    // Return the title from the MeasurementTypeInfo object
    // If the info is null, return a default title or handle it accordingly
    print("title: ${info?.title} $step");
    return info?.title ?? 'Default Title';
  }
}

// class VideoAsset {
//   static String getVideoURL(int step) {
//     if (step >= 0 && step < MeasurementType.values.length) {
//       MeasurementTypeInfo? info =
//           measurementTypeVideos[MeasurementType.values[step]];

//       String language = 'Thai';
//       VideoClip? videoClip = info?.videos[language];

//       String videoName = videoClip?.startMeasureVid ?? '';
//       print("Video Name: $videoName");

//       return videoName;
//     } else {
//       print("Active Step Out of Bounds");
//       return '${AppConfig().videosDir}/thai/VideoNotFound.mp4'; // Or provide a default video name.
//     }
//   }
// }

// class KioskController extends ChangeNotifier {
//   final Logger logger = Logger(
//     printer: PrettyPrinter(
//       methodCount: 0,
//       errorMethodCount: 5,
//       lineLength: 50,
//       colors: true,
//       printTime: true,
//     ),
//   );

//   int curFlowStep = 0;

//   late String curVideo = VideoAsset.getVideoURL(0);
// }
