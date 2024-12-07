import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_devices_sdk/devices/device_order_check.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_kiosk_software/screens/device_check_view.dart';
import 'package:simple_kiosk_software/screens/manager/admin_login_page.dart';
import 'package:simple_kiosk_software/utils/app_config.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Footer extends StatefulWidget {
  @override
  FooterState createState() => FooterState();
}

class FooterState extends State<Footer> {
  // 屏幕宽度
  double width = 0;
  // 屏幕高度
  double height = 0;
  // usb连接状态
  ValueNotifier<bool> usbDeviceConnectStatus = ValueNotifier<bool>(false);
  late Timer timer;

  @override
  void initState() {
    super.initState();
    int time = AppConfig().usbSequenceCheckTime;
    timer = Timer.periodic(
        Duration(seconds: AppConfig().usbSequenceCheckTime), onTimer);
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  // 定时器
  Future<void> onTimer(Timer timer) async {
    await DeviceOrderCheck().checkDeviceOrder();

    if (DeviceOrderCheck().hubDeviceNames.isEmpty) {
      usbDeviceConnectStatus.value = false;
      return;
    }

    usbDeviceConnectStatus.value = !DeviceOrderCheck().usbError;

    if (DeviceOrderCheck().usbError) {
      Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG,
          msg: "USB device sequence error",
          backgroundColor: ColorPalette.darkGrey,
          textColor: Colors.red);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    final footerHeight = height * 0.05;
    final fontSize = footerHeight * 0.30;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: footerHeight,
        width: double.infinity,
        color: ColorPalette.headerFooterBackground,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: Row(
              children: [
                IconButton(
                    iconSize: height * 0.025,
                    onPressed: () {
                      Navigator.of(context).push(TDSlidePopupRoute(
                          modalBarrierColor: TDTheme.of(context).fontGyColor2,
                          isDismissible: false,
                          slideTransitionFrom: SlideTransitionFrom.center,
                          builder: (context) {
                            return TDPopupCenterPanel(
                              closeClick: () {
                                Navigator.maybePop(context);
                              },
                              child: SizedBox(
                                height: height * 0.45,
                                width: width * 0.8,
                                child: AdminLoginPage(),
                              ),
                            );
                          }));
                      // Navigator.pushNamedAndRemoveUntil(
                      //     context, '/KioskManager', ((route) => false));
                    },
                    icon: Icon(Icons.settings)),
                ValueListenableBuilder(
                    valueListenable: usbDeviceConnectStatus,
                    builder: (context, enable, child) {
                      String path = enable
                          ? "assets/images/connected.png"
                          : "assets/images/disconnected.png";
                      return IconButton(
                          iconSize: height * 0.025,
                          onPressed: () {
                            Navigator.of(context).push(TDSlidePopupRoute(
                                modalBarrierColor:
                                    TDTheme.of(context).fontGyColor2,
                                isDismissible: false,
                                slideTransitionFrom: SlideTransitionFrom.center,
                                builder: (context) {
                                  return TDPopupCenterPanel(
                                    closeUnderBottom: true,
                                    closeClick: () {
                                      Navigator.maybePop(context);
                                    },
                                    child: SizedBox(
                                      height: height * 0.6,
                                      width: width * 0.8,
                                      child: DeviceCheckView(),
                                    ),
                                  );
                                }));
                            // Navigator.pushNamedAndRemoveUntil(
                            //     context, '/KioskManager', ((route) => false));
                          },
                          icon: Image.asset(path));
                    }),
              ],
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.powered_by,
                  style: TextStyle(fontSize: fontSize, color: Colors.white),
                ),
                SizedBox(
                  width: width * 0.02,
                ),
                Image.asset(
                  'assets/images/Medlyves_name_only.png',
                  height: footerHeight * 0.5,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  '${AppLocalizations.of(context)!.version} ${AppConfig().appVersion}',
                  style:
                      TextStyle(fontSize: height * 0.008, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
