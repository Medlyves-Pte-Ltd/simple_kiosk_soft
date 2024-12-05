import 'package:flutter_devices_sdk/device_sdk_param_setting.dart';
import 'package:simple_kiosk_software/common/footer.dart';
import 'package:simple_kiosk_software/utils/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:simple_kiosk_software/utils/permission_config.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class HeightCalibrationPage extends StatefulWidget {
  @override
  _HeightCalibrationPageState createState() => _HeightCalibrationPageState();
}

class _HeightCalibrationPageState extends State<HeightCalibrationPage> {
  final _scrollController = ScrollController();
  bool allowEdit = true;
  double height = 0;
  double width = 0;
  var totalHeightControl =
      TextEditingController(text: AppConfig().totalHeight.toStringAsFixed(1));
  var heightOffsetControl =
      TextEditingController(text: AppConfig().heightOffset.toStringAsFixed(1));
  @override
  void initState() {
    super.initState();
    allowEdit =
        PermissionConfig().havePermission(PermissionModules.DeviceCalibration);
  }

  @override
  void dispose() {
    super.dispose();
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
        title: Text('Height Calibration'),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
              child: RawScrollbar(
                  thumbColor: Colors.grey,
                  controller: _scrollController,
                  thumbVisibility: true, // 一直显示滑动条
                  thickness: 8, // 滑动条的宽度
                  radius: const Radius.circular(10),
                  interactive: true, // 滑动条为true 可拖动
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: settingArea(),
                  ))),
          Footer()
        ],
      ),
    );
  }

  Widget settingArea() {
    return Column(children: [
      TDInput(
        readOnly: !allowEdit,
        inputType: TextInputType.number,
        type: TDInputType.special,
        controller: totalHeightControl,
        leftLabel: 'Total Height',
        hintText: '0.0',
        backgroundColor: Colors.white,
        textAlign: TextAlign.end,
        rightWidget: TDText('cm', textColor: TDTheme.of(context).fontGyColor1),
        onChanged: (text) {
          setState(() {});
          if (text.isEmpty) {
            return;
          }
          DeviceSdkParamSetting().totalHeight = double.parse(text);
          AppConfig().totalHeight = double.parse(text);
        },
      ),
      TDInput(
        readOnly: !allowEdit,
        inputType: TextInputType.number,
        type: TDInputType.special,
        controller: heightOffsetControl,
        leftLabel: 'Height Offset',
        hintText: '0.0',
        backgroundColor: Colors.white,
        textAlign: TextAlign.end,
        rightWidget: TDText('cm', textColor: TDTheme.of(context).fontGyColor1),
        onChanged: (text) {
          setState(() {});
          if (text.isEmpty) {
            return;
          }
          DeviceSdkParamSetting().heightOffset = double.parse(text);
          AppConfig().heightOffset = double.parse(text);
        },
      ),
    ]);
  }
}
