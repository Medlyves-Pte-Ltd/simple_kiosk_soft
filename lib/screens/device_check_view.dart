import 'package:flutter/material.dart';
import 'package:flutter_devices_sdk/devices/device_order_check.dart';
import 'package:simple_kiosk_software/utils/kiosk_config.dart';

class DeviceCheckView extends StatefulWidget {
  @override
  _DeviceCheckViewState createState() => _DeviceCheckViewState();
}

class _DeviceCheckViewState extends State<DeviceCheckView> {
  late BuildContext _context;
  // 屏幕宽度
  double width = 0;
  // 屏幕高度
  double height = 0;
  List<Widget> deviceList = [];
  ValueNotifier<String> _showInfo = ValueNotifier<String>("");
  final _scrollController = ScrollController();

  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 10), start);
  }

  // 启动
  void start() async {
    await DeviceOrderCheck().checkDeviceOrder();

    if (KioskConfig().kioskType == "xk") {
      deviceList = DeviceOrderCheck().xkUsbList();

      if (DeviceOrderCheck().usbError) {
        _showInfo.value = "USB devices not found. Please check the connection.";
      }
    } else {
      deviceList = DeviceOrderCheck().relayUsbList();

      // hub故障或者继电器故障
      if (DeviceOrderCheck().hubUsbPathList.isEmpty) {
        _showInfo.value = "The relay or usb hub is not working properly";
        return;
      }

      // 如果有usb顺序错误
      if (DeviceOrderCheck().usbOrderError()) {
        _showInfo.value =
            "USB device sequence error, \nPlease first check if the USB device sequence is correct, and then restart the machine";
        return;
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: height * 0.03),
            _buildError(),
            SizedBox(height: height * 0.01),
            Expanded(
                child: RawScrollbar(
                    thumbColor: Colors.grey,
                    controller: _scrollController,
                    thumbVisibility: true, // 一直显示滑动条
                    thickness: 8, // 滑动条的宽度
                    radius: const Radius.circular(10),
                    interactive: true, // 滑动条为true 可拖动
                    child: ListView(
                      physics: AlwaysScrollableScrollPhysics(),
                      controller: _scrollController,
                      children: deviceList,
                    ))),
          ],
        ),
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
}
