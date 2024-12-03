import 'package:flutter/material.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:simple_kiosk_software/screens/check/base_check_widget.dart';
import 'package:simple_kiosk_software/utils/permission_config.dart';
import 'package:simple_kiosk_software/utils/print_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrinterCheck extends BaseCheckWidget {
  // 能后控制打印
  ValueNotifier<String> printerStatus = ValueNotifier<String>("");
  ValueNotifier<String> btnText = ValueNotifier<String>("");

  PrinterCheck() {
    printerStatus.value = dataDefaultValue;
  }

  @override
  void init() {
    super.title = AppLocalizations.of(mainContext)!.print;
    btnText.value = AppLocalizations.of(mainContext)!.start;
    iconFile = "assets/images/printer.png";
    underlineColor = ColorPalette.colorheightWeight;
  }

  @override
  Widget startButton() {
    double btnFontSize = height * 0.01;
    return ValueListenableBuilder<String>(
        valueListenable: btnText,
        builder: (context, value, child) {
          return PermissionConfig().havePermission(PermissionModules.DeviceTest)
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
  Future<void> onStart() async {
    printerStatus.value = "正在打印中...";
    // 由于关闭打印机会抛异常，暂时没法解决，先全局使用
    await PrintUtils().connect();
    await PrintUtils().startPrint(mainContext, () {
      printerStatus.value = "打印结束";
    });
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
                AppLocalizations.of(mainContext)!.print,
                style: TextStyle(
                    fontSize: titleFontSize, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: height * 0.02),
              ValueListenableBuilder(
                  valueListenable: printerStatus,
                  builder: (context, value, child) {
                    return Text(
                      value,
                      style: TextStyle(
                          fontSize: dataFontSize,
                          fontWeight: FontWeight.bold,
                          color: ColorPalette.materialGreen),
                    );
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
