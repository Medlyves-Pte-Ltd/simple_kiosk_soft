import 'dart:core';
import 'dart:ui' as ui;
import 'package:flutter_devices_sdk/device_manager.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:flutter_devices_sdk/devices/device_base_model.dart';
import 'package:flutter_devices_sdk/log/log_printer.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:simple_kiosk_software/utils/print_map.dart';
import 'package:simple_kiosk_software/utils/user_info.dart';

// 注意事项:
// 1.通常不会把一整张图片直接发给打印机，那样太大。都会分割成小图片逐个发送。 比如数据太大导致打印机内存溢出输出乱码。
// 2.小票机，目前常用尺寸为 80mm、58mm。通常 1mm 等于 8个像素，因此，适合小票打印机打印的图片像素尺寸应为：558px、372px。
// （因为宽度适配在实际打印中有偏差，不宜设置为完全吻合）
// 3.打印的图片宽度像素太大会造成打印无反应。

class PrintUtils {
  DeviceBaseModel? printer;

  Future<void> connect() async {
    if (printer != null) {
      return;
    }

    printer = DeviceManager().getDevice(DeviceType.PRINTER_DEVICE);
    await printer?.connect();
  }

  Future<void> disconnect() async {
    await printer?.disconnect();
  }

  // 开始打印
  Future<void> startPrint(BuildContext context, Function callBack) async {
    // uint8list打印
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);

    // 创建图片并自动切割成多张小图
    List<img.Image> data =
        await createBitmapImage(UserInfo().toJson(), context);

    // 根据图片任务数量打印任务
    List<Future<void>> printTaskList = [];
    for (int i = 0; i < data.length; ++i) {
      Future<void> task =
          Future.delayed(Duration(milliseconds: i * 6000), () async {
        LogPrinter.log("开始打印第${i + 1}张图片, 共${data.length}张");
        List<int> bytes = generator.image(data[i]);
        await printer?.sendCommand(bytes);
      });
      // 添加到打印任务列表
      printTaskList.add(task);
    }
    // 等待全部打印任务结束
    await Future.wait(printTaskList);
    // 半切纸张命令hex:1D 56 01
    await printer?.sendCommand([29, 86, 1]);

    // 延时关闭打印机
    Future.delayed(const Duration(milliseconds: 5000), () async {
      if (callBack != null) {
        callBack();
      }
    });
  }

  Future<List<img.Image>> createBitmapImage(
      Map<String, dynamic> data, BuildContext context) async {
    // Calculate height of the full receipt
    const int width = 368;
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
        await rootBundle.load('assets/images/Medlyves_logo_dark.png');
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
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final ui.Canvas canvas = ui.Canvas(recorder);

    // Draw the logo
    canvas.drawImage(uiLogoImg, const ui.Offset(0, 0), ui.Paint());

    // Put data into receipt image
    double yOffset = logoHeight.toDouble() + rowHeight;

    String nameTitle = AppLocalizations.of(context)!.print_name;
    drawText(canvas, nameTitle, TextAlign.left, fontSize,
        const ui.Color(0xFF000000), ui.Offset(0, yOffset), width.toDouble());
    drawText(canvas, UserInfo().name, TextAlign.left, fontSize,
        const ui.Color(0xFF000000), ui.Offset(130, yOffset), width.toDouble());
    yOffset += rowHeight;

    String ageTitle = AppLocalizations.of(context)!.print_age;
    drawText(canvas, ageTitle, TextAlign.left, fontSize,
        const ui.Color(0xFF000000), ui.Offset(0, yOffset), width.toDouble());
    drawText(canvas, UserInfo().age, TextAlign.left, fontSize,
        const ui.Color(0xFF000000), ui.Offset(130, yOffset), width.toDouble());
    yOffset += rowHeight;

    String genderTitle = AppLocalizations.of(context)!.gender;
    drawText(canvas, genderTitle, TextAlign.left, fontSize,
        const ui.Color(0xFF000000), ui.Offset(0, yOffset), width.toDouble());
    String gender = UserInfo().gender == 1
        ? AppLocalizations.of(context)!.male
        : AppLocalizations.of(context)!.female;
    drawText(canvas, gender, TextAlign.left, fontSize,
        const ui.Color(0xFF000000), ui.Offset(130, yOffset), width.toDouble());
    yOffset += rowHeight;
    yOffset += rowHeight;

    String timestampTitle = AppLocalizations.of(context)!.print_timestamp;
    String timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    drawText(canvas, timestampTitle, TextAlign.left, fontSize,
        const ui.Color(0xFF000000), ui.Offset(0, yOffset), width.toDouble());
    drawText(canvas, timestamp, TextAlign.left, fontSize,
        const ui.Color(0xFF000000), ui.Offset(130, yOffset), width.toDouble());
    yOffset += rowHeight;

    yOffset += lineHeight;

    canvas.drawLine(ui.Offset(0, yOffset), ui.Offset(width.toDouble(), yOffset),
        sectionPaint);

    yOffset += gapHeight;

    canvas.drawLine(ui.Offset(0, yOffset), ui.Offset(width.toDouble(), yOffset),
        separationPaint);

    yOffset += gapHeight;

    UserInfo().toJson().forEach((key, value) {
      delta = drawText(
          canvas,
          PrintMap.codeToName(key, context),
          TextAlign.left,
          fontSize,
          const ui.Color(0xFF000000),
          ui.Offset(0, yOffset),
          width.toDouble());
      yOffset += delta;

      yOffset += 2 * gapHeight;

      delta = drawText(
          canvas,
          "${PrintMap.codeToRange(key)} ${value.toString().isEmpty ? "N.A." : value}",
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

    // 长图切割为多张小图, 否则可能会造成打印机内存溢出，打印乱码
    List<img.Image> list = await decodeImage(imgReceipt);

    return list;
  }

  // 长图切割为多张小图
  Future<List<img.Image>> decodeImage(
    img.Image crop, {
    int imgSizeLimit = 368 * 1000,
  }) async {
    final cropWidth = crop.width;
    img.Image targetImg = crop;
    // 缩放处理，保持图片宽度能被8整除
    if (cropWidth % 8 != 0) {
      targetImg =
          img.copyResize(crop, width: cropWidth ~/ 8 * 8, height: crop.height);
    }
    final targetWidth = targetImg.width;
    final targetHeight = targetImg.height;
    final result = <img.Image>[];
    if (targetWidth * targetHeight > imgSizeLimit) {
      LogPrinter.log('esc 长图开启切割');
      int splitItemHeight = imgSizeLimit ~/ targetWidth;

      int splitCount = targetHeight ~/ splitItemHeight;

      int lastItemHeight = targetHeight % splitItemHeight;

      for (int index = 0; index < splitCount; index++) {
        final splitItem = img.copyCrop(
          targetImg,
          x: 0,
          y: splitItemHeight * index,
          width: targetWidth,
          height: splitItemHeight,
        );
        result.add(splitItem);
      }
      LogPrinter.log(
          '切图 * $splitCount 份 width（$targetWidth） height（$splitItemHeight）');

      if (lastItemHeight > 0) {
        final lastItem = img.copyCrop(
          crop,
          x: 0,
          y: splitItemHeight * splitCount,
          width: targetWidth,
          height: lastItemHeight,
        );
        result.add(lastItem);
        LogPrinter.log('切图 * 1 份 width（$targetWidth） height（$lastItemHeight）');
      }
    } else {
      result.add(crop);
      LogPrinter.log('esc 无需切割 width（$targetWidth） height（$targetHeight）');
    }
    return result;
  }

  double drawText(Canvas canvas, String text, TextAlign align, double fontSize,
      ui.Color fontColor, ui.Offset offset, double width) {
    ui.ParagraphBuilder pb = ui.ParagraphBuilder(
        ui.ParagraphStyle(fontSize: fontSize, textAlign: align))
      ..pushStyle(ui.TextStyle(color: fontColor));
    pb.addText(text);
    ui.Paragraph para = pb.build()
      ..layout(ui.ParagraphConstraints(width: width.toDouble()));
    canvas.drawParagraph(para, offset);
    return para.height;
  }

  Future<ui.Image> convertImageToFlutterUi(img.Image image) async {
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

  // 私有构造函数
  PrintUtils._internal();
  // 保存单例
  static final PrintUtils _instance = PrintUtils._internal();
  // 工厂构造函数
  factory PrintUtils() => _instance;
}
