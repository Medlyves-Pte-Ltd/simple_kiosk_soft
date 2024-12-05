import 'package:flutter/material.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:simple_kiosk_software/screens/check/base_check_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_kiosk_software/utils/permission_config.dart';
import 'package:flutter_devices_sdk/devices/thai_id_card/thai_card.dart';

class ThaiCardCheck extends BaseCheckWidget {
  ValueNotifier<String> uiData = ValueNotifier<String>("");
  ValueNotifier<String> btnText = ValueNotifier<String>("");
  ThaiCard thaiCard = ThaiCard();

  ThaiCardCheck() {
    uiData.value = dataDefaultValue;
  }

  @override
  void init() {
    super.title = AppLocalizations.of(mainContext)!.id_card;
    btnText.value = AppLocalizations.of(mainContext)!.start;
    iconFile = "assets/images/id_card.png";
    underlineColor = ColorPalette.colorheightWeight;
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
                      uiData.value = dataDefaultValue;
                    } else {
                      btnText.value = AppLocalizations.of(mainContext)!.stop;
                      uiData.value = AppLocalizations.of(mainContext)!.loading;
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
  Future<void> onStart() async {
    await thaiCard.getThaiIdCard();
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
                AppLocalizations.of(mainContext)!.id_card,
                style: TextStyle(
                    fontSize: titleFontSize, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: height * 0.02),
              Expanded(
                child: ValueListenableBuilder(
                    valueListenable: uiData,
                    builder: (context, value, child) {
                      return SizedBox(
                        width: width * 0.25,
                        child: Text(
                          value,
                          softWrap: true,
                          maxLines: 10,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: dataFontSize,
                              fontWeight: FontWeight.bold,
                              color: ColorPalette.materialGreen),
                        ),
                      );
                    }),
              ),
              ValueListenableBuilder(
                  valueListenable: thaiIdCard,
                  builder: (context, value, child) {
                    if (value == null) {
                      return const SizedBox.shrink();
                    }

                    uiData.value = value.toMap().toString();
                    return SizedBox(
                      width: width * 0.25,
                      child: Text(""),
                    );
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
