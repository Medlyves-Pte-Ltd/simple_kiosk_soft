import 'dart:io';

import 'package:flutter/material.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:simple_kiosk_software/screens/check/base_check_widget.dart';
import 'package:camera/camera.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_kiosk_software/screens/manager/general/permission/permission_config_page.dart';
import 'package:simple_kiosk_software/utils/permission_config.dart';

class CameraCheck2 extends BaseCheckWidget {
  late CameraController controller;
  late List<CameraDescription> cameras;
  ValueNotifier<String> btnText = ValueNotifier<String>("");
  ValueNotifier<String> imagePath = ValueNotifier<String>("");

  CameraCheck2() {}

  Future<void> initCamera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[1], ResolutionPreset.max);
    await controller.initialize();
    XFile file = await controller.takePicture();
    imagePath.value = file.path;
  }

  @override
  Widget startButton() {
    double btnFontSize = height * 0.01;
    return ValueListenableBuilder<String>(
        valueListenable: btnText,
        builder: (context, value, child) {
          return PermissionConfig().havePermission(PermissionModules.DeviceDiagnostic)
              ? InkWell(
                  onTap: () async {
                    if (value == AppLocalizations.of(mainContext)!.stop) {
                      await onStop();
                      btnText.value = AppLocalizations.of(mainContext)!.start;
                    } else {
                      btnText.value = AppLocalizations.of(mainContext)!.stop;
                      await onStart();
                    }
                  },
                  child: Container(
                    height: height * 0.03,
                    width: width * 0.1,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: ColorPalette.materialGreen,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: btnFontSize,
                            color: Colors.white)),
                  ),
                )
              : Container(
                  height: height * 0.03,
                  width: width * 0.1,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ColorPalette.darkGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(value,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: btnFontSize,
                          color: Colors.white)),
                );
        });
  }

  @override
  void init() {
    super.title = "${AppLocalizations.of(mainContext)!.camera}2";
    btnText.value = AppLocalizations.of(mainContext)!.start;
    iconFile = "assets/images/camera.png";
    underlineColor = ColorPalette.colorheightWeight;
  }

  @override
  Future<void> onStart() async {
    await initCamera();
  }

  @override
  Future<void> onStop() async {}

  @override
  Widget buildCardDataShowArea() {
    return ValueListenableBuilder(
        valueListenable: imagePath,
        builder: (context, value, child) {
          return value.isNotEmpty
              ? Image.file(File(value), fit: BoxFit.cover)
              : const SizedBox.shrink();
        });
  }
}
