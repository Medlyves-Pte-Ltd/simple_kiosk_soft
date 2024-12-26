import 'package:simple_kiosk_software/common/footer.dart';
import 'package:simple_kiosk_software/utils/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:simple_kiosk_software/utils/permission_config.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class DeviceUsbRelayPage extends StatefulWidget {
  @override
  _DeviceUsbRelayPageState createState() => _DeviceUsbRelayPageState();
}

class _DeviceUsbRelayPageState extends State<DeviceUsbRelayPage> {
  final _scrollController = ScrollController();
  var relayUsbConverterVidControl =
      TextEditingController(text: AppConfig().relayUsbConverterVid.toString());
  var relayUsbConverterPidControl =
      TextEditingController(text: AppConfig().relayUsbConverterPid.toString());
  bool allowEdit = true;
  double height = 0;
  double width = 0;

  @override
  void initState() {
    super.initState();
    allowEdit =
        PermissionConfig().havePermission(PermissionModules.DeviceUsbRelay);
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
        title: Text('Device Usb Relay'),
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

  Widget relayIoCountWidget() {
    List<dynamic> relayIoCountList =
        AppConfig().configMap["relay_io_count_list"];

    return Row(
      children: [
        Text(
          "Usb Relay IO Count",
          style: TextStyle(fontSize: height * 0.012),
        ),
        const Spacer(),
        allowEdit
            ? DropdownButton<int>(
                value: AppConfig().relayIoCount,
                iconEnabledColor: ColorPalette.materialGreen,
                onChanged: (value) {
                  AppConfig().relayIoCount = value!;
                  setState(() {});
                },
                items: relayIoCountList.map<DropdownMenuItem<int>>((var value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: height * 0.012)),
                  );
                }).toList(),
              )
            : IgnorePointer(
                ignoring: true,
                child: DropdownButton<int>(
                  iconEnabledColor: ColorPalette.darkGrey,
                  value: AppConfig().relayIoCount,
                  onChanged: (value) {
                    AppConfig().relayIoCount = value!;
                    setState(() {});
                  },
                  items:
                      relayIoCountList.map<DropdownMenuItem<int>>((var value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: height * 0.012)),
                    );
                  }).toList(),
                )),
      ],
    );
  }

  Widget relayUsbConvertPidWidget() {
    return Row(
      children: [
        Text(
          "Relay Usb Converter Pid",
          style: TextStyle(fontSize: height * 0.012),
        ),
        const Spacer(),
        SizedBox(
            width: width * 0.1,
            child: TextField(
              readOnly: !allowEdit,
              keyboardType: TextInputType.number,
              autocorrect: false,
              controller: relayUsbConverterPidControl,
              textCapitalization: TextCapitalization.words,
              cursorColor: const Color.fromRGBO(103, 155, 206, 1),
              style: TextStyle(fontSize: height * 0.012),
              onSubmitted: (text) {
                setState(() {});
                if (text.isEmpty) {
                  return;
                }
                AppConfig().relayUsbConverterPid = int.parse(text);
              },
            )),
      ],
    );
  }

  Widget relayUsbConvertVidWidget() {
    return Row(
      children: [
        Text(
          "Relay Usb Converter Vid",
          style: TextStyle(fontSize: height * 0.012),
        ),
        const Spacer(),
        SizedBox(
          width: width * 0.1,
          child: TextField(
            readOnly: !allowEdit,
            keyboardType: TextInputType.number,
            autocorrect: false,
            controller: relayUsbConverterVidControl,
            textCapitalization: TextCapitalization.words,
            cursorColor: const Color.fromRGBO(103, 155, 206, 1),
            style: TextStyle(fontSize: height * 0.012),
            onSubmitted: (text) {
              setState(() {});
              if (text.isEmpty) {
                return;
              }
              AppConfig().relayUsbConverterVid = int.parse(text);
            },
          ),
        ),
      ],
    );
  }

  Widget usbRelayCommTypeWidget() {
    List<dynamic> relayCommTypeList = AppConfig().configMap["relay_comm_list"];
    return Row(
      children: [
        Text(
          "Usb Relay Comm Type",
          style: TextStyle(fontSize: height * 0.012),
        ),
        const Spacer(),
        allowEdit
            ? DropdownButton<String>(
                value: AppConfig().relayCommType,
                iconEnabledColor: ColorPalette.materialGreen,
                onChanged: (value) {
                  AppConfig().relayCommType = value!;
                  setState(() {});
                },
                items: relayCommTypeList
                    .map<DropdownMenuItem<String>>((var value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: height * 0.012)),
                  );
                }).toList(),
              )
            : IgnorePointer(
                ignoring: true,
                child: DropdownButton<String>(
                  iconEnabledColor: ColorPalette.darkGrey,
                  value: AppConfig().relayCommType,
                  onChanged: (value) {
                    AppConfig().relayCommType = value!;
                    setState(() {});
                  },
                  items: relayCommTypeList
                      .map<DropdownMenuItem<String>>((var value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: height * 0.012)),
                    );
                  }).toList(),
                )),
      ],
    );
  }

  Widget settingArea() {
    return Column(children: [
      // 继电器
      allowEdit
          ? SwitchListTile(
              title: Text('Enable Usb Relay',
                  style: TextStyle(fontSize: height * 0.012)),
              value: AppConfig().enableUsbRelay,
              onChanged: (bool value) {
                AppConfig().enableUsbRelay = value;
                setState(() {});
              },
            )
          : IgnorePointer(
              ignoring: true,
              child: SwitchListTile(
                title: Text('Enable Usb Relay',
                    style: TextStyle(fontSize: height * 0.012)),
                value: AppConfig().enableUsbRelay,
                activeTrackColor: Colors.grey,
                inactiveThumbColor: Colors.red,
                inactiveTrackColor: Colors.grey,
                onChanged: (bool value) {},
              ),
            ),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: usbRelayCommTypeWidget()),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: relayIoCountWidget()),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: relayUsbConvertVidWidget()),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: relayUsbConvertPidWidget()),
      const SizedBox(
        height: 16,
      )
    ]);
  }
}
