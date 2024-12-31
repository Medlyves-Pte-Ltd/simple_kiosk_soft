import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_devices_sdk/log/log_printer.dart';
import 'package:flutter_devices_sdk/view/colors.dart';
import 'package:simple_kiosk_software/utils/app_config.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simple_kiosk_software/utils/kiosk_config.dart';
import 'package:simple_kiosk_software/utils/permission_config.dart';

class SampleKioskDeviceConfigView extends StatefulWidget {
  bool allowEdit = true;

  @override
  SampleKioskDeviceConfigViewState createState() =>
      SampleKioskDeviceConfigViewState();
}

class SampleKioskDeviceConfigViewState
    extends State<SampleKioskDeviceConfigView> {
  final _scrollController = ScrollController();
  String configFile = "";
  List<dynamic> _deviceConfigList = [];
  // 屏幕宽度
  double width = 0;
  // 屏幕高度
  double height = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    configFile =
        "${AppConfig().configDir}/devices/${KioskConfig().kioskType}_config.json";
    widget.allowEdit = PermissionConfig()
        .havePermission(PermissionModules.DeviceConfiguration);
    Future.delayed(Duration(milliseconds: 10), () async {
      await loadFile();
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return buildBody();
  }

  Widget buildBody() {
    return Column(
      children: [
        Expanded(
          child: RawScrollbar(
            thumbColor: Colors.grey,
            controller: _scrollController,
            thumbVisibility: true, // 一直显示滑动条
            thickness: 6, // 滑动条的宽度
            radius: const Radius.circular(10),
            interactive: true, // 滑动条为true 可拖动
            child: ReorderableListView.builder(
                scrollController: _scrollController,
                padding: const EdgeInsets.only(left: 8, right: 8),
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: deviceItem,
                itemCount: _deviceConfigList.length,
                onReorder: _onReorder),
          ),
        ),
        widget.allowEdit ? buildSaveBtn() : const SizedBox.shrink()
      ],
    );
  }

  Widget deviceItem(BuildContext context, int index) {
    if (index >= _deviceConfigList.length) {
      return const SizedBox.shrink();
    }

    List<String> deviceList =
        List<String>.from(_deviceConfigList[index]['deviceList']);
    int deviceIndex = _deviceConfigList[index]['deviceIndex'] as int;
    bool enable = _deviceConfigList[index]['enable'] as bool;
    String? selectItem = deviceList[deviceIndex];
    String? vid = _deviceConfigList[index]['vid'] as String;
    String? pid = _deviceConfigList[index]['pid'] as String;
    double time = _deviceConfigList[index]['start_wait_time_s'];
    String? info = _deviceConfigList[index]['info'] as String;

    return Container(
      key: ObjectKey(index),
      padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(
            color: widget.allowEdit
                ? ColorPalette.materialGreen
                : ColorPalette.darkGrey,
            width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          deviceTypeIcon(_deviceConfigList[index]['deviceType']),
          const SizedBox(width: 10),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _deviceConfigList[index]['deviceName'],
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "vid:",
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 5),
                  SizedBox(
                    height: 40,
                    width: 50,
                    child: TextField(
                      readOnly: !widget.allowEdit,
                      controller: TextEditingController(text: vid),
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        _deviceConfigList[index]['vid'] = value;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "pid:",
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 5),
                  SizedBox(
                    height: 40,
                    width: 50,
                    child: TextField(
                      readOnly: !widget.allowEdit,
                      controller: TextEditingController(text: pid),
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        _deviceConfigList[index]['pid'] = value;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "time_s:",
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 5),
                  SizedBox(
                    height: 40,
                    width: 50,
                    child: TextField(
                      readOnly: !widget.allowEdit,
                      controller: TextEditingController(text: time.toString()),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _deviceConfigList[index]['start_wait_time_s'] =
                            double.parse(value);
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    "Select Device:",
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 10),
                  widget.allowEdit
                      ? SizedBox(
                          child: DropdownButton<String>(
                            value: selectItem,
                            iconEnabledColor: ColorPalette.materialGreen,
                            onChanged: (value) {
                              int deviceIndex = deviceList.indexOf(value!);
                              _deviceConfigList[index]['deviceIndex'] =
                                  deviceIndex;
                              selectItem = value;
                              setState(() {});
                            },
                            items: deviceList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: SizedBox(
                                  width: width * 0.4,
                                  child: Text(value,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 11)),
                                ),
                              );
                            }).toList(),
                          ),
                        )
                      : IgnorePointer(
                          ignoring: true,
                          child: DropdownButton<String>(
                            iconEnabledColor: ColorPalette.darkGrey,
                            value: selectItem,
                            onChanged: (value) {
                              int deviceIndex = deviceList.indexOf(value!);
                              _deviceConfigList[index]['deviceIndex'] =
                                  deviceIndex;
                              selectItem = value;
                              setState(() {});
                            },
                            items: deviceList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 11)),
                              );
                            }).toList(),
                          )),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "info:",
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 5),
                  Text(info),
                  // SizedBox(
                  //   height: 20,
                  //   width: width * 0.5,
                  //   child: TextField(
                  //     readOnly: !widget.allowEdit,
                  //     controller: TextEditingController(text: info),
                  //     keyboardType: TextInputType.text,
                  //     onChanged: (value) {
                  //       _deviceConfigList[index]['info'] = value;
                  //     },
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
          const Spacer(),
          selectDeviceEnable(index, enable),
        ],
      ),
    );
  }

  // 设置设备能否使用
  // Set whether the device can be used
  Widget selectDeviceEnable(int index, bool enable) {
    // 在编辑状态
    // In editing status
    if (widget.allowEdit) {
      return Switch(
          value: enable,
          activeColor: ColorPalette.materialGreen,
          inactiveThumbColor: Colors.red,
          onChanged: (value) {
            enable = value;
            _deviceConfigList[index]['enable'] = value;
            setState(() {});
          });
    } else {
      // 不在编辑状态，不能点击, 颜色会变灰
      // Not in editing status, cannot be clicked, color will turn gray
      return IgnorePointer(
        ignoring: true,
        child: Switch(
            value: enable,
            activeColor: ColorPalette.materialGreen,
            activeTrackColor: Colors.grey,
            inactiveThumbColor: Colors.red,
            inactiveTrackColor: Colors.grey,
            onChanged: (value) {}),
      );
    }
  }

  Widget deviceTypeIcon(String typeText) {
    String iconPath = "";
    switch (typeText) {
      case 'BC_DEVICE':
        iconPath = 'assets/images/bodycomposition_logo.png';
        break;
      case 'BO_DEVICE':
        iconPath = 'assets/images/spo2_icon.png';
        break;
      case 'BP_DEVICE':
        iconPath = 'assets/images/bloodpressure_logo.png';
        break;
      case 'TEMP_DEVICE':
        iconPath = 'assets/images/temperature_icon.png';
        break;
      case 'HEIGHT_DEVICE':
        iconPath = 'assets/images/heightweight_logo.png';
        break;
      case 'WEIGHT_DEVICE':
        iconPath = 'assets/images/heightweight_logo.png';
        break;
      case 'BF_DEVICE':
        iconPath = 'assets/images/blood_fit.png';
        break;
      case 'ECG_DEVICE':
        iconPath = 'assets/images/ecg.png';
        break;
      case 'SCANNER_DEVICE':
        iconPath = 'assets/images/scanner.png';
        break;
      case 'PRINTER_DEVICE':
        iconPath = 'assets/images/printer.png';
        break;
      case 'IO_DEVICE':
        iconPath = 'assets/images/io.png';
        break;
      case 'BG_DEVICE':
        iconPath = 'assets/images/blood_glucose.png';
        break;
    }

    if (iconPath.isEmpty) {
      return const Icon(Icons.error, size: 40);
    } else {
      return Image.asset(
        iconPath,
        width: 40,
        height: 40,
      );
    }
  }

  Widget buildSaveBtn() {
    return Container(
      height: height * 0.08,
      padding: EdgeInsets.only(
          top: height * 0.01, bottom: height * 0.01, right: width * 0.05),
      child: Row(
        children: [
          const Spacer(),
          InkWell(
            onTap: () async {
              String error = await saveFile();
              if (error.isNotEmpty) {
                Fluttertoast.showToast(msg: error);
              } else {
                Fluttertoast.showToast(
                    msg: "save success, please reboot machine");
              }
            },
            child: Container(
                height: height * 0.03,
                width: width * 0.15,
                decoration: BoxDecoration(
                  color: ColorPalette.materialGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "Save",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: height * 0.015,
                        fontWeight: FontWeight.w600),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Future<bool> loadFile() async {
    var file = File(configFile);
    try {
      String json = await file.readAsString();
      _deviceConfigList = jsonDecode(json);
    } catch (e) {
      LogPrinter.log('Error: $e');
      Fluttertoast.showToast(msg: "Error: $e");
      return false;
    }
    return true;
  }

  // 写文件
  Future<String> saveFile() async {
    String text = jsonEncode(_deviceConfigList);
    var file = File(configFile);
    try {
      await file.writeAsString(text);
    } catch (e) {
      LogPrinter.log('Error: $e');
      return "Error: $e";
    }

    return "";
  }

  _onReorder(int oldIndex, int newIndex) {
    if (!widget.allowEdit) {
      return;
    }
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    var item = _deviceConfigList.removeAt(oldIndex);
    _deviceConfigList.insert(newIndex, item);
    setState(() {});
  }
}
