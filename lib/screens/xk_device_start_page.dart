import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_devices_sdk/device_sdk_param_setting.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:flutter_devices_sdk/devices/device_config.dart';
import 'package:flutter_devices_sdk/devices/device_order_check.dart';
import 'package:flutter_devices_sdk/devices/up_down_control.dart';
import 'package:flutter_devices_sdk/devices/usb_relay_control.dart';
import 'package:flutter_devices_sdk/kiosk_type.dart';
import 'package:simple_kiosk_software/common/footer.dart';
import 'package:simple_kiosk_software/common/header.dart';
import 'package:simple_kiosk_software/utils/app_config.dart';
import 'package:simple_kiosk_software/utils/kiosk_config.dart';
import 'package:volume_controller/volume_controller.dart';

class XKDeviceStartPage extends StatefulWidget {
  @override
  _XKDeviceStartPageState createState() => _XKDeviceStartPageState();
}

class _XKDeviceStartPageState extends State<XKDeviceStartPage> {
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
    Future.delayed(const Duration(milliseconds: 10), start);
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
          Footer(showStatus: false),
        ],
      ),
    );
  }

  // 启动
  void start() async {
    // 判断配置文件路径是否存在
    final dir = Directory(AppConfig().configDir);
    bool result = await dir.exists();
    if (!result) {
      _showInfo.value = "${dir.path} not exists";
      return;
    }

    try {
      await DeviceConfig().loadFile();
    } catch (e) {
      _showInfo.value = "Error:$e";
      return;
    }
    await DeviceOrderCheck().checkDeviceOrder();

    // 设备初始化
    try {
      await DeviceConfig().createDevices();
    } catch (e) {
      _showInfo.value = "Error:$e";
      return;
    }
    // 设备列表
    deviceList = DeviceOrderCheck().xkUsbList();
    setState(() {});

    if (DeviceOrderCheck().usbError) {
      _showInfo.value = "USB devices not found. Please check the connection.";
    } else {
      await jumpNewPage();
    }
  }

  Future<void> jumpNewPage() async {
    await Future.delayed(Duration(seconds: 2), () {});
    await VolumeController.instance.setVolume(AppConfig().playVolume);
    // 如果没有错误就进到欢迎界面
    if (!DeviceOrderCheck().usbOrderError()) {
      Navigator.pushNamedAndRemoveUntil(
          _context, '/LanguagePage', (route) => false);
    }
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
              "Checking USB device",
              softWrap: true,
              maxLines: 5,
              style: TextStyle(
                  fontSize: height * 0.03, fontWeight: FontWeight.w600),
            );
          },
        ));
  }
}
