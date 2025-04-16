import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_devices_sdk/device_data/ecg_data.dart';
import 'package:flutter_devices_sdk/device_manager.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:flutter_devices_sdk/devices/device_base_model.dart';
import 'package:flutter_devices_sdk/log/log_printer.dart';
import 'package:simple_kiosk_software/remote/blocs/appointment/appointment_bloc.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:simple_kiosk_software/screens/measurement_pages/base_measure_layout_widget.dart';
import 'package:simple_kiosk_software/blocs/device/device_bloc.dart';
import 'package:simple_kiosk_software/blocs/device/device_event.dart';
import 'package:simple_kiosk_software/blocs/device/device_state.dart';
import 'package:simple_kiosk_software/utils/control_measure_page_utils.dart';
import 'package:simple_kiosk_software/utils/kiosk_config.dart';
import 'package:simple_kiosk_software/utils/user_info.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ECGMeasure extends BaseMeasureLayoutWidget {
  String HR = "";
  String PR = "";
  String QT = "";
  String QTc = "";
  String P_Width = "";
  String QRS_Dur = "";
  String P_Axis = "";
  String QRS_Axis = "";
  String T_Axis = "";

  ECGMeasure() {
    HR = UserInfo().HR.isNotEmpty ? UserInfo().HR : dataDefaultValue;
    PR = UserInfo().PR.isNotEmpty ? UserInfo().PR : dataDefaultValue;
    QT = UserInfo().QT.isNotEmpty ? UserInfo().QT : dataDefaultValue;

    QTc = UserInfo().QTc.isNotEmpty ? UserInfo().QTc : dataDefaultValue;
    P_Width =
        UserInfo().P_Width.isNotEmpty ? UserInfo().P_Width : dataDefaultValue;
    QRS_Dur =
        UserInfo().QRS_Dur.isNotEmpty ? UserInfo().QRS_Dur : dataDefaultValue;

    P_Axis =
        UserInfo().P_Axis.isNotEmpty ? UserInfo().P_Axis : dataDefaultValue;
    QRS_Axis =
        UserInfo().QRS_Axis.isNotEmpty ? UserInfo().QRS_Axis : dataDefaultValue;
    T_Axis =
        UserInfo().T_Axis.isNotEmpty ? UserInfo().T_Axis : dataDefaultValue;
  }

  @override
  void init() {
    super.title = AppLocalizations.of(mainContext)!.ecg;
    if (super.startVideoFile.isEmpty) {
      super.startVideoFile = getVideoFileName(DeviceType.ECG_DEVICE, false);
    }
    if (super.endVideoFile.isEmpty) {
      super.endVideoFile = getVideoFileName(DeviceType.ECG_DEVICE, true);
    }
  }

  @override
  Future<void> onStart() async {
    // ecg配置里面禁用，只是不检查它的连接情况，设备依然能够使用
    DeviceManager().bindToDevice(DeviceType.ECG_DEVICE, 0);

    DeviceBaseModel? ecg = DeviceManager().getDevice(DeviceType.ECG_DEVICE);
    ecg?.mapData = {
      'name': UserInfo().name,
      'age': UserInfo().age,
      'gender': UserInfo().gender == 1
          ? AppLocalizations.of(mainContext)!.male
          : AppLocalizations.of(mainContext)!.female
    };

    DeviceStartEvent startEvent =
        DeviceStartEvent(deviceType: DeviceType.ECG_DEVICE);
    BlocProvider.of<DeviceBloc>(mainContext).add(startEvent);
  }

  @override
  Future<void> onStop() async {}

  Widget buildItem(String title, String? data) {
    double titleFontSize = height * 0.02;
    double dataFontSize = height * 0.02;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style:
              TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: height * 0.01),
        Text(
          data ?? "",
          style: TextStyle(
              fontSize: dataFontSize,
              fontWeight: FontWeight.bold,
              color: ColorPalette.materialGreen),
        )
      ],
    );
  }

  @override
  Widget buildCardDataShowArea() {
    return BlocBuilder<DeviceBloc, DeviceState>(buildWhen: (previous, state) {
      bool update = false;

      // if (state is DeviceDataLoading) {
      //   ecgData.HR = ecgData.P_Width = ecgData.PR = ecgData.QRS_Dur =
      //       ecgData.QT = ecgData.QTc = ecgData.QRS_Axis = ecgData.P_Axis =
      //           ecgData.T_Axis =
      //               ecgData.RR = AppLocalizations.of(mainContext)!.loading;
      //   update = true;
      // } else
      if (state is DeviceDataUpdated && state.deviceData is ECGData) {
        ECGData ecgData = state.deviceData as ECGData;

        HR = UserInfo().HR = ecgData.HR ?? "";
        P_Width = UserInfo().P_Width = ecgData.P_Width ?? "";
        PR = UserInfo().PR = ecgData.PR ?? "";
        QRS_Dur = UserInfo().QRS_Dur = ecgData.QRS_Dur ?? "";
        QT = UserInfo().QT = ecgData.QT ?? "";
        QTc = UserInfo().QTc = ecgData.QTc ?? "";
        QRS_Axis = UserInfo().QRS_Axis = ecgData.QRS_Axis ?? "";
        P_Axis = UserInfo().P_Axis = ecgData.P_Axis ?? "";
        T_Axis = UserInfo().T_Axis = ecgData.T_Axis ?? "";
        UserInfo().RR = ecgData.RR ?? "";
        UserInfo().Conclusion =
            (ecgData.Conclusion ?? "").replaceAll("\n", " ");
        UserInfo().ResultImage = ecgData.ResultImage ?? "";

        if (KioskConfig().healthScreeningMode == HealthScreeningMode.online) {
          // 上传图片
          if (UserInfo().ResultImage.isNotEmpty) {
            File img = File(UserInfo().ResultImage);
            LogPrinter.log("Uploading conclusion and image.");
            BlocProvider.of<AppointmentBloc>(mainContext)
                .uploadEcgDocument(img, UserInfo().Conclusion);
            LogPrinter.log("Image uploaded.");
            LogPrinter.log(UserInfo().Conclusion);
          }

          // 上传数据
          BlocProvider.of<AppointmentBloc>(mainContext)
              .processNewData(state.deviceData.data);
        }

        ControlMeasurePageUtils().measured = true;
        update = true;
      }

      return update;
    }, builder: (context, state) {
      return GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          // 一行几列
          crossAxisCount: 3,
          // 设置每子元素的大小（宽高比）
          childAspectRatio: 1.8,
          // 元素的左右的 距离
          crossAxisSpacing: width * 0.02,
          // 子元素上下的 距离
          mainAxisSpacing: height * 0.01,
        ),
        children: [
          buildItem(AppLocalizations.of(context)!.ecg_hr, HR),
          buildItem(AppLocalizations.of(context)!.ecg_pr, PR),
          buildItem(AppLocalizations.of(context)!.ecg_qt, QT),
          buildItem(AppLocalizations.of(context)!.ecg_qtc, QTc),
          buildItem(AppLocalizations.of(context)!.ecg_p_width, P_Width),
          buildItem(AppLocalizations.of(context)!.ecg_qrs_dur, QRS_Dur),
          buildItem(AppLocalizations.of(context)!.ecg_p_axis, P_Axis),
          buildItem(AppLocalizations.of(context)!.ecg_qrs_axis, QRS_Axis),
          buildItem(AppLocalizations.of(context)!.ecg_t_axis, T_Axis),
        ],
      );
    });
  }
}
