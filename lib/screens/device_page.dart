import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_devices_sdk/device_sdk_param_setting.dart';
import 'package:flutter_devices_sdk/devices/device_config.dart';
import 'package:flutter_devices_sdk/devices/device_order_check.dart';
import 'package:flutter_devices_sdk/devices/usb_relay_control.dart';
import 'package:simple_kiosk_software/common/footer.dart';
import 'package:simple_kiosk_software/common/header.dart';
import 'package:simple_kiosk_software/utils/app_config.dart';
import 'package:simple_kiosk_software/utils/scanner_utils.dart';

class DevicePage extends StatefulWidget {
  @override
  _DevicePageState createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  late BuildContext _context;
  // 屏幕宽度
  double width = 0;
  // 屏幕高度
  double height = 0;
  List<Widget> deviceList = [];
  ValueNotifier<int> _curIndex = ValueNotifier<int>(0);
  ValueNotifier<String> _showInfo = ValueNotifier<String>("");

  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 10), () async {
      final dir = Directory(AppConfig().configDir);
      bool result = await dir.exists();
      if (!result) {
        _showInfo.value = "${dir.path} not exists";
        return;
      }

      try {
        await UsbRelayControl().initRelayIoStartTime();
      } catch (e) {
        _showInfo.value = "$e";
        return;
      }

      try {
        RelayCommType type =
            RelayCommType.values.byName(AppConfig().relayCommType);
        // 打开USB IO继电器设备
        await UsbRelayControl().connect(type);
      } catch (e) {
        _showInfo.value = "The relay device not fond, Error:$e";
        return;
      }

      await UsbRelayControl().setAutoControl((int index) {
        _curIndex.value = index;
      });

      try {
        // 设备初始化
        await DeviceConfig().init();
      } catch (e) {
        _showInfo.value = "Error:$e";
        return;
      }

      await Future.delayed(Duration(seconds: 1), () {});
      await DeviceOrderCheck().checkDeviceOrder();

      // hub故障或者继电器故障
      if (DeviceOrderCheck().hubDeviceNames.isEmpty) {
        _showInfo.value = "The relay or usb hub is not working properly";
        return;
      }

      // 设备列表
      deviceList = DeviceOrderCheck().usbList();
      setState(() {});

      if (DeviceOrderCheck().usbError) {
        _showInfo.value = "USB device sequence error";
        return;
      }
      // 延时
      await Future.delayed(Duration(seconds: 2), () {});

      try {
        // 打开扫码器
        await ScannerUtils().connect();
      } catch (e) {
        _showInfo.value = "Scanner connection failed";
        return;
      }

      if (!DeviceOrderCheck().usbError) {
        Navigator.pushNamedAndRemoveUntil(_context, '/', (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          const Header(),
          SizedBox(height: height * 0.1),
          _buildProgress(),
          _buildError(),
          Expanded(
              child: ListView(
            children: deviceList,
          )),
          //const Spacer(),
          Footer()
        ],
      ),
    );
  }

  Widget _buildError() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        alignment: Alignment.center,
        child: ValueListenableBuilder(
          valueListenable: _showInfo,
          builder: (context, value, child) {
            if (value.isEmpty) {
              return const SizedBox.shrink();
            }
            return Text(
              "Error:${value}",
              softWrap: true,
              maxLines: 5,
              style: TextStyle(
                  color: Colors.red,
                  fontSize: height * 0.02,
                  fontWeight: FontWeight.w600),
            );
          },
        ));
  }

  Widget _buildProgress() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        alignment: Alignment.center,
        child: ValueListenableBuilder(
          valueListenable: _curIndex,
          builder: (context, value, child) {
            return Text(
              "Starting device, $value  / ${DeviceSdkParamSetting().replayIoCount}",
              softWrap: true,
              maxLines: 5,
              style: TextStyle(
                  fontSize: height * 0.03, fontWeight: FontWeight.w600),
            );
          },
        ));
  }
}
