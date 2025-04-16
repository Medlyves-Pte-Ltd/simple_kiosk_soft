import 'package:flutter/material.dart';
import 'package:flutter_devices_sdk/device_data/blood_fit_data.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_kiosk_software/blocs/device/device_bloc.dart';
import 'package:simple_kiosk_software/blocs/device/device_event.dart';
import 'package:simple_kiosk_software/blocs/device/device_state.dart';
import 'package:simple_kiosk_software/screens/check/base_check_widget.dart';
import 'package:simple_kiosk_software/utils/user_info.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BloodFitCheck extends BaseCheckWidget {
  // 胆固醇
  late String chol = '';
  // 高密度脂蛋白
  late String hdl = '';
  // 甘油三酯
  late String trig = '';
  // 低密度脂蛋白
  late String ldl = '';

  BloodFitCheck() {
    iconFile = "assets/images/blood_fit.png";
    underlineColor = ColorPalette.colorbloodFat;
    chol = UserInfo().chol.isNotEmpty ? UserInfo().chol : dataDefaultValue;
    hdl = UserInfo().hdl.isNotEmpty ? UserInfo().hdl : dataDefaultValue;
    trig = UserInfo().trig.isNotEmpty ? UserInfo().trig : dataDefaultValue;
    ldl = UserInfo().ldl.isNotEmpty ? UserInfo().ldl : dataDefaultValue;
  }

  @override
  void init() {
    title = AppLocalizations.of(mainContext)!.bf;
  }

  @override
  Future<void> onStart() async {
    DeviceConnectEvent connectEvent =
        DeviceConnectEvent(deviceType: DeviceType.BF_DEVICE);
    BlocProvider.of<DeviceBloc>(mainContext).add(connectEvent);
  }

  @override
  Future<void> onStop() async {
    DeviceStopEvent stopEvent =
        DeviceStopEvent(deviceType: DeviceType.BF_DEVICE);
    BlocProvider.of<DeviceBloc>(mainContext).add(stopEvent);
  }

  @override
  bool needUpdate(DeviceType? type) {
    return type == DeviceType.BF_DEVICE;
  }

  Widget buildItem(String title, String? data) {
    double titleFontSize = height * 0.01;
    double dataFontSize = height * 0.01;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style:
              TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: height * 0.005),
        Text(
          data ?? "",
          style: TextStyle(
              fontSize: dataFontSize,
              color: ColorPalette.materialGreen,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  @override
  Widget buildCardDataShowArea() {
    return BlocBuilder<DeviceBloc, DeviceState>(buildWhen: (previous, state) {
      bool update = false;

      if (!needUpdate(state.deviceType)) {
        return false;
      }

      if (state is DeviceConnected) {
        measured = false;
        chol = hdl = trig = ldl = dataDefaultValue;

        UserInfo().chol = "";
        UserInfo().hdl = "";
        UserInfo().trig = "";
        UserInfo().ldl = "";
        update = true;
      } else if (state is DeviceDataLoading) {
        chol = hdl = trig = ldl = AppLocalizations.of(mainContext)!.loading;
        update = true;
      } else if (state is DeviceDataUpdated) {
        if (state.deviceData is BloodFitData) {
          BloodFitData bloodFitData = state.deviceData as BloodFitData;
          chol = bloodFitData.chol;
          hdl = bloodFitData.hdl;
          trig = bloodFitData.trig;
          ldl = bloodFitData.ldl;

          UserInfo().chol = bloodFitData.chol;
          UserInfo().hdl = bloodFitData.hdl;
          UserInfo().trig = bloodFitData.trig;
          UserInfo().ldl = bloodFitData.ldl;

          measured = true;
          update = true;
        }
      } else if (state is DeviceDisconnected) {
        if (!measured) {
          chol = hdl = trig = ldl = dataDefaultValue;
          update = true;
        }
      }

      return update;
    }, builder: (context, state) {
      return GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          // 一行几列
          crossAxisCount: 1,
          // 设置每子元素的大小（宽高比）
          childAspectRatio: 3,
          // 元素的左右的 距离
          crossAxisSpacing: width * 0.02,
          // 子元素上下的 距离
          mainAxisSpacing: height * 0.01,
        ),
        physics: const AlwaysScrollableScrollPhysics(), // 禁止滚动
        shrinkWrap: true,
        children: [
          buildItem(AppLocalizations.of(context)!.bf_totalCholesterol, chol),
          buildItem(AppLocalizations.of(context)!.bf_triglyceride, trig),
          buildItem(AppLocalizations.of(context)!.bf_hgl, hdl),
          buildItem(AppLocalizations.of(context)!.bf_ldl, ldl),
        ],
      );
    });
  }
}
