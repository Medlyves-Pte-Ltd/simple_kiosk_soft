import 'package:flutter/material.dart';
import 'package:flutter_devices_sdk/device_data/weight_data.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:flutter_devices_sdk/devices/device_base_model.dart';
import 'package:flutter_devices_sdk/device_manager.dart';
import 'package:flutter_devices_sdk/devices/device_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_kiosk_software/utils/user_info.dart';
import '../../utils/hex_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../check/weight_check.dart';

class WeightCalibrationPage extends StatefulWidget {
  @override
  _WeightCalibrationPageState createState() => _WeightCalibrationPageState();
}

class _WeightCalibrationPageState extends State<WeightCalibrationPage> {
  // 屏幕宽度
  double width = 0;
  // 屏幕高度
  double height = 0;
  final counterWeight = TextEditingController();
  late String text;
  ValueNotifier<String> _height = ValueNotifier('- - -');
  ValueNotifier<String> _weight = ValueNotifier('- - -');
  DeviceBaseModel? _weightDevice;

  @override
  void initState() {
    for (var item in DeviceConfig().availableDeviceList) {
      if (item.deviceType == DeviceType.WEIGHT_DEVICE) {
        _weightDevice = item.device;
        break;
      }
    }

    _weightDevice?.onDataReady.listen((event) {
      WeightData weightData = event as WeightData;
      _weight.value = weightData.weight;
      UserInfo().weight = weightData.weight;
    });
  }

  Future<void> stop() async {
    await _weightDevice?.stop();
    await _weightDevice?.disconnect();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    counterWeight.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Weight Calibration'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: height * 0.3,
            width: width,
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
              Container(
                height: height * 0.03,
                margin: const EdgeInsets.fromLTRB(10, 0, 25, 20),
                child: ElevatedButton(
                  onPressed: () async {
                    num weightCount = double.parse(counterWeight.text);
                    while (weightCount != null) {
                      if (weightCount <= 24.9999) {
                        Fluttertoast.showToast(
                            msg: "The weight is less than 25 kg");
                        break;
                      } else {
                        num resultWeight = weightCount * 20;
                        String c = (resultWeight)
                            .toInt()
                            .toRadixString(16)
                            .padLeft(4, "0");
                        String data =
                            "0A 27 C0 02 12 00 00 ${c.substring(0, 2)} ${c.substring(2)}";
                        String xor = xorSum(data).toRadixString(16);
                        await _weightDevice?.sendCommand(
                            HexUtils.hexStringToBytes("A5 $data $xor AA"));
                        print("A5 $data $xor AA");
                        break;
                      }
                    }
                  },
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: const Text("Set", style: TextStyle(fontSize: 10)),
                ),
              ),
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
                      .click_the_Calibration_command_button,
                  style: TextStyle(fontSize: height * 0.015),
                ),
              ),
              Container(
                height: height * 0.03,
                margin: const EdgeInsets.fromLTRB(10, 0, 25, 20),
                child: ElevatedButton(
                  onPressed: () async {
                    await _weightDevice?.sendCommand(
                        [0xA5, 0x07, 0x27, 0xA0, 0x07, 0x00, 0x00, 0x87, 0xAA]);
                  },
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: const Text(
                    "Calibration command",
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              ),
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
              Container(
                height: height * 0.03,
                margin: const EdgeInsets.fromLTRB(0, 0, 25, 20),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: const Text("Start", style: TextStyle(fontSize: 10)),
                ),
              ),
            ],
          ),
          WeightCheck(),
        ],
      ),
    );
  }
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
