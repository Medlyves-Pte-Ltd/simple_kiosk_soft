import 'package:flutter_devices_sdk/run_param_setting.dart';
import 'package:simple_kiosk_software/common/footer.dart';
import 'package:simple_kiosk_software/utils/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:flutter_devices_sdk/view/device_config_login_page.dart';

class KioskManager extends StatefulWidget {
  @override
  _KioskManagerState createState() => _KioskManagerState();
}

class _KioskManagerState extends State<KioskManager> {
  bool _allowEdit = true;
  bool _isLogin = false;
  double height = 0;
  double width = 0;

  @override
  void initState() {
    super.initState();
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
        children: [Expanded(child: settingArea()), Footer()],
      ),
    );
  }

  Widget settingArea() {
    return SingleChildScrollView(
      child: Column(children: [
        TDInput(
          inputType: TextInputType.text,
          needClear: false,
          leftLabel: 'Kiosk ID',
          controller: TextEditingController(text: AppConfig().kioskId),
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
          inputType: TextInputType.text,
          needClear: false,
          leftLabel: 'Device Model',
          controller: TextEditingController(text: AppConfig().deviceModel),
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
          inputType: TextInputType.text,
          needClear: false,
          leftLabel: 'Device Address',
          controller: TextEditingController(text: AppConfig().deviceAddress),
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
          inputType: TextInputType.text,
          needClear: false,
          leftLabel: 'Client Name',
          controller: TextEditingController(text: AppConfig().clientName),
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
        SwitchListTile(
          title: Text('Enable TC'),
          value: AppConfig().enableTC,
          onChanged: (bool value) {
            AppConfig().enableTC = value;
            setState(() {});
          },
        ),
        TDInput(
          inputType: TextInputType.number,
          type: TDInputType.special,
          controller: TextEditingController(
              text: AppConfig().totalHeight.toStringAsFixed(2)),
          leftLabel: 'Total Height',
          hintText: '0.00',
          backgroundColor: Colors.white,
          textAlign: TextAlign.end,
          rightWidget: TDText('m', textColor: TDTheme.of(context).fontGyColor1),
          onChanged: (text) {
            setState(() {});
            if (text.isEmpty) {
              return;
            }
            RunParamSetting().totalHeight = double.parse(text);
            AppConfig().totalHeight = double.parse(text);
          },
        ),
        const SizedBox(
          height: 16,
        )
      ]),
    );
  }
}
