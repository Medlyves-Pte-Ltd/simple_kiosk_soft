import 'package:flutter_devices_sdk/device_sdk_param_setting.dart';
import 'package:simple_kiosk_software/common/footer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:simple_kiosk_software/utils/kiosk_config.dart';
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
  var kioskidControl = TextEditingController(text: KioskConfig().kioskId);

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
        title: Text('Kiosk Manager'),
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

  Widget healthScreeningModeWidget() {
    List<dynamic> healthScreeningModeList =
        KioskConfig().configMap["health_screening_mode_list"];

    return Row(
      children: [
        Text(
          "Health Screening Mode",
          style: TextStyle(fontSize: height * 0.012),
        ),
        const Spacer(),
        allowEdit
            ? DropdownButton<String>(
                value: KioskConfig().healthScreeningMode.name,
                iconEnabledColor: ColorPalette.materialGreen,
                onChanged: (value) {
                  KioskConfig().healthScreeningMode =
                      HealthScreeningMode.values.byName(value!);
                  setState(() {});
                },
                items: healthScreeningModeList
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
                  value: KioskConfig().healthScreeningMode.name,
                  onChanged: (value) {
                    KioskConfig().healthScreeningMode =
                        HealthScreeningMode.values.byName(value!);
                    setState(() {});
                  },
                  items: healthScreeningModeList
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

  Widget teleConsultationModeWidget() {
    List<dynamic> teleConsultationModeList =
        KioskConfig().configMap["tele_consultation_mode_list"];

    return Row(
      children: [
        Text(
          "Tele Consultation Mode",
          style: TextStyle(fontSize: height * 0.012),
        ),
        const Spacer(),
        allowEdit
            ? DropdownButton<String>(
                value: KioskConfig().teleConsultationMode.name,
                iconEnabledColor: ColorPalette.materialGreen,
                onChanged: (value) {
                  KioskConfig().teleConsultationMode =
                      TeleConsultationMode.values.byName(value!);
                  setState(() {});
                },
                items: teleConsultationModeList
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
                  value: KioskConfig().teleConsultationMode.name,
                  onChanged: (value) {
                    KioskConfig().teleConsultationMode =
                        TeleConsultationMode.values.byName(value!);
                    setState(() {});
                  },
                  items: teleConsultationModeList
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

  Widget kioskTypeWidget() {
    List<dynamic> kioskTypeList = KioskConfig().configMap["kiosk_type_list"];

    return Row(
      children: [
        Text(
          "Kiosk Type",
          style: TextStyle(fontSize: height * 0.012),
        ),
        const Spacer(),
        allowEdit
            ? DropdownButton<String>(
                value: KioskConfig().kioskType,
                iconEnabledColor: ColorPalette.materialGreen,
                onChanged: (value) {
                  KioskConfig().kioskType = value!;
                  setState(() {});
                },
                items: kioskTypeList.map<DropdownMenuItem<String>>((var value) {
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
                  value: KioskConfig().kioskType,
                  onChanged: (value) {
                    KioskConfig().kioskType = value!;
                    setState(() {});
                  },
                  items:
                      kioskTypeList.map<DropdownMenuItem<String>>((var value) {
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

  Widget envWidget() {
    List<dynamic> envList = KioskConfig().configMap["env_list"];
    return Row(
      children: [
        Text(
          "Environment",
          style: TextStyle(fontSize: height * 0.012),
        ),
        const Spacer(),
        allowEdit
            ? DropdownButton<String>(
                value: KioskConfig().envType,
                iconEnabledColor: ColorPalette.materialGreen,
                onChanged: (value) {
                  KioskConfig().envType = value!;
                  setState(() {});
                },
                items: envList.map<DropdownMenuItem<String>>((var value) {
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
                  value: KioskConfig().envType,
                  onChanged: (value) {
                    KioskConfig().envType = value!;
                    setState(() {});
                  },
                  items: envList.map<DropdownMenuItem<String>>((var value) {
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
        onSubmitted: (text) {
          KioskConfig().kioskId = text;
          setState(() {});
        },
      ),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 18), child: envWidget()),
      // Padding(
      //     padding: EdgeInsets.symmetric(horizontal: 18),
      //     child: healthScreeningModeWidget()),
      // Padding(
      //     padding: EdgeInsets.symmetric(horizontal: 18),
      //     child: teleConsultationModeWidget()),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: kioskTypeWidget()),
      const SizedBox(
        height: 16,
      )
    ]);
  }
}
