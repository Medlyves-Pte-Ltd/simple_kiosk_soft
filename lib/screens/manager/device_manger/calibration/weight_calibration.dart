import 'dart:async';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:flutter_devices_sdk/devices/boruiwei_dg861_weight_calibration.dart';
import 'package:flutter_devices_sdk/devices/device_config.dart';
import 'package:simple_kiosk_software/common/footer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:simple_kiosk_software/utils/permission_config.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WeightCalibration extends StatefulWidget {
  @override
  _WeightCalibrationState createState() => _WeightCalibrationState();
}

class _WeightCalibrationState extends State<WeightCalibration> {
  bool allowEdit = true;
  double height = 0;
  double width = 0;
  ValueNotifier<bool> enableClickSendWightData = ValueNotifier<bool>(true);
  ValueNotifier<bool> enableClickSendCalibration = ValueNotifier<bool>(true);
  ValueNotifier<bool> enableClickConnect = ValueNotifier<bool>(true);
  var weight1Control = TextEditingController(text: "25.0");
  var weight2Control = TextEditingController(text: "25.0");
  var weight3Control = TextEditingController(text: "25.0");

  @override
  void initState() {
    super.initState();
    allowEdit =
        PermissionConfig().havePermission(PermissionModules.DeviceCalibration);
    enableClickSendWightData.value = allowEdit;
    enableClickSendCalibration.value = allowEdit;
    enableClickConnect.value = allowEdit;
  }

  @override
  void dispose() {
    super.dispose();
    if (DeviceConfig().deviceEnable(DeviceType.WEIGHT_DEVICE)) {
      Future.delayed(Duration(milliseconds: 10), () async {
        BoruiweiDG861WeightCalibration().stop();
        await BoruiweiDG861WeightCalibration().disConnect();
      });
    }
  }

  void alertDialog(String text) {
    showDialog(
      context: context,
      barrierDismissible: false, //点击弹窗以外背景是否取消弹窗
      builder: (context) {
        return AlertDialog(
          title: const Text("Weight Calibration Info"),
          content: Text(text),
          actions: [
            TextButton(
              onPressed: () {
                //关闭弹窗
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void calibrationResultCallback(int order) {
    if (order == 16) {
    } else if (order == 17) {
      // 零点校准成功，请放上第一个砝码
      alertDialog(
          "Zero calibration successful, please place the first calibration weight");
    } else if (order == 18) {
      // 请放上第二个砝码
      alertDialog("Please place the second calibration weight");
    } else if (order == 19) {
      // 请放上第三个砝码
      alertDialog("Please put on the third calibration weight");
    } else if (order == 21) {
      // 校准完成
      alertDialog("Calibration completed, please reboot machine");
    }
  }

  Future<void> connectWeightDevice() async {
    if (DeviceConfig().deviceEnable(DeviceType.WEIGHT_DEVICE)) {
      Future.delayed(Duration(milliseconds: 10), () async {
        try {
          BoruiweiDG861WeightCalibration().calibrationResultCallback =
              calibrationResultCallback;
          await BoruiweiDG861WeightCalibration().connect();
          BoruiweiDG861WeightCalibration().start();
        } catch (e) {
          alertDialog("Connection failed, Error:$e");
          return;
        }
      });
    }
    enableClickConnect.value = false;
    alertDialog("Connection successful");
  }

  Future<void> calibration() async {
    enableClickSendCalibration.value = false;
    try {
      await BoruiweiDG861WeightCalibration().sendCalibrationCmd();
      enableClickSendCalibration.value = true;
    } catch (e) {
      alertDialog("Calibration cmd sent failed, Error:$e");
      enableClickSendCalibration.value = true;
      return;
    }
    alertDialog("Calibration cmd sent successfully");
  }

  Future<void> sendWeightData() async {
    double weight0 = 0.0;
    double weight1 = 0.0;
    double weight2 = 0.0;

    if (weight1Control.text.isEmpty) {
      alertDialog("The calibration weight 1 cannot be empty");
      return;
    }

    if (weight1Control.text.isEmpty) {
      alertDialog("The calibration weight 1 cannot be empty");
      return;
    }

    weight0 = double.parse(weight1Control.text);
    if (weight0.abs() <= 24.8) {
      alertDialog("The weight is less than 25 kg");
      return;
    }

    if (weight2Control.text.isNotEmpty) {
      weight1 = double.parse(weight2Control.text);
    }

    if (weight3Control.text.isNotEmpty) {
      weight2 = double.parse(weight3Control.text);
    }

    enableClickSendWightData.value = false;
    try {
      await BoruiweiDG861WeightCalibration()
          .setWeightData(weight0, weight1, weight2);
    } catch (e) {
      enableClickSendWightData.value = true;
      alertDialog("Weight data sent failed, Error:$e");
      return;
    }
    enableClickSendWightData.value = true;
    alertDialog("Weight data sent successfully");
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Weight Calibration'),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
              child: Padding(
                  padding: EdgeInsets.all(width * 0.1), child: settingArea())),
          Footer()
        ],
      ),
    );
  }

  Widget settingArea() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Image.asset(
        'assets/images/weightcalibration.webp',
        height: height * 0.2,
      ),

      SizedBox(
        height: height * 0.01,
      ),
      Text(
        "Only calibration BoRuiWei DG861 weight device.",
        softWrap: true,
        style: TextStyle(fontSize: height * 0.015, color: Colors.red),
      ),
      SizedBox(
        height: height * 0.01,
      ),
      // 校准的砝码不能小于25kg
      Text(
        "The calibrated weight cannot be less than 25kg.",
        softWrap: true,
        style: TextStyle(fontSize: height * 0.015, color: Colors.red),
      ),
      SizedBox(
        height: height * 0.01,
      ),
      Text(
        "If calibrating at a single point, only weight 1 needs to be set, and weights 2 and 3 need to be set to 0.0",
        softWrap: true,
        style: TextStyle(fontSize: height * 0.015),
      ),
      SizedBox(
        height: height * 0.01,
      ),
      TDInput(
        textStyle: TextStyle(fontSize: height * 0.015),
        readOnly: !allowEdit,
        inputType: TextInputType.number,
        needClear: false,
        leftLabel: 'Weight 1',
        controller: weight1Control,
        backgroundColor: Colors.white,
        contentAlignment: TextAlign.end,
        hintText: 'Input Text',
        rightWidget: TDText('kg', textColor: TDTheme.of(context).fontGyColor1),
      ),
      SizedBox(
        height: height * 0.01,
      ),
      TDInput(
        textStyle: TextStyle(fontSize: height * 0.015),
        readOnly: !allowEdit,
        inputType: TextInputType.number,
        needClear: false,
        leftLabel: 'Weight 2',
        controller: weight2Control,
        backgroundColor: Colors.white,
        contentAlignment: TextAlign.end,
        hintText: 'Input Text',
        rightWidget: TDText('kg', textColor: TDTheme.of(context).fontGyColor1),
      ),
      SizedBox(
        height: height * 0.01,
      ),
      TDInput(
        textStyle: TextStyle(fontSize: height * 0.015),
        readOnly: !allowEdit,
        inputType: TextInputType.number,
        needClear: false,
        leftLabel: 'Weight 3',
        controller: weight3Control,
        backgroundColor: Colors.white,
        contentAlignment: TextAlign.end,
        hintText: 'Input Text',
        rightWidget: TDText('kg', textColor: TDTheme.of(context).fontGyColor1),
      ),
      SizedBox(
        height: height * 0.01,
      ),
      Row(
        children: [
          Text(
            "1. Connect weight device.",
            style: TextStyle(fontSize: height * 0.015),
          ),
          SizedBox(
            width: width * 0.03,
          ),
          ValueListenableBuilder(
              valueListenable: enableClickConnect,
              builder: (context, enable, child) {
                return InkWell(
                  onTap: enable ? connectWeightDevice : null,
                  child: Container(
                    height: height * 0.022,
                    width: width * 0.15,
                    decoration: BoxDecoration(
                      color: enable
                          ? ColorPalette.materialGreen
                          : ColorPalette.darkGrey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      textAlign: TextAlign.center,
                      "connect",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: height * 0.015),
                    ),
                  ),
                );
              })
        ],
      ),
      SizedBox(
        height: height * 0.01,
      ),
      Text(
        "2. Empty the pan.",
        style: TextStyle(fontSize: height * 0.015),
      ),
      SizedBox(
        height: height * 0.01,
      ),
      Row(
        children: [
          Text(
            "3. Send weight data, wait for 6 seconds.",
            style: TextStyle(fontSize: height * 0.015),
          ),
          SizedBox(
            width: width * 0.03,
          ),
          ValueListenableBuilder(
              valueListenable: enableClickSendWightData,
              builder: (context, enable, child) {
                return InkWell(
                  onTap: enable ? sendWeightData : null,
                  child: Container(
                    height: height * 0.022,
                    width: width * 0.1,
                    decoration: BoxDecoration(
                      color: enable
                          ? ColorPalette.materialGreen
                          : ColorPalette.darkGrey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      textAlign: TextAlign.center,
                      "send",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: height * 0.015),
                    ),
                  ),
                );
              })
        ],
      ),
      SizedBox(
        height: height * 0.01,
      ),
      Row(
        children: [
          Text(
            "4. Send Calibration command.",
            style: TextStyle(fontSize: height * 0.015),
          ),
          SizedBox(
            width: width * 0.03,
          ),
          ValueListenableBuilder(
              valueListenable: enableClickSendCalibration,
              builder: (context, enable, child) {
                return InkWell(
                  onTap: enable ? calibration : null,
                  child: Container(
                    height: height * 0.022,
                    width: width * 0.1,
                    decoration: BoxDecoration(
                      color: enable
                          ? ColorPalette.materialGreen
                          : ColorPalette.darkGrey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      textAlign: TextAlign.center,
                      "send",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: height * 0.015),
                    ),
                  ),
                );
              })
        ],
      ),
      SizedBox(
        height: height * 0.01,
      ),
      // 校准成功后断开电源,等待5秒后重新上电
      Text(
        "5. After successful calibration, disconnect the power supply and wait for 5 seconds before powering it back on.",
        softWrap: true,
        style: TextStyle(fontSize: height * 0.015),
      ),
    ]);
  }
}
