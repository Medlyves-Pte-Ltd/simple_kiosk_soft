import 'dart:core';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:base_kiosk_software/utils/storage_utils.dart';
import 'device_id_map.dart';

class PrintCmd {
  static Uint8List receipt = Uint8List(0);

  static Future<void> createBitmapImage(BuildContext context) async {
    Map<String, dynamic> data = (await StorageUtils.getData({
      'patientId', 
      'gender', 
      'age', 
      'height',
      'weight',
      'bmi',
      'systolic',
      'diastolic',
      'bpHeartRate',
      'bodyFatPercentage',
      'bodyFatMass',
      'basalMetabolism',
      'bodyWaterPercentage',
      'skeletalMusclePercentage',
      'visceralFatLevel',
      'protein'
    }))..removeWhere((key, value) => value == "");

    // Calculate height of the full receipt
    const int width = 380;
    const int rowHeight = 30;
    const int lineHeight = 5;
    const double fontSize = 24;
    const int gapHeight = (rowHeight - fontSize) ~/ 2;
    double delta = 0;

    ui.Paint sectionPaint = ui.Paint();
    sectionPaint.strokeWidth = 5;

    ui.Paint separationPaint = ui.Paint();
    separationPaint.strokeWidth = 2;
    separationPaint.strokeCap = ui.StrokeCap.round;

    // Load the MedLyves logo image from assets
    ByteData logoAsset =
        await rootBundle.load('assets/images/nhc_logo.png');
    List<int> logoBytes = logoAsset.buffer.asUint8List();
    img.Image logoRawImg = img.decodePng(Uint8List.fromList(logoBytes))!;

    // Resize to the same width as the receipt and keep ratio
    img.Image resizedLogoImg =
        img.copyResize(logoRawImg, width: width, maintainAspect: true);

    ui.Codec codec =
        await ui.instantiateImageCodec(img.encodePng(resizedLogoImg));
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    ui.Image uiLogoImg = frameInfo.image;

    int logoHeight = uiLogoImg.height;
    // int dataSectionHeight = rowHeight * data.length * 2;
    // int receiptHeight = logoHeight + dataSectionHeight;

    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final ui.Canvas canvas = ui.Canvas(recorder);

    // Draw the logo
    canvas.drawImage(uiLogoImg, const ui.Offset(0, 0), ui.Paint());

    // Put data into receipt image
    double yOffset = logoHeight.toDouble() + rowHeight;

    String modeTitle = 
        "${AppLocalizations.of(context)!.mode}: ";
    String modeStr = AppLocalizations.of(context)!.purpose_frailty;
    drawText(canvas, modeTitle, TextAlign.left, fontSize, const ui.Color(0xFF000000),
        ui.Offset(0, yOffset), width.toDouble());
    yOffset += rowHeight;
    drawText(canvas, modeStr, TextAlign.left, fontSize, const ui.Color(0xFF000000),
        ui.Offset(130, yOffset), width.toDouble());
    yOffset += rowHeight;

      String patientIdTitle = 
          AppLocalizations.of(context)!.patient_id;
      String patientId = data['patientId'];
      drawText(canvas, patientIdTitle, TextAlign.left, fontSize, const ui.Color(0xFF000000),
          ui.Offset(0, yOffset), width.toDouble());
      yOffset += rowHeight;
      drawText(canvas, patientId, TextAlign.left, fontSize, const ui.Color(0xFF000000),
          ui.Offset(130, yOffset), width.toDouble());
      yOffset += rowHeight;

      String ageTitle =
          AppLocalizations.of(context)!.print_age;
      String age = data['age'];
      drawText(canvas, ageTitle, TextAlign.left, fontSize, const ui.Color(0xFF000000),
          ui.Offset(0, yOffset), width.toDouble());
      yOffset += rowHeight;
      drawText(canvas, age, TextAlign.left, fontSize, const ui.Color(0xFF000000),
          ui.Offset(130, yOffset), width.toDouble());
      yOffset += rowHeight;

      String genderTitle =
          AppLocalizations.of(context)!.print_gender;
      String gender = data['gender'];
      drawText(canvas, genderTitle, TextAlign.left, fontSize,
          const ui.Color(0xFF000000), ui.Offset(0, yOffset), width.toDouble());
      yOffset += rowHeight;
      drawText(canvas, gender, TextAlign.left, fontSize, const ui.Color(0xFF000000),
          ui.Offset(130, yOffset), width.toDouble());
      yOffset += rowHeight;

    yOffset += rowHeight;

    String timestampTitle =
        AppLocalizations.of(context)!.print_timestamp;
    String timestamp =
        DateFormat('yyyy-MMM-dd hh:mm:ss').format(DateTime.now());
    drawText(canvas, timestampTitle, TextAlign.left, fontSize,
        const ui.Color(0xFF000000), ui.Offset(0, yOffset), width.toDouble());
    yOffset += rowHeight;
    drawText(canvas, timestamp, TextAlign.left, fontSize, const ui.Color(0xFF000000),
        ui.Offset(130, yOffset), width.toDouble());
    yOffset += rowHeight;

    yOffset += lineHeight;

    canvas.drawLine(ui.Offset(0, yOffset), ui.Offset(width.toDouble(), yOffset),
        sectionPaint);

    yOffset += gapHeight;

    canvas.drawLine(ui.Offset(0, yOffset), ui.Offset(width.toDouble(), yOffset),
        separationPaint);

    yOffset += gapHeight;

    Map<String, dynamic> result = processData(data);

    result.forEach((key, value) {
      delta = drawText(
          canvas,
          DeviceMap.CODETONAME(context, key),
          TextAlign.left,
          fontSize,
          const ui.Color(0xFF000000),
          ui.Offset(0, yOffset),
          width.toDouble());
      yOffset += delta;

      yOffset += 2 * gapHeight;

      delta = drawText(
          canvas,
          "$value ${DeviceMap.CODETOUNIT[key] == "N.A." ? "" : DeviceMap.CODETOUNIT[key]} ",
          TextAlign.right,
          fontSize,
          const ui.Color(0xFF000000),
          ui.Offset(0, yOffset),
          width.toDouble());
      yOffset += delta;

      yOffset += gapHeight;
      canvas.drawLine(ui.Offset(0, yOffset),
          ui.Offset(width.toDouble(), yOffset), separationPaint);
      yOffset += gapHeight;
    });

    canvas.drawLine(ui.Offset(0, yOffset), ui.Offset(width.toDouble(), yOffset),
        sectionPaint);

    yOffset += lineHeight;

    delta = drawText(
        canvas,
        AppLocalizations.of(context)!.print_disclaimer,
        TextAlign.left,
        20,
        const ui.Color(0xFF000000),
        ui.Offset(0, yOffset),
        width.toDouble());
    yOffset += delta;

    yOffset += 2 * gapHeight;

    delta = drawText(
        canvas,
        AppLocalizations.of(context)!.disclaimer_text,
        TextAlign.left,
        20,
        const ui.Color(0xFF000000),
        ui.Offset(0, yOffset),
        width.toDouble());

    yOffset += delta;

    yOffset += rowHeight;

    double receiptHeight = yOffset;

    // Convert to ui.Image
    final ui.Picture picture = recorder.endRecording();
    ui.Image uiReceipt =
        await picture.toImage(width.toInt(), receiptHeight.toInt());

    img.Image imgReceipt = await convertFlutterUiToImage(uiReceipt);

    Uint8List bmpBytes = img.encodeBmp(imgReceipt);

    // // Download path
    // Directory pathDir = (await getDownloadsDirectory())!;

    // img.writeFile('${pathDir.path}/test.bmp', bmpBytes);

    receipt = bmpBytes;

    // dataMap.forEach((key, value) {
    //   if (DeviceMap.CODETONAME[key] != null) {
    //     dataList.addAll(generator.text(DeviceMap.CODETONAME[key]!,
    //         styles: const PosStyles(align: PosAlign.left)));
    //     dataList.addAll(generator.text(
    //         "$value ${DeviceMap.CODETOUNIT[key] == "N.A." ? "" : DeviceMap.CODETOUNIT[key]} ",
    //         styles: const PosStyles(bold: true, align: PosAlign.right)));
    //     dataList.addAll(generator.hr(ch: '-'));
    //   }
    // });
  }

  static Map<String, dynamic> processData(Map<String, dynamic> rawData) {
    Map<String, dynamic> result = {};
    const List<String> recognizedCodes = [
      'height',
      'weight',
      // 'bmi',
      'bodyFatPercentage',
      'bodyFatMass',
      'skeletalMusclePercentage',
      'bodyWaterPercentage',
      'basalMetabolism',
      'visceralFatLevel',
      'protein',
      'bodyAge',
      'overall',
      'mineral',
      'temperature',
      'hr',
      // 'spo2',
      // 'spo2HeartRate',
      'systolic',
      'diastolic',
      'bpHeartRate',
      // 'ecg_hr',
      // 'ecg_rr',
      // 'ecg_p_width',
      // 'ecg_pr',
      // 'ecg_qrs_dur',
      // 'ecg_qt',
      // 'ecg_qtc',
      // 'ecg_p_axis',
      // 'ecg_qrs_axis',
      // 'ecg_t_axis',
      // 'ecg_cln',
      'bp',
      // 'ecg',
    ];
    rawData.forEach((key, value) {
      if (recognizedCodes.contains(key)) {
        switch (key) {
          case 'systolic':
          case 'diastolic':
            if (rawData.containsKey('systolic') &&
                rawData.containsKey('diastolic')) {
              String newValue =
                  '${rawData['systolic']} / ${rawData['diastolic']}';
              result['bp'] = newValue;
            }
            break;
          case 'spo2HeartRate':
            result['hr'] = rawData[key];
            break;
          case 'bpHeartRate':
            result['hr'] = rawData[key];
            break;
          case 'ecg_hr':
            result['hr'] = rawData[key];
            break;
          default:
            result[key] = rawData[key];
            break;
        }
      }
    });
    return result;
  }

  // DeviceMap.CODETONAME.forEach((key, value) {
  //   if (rawData.containsKey(key)) {
  //     switch (key) {
  //       case 'systolic':
  //       case 'diastolic':
  //         String newValue = '${rawData['systolic']}/${rawData['diastolic']}';
  //         result['bp'] = newValue;
  //         break;
  //       case 'spo2HeartRate':
  //         result['hr'] = rawData[key];
  //         break;
  //       case 'bpHeartRate':
  //         result['hr'] = rawData[key];
  //         break;
  //       case 'ecg_hr':
  //         result['hr'] = rawData[key];
  //         break;
  //       default:
  //         result[key] = rawData[key];
  //         break;
  //     }
  //   }
  // });

  static double drawText(Canvas canvas, String text, TextAlign align,
      double fontSize, ui.Color fontColor, ui.Offset offset, double width) {
    ui.ParagraphBuilder pb = ui.ParagraphBuilder(
        ui.ParagraphStyle(fontSize: fontSize, textAlign: align))
      ..pushStyle(ui.TextStyle(color: fontColor));
    pb.addText(text);
    ui.Paragraph para = pb.build()
      ..layout(ui.ParagraphConstraints(width: width.toDouble()));
    canvas.drawParagraph(para, offset);
    return para.height;
  }

  static Future<ui.Image> convertImageToFlutterUi(img.Image image) async {
    if (image.format != img.Format.uint8 || image.numChannels != 4) {
      final cmd = img.Command()
        ..image(image)
        ..convert(format: img.Format.uint8, numChannels: 4);
      final rgba8 = await cmd.getImageThread();
      if (rgba8 != null) {
        image = rgba8;
      }
    }

    ui.ImmutableBuffer buffer =
        await ui.ImmutableBuffer.fromUint8List(image.toUint8List());

    ui.ImageDescriptor id = ui.ImageDescriptor.raw(buffer,
        height: image.height,
        width: image.width,
        pixelFormat: ui.PixelFormat.rgba8888);

    ui.Codec codec = await id.instantiateCodec(
        targetHeight: image.height, targetWidth: image.width);

    ui.FrameInfo fi = await codec.getNextFrame();
    ui.Image uiImage = fi.image;

    return uiImage;
  }

  static Future<img.Image> convertFlutterUiToImage(ui.Image uiImage) async {
    final uiBytes = await uiImage.toByteData();

    final image = img.Image.fromBytes(
        width: uiImage.width,
        height: uiImage.height,
        bytes: uiBytes!.buffer,
        numChannels: 4);

    return image;
  }

}
