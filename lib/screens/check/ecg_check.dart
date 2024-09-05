import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_devices_sdk/device_data/ecg_data.dart';
import 'package:flutter_devices_sdk/device_manager.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:flutter_devices_sdk/devices/device_base_model.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:simple_kiosk_software/screens/check/base_check_widget.dart';
import 'package:simple_kiosk_software/blocs/device/device_bloc.dart';
import 'package:simple_kiosk_software/blocs/device/device_event.dart';
import 'package:simple_kiosk_software/blocs/device/device_state.dart';
import 'package:simple_kiosk_software/utils/user_info.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ECGCheck extends BaseCheckWidget {
  ECGData ecgData = ECGData();

  ECGCheck() {
    ecgData.HR = UserInfo().HR.isNotEmpty ? UserInfo().HR : dataDefaultValue;
    ecgData.PR = UserInfo().PR.isNotEmpty ? UserInfo().PR : dataDefaultValue;
    ecgData.QT = UserInfo().QT.isNotEmpty ? UserInfo().QT : dataDefaultValue;

    ecgData.QTc = UserInfo().QTc.isNotEmpty ? UserInfo().QTc : dataDefaultValue;
    ecgData.P_Width =
        UserInfo().P_Width.isNotEmpty ? UserInfo().P_Width : dataDefaultValue;
    ecgData.QRS_Dur =
        UserInfo().QRS_Dur.isNotEmpty ? UserInfo().QRS_Dur : dataDefaultValue;

    ecgData.P_Axis =
        UserInfo().P_Axis.isNotEmpty ? UserInfo().P_Axis : dataDefaultValue;
    ecgData.QRS_Axis =
        UserInfo().QRS_Axis.isNotEmpty ? UserInfo().QRS_Axis : dataDefaultValue;
    ecgData.T_Axis =
        UserInfo().T_Axis.isNotEmpty ? UserInfo().T_Axis : dataDefaultValue;
  }

  @override
  void init() {
    super.title = AppLocalizations.of(mainContext)!.ecg;
    iconFile = "assets/images/ecg.png";
    underlineColor = ColorPalette.colorEcg;
  }

  @override
  Future<void> onStart() async {
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
    double titleFontSize = height * 0.01;
    double dataFontSize = height * 0.01;
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
  bool needUpdate(DeviceType? type) {
    return type == DeviceType.ECG_DEVICE;
  }

  @override
  Widget buildCardDataShowArea() {
    return BlocBuilder<DeviceBloc, DeviceState>(buildWhen: (previous, state) {
      if (!needUpdate(state.deviceType)) {
        return false;
      }

      bool update = false;

      if (state is DeviceDataUpdated && state.deviceData is ECGData) {
        ecgData = state.deviceData as ECGData;

        UserInfo().HR = ecgData.HR ?? "";
        UserInfo().P_Width = ecgData.P_Width ?? "";
        UserInfo().PR = ecgData.PR ?? "";
        UserInfo().QRS_Dur = ecgData.QRS_Dur ?? "";
        UserInfo().QT = ecgData.QT ?? "";
        UserInfo().QTc = ecgData.QTc ?? "";
        UserInfo().QRS_Axis = ecgData.QRS_Axis ?? "";
        UserInfo().P_Axis = ecgData.P_Axis ?? "";
        UserInfo().T_Axis = ecgData.T_Axis ?? "";
        UserInfo().RR = ecgData.RR ?? "";
        UserInfo().Conclusion = ecgData.Conclusion ?? "";
        UserInfo().ResultImage = ecgData.ResultImage ?? "";

        update = true;
      }

      return update;
    }, builder: (context, state) {
      return GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          // 一行几列
          crossAxisCount: 2,
          // 设置每子元素的大小（宽高比）
          childAspectRatio: 1.8,
          // 元素的左右的 距离
          crossAxisSpacing: width * 0.02,
          // 子元素上下的 距离
          mainAxisSpacing: height * 0.01,
        ),
        children: [
          buildItem(AppLocalizations.of(context)!.ecg_hr, ecgData.HR),
          buildItem(AppLocalizations.of(context)!.ecg_pr, ecgData.PR),
          buildItem(AppLocalizations.of(context)!.ecg_qt, ecgData.QT),
          buildItem(AppLocalizations.of(context)!.ecg_qtc, ecgData.QTc),
          buildItem(AppLocalizations.of(context)!.ecg_p_width, ecgData.P_Width),
          buildItem(AppLocalizations.of(context)!.ecg_qrs_dur, ecgData.QRS_Dur),
          buildItem(AppLocalizations.of(context)!.ecg_p_axis, ecgData.P_Axis),
          buildItem(
              AppLocalizations.of(context)!.ecg_qrs_axis, ecgData.QRS_Axis),
          buildItem(AppLocalizations.of(context)!.ecg_t_axis, ecgData.T_Axis),
        ],
      );
    });
  }
}
