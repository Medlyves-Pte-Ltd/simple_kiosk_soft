import 'package:base_kiosk_software/common/footer.dart';
import 'package:base_kiosk_software/utils/storage_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:base_kiosk_software/constants/colors.dart';
import 'package:flutter_devices_sdk/view/device_config_login_page.dart';
import 'package:flutter_devices_sdk/view/device_config_page.dart';

class KioskManager extends StatefulWidget {
  @override
  _KioskManagerState createState() => _KioskManagerState();
}

class _KioskManagerState extends State<KioskManager> {
  bool _allowEdit = false;
  bool _isLogin = false;
  double screenHeight = 0;
  double screenWidth = 0;
  final _scrollController = ScrollController();
  DeviceManagerInfo _tempDeviceManagerInfo = DeviceManagerInfo();
  DeviceManagerInfo _deviceManagerInfo = DeviceManagerInfo();
  final DeviceConfigPage _deviceConfigPage = DeviceConfigPage(
      allowEdit: false,
      showLoginWindow: false,
      showBottomButton: false,
      showSwithDeviceEnable: true);

  @override
  void initState() {
    super.initState();

    StorageUtils.getData(_tempDeviceManagerInfo.toMap().keys.toSet())
        .then((data) {
      _tempDeviceManagerInfo.fromMap(data);
      _deviceManagerInfo.fromMap(data);
      setState(() {});
    }).catchError((error) {
      print("Error deviceManagerInfo: $error");
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("_KioskManagerState");
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    // 如果登录了，显示主窗口， 否则显示登录窗口
    // If logged in, display the main window; otherwise, display the login window
    if (!_isLogin) {
      return loginWindow(context);
    }

    return Scaffold(
      backgroundColor: ColorPalette.colorAppBackground,
      body: Column(
        children: [
          customAppBar(),
          saveCancelButton(),
          deviceInfoArea(),
          Expanded(child: _deviceConfigPage),
          const Footer()
        ],
      ),
    );
  }

  // 设置编辑状态
  // set edit status
  void setEditStatus(bool allow) {
    _allowEdit = !allow;
    setState(() {});
    _deviceConfigPage.view.setEditStatus(_allowEdit);
  }

  // 保存配置
  // save config
  void saveConfig() async {
    StorageUtils.saveData(_tempDeviceManagerInfo.toMap());
    _deviceConfigPage.view.saveConfig();
    _allowEdit = false;
    setState(() {});
  }

  // 取消保存
  // cancel save
  void cancelSave() {
    _allowEdit = false;
    _tempDeviceManagerInfo.fromMap(_deviceManagerInfo.toMap());
    _deviceConfigPage.view.cancelSave();
    setState(() {});
  }

  void onLogin() {
    _isLogin = true;
    setState(() {});
  }

  Widget loginWindow(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.colorAppBackground,
      body: DeviceConfigLoginPage(onLogin: onLogin),
    );
  }

  // 输入框控件
  // input edit
  Widget inputEdit({required String text, ValueChanged<String>? onChanged}) {
    return TextField(
        readOnly: !_allowEdit,
        textAlignVertical: TextAlignVertical.center,
        controller: TextEditingController(text: text),
        obscureText: false,
        maxLength: 20,
        keyboardType: TextInputType.text,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: "Sample Text",
          counterText: "",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: _allowEdit
                  ? ColorPalette.materialGreen
                  : ColorPalette.darkGrey,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: ColorPalette.darkGrey,
              width: 1.0,
            ),
          ),
        ));
  }

  // 设备信息区域
  // device info area
  Widget deviceInfoArea() {
    double fontSize = screenHeight * 0.017;
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(2),
          },
          children: [
            // kiosk id row
            TableRow(children: [
              Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  textAlign: TextAlign.right,
                  "Kiosk\nID",
                  style: TextStyle(
                      color: ColorPalette.blackColor,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize),
                ),
              ),
              inputEdit(
                  text: _tempDeviceManagerInfo.kioskId,
                  onChanged: (value) {
                    _tempDeviceManagerInfo.kioskId = value;
                  }),
            ]),

            // device model row
            TableRow(children: [
              Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  textAlign: TextAlign.right,
                  "Device\nModel",
                  style: TextStyle(
                      color: ColorPalette.blackColor,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize),
                ),
              ),
              inputEdit(
                  text: _tempDeviceManagerInfo.deviceModel,
                  onChanged: (value) {
                    _tempDeviceManagerInfo.deviceModel = value;
                  }),
            ]),

            // device address row
            TableRow(children: [
              Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  textAlign: TextAlign.right,
                  "Device\nAddress",
                  style: TextStyle(
                      color: ColorPalette.blackColor,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize),
                ),
              ),
              inputEdit(
                  text: _tempDeviceManagerInfo.deviceAddress,
                  onChanged: (value) {
                    _tempDeviceManagerInfo.deviceAddress = value;
                  }),
            ]),

            // client name row
            TableRow(children: [
              Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  textAlign: TextAlign.right,
                  "Client\nName",
                  style: TextStyle(
                      color: ColorPalette.blackColor,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize),
                ),
              ),
              inputEdit(
                  text: _tempDeviceManagerInfo.clientName,
                  onChanged: (value) {
                    _tempDeviceManagerInfo.clientName = value;
                  }),
            ]),
          ],
        ));
  }

  // 保存取消按钮
  // Save Cancel button
  Widget saveCancelButton() {
    double buttonWidth = screenWidth * 0.25;
    double buttonHeight = screenHeight * 0.04;
    double fontSize = buttonHeight * 0.55;

    return Padding(
        padding: const EdgeInsets.only(top: 10, right: 10),
        child: Visibility(
          visible: _allowEdit,
          maintainAnimation: true,
          maintainSize: true,
          maintainState: true,
          child: Row(
            children: [
              const Spacer(),

              // 保存按钮
              // save button
              GestureDetector(
                onTap: saveConfig,
                child: Container(
                  width: buttonWidth,
                  height: buttonHeight,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    color: ColorPalette.materialGreen,
                    border:
                        Border.all(color: ColorPalette.materialGreen, width: 2),
                  ),
                  child: Text(
                    textAlign: TextAlign.center,
                    "Save",
                    style: TextStyle(
                        color: ColorPalette.colorAppBackground,
                        fontWeight: FontWeight.w400,
                        fontSize: fontSize),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // 取消按钮
              // cancel button
              GestureDetector(
                onTap: cancelSave,
                child: Container(
                  width: buttonWidth,
                  height: buttonHeight,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    color: ColorPalette.colorAppBackground,
                    border: Border.all(
                        color: ColorPalette.headerFooterBackground, width: 2),
                  ),
                  child: Text(
                    textAlign: TextAlign.center,
                    "Cancel",
                    style: TextStyle(
                        color: ColorPalette.headerFooterBackground,
                        fontWeight: FontWeight.w400,
                        fontSize: fontSize),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  // 切换编辑状态按钮
  // switch edit status button
  Widget switchEditStatusButton(double fontSize, double width) {
    return GestureDetector(
      child: Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          border: Border.all(color: ColorPalette.colorAppBackground, width: 2),
          color:
              _allowEdit ? ColorPalette.colorAppBackground : Colors.transparent,
        ),
        margin: const EdgeInsets.only(top: 20, bottom: 20),
        padding: const EdgeInsets.all(10),
        child: Text(
          _allowEdit ? "Editing" : "Edit Details",
          maxLines: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: _allowEdit
                  ? ColorPalette.headerFooterBackground
                  : ColorPalette.colorAppBackground,
              fontSize: fontSize,
              fontWeight: FontWeight.w300),
        ),
      ),
      onTap: () {
        setEditStatus(_allowEdit);
      },
    );
  }

  // 定义标题栏
  // define title bar
  Widget customAppBar() {
    final headerHeight = screenHeight * 0.08;
    final boxWidth = screenWidth * 0.04;
    final textfontSize = headerHeight * 0.3;
    final bntFontSize = headerHeight * 0.25;
    final bntWidth = screenWidth * 0.3;

    return AppBar(
        backgroundColor: ColorPalette.headerFooterBackground,
        automaticallyImplyLeading: false,
        toolbarHeight: headerHeight,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            switchEditStatusButton(bntFontSize, bntWidth),
            SizedBox(
              width: boxWidth,
            ),
            Expanded(
              child: Text(
                "Kiosk Configuration Page",
                maxLines: 2,
                textAlign: TextAlign.end,
                style: TextStyle(
                    color: ColorPalette.colorAppBackground,
                    fontSize: textfontSize,
                    fontWeight: FontWeight.w600),
              ),
            )
          ],
        ));
  }
}

// 设备管理信息
// device manager info
class DeviceManagerInfo {
  String kioskId = '';
  String deviceModel = '';
  String deviceAddress = '';
  String clientName = '';

  Map<String, String> toMap() {
    return {
      "kioskId": kioskId,
      "deviceModel": deviceModel,
      "deviceAddress": deviceAddress,
      "clientName": clientName,
    };
  }

  void fromMap(Map<String, String> info) {
    kioskId = info['kioskId']!;
    deviceModel = info['deviceModel']!;
    deviceAddress = info['deviceAddress']!;
    clientName = info['clientName']!;
  }
}
