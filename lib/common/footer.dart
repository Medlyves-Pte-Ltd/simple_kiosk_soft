import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_devices_sdk/devices/device_config.dart';
import 'package:flutter_devices_sdk/devices/device_order_check.dart';
import 'package:flutter_devices_sdk/devices/usb_relay_control.dart';
import 'package:flutter_devices_sdk/log/log_printer.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_kiosk_software/screens/device_check_view.dart';
import 'package:simple_kiosk_software/screens/manager/admin_login_page.dart';
import 'package:simple_kiosk_software/utils/app_config.dart';
import 'package:simple_kiosk_software/utils/kiosk_config.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Footer extends StatefulWidget {
  bool showStatus = false;
  Footer({this.showStatus = true}) {}

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

    if (widget.showStatus) {
      usbDeviceConnectStatus.value = !DeviceOrderCheck().usbOrderError();
      timer = makePeriodicTimer(
          Duration(seconds: AppConfig().usbSequenceCheckTime), onTimer,
          fireNow: true);
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.showStatus) {
      timer.cancel();
    }
  }

  Timer makePeriodicTimer(
    Duration duration,
    void Function(Timer timer) callback, {
    bool fireNow = false,
  }) {
    var timer = Timer.periodic(duration, callback);
    if (fireNow) {
      Future.delayed(const Duration(milliseconds: 10), () async {
        callback(timer);
      });
    }
    return timer;
  }

  // 定时器
  Future<void> onTimer(Timer timer) async {
    List<DeviceInfo> usbDeviceLostList =
        await DeviceOrderCheck().checkDeviceLost();

    for (DeviceInfo item in usbDeviceLostList) {
      String error = "${item.deviceName} not found, ${item.usbPath}";
      Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG,
          msg: error,
          backgroundColor: ColorPalette.darkGrey,
          textColor: Colors.red);
    }

    if (DeviceOrderCheck().usbOrderError()) {
      usbDeviceConnectStatus.value = false;
    } else {
      usbDeviceConnectStatus.value = usbDeviceLostList.isEmpty;
    }
  }

  // 关机提示
  void shutdownTip() {
    showDialog(
      context: context,
      barrierDismissible: true, //点击弹窗以外背景是否取消弹窗
      builder: (context) {
        return AlertDialog(
          title: const Text("Shutdown"),
          content:
              Text("Are you sure to perform a shutdown or restart operation"),
          actions: [
            TextButton(
              onPressed: () {
                //关闭弹窗
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: shutdown,
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // 关机
  void shutdown() async {
    LogPrinter.log("click shutdown btn");

    if (AppConfig().enableUsbRelay) {
      try {
        await UsbRelayControl().setAllIoStatus(false);
      } catch (e) {
        Fluttertoast.showToast(msg: "Error:$e");
        LogPrinter.log("Error:$e");
        return;
      }
      await Future.delayed(Duration(seconds: 1), () {});
    }

    try {
      MethodChannel methodChannel = const MethodChannel("Shutdown");
      await methodChannel.invokeMethod("openShutdownApp");
    } on PlatformException catch (e) {
      LogPrinter.log("openShutdownApp failed! Error:$e");
      Fluttertoast.showToast(msg: "openShutdownApp failed! Error:$e");
      return;
    }

    LogPrinter.log("shutdown");
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
                Offstage(
                  offstage: !widget.showStatus,
                  child: ValueListenableBuilder(
                      valueListenable: usbDeviceConnectStatus,
                      builder: (context, enable, child) {
                        String path = enable
                            ? "assets/images/connected.png"
                            : "assets/images/fail.png";
                        return IconButton(
                            iconSize: height * 0.025,
                            onPressed: () {
                              Navigator.of(context).push(TDSlidePopupRoute(
                                  modalBarrierColor:
                                      TDTheme.of(context).fontGyColor2,
                                  isDismissible: false,
                                  slideTransitionFrom:
                                      SlideTransitionFrom.center,
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
                            icon: Image.asset(
                              path,
                              height: height * 0.025,
                            ));
                      }),
                ),
                IconButton(
                    iconSize: height * 0.025,
                    onPressed: () {
                      shutdownTip();
                    },
                    icon: Image.asset(
                      "assets/images/reboot.png",
                      height: height * 0.025,
                    )),
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
              child: Container(
                margin: EdgeInsets.all(10),
                alignment: Alignment.bottomRight,
                child: Text(
                  '${KioskConfig().kioskId}-${AppConfig().appVersion}',
                  style:
                      TextStyle(fontSize: height * 0.01, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
