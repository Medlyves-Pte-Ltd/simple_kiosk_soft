import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_devices_sdk/device_data/height_data.dart';
import 'package:flutter_devices_sdk/device_manager.dart';
import 'package:flutter_devices_sdk/device_sdk_param_setting.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:simple_kiosk_software/blocs/device/device_bloc.dart';
import 'package:simple_kiosk_software/blocs/device/device_event.dart';
import 'package:simple_kiosk_software/blocs/device/device_state.dart';
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
  String bodyHeight = "- - -";
  late BuildContext mainContext;
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
    mainContext = context;

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
      Container(
        padding: EdgeInsets.symmetric(horizontal: width * 0.01),
        child: Row(
          children: [
            Text(
              "Calibration Bar To Top Distance",
              style: TextStyle(fontSize: height * 0.009),
            ),
            Spacer(),
            buildShowCalibrationBarToTopDistance(),
            SizedBox(
              width: width * 0.03,
            ),
            readDistanceButton()
          ],
        ),
      )
    ]);
  }

  // 是否测过
  bool measured = false;
  // 显示标定杠到顶部的距离
  Widget buildShowCalibrationBarToTopDistance() {
    return BlocBuilder<DeviceBloc, DeviceState>(buildWhen: (previous, state) {
      bool update = false;
      if (state is DeviceConnected) {
        measured = false;
        bodyHeight = "- - -";
        update = true;
      } else if (state is DeviceDataLoading) {
        bodyHeight = "Reading...";
        update = true;
      } else if (state is DeviceDataUpdated && state.deviceData is HeightData) {
        bodyHeight = (state.deviceData as HeightData).height + " cm";
        measured = true;
        update = true;
      } else if (state is DeviceDisconnected) {
        if (!measured) {
          bodyHeight = "- - -";
          update = true;
        }
      }

      return update;
    }, builder: (context, state) {
      return Text(
        bodyHeight,
        style: TextStyle(
            fontSize: height * 0.014, color: ColorPalette.materialGreen),
      );
    });
  }

  Widget readDistanceButton() {
    double btnFontSize = height * 0.014;
    String btnText = "start";
    return BlocBuilder<DeviceBloc, DeviceState>(buildWhen: (previous, state) {
      bool update = false;

      if (state is DeviceConnected) {
        btnText = "stop";
        update = true;
      } else if (state is DeviceDisconnected) {
        btnText = "start";
        update = true;
      }

      return update;
    }, builder: (_, state) {
      return PermissionConfig()
              .havePermission(PermissionModules.DeviceCalibration)
          ? InkWell(
              onTap: () async {
                if (btnText == "stop") {
                  DeviceStopEvent stopEvent =
                      DeviceStopEvent(deviceType: DeviceType.HEIGHT_DEVICE);
                  BlocProvider.of<DeviceBloc>(mainContext).add(stopEvent);
                } else {
                  // 是否使用原始数据
                  DeviceManager().getDevice(DeviceType.HEIGHT_DEVICE)?.mapData =
                      {'use_original_data': true};

                  DeviceConnectEvent connectEvent =
                      DeviceConnectEvent(deviceType: DeviceType.HEIGHT_DEVICE);
                  BlocProvider.of<DeviceBloc>(mainContext).add(connectEvent);
                }
              },
              child: Container(
                height: height * 0.022,
                width: width * 0.1,
                decoration: BoxDecoration(
                  color: ColorPalette.materialGreen,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(btnText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: btnFontSize, color: Colors.white)),
                ),
              ),
            )
          : Container(
              height: height * 0.022,
              width: width * 0.1,
              decoration: BoxDecoration(
                color: ColorPalette.darkGrey,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text(btnText,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: btnFontSize, color: Colors.white)),
              ),
            );
    });
  }
}
