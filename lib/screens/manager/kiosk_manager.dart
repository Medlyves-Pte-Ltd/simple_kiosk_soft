import 'package:flutter_devices_sdk/device_sdk_param_setting.dart';
import 'package:simple_kiosk_software/common/footer.dart';
import 'package:simple_kiosk_software/utils/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:simple_kiosk_software/utils/permission_config.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class KioskManager extends StatefulWidget {
  @override
  _KioskManagerState createState() => _KioskManagerState();
}

class _KioskManagerState extends State<KioskManager> {
  final _scrollController = ScrollController();
  bool allowEdit = true;
  double height = 0;
  double width = 0;
  var kioskidControl = TextEditingController(text: AppConfig().kioskId);
  var deviceModelControl = TextEditingController(text: AppConfig().deviceModel);
  var deviceAddressControl =
      TextEditingController(text: AppConfig().deviceAddress);
  var clientNameControl = TextEditingController(text: AppConfig().clientName);
  var totalHeightControl =
      TextEditingController(text: AppConfig().totalHeight.toStringAsFixed(1));
  var heightOffsetControl =
      TextEditingController(text: AppConfig().heightOffset.toStringAsFixed(1));
  @override
  void initState() {
    super.initState();
    allowEdit =
        PermissionConfig().havePermission(PermissionModules.KioskManager);
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
        title: Text('Kiosk Configuration Page'),
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

  Widget kioskTypeWidget() {
    List<dynamic> kioskTypeList = AppConfig().configMap["kiosk_type_list"];

    return Row(
      children: [
        Text(
          "Kiosk Type",
          style:
              TextStyle(fontSize: height * 0.022, fontWeight: FontWeight.w500),
        ),
        const Spacer(),
        allowEdit
            ? DropdownButton<String>(
                value: AppConfig().kioskType,
                iconEnabledColor: ColorPalette.materialGreen,
                onChanged: (value) {
                  AppConfig().kioskType = value!;
                  setState(() {});
                },
                items: kioskTypeList.map<DropdownMenuItem<String>>((var value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: height * 0.02)),
                  );
                }).toList(),
              )
            : IgnorePointer(
                ignoring: true,
                child: DropdownButton<String>(
                  iconEnabledColor: ColorPalette.darkGrey,
                  value: AppConfig().kioskType,
                  onChanged: (value) {
                    AppConfig().kioskType = value!;
                    setState(() {});
                  },
                  items:
                      kioskTypeList.map<DropdownMenuItem<String>>((var value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: height * 0.02)),
                    );
                  }).toList(),
                )),
      ],
    );
  }

  Widget envWidget() {
    List<dynamic> envList = AppConfig().configMap["env_list"];

    return Row(
      children: [
        Text(
          "Environment",
          style:
              TextStyle(fontSize: height * 0.022, fontWeight: FontWeight.w500),
        ),
        const Spacer(),
        allowEdit
            ? DropdownButton<String>(
                value: AppConfig().envType,
                iconEnabledColor: ColorPalette.materialGreen,
                onChanged: (value) {
                  AppConfig().envType = value!;
                  setState(() {});
                },
                items: envList.map<DropdownMenuItem<String>>((var value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: height * 0.02)),
                  );
                }).toList(),
              )
            : IgnorePointer(
                ignoring: true,
                child: DropdownButton<String>(
                  iconEnabledColor: ColorPalette.darkGrey,
                  value: AppConfig().envType,
                  onChanged: (value) {
                    AppConfig().envType = value!;
                    setState(() {});
                  },
                  items: envList.map<DropdownMenuItem<String>>((var value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: height * 0.02)),
                    );
                  }).toList(),
                )),
      ],
    );
  }

  Widget settingArea() {
    return Column(children: [
      TDInput(
        readOnly: !allowEdit,
        inputType: TextInputType.text,
        needClear: false,
        leftLabel: 'Kiosk ID',
        controller: kioskidControl,
        backgroundColor: Colors.white,
        contentAlignment: TextAlign.end,
        hintText: 'Input Text',
        rightWidget: TDText('', textColor: TDTheme.of(context).fontGyColor1),
        onChanged: (text) {
          AppConfig().kioskId = text;
          setState(() {});
        },
      ),
      TDInput(
        readOnly: !allowEdit,
        inputType: TextInputType.text,
        needClear: false,
        leftLabel: 'Device Model',
        controller: deviceModelControl,
        backgroundColor: Colors.white,
        contentAlignment: TextAlign.end,
        hintText: 'Input Text',
        rightWidget: TDText('', textColor: TDTheme.of(context).fontGyColor1),
        onChanged: (text) {
          AppConfig().deviceModel = text;
          setState(() {});
        },
      ),
      TDInput(
        readOnly: !allowEdit,
        inputType: TextInputType.text,
        needClear: false,
        leftLabel: 'Device Address',
        controller: deviceAddressControl,
        backgroundColor: Colors.white,
        contentAlignment: TextAlign.end,
        hintText: 'Input Text',
        rightWidget: TDText('', textColor: TDTheme.of(context).fontGyColor1),
        onChanged: (text) {
          AppConfig().deviceAddress = text;
          setState(() {});
        },
      ),
      TDInput(
        readOnly: !allowEdit,
        inputType: TextInputType.text,
        needClear: false,
        leftLabel: 'Client Name',
        controller: clientNameControl,
        backgroundColor: Colors.white,
        contentAlignment: TextAlign.end,
        hintText: 'Input Text',
        rightWidget: TDText('', textColor: TDTheme.of(context).fontGyColor1),
        onChanged: (text) {
          AppConfig().clientName = text;
          setState(() {});
        },
      ),

      // 远程医疗功能
      allowEdit
          ? SwitchListTile(
              title: Text('Enable TC'),
              value: AppConfig().enableTC,
              onChanged: (bool value) {
                AppConfig().enableTC = value;
                setState(() {});
              },
            )
          : IgnorePointer(
              ignoring: true,
              child: SwitchListTile(
                title: Text('Enable TC'),
                value: AppConfig().enableTC,
                activeTrackColor: Colors.grey,
                inactiveThumbColor: Colors.red,
                inactiveTrackColor: Colors.grey,
                onChanged: (bool value) {},
              ),
            ),
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
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: kioskTypeWidget()),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 18), child: envWidget()),
      const SizedBox(
        height: 16,
      )
    ]);
  }
}
