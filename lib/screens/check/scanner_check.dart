import 'package:flutter/material.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:simple_kiosk_software/screens/check/base_check_widget.dart';
import 'package:simple_kiosk_software/utils/print_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_kiosk_software/utils/scanner_utils.dart';

class ScannerCheck extends BaseCheckWidget {
  ValueNotifier<String> scannerData = ValueNotifier<String>("");
  ValueNotifier<String> btnText = ValueNotifier<String>("");

  ScannerCheck() {
    scannerData.value = dataDefaultValue;
    ScannerUtils().listenData = listenScannerData;
  }

  // 监听扫码器数据
  void listenScannerData(String data) {
    scannerData.value = data;
  }

  @override
  void init() {
    super.title = AppLocalizations.of(mainContext)!.scanner;
    btnText.value = AppLocalizations.of(mainContext)!.start;
    iconFile = "assets/images/scanner.png";
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
                scannerData.value = dataDefaultValue;
              } else {
                btnText.value = AppLocalizations.of(mainContext)!.stop;
                scannerData.value = AppLocalizations.of(mainContext)!.loading;
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
    scannerData.value = dataDefaultValue;
    // 打开扫码器
    await ScannerUtils().connect();
  }

  @override
  Future<void> onStop() async {}

  @override
  Widget buildCardDataShowArea() {
    double titleFontSize = height * 0.01;
    double dataFontSize = height * 0.01;

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(mainContext)!.scanner,
                style: TextStyle(
                    fontSize: titleFontSize, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: height * 0.02),
              ValueListenableBuilder(
                  valueListenable: scannerData,
                  builder: (context, value, child) {
                    return SizedBox(
                      width: width * 0.25,
                      child: Text(
                        value,
                        softWrap: true,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: dataFontSize,
                            fontWeight: FontWeight.bold,
                            color: ColorPalette.materialGreen),
                      ),
                    );
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
