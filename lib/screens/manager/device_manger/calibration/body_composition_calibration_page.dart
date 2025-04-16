import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_devices_sdk/device_data/body_composition_data.dart';
import 'package:flutter_devices_sdk/device_manager.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:simple_kiosk_software/blocs/device/device_bloc.dart';
import 'package:simple_kiosk_software/blocs/device/device_event.dart';
import 'package:simple_kiosk_software/blocs/device/device_state.dart';
import 'package:simple_kiosk_software/common/footer.dart';
import 'package:flutter/material.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:simple_kiosk_software/utils/permission_config.dart';

class BodyCompositionCalibrationPage extends StatefulWidget {
  @override
  _BodyCompositionCalibrationPageState createState() =>
      _BodyCompositionCalibrationPageState();
}

class _BodyCompositionCalibrationPageState
    extends State<BodyCompositionCalibrationPage> {
  final _scrollController = ScrollController();
  bool allowEdit = true;
  double height = 0;
  double width = 0;
  String bodyImpedance = "- - -";
  late BuildContext mainContext;
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
        title: Text('Body Composition Calibration'),
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
      Container(
        padding: EdgeInsets.symmetric(horizontal: width * 0.01),
        child: Row(
          children: [
            Text(
              "Impedance",
              style: TextStyle(fontSize: height * 0.009),
            ),
            Spacer(),
            buildShowImpedanc(),
            SizedBox(
              width: width * 0.03,
            ),
            readImpedanceButton()
          ],
        ),
      )
    ]);
  }

  // 是否测过
  bool measured = false;

  Widget buildShowImpedanc() {
    return BlocBuilder<DeviceBloc, DeviceState>(buildWhen: (previous, state) {
      bool update = false;
      if (state is DeviceConnected) {
        measured = false;
        bodyImpedance = "- - -";
        update = true;
      } else if (state is DeviceDataLoading) {
        bodyImpedance = "Reading...";
        update = true;
      } else if (state is DeviceDataUpdated &&
          state.deviceData is BodyCompositionData) {
        bodyImpedance =
            (state.deviceData as BodyCompositionData).impedance! + " Ω";
        measured = true;
        update = true;
      } else if (state is DeviceDisconnected) {
        if (!measured) {
          bodyImpedance = "- - -";
          update = true;
        }
      }

      return update;
    }, builder: (context, state) {
      return Text(
        bodyImpedance,
        style: TextStyle(
            fontSize: height * 0.014, color: ColorPalette.materialGreen),
      );
    });
  }

  Widget readImpedanceButton() {
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
                      DeviceStopEvent(deviceType: DeviceType.BC_DEVICE);
                  BlocProvider.of<DeviceBloc>(mainContext).add(stopEvent);
                } else {
                  // 是否只测阻抗
                  DeviceManager().getDevice(DeviceType.BC_DEVICE)?.mapData = {
                    'only_test_impedance': true
                  };

                  DeviceConnectEvent connectEvent =
                      DeviceConnectEvent(deviceType: DeviceType.BC_DEVICE);
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
