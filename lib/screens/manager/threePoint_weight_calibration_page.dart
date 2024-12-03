import 'package:flutter/material.dart';
import 'package:flutter_devices_sdk/device_data/weight_data.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:flutter_devices_sdk/devices/device_base_model.dart';
import 'package:flutter_devices_sdk/devices/device_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_kiosk_software/utils/user_info.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ThreePointWeightCalibrationPage extends StatefulWidget {
  const ThreePointWeightCalibrationPage({super.key});

  @override
  State<ThreePointWeightCalibrationPage> createState() =>
      _threePointWeightCalibrationPageState();
}

class _threePointWeightCalibrationPageState
    extends State<ThreePointWeightCalibrationPage> {
  // 屏幕宽度
  double width = 0;
  // 屏幕高度
  double height = 0;
  ValueNotifier<String> _weight = ValueNotifier('');
  DeviceBaseModel? _weightDevice;
  late String text;
  late String text1;

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

  @override
  Widget build(BuildContext context) {
    initState();
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Three Point Weight Calibration'),
      ),
      body: ThreePointWeightCalibrationPagemain(),
    );
  }

  Widget ThreePointWeightCalibrationPagemain() {
    text = AppLocalizations.of(context)!.empty_the_pan;
    text1 =
        AppLocalizations.of(context)!.click_three_calibration_command_button;
    return Column(
      children: [
        SizedBox(
          child: Image.asset('assets/images/weightcalibration.webp'),
        ),
        ListTile(
          title: Text(text),
        ),
        ListTile(
          title: Text(text1),
        ),
        threeCalibrationButton(),
      ],
    );
  }

  Widget threeCalibrationButton() {
    return ElevatedButton(
      onPressed: () async {
        await _weightDevice?.sendCommand(
            [0xA5, 0x07, 0x27, 0xA0, 0x07, 0x05, 0x01, 0x83, 0xAA]);
      },
      child: Text('Start'),
    );
  }
}
