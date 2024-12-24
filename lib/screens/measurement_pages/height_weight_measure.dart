import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_devices_sdk/device_data/height_data.dart';
import 'package:flutter_devices_sdk/device_data/weight_data.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:flutter_devices_sdk/log/log_printer.dart';
import 'package:simple_kiosk_software/common/range_widget.dart';
import 'package:simple_kiosk_software/remote/blocs/appointment/appointment_bloc.dart';
import 'package:simple_kiosk_software/common/video_widget.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:simple_kiosk_software/blocs/device/device_bloc.dart';
import 'package:simple_kiosk_software/blocs/device/device_event.dart';
import 'package:simple_kiosk_software/blocs/device/device_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_kiosk_software/screens/measurement_pages/base_measure_layout_widget.dart';
import 'package:simple_kiosk_software/utils/app_config.dart';
import 'package:simple_kiosk_software/utils/body_range.dart';
import 'package:simple_kiosk_software/utils/control_measure_page_utils.dart';
import 'package:simple_kiosk_software/utils/kiosk_config.dart';
import 'package:simple_kiosk_software/utils/user_info.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HeightWeightMeasure extends BaseMeasureLayoutWidget {
  late String bodyHeight;
  late String bodyWeight;
  late String bodyBmi;
  bool heightMeasured = false;
  bool weightMeasured = false;
  HeightWeightMeasure() {
    bodyHeight =
        UserInfo().height.isNotEmpty ? UserInfo().height : dataDefaultValue;
    bodyWeight =
        UserInfo().weight.isNotEmpty ? UserInfo().weight : dataDefaultValue;
    bodyBmi = UserInfo().bmi.isNotEmpty ? UserInfo().bmi : dataDefaultValue;
  }

  @override
  Widget startButton() {
    double btnFontSize = height * 0.025;
    String btnText = AppLocalizations.of(mainContext)!.start;
    return BlocBuilder<DeviceBloc, DeviceState>(buildWhen: (previous, state) {
      bool update = false;

      if (state is DeviceConnected &&
          state.deviceType == DeviceType.HEIGHT_DEVICE) {
        btnText = AppLocalizations.of(mainContext)!.stop;
        startButtonColor = Colors.red;
        update = true;
        timerStop = Timer(Duration(seconds: 45), () {
          if (startStatus) {
            onStop();
            timerStop?.cancel();
          }
        });
      } else if (state is DeviceDisconnected) {
        if (state.deviceType == DeviceType.WEIGHT_DEVICE) {
          btnText = AppLocalizations.of(mainContext)!.start;
          startButtonColor = ColorPalette.materialGreen;
          update = true;
          timerStop?.cancel();
        }
      }

      return update;
    }, builder: (context, state) {
      return InkWell(
        onTap: () async {
          if (btnText == AppLocalizations.of(mainContext)!.stop) {
            await onStop();
          } else {
            await onStart();
          }
        },
        child: Container(
          height: height * 0.04,
          width: width * 0.2,
          decoration: BoxDecoration(
            color: startButtonColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(btnText,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: btnFontSize,
                    color: Colors.white)),
          ),
        ),
      );
    });
  }

  @override
  Widget buildVideoArea() {
    String file = ControlMeasurePageUtils().measured == false
        ? startVideoFile
        : endVideoFile;

    return BlocBuilder<DeviceBloc, DeviceState>(
      buildWhen: (previous, current) {
        if (current is DeviceDataUpdated &&
            current.deviceType == DeviceType.WEIGHT_DEVICE) {
          file = endVideoFile;
        } else if (current is DeviceConnected &&
            current.deviceType == DeviceType.HEIGHT_DEVICE) {
          file = startVideoFile;
        }
        return file != curPlayFile;
      },
      builder: (context, state) {
        curPlayFile = file;
        return VideoWidget(
            key: GlobalKey(),
            videoName: file,
            setLooping: false,
            fromFile: true);
      },
    );
  }

  @override
  void init() {
    super.title = AppLocalizations.of(mainContext)!.hw;
    if (super.startVideoFile.isEmpty) {
      super.startVideoFile = getVideoFileName(DeviceType.HEIGHT_DEVICE, false);
    }
    if (super.endVideoFile.isEmpty) {
      super.endVideoFile = getVideoFileName(DeviceType.HEIGHT_DEVICE, true);
    }
  }

  @override
  Future<void> onStart() async {
    startStatus = true;
    DeviceConnectEvent connectEvent =
        DeviceConnectEvent(deviceType: DeviceType.HEIGHT_DEVICE);
    BlocProvider.of<DeviceBloc>(mainContext).add(connectEvent);
  }

  @override
  Future<void> onStop() async {
    startStatus = false;
    heightMeasured = weightMeasured = false;
    DeviceStopEvent stopEvent =
        DeviceStopEvent(deviceType: DeviceType.HEIGHT_DEVICE);
    BlocProvider.of<DeviceBloc>(mainContext).add(stopEvent);

    stopEvent = DeviceStopEvent(deviceType: DeviceType.WEIGHT_DEVICE);
    BlocProvider.of<DeviceBloc>(mainContext).add(stopEvent);
  }

  @override
  Widget buildCardDataShowArea() {
    double titleFontSize = height * 0.02;
    double dataFontSize = height * 0.02;

    return BlocBuilder<DeviceBloc, DeviceState>(buildWhen: (previous, state) {
      bool update = false;

      if (state is DeviceConnected &&
          state.deviceType == DeviceType.HEIGHT_DEVICE) {
        bodyHeight = bodyWeight = bodyBmi = dataDefaultValue;
        UserInfo().height = "";
        UserInfo().weight = "";
        ControlMeasurePageUtils().measured = false;
        heightMeasured = weightMeasured = false;
        update = true;
      } else if (state is DeviceDataLoading &&
          state.deviceType == DeviceType.HEIGHT_DEVICE) {
        bodyHeight =
            bodyWeight = bodyBmi = AppLocalizations.of(mainContext)!.loading;
        update = true;
      } else if (state is DeviceDataUpdated) {
        if (state.deviceData is HeightData) {
          String heightStr = (state.deviceData as HeightData).height;
          UserInfo().height = "${double.parse(heightStr).toStringAsFixed(1)}";

          // 显示身高数据
          bodyHeight = UserInfo().height;
          update = true;

          // 计算标准体重
          BodyRange().calculateStandWeight();
          heightMeasured = true;
          // 如果收到身高数据，先关闭身高设备，再打开体重设备
          Future.delayed(const Duration(milliseconds: 500), () {
            DeviceConnectEvent connectEvent =
                DeviceConnectEvent(deviceType: DeviceType.WEIGHT_DEVICE);
            BlocProvider.of<DeviceBloc>(mainContext).add(connectEvent);
          });
        } else if (state.deviceData is WeightData) {
          String weightStr = (state.deviceData as WeightData).weight;
          // double h = 0.0;
          // try {
          //   h = double.parse(bodyHeight);
          // } catch (e) {
          //   h = 0.0;
          //   LogPrinter.log("Error: $e");
          //   bodyHeight = bodyWeight = bodyBmi = dataDefaultValue;
          // }
          //
          // double w = 0;
          // try {
          //   w = double.parse(weightStr);
          // } catch (e) {
          //   w = 0.0;
          //   LogPrinter.log("Error: $e");
          //   bodyHeight = bodyWeight = bodyBmi = dataDefaultValue;
          // }
          //
          // if (h < 80.0 || w < 20.0) {
          //   heightMeasured = false;
          //   if (bodyWeight != weightStr) {
          //     messageBox(mainContext, super.title,
          //         AppLocalizations.of(mainContext)!.please_click_start_again);
          //   }
          //
          //   bodyHeight = bodyWeight = bodyBmi = dataDefaultValue;
          // } else {
          bodyHeight = UserInfo().height;
          bodyWeight = UserInfo().weight = weightStr;

          try {
            double height_m = double.parse(bodyHeight) / 100.0;
            bodyBmi = UserInfo().bmi =
                (double.parse(bodyWeight) / (height_m * height_m))
                    .toStringAsFixed(1);
          } catch (e) {
            bodyBmi = "0.0";
            Fluttertoast.showToast(msg: "$e");
            LogPrinter.log("$e");
          }

          if (KioskConfig().healthScreeningMode == HealthScreeningMode.online) {
            BlocProvider.of<AppointmentBloc>(mainContext).processNewData({
              "height": UserInfo().height,
              "weight": UserInfo().weight,
              "bmi": UserInfo().bmi
            });
          }
          ControlMeasurePageUtils().measured = true;
          //}

          weightMeasured = true;
          update = true;
        }
      } else if (state is DeviceDisconnected) {
        if (weightMeasured) {
          startStatus = false;
        }

        if (!heightMeasured && !weightMeasured) {
          bodyHeight = bodyWeight = bodyBmi = dataDefaultValue;
          update = true;
        }
      }

      return update;
    }, builder: (context, state) {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.hw_height,
                  style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: height * 0.02),
                Text(
                  bodyHeight,
                  style: TextStyle(
                      fontSize: dataFontSize,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.materialGreen),
                ),
                Offstage(
                  offstage: !heightMeasured,
                  child: Text(""),
                )
              ],
            ),
            SizedBox(width: width * 0.1),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.hw_weight,
                  style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: height * 0.02),
                measureValueChangeColor(
                    bodyWeight,
                    BodyRange().weightMin.toStringAsFixed(1),
                    BodyRange().weightMax.toStringAsFixed(1),
                    dataFontSize,
                    true),
                rangeMeasureWidget(
                    BodyRange().weightMin.toStringAsFixed(1),
                    BodyRange().weightMax.toStringAsFixed(1),
                    dataFontSize,
                    true)
              ],
            ),
            SizedBox(width: width * 0.1),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.hw_bmi,
                  style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: height * 0.02),
                measureValueChangeColor(
                    bodyBmi,
                    BodyRange().bmiMin.toStringAsFixed(1),
                    BodyRange().bmiMax.toStringAsFixed(1),
                    dataFontSize,
                    true),
                rangeMeasureWidget(BodyRange().bmiMin.toStringAsFixed(1),
                    BodyRange().bmiMax.toStringAsFixed(1), dataFontSize, true)
              ],
            ),
          ],
        ),
      );
    });
  }
}
