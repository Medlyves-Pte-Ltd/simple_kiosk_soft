import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:simple_kiosk_software/screens/check/base_check_widget.dart';
import 'package:record/record.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AudioRecordCheck extends BaseCheckWidget {
  final record = AudioRecorder();
  final player = AudioPlayer();
  late String filePath;
  ValueNotifier<String> btnText = ValueNotifier<String>("");

  @override
  void init() {
    super.title = AppLocalizations.of(mainContext)!.record;
    btnText.value = AppLocalizations.of(mainContext)!.start;
    iconFile = "assets/images/record_audio.png";
    underlineColor = ColorPalette.colorheightWeight;
  }

  @override
  Widget startButton() {
    double btnFontSize = height * 0.01;
    return ValueListenableBuilder<String>(
        valueListenable: btnText,
        builder: (context, value, child) {
          return InkWell(
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
          );
        });
  }

  @override
  Future<void> onStart() async {
    // Check and request permission if needed
    if (await record.hasPermission()) {
      final Directory tempDir = await getTemporaryDirectory();
      filePath = "${tempDir.path}/record.m4a";
      // Start recording to file
      await record.start(const RecordConfig(), path: filePath);
      // ... or to stream
      final stream = await record
          .startStream(const RecordConfig(encoder: AudioEncoder.pcm16bits));
    }
  }

  @override
  Future<void> onStop() async {
    // Stop recording...
    await record.stop();
    await player.play(DeviceFileSource(filePath));
  }

  @override
  Widget buildCardDataShowArea() {
    return const SizedBox.shrink();
  }
}
