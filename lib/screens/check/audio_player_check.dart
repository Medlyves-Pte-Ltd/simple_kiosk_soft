import 'package:flutter/material.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:simple_kiosk_software/screens/check/base_check_widget.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AudioPlayerCheck extends BaseCheckWidget {
  final player = AudioPlayer();
  ValueNotifier<String> btnText = ValueNotifier<String>("");

  @override
  void init() {
    super.title = AppLocalizations.of(mainContext)!.loudspeaker;
    btnText.value = AppLocalizations.of(mainContext)!.start;
    iconFile = "assets/images/audio_player_check.png";
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
    await player.play(AssetSource('audios/tong_hua_zheng.wav'));
  }

  @override
  Future<void> onStop() async {
    player.pause();
  }

  @override
  Widget buildCardDataShowArea() {
    return const SizedBox.shrink();
  }
}
