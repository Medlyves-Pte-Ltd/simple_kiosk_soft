import 'package:flutter/material.dart';
import 'package:flutter_devices_sdk/device_data/blood_fit_data.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:simple_kiosk_software/screens/measurement_pages/base_measure_layout_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_kiosk_software/blocs/device/device_bloc.dart';
import 'package:simple_kiosk_software/blocs/device/device_event.dart';
import 'package:simple_kiosk_software/blocs/device/device_state.dart';
import 'package:simple_kiosk_software/utils/control_measure_page_utils.dart';
import 'package:simple_kiosk_software/utils/user_info.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BloodFitMeasure extends BaseMeasureLayoutWidget {
  // 胆固醇
  late String chol = '';
  // 高密度脂蛋白
  late String hdl = '';
  // 甘油三酯
  late String trig = '';
  // 低密度脂蛋白
  late String ldl = '';

  BloodFitMeasure() {
    chol = UserInfo().chol.isNotEmpty ? UserInfo().chol : dataDefaultValue;
    hdl = UserInfo().hdl.isNotEmpty ? UserInfo().hdl : dataDefaultValue;
    trig = UserInfo().trig.isNotEmpty ? UserInfo().trig : dataDefaultValue;
    ldl = UserInfo().ldl.isNotEmpty ? UserInfo().ldl : dataDefaultValue;
  }

  @override
  void init() {
    super.title = AppLocalizations.of(mainContext)!.bf;
    if (super.startVideoFile.isEmpty) {
      super.startVideoFile = getVideoFileName(DeviceType.BF_DEVICE, false);
    }
    if (super.endVideoFile.isEmpty) {
      super.endVideoFile = getVideoFileName(DeviceType.BF_DEVICE, true);
    }
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

  Widget buildItem(String title, String? data) {
    double titleFontSize = height * 0.02;
    double dataFontSize = height * 0.02;
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
    double titleFontSize = height * 0.02;
    double dataFontSize = height * 0.02;

    return BlocBuilder<DeviceBloc, DeviceState>(buildWhen: (previous, state) {
      bool update = false;

      if (state is DeviceConnected) {
        ControlMeasurePageUtils().measured = false;
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

          ControlMeasurePageUtils().measured = true;
          update = true;
        }
      } else if (state is DeviceDisconnected) {
        if (ControlMeasurePageUtils().measured == false) {
          chol = hdl = trig = ldl = dataDefaultValue;
          update = true;
        }
      }

      return update;
    }, builder: (context, state) {
      return Center(
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            // 一行几列
            crossAxisCount: 2,
            // 设置每子元素的大小（宽高比）
            childAspectRatio: 3,
            // 元素的左右的 距离
            crossAxisSpacing: width * 0.02,
            // 子元素上下的 距离
            mainAxisSpacing: height * 0.01,
          ),
          physics: const NeverScrollableScrollPhysics(), // 禁止滚动
          shrinkWrap: true,
          children: [
            buildItem(AppLocalizations.of(context)!.bf_totalCholesterol, chol),
            buildItem(AppLocalizations.of(context)!.bf_triglyceride, trig),
            buildItem(AppLocalizations.of(context)!.bf_hgl, hdl),
            buildItem(AppLocalizations.of(context)!.bf_ldl, ldl),
          ],
        ),
      );
    });
  }
}
