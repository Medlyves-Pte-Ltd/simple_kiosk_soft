import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_devices_sdk/device_data/weight_data.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:flutter_devices_sdk/devices/device_base_model.dart';
import 'package:flutter_devices_sdk/devices/device_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:simple_kiosk_software/utils/user_info.dart';
import '../../constants/colors.dart';
import '../../remote/utils/app_constants.dart';
import '../../utils/hex_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_devices_sdk/comm/usb_interface.dart';
import 'package:flutter_android_usb/usb_port.dart';
import 'package:flutter_devices_sdk/comm/communication_interface.dart';

class singePointWeightCalibrationPage extends StatefulWidget {
  @override
  _singePointWeightCalibrationPageState createState() =>
      _singePointWeightCalibrationPageState();
}

class _singePointWeightCalibrationPageState
    extends State<singePointWeightCalibrationPage> {
  // 屏幕宽度
  double width = 0;
  // 屏幕高度
  double height = 0;
  final counterWeight = TextEditingController();
  late String text;
  ValueNotifier<String> _weight = ValueNotifier('');
  DeviceBaseModel? _weightDevice;
  UsbPort? _port;
  StreamSubscription? _inputStreamSubscription;

  @override
  void initState() {
    for (var item in DeviceConfig().availableDeviceList) {
      if (item.deviceType == DeviceType.WEIGHT_DEVICE) {
        _weightDevice = item.device;
        break;
      }
    }
    readData();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    counterWeight.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initState();
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Singe Point Weight Calibration'),
      ),
      body: Column(
        children: [
          SizedBox(
            child: Image.asset('assets/images/weightcalibration.webp'),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(30, 20, 25, 25),
            height: height * 0.02,
            width: width,
            child: Text(
              text = AppLocalizations.of(context)!.empty_the_pan,
              style: TextStyle(fontSize: height * 0.015),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(30, 20, 25, 0),
            height: height * 0.02,
            width: width,
            child: Text(
              text = AppLocalizations.of(context)!.enter_the_weight,
              style: TextStyle(fontSize: height * 0.015),
            ),
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(30, 0, 10, 10),
                height: height * 0.02,
                width: width * 0.4,
                child: TextField(
                  controller: counterWeight,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: ' ',
                    suffixIcon: Text(
                      'KG',
                      style: TextStyle(fontSize: height * 0.01),
                    ),
                    prefixIcon: Icon(Icons.accessibility_rounded),
                  ),
                ),
              ),
              setWeight(),
            ],
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(30, 20, 25, 10),
            height: height * 0.02,
            width: width,
            child: Text(
              text = AppLocalizations.of(context)!.put_the_weight,
              style: TextStyle(fontSize: height * 0.015),
            ),
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(30, 20, 5, 25),
                height: height * 0.02,
                width: width * 0.4,
                child: Text(
                  text = AppLocalizations.of(context)!
                      .click_singe_calibration_command_button,
                  style: TextStyle(fontSize: height * 0.015),
                ),
              ),
              commandButton(),
            ],
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(30, 20, 25, 15),
            height: height * 0.04,
            width: width,
            child: Text(
              text = AppLocalizations.of(context)!.weight_check,
              maxLines: 2,
              style: TextStyle(fontSize: height * 0.015),
            ),
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(30, 0, 25, 20),
                height: height * 0.02,
                width: width * 0.4,
                child: Text(
                  '0' + '\tKG',
                  style: TextStyle(fontSize: height * 0.015),
                ),
              ),
              testButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget commandButton() {
    return Container(
      height: height * 0.03,
      margin: const EdgeInsets.fromLTRB(10, 0, 25, 20),
      child: ElevatedButton(
        onPressed: () async {
          Fluttertoast.showToast(
              msg:
                  "Calibration starts in ten seconds. Please put the weights on quickly");
          Future.delayed(const Duration(seconds: 10), () async {
            await _weightDevice?.sendCommand(
                [0xA5, 0x07, 0x27, 0xA0, 0x07, 0x00, 0x00, 0x87, 0xAA]);
          });
        },
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(ColorPalette.materialGreen),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        child: Text(
          "Calibration command",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: height * 0.01,
              color: Colors.white),
        ),
      ),
    );
  }

  Widget testButton() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 25, 20),
      child: ElevatedButton(
        onPressed: () {},
        child: Center(
          child: Text('Start',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: Device.height * 0.015)),
        ),
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(ColorPalette.materialGreen),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  Widget setWeight() {
    return Container(
      height: height * 0.03,
      decoration: BoxDecoration(color: ColorPalette.materialGreen),
      margin: const EdgeInsets.fromLTRB(10, 0, 25, 20),
      child: ElevatedButton(
        onPressed: () async {
          num weightCount = double.parse(counterWeight.text);
          while (weightCount != '') {
            if (weightCount <= 24.9999) {
              Fluttertoast.showToast(msg: "The weight is less than 25 kg");
              break;
            } else {
              num resultWeight = weightCount * 20;
              String c =
                  (resultWeight).toInt().toRadixString(16).padLeft(4, "0");
              String data =
                  "0A 27 C0 02 12 00 00 ${c.substring(0, 2)} ${c.substring(2)}";
              String xor = xorSum(data).toRadixString(16);
              await _weightDevice
                  ?.sendCommand(HexUtils.hexStringToBytes("A5 $data $xor AA"));
              await _weightDevice?.sendCommand([
                0xA5,
                0x0A,
                0x27,
                0xC0,
                0x02,
                0x14,
                0x00,
                0x00,
                0x00,
                0x00,
                0xFB,
                0xAA
              ]);
              await _weightDevice?.sendCommand([
                0xA5,
                0x0A,
                0x27,
                0xC0,
                0x02,
                0x16,
                0x00,
                0x00,
                0x00,
                0x00,
                0xF9,
                0xAA
              ]);
            }
          }
        },
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(ColorPalette.materialGreen),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        child: Text("Set",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: height * 0.015,
                color: Colors.white)),
      ),
    );
  }

  int xorSum(String inData) {
    List<int> outData =
        inData.split(' ').map((hex) => int.parse(hex, radix: 16)).toList();
    int sum = 0;
    for (int i = 0; i < outData.length; ++i) {
      sum ^= outData[i];
    }
    return sum;
  }
}
