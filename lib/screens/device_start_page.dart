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
import 'package:simple_kiosk_software/utils/scanner_utils.dart';

class DeviceStartPage extends StatefulWidget {
  @override
  _DeviceStartPageState createState() => _DeviceStartPageState();
}

class _DeviceStartPageState extends State<DeviceStartPage> {
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

    if (AppConfig().enableUsbRelay) {
      // 连接usb继电器
      try {
        RelayCommType type =
            RelayCommType.values.byName(AppConfig().relayCommType);
        // 打开USB IO继电器设备
        await UsbRelayControl().connect(type);
      } catch (e) {
        _showInfo.value = "The relay device not fond, Error:$e";
        return;
      }
    }

    try {
      await DeviceConfig().loadFile();
    } catch (e) {
      _showInfo.value = "Error:$e";
      return;
    }

    await DeviceOrderCheck().checkDeviceOrder();

    // 如果hub上usb列表不为空和usb没有错误
    if (!DeviceOrderCheck().hubUsbPathList.isEmpty &&
        !DeviceOrderCheck().usbOrderError()) {
      if (AppConfig().enableUsbRelay) {
        _curIndex.value = AppConfig().relayIoCount;
      }

      // 设备初始化
      try {
        await DeviceConfig().createDevices();
      } catch (e) {
        _showInfo.value = "Error:$e";
        return;
      }

      // 设备列表
      deviceList = DeviceOrderCheck().usbList();
      setState(() {});
    } else {
      if (AppConfig().enableUsbRelay) {
        // 读配置文件中每个设备等待响应的时间
        try {
          await UsbRelayControl().initRelayIoStartTime();
        } catch (e) {
          _showInfo.value = "Error: $e";
          return;
        }
        // 继电器控制启动设备
        await UsbRelayControl().setAutoControl((int index) {
          _curIndex.value = index;
        });

        // 检查usb设备的顺序并显示结果
        await Future.delayed(Duration(seconds: 2), () {});
      }

      // 设备初始化
      try {
        await DeviceConfig().createDevices();
      } catch (e) {
        _showInfo.value = "Error:$e";
        return;
      }

      try {
        await DeviceOrderCheck().checkDeviceOrder();
      } catch (e) {
        _showInfo.value = "Error: $e";
        return;
      }

      // hub故障或者继电器故障
      if (DeviceOrderCheck().hubUsbPathList.isEmpty) {
        _showInfo.value = "The relay or usb hub is not working properly";
        return;
      }

      // 设备列表
      deviceList = DeviceOrderCheck().usbList();
      setState(() {});

      // 如果有usb顺序错误
      if (DeviceOrderCheck().usbOrderError()) {
        _showInfo.value =
            "USB device sequence error, \nPlease first check if the USB device sequence is correct, and then restart the machine";
        return;
      }
    }

    await jumpNewPage();
  }

  Future<void> jumpNewPage() async {
    // 站式有升降io设备
    if (DeviceSdkParamSetting().kioskType == KioskType.stand) {
      if (DeviceConfig().deviceEnable(DeviceType.IO_DEVICE)) {
        try {
          await UpDownControl().connect();
        } catch (e) {
          _showInfo.value = "Up down io device connection failed, Error:$e";
          return;
        }
      }
    }

    await Future.delayed(Duration(seconds: 2), () {});
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
              "Connecting USB device, $value  / ${DeviceSdkParamSetting().replayIoCount}",
              softWrap: true,
              maxLines: 5,
              style: TextStyle(
                  fontSize: height * 0.03, fontWeight: FontWeight.w600),
            );
          },
        ));
  }
}
