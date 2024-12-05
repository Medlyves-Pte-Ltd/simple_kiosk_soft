import 'package:flutter/material.dart';
import 'package:flutter_devices_sdk/devices/up_down_control.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:simple_kiosk_software/screens/check/base_check_widget.dart';
import 'package:simple_kiosk_software/utils/permission_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_kiosk_software/utils/scanner_utils.dart';

class UpDownCheck extends BaseCheckWidget {
  UpDownCheck() {}

  @override
  void init() {
    super.title = "Up Down IO";
    iconFile = "assets/images/io.png";
    underlineColor = ColorPalette.colorheightWeight;
  }

  @override
  Widget startButton() {
    return SizedBox.shrink();
  }

  @override
  Future<void> onStart() async {}

  @override
  Future<void> onStop() async {}

  @override
  Widget buildCardDataShowArea() {
    double btnFontSize = height * 0.01;
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PermissionConfig().havePermission(PermissionModules.DeviceTest)
              ? InkWell(
                  onTap: () async {
                    await UpDownControl().up();
                  },
                  child: Container(
                    height: height * 0.03,
                    width: width * 0.1,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: ColorPalette.materialGreen,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text("Up",
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
                  child: Text("UP",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: btnFontSize,
                          color: Colors.white)),
                ),
          SizedBox(height: height * 0.01),
          PermissionConfig().havePermission(PermissionModules.DeviceTest)
              ? InkWell(
                  onTap: () async {
                    await UpDownControl().down();
                  },
                  child: Container(
                    height: height * 0.03,
                    width: width * 0.1,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: ColorPalette.materialGreen,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text("Down",
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
                  child: Text("Down",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: btnFontSize,
                          color: Colors.white)),
                ),
        ],
      ),
    );
  }
}
