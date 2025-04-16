import 'package:flutter_devices_sdk/device_sdk_param_setting.dart';
import 'package:simple_kiosk_software/common/footer.dart';
import 'package:simple_kiosk_software/utils/app_config.dart';
import 'package:flutter/material.dart';
import 'package:simple_kiosk_software/utils/permission_config.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class DeviceOtherSettingPage extends StatefulWidget {
  @override
  _DeviceOtherSettingPageState createState() => _DeviceOtherSettingPageState();
}

class _DeviceOtherSettingPageState extends State<DeviceOtherSettingPage> {
  final _scrollController = ScrollController();
  bool allowEdit = true;
  double height = 0;
  double width = 0;
  TextEditingController usbSequenceCheckTime =
      TextEditingController(text: AppConfig().usbSequenceCheckTime.toString());
  TextEditingController upDownIoStopTimeInterval =
      TextEditingController(text: AppConfig().upDownIoStopTime.toString());
  @override
  void initState() {
    super.initState();

    allowEdit = PermissionConfig()
        .havePermission(PermissionModules.DeviceRelateSetting);
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
        title: Text('Device Other Setting'),
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
        needClear: false,
        leftLabel: 'Usb Check Time',
        controller: usbSequenceCheckTime,
        backgroundColor: Colors.white,
        contentAlignment: TextAlign.end,
        hintText: 'Input Text',
        rightWidget: TDText('s', textColor: TDTheme.of(context).fontGyColor1),
        onSubmitted: (text) {
          if (text.isEmpty) {
            return;
          }
          AppConfig().usbSequenceCheckTime = int.parse(text);
        },
      ),
      TDInput(
        readOnly: !allowEdit,
        inputType: TextInputType.number,
        needClear: false,
        leftLabel: 'Up Down Stop Time',
        controller: upDownIoStopTimeInterval,
        backgroundColor: Colors.white,
        contentAlignment: TextAlign.end,
        hintText: 'Input Text',
        rightWidget: TDText('ms', textColor: TDTheme.of(context).fontGyColor1),
        onSubmitted: (text) {
          if (text.isEmpty) {
            return;
          }
          DeviceSdkParamSetting().upDownIoStopTimeInterval = int.parse(text);
          AppConfig().upDownIoStopTime = int.parse(text);
        },
      )
    ]);
  }
}
