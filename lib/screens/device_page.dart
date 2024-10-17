import 'package:flutter/material.dart';
import 'package:flutter_devices_sdk/devices/device_config.dart';
import 'package:flutter_devices_sdk/devices/usb_relay_control.dart';
import 'package:flutter_devices_sdk/project_type.dart';
import 'package:simple_kiosk_software/common/footer.dart';
import 'package:simple_kiosk_software/common/header.dart';
import 'package:simple_kiosk_software/utils/scanner_utils.dart';

class DevicePage extends StatelessWidget {
  late BuildContext _context;
  // 屏幕宽度
  double width = 0;
  // 屏幕高度
  double height = 0;
  int _ioCount = 0;
  ValueNotifier<int> _curIndex = ValueNotifier<int>(0);

  DevicePage() {
    Future.delayed(const Duration(milliseconds: 10), () async {
      //UsbRelayControl().ioCount = 8;
      // 打开USB IO继电器设备
      await UsbRelayControl().connect();
      _ioCount = UsbRelayControl().ioCount ?? 0;
      await UsbRelayControl().setAutoControl((int index) {
        _curIndex.value = index;
      });

      // 设备初始化
      await DeviceConfig().clearDeviceConfigStorage();
      await DeviceConfig().init(ProjectType.simple_kiosk_software_v2);

      // 打开扫码器
      await ScannerUtils().connect();

      Navigator.pushNamedAndRemoveUntil(_context, '/', (route) => false);
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
          const Spacer(),
          _buildProgress(),
          const Spacer(),
          const Footer()
        ],
      ),
    );
  }

  Widget _buildProgress() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        alignment: Alignment.center,
        child: ValueListenableBuilder(
          valueListenable: _curIndex,
          builder: (context, value, child) {
            return Text(
              "Starting the medical examination device, $value  / $_ioCount, please wait...",
              softWrap: true,
              maxLines: 5,
              style: TextStyle(
                  fontSize: height * 0.03, fontWeight: FontWeight.w600),
            );
          },
        ));
  }
}
