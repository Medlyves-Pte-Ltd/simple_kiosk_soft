import 'package:flutter/material.dart';
import 'package:flutter_devices_sdk/device_data/body_composition_data.dart';
import 'package:flutter_devices_sdk/device_manager.dart';
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

class BodyCompositionMeasure extends BaseMeasureLayoutWidget {
  // Body Fat Rate (脂肪率)
  late String bodyFatPercentage;
  // Basal Metabolism (基础代谢)
  late String basalMetabolism;
  // 骨量
  late String boneMass;
  // Visceral Fat Level (内脏脂肪等级)
  late String visceralFatLevel;
  // Protein Rate (蛋白质率)
  late String proteinPercentage;
  // 水分含量
  late String bodyWaterPercentage;

  BodyCompositionMeasure() {
    bodyFatPercentage = UserInfo().bodyFatPercentage.isNotEmpty
        ? UserInfo().bodyFatPercentage
        : dataDefaultValue;
    basalMetabolism = UserInfo().basalMetabolism.isNotEmpty
        ? UserInfo().basalMetabolism
        : dataDefaultValue;
    boneMass =
        UserInfo().boneMass.isNotEmpty ? UserInfo().boneMass : dataDefaultValue;
    visceralFatLevel = UserInfo().visceralFatLevel.isNotEmpty
        ? UserInfo().visceralFatLevel
        : dataDefaultValue;
    proteinPercentage = UserInfo().proteinPercentage.isNotEmpty
        ? UserInfo().proteinPercentage
        : dataDefaultValue;
    bodyWaterPercentage = UserInfo().bodyWaterPercentage.isNotEmpty
        ? UserInfo().bodyWaterPercentage
        : dataDefaultValue;
  }

  @override
  void init() {
    super.title = AppLocalizations.of(mainContext)!.bcm;
    if (super.startVideoFile.isEmpty) {
      super.startVideoFile = getVideoFileName(DeviceType.BC_DEVICE, false);
    }
    if (super.endVideoFile.isEmpty) {
      super.endVideoFile = getVideoFileName(DeviceType.BC_DEVICE, true);
    }
  }

  @override
  Future<void> onStart() async {
    // 人体成分需要传入参数
    DeviceManager().getDevice(DeviceType.BC_DEVICE)?.mapData = {
      'height': UserInfo().height,
      'weight': UserInfo().weight,
      'age': UserInfo().age,
      'gender': UserInfo().gender
    };

    DeviceConnectEvent connectEvent =
        DeviceConnectEvent(deviceType: DeviceType.BC_DEVICE);
    BlocProvider.of<DeviceBloc>(mainContext).add(connectEvent);
  }

  @override
  Future<void> onStop() async {
    DeviceStopEvent stopEvent =
        DeviceStopEvent(deviceType: DeviceType.BC_DEVICE);
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
    return BlocBuilder<DeviceBloc, DeviceState>(buildWhen: (previous, state) {
      bool update = false;

      if (state is DeviceConnected) {
        ControlMeasurePageUtils().measured = false;
        bodyFatPercentage = boneMass = basalMetabolism = boneMass =
            visceralFatLevel =
                proteinPercentage = bodyWaterPercentage = dataDefaultValue;

        UserInfo().bodyFatPercentage = "";
        UserInfo().bodyFatMass = "";
        UserInfo().basalMetabolism = "";
        UserInfo().boneMass = "";
        UserInfo().visceralFatLevel = "";
        UserInfo().proteinPercentage = "";
        UserInfo().mineral = "";
        UserInfo().bodyWaterPercentage = "";
        update = true;
      } else if (state is DeviceDataLoading) {
        bodyFatPercentage = boneMass = basalMetabolism = boneMass =
            visceralFatLevel = proteinPercentage =
                bodyWaterPercentage = AppLocalizations.of(mainContext)!.loading;
        update = true;
      } else if (state is DeviceDataUpdated) {
        if (state.deviceData is BodyCompositionData) {
          BodyCompositionData bodyCompositionData =
              state.deviceData as BodyCompositionData;
          bodyFatPercentage = bodyCompositionData.bodyFatPercentage ?? "";
          basalMetabolism = bodyCompositionData.basalMetabolism ?? "";
          boneMass = bodyCompositionData.boneMass ?? "";
          visceralFatLevel = bodyCompositionData.visceralFatLevel ?? "";
          proteinPercentage = bodyCompositionData.proteinPercentage ?? "";
          bodyWaterPercentage = bodyCompositionData.bodyWaterPercentage ?? "";

          UserInfo().bodyFatPercentage =
              bodyCompositionData.bodyFatPercentage ?? "";
          UserInfo().bodyFatMass = bodyCompositionData.bodyFatPercentage ?? "";
          UserInfo().basalMetabolism =
              bodyCompositionData.basalMetabolism ?? "";
          UserInfo().boneMass = bodyCompositionData.boneMass ?? "";
          UserInfo().visceralFatLevel =
              bodyCompositionData.visceralFatLevel ?? "";
          UserInfo().proteinPercentage =
              bodyCompositionData.proteinPercentage ?? "";
          UserInfo().mineral = bodyCompositionData.mineral ?? "";
          UserInfo().bodyWaterPercentage =
              bodyCompositionData.bodyWaterPercentage ?? "";

          ControlMeasurePageUtils().measured = true;
          update = true;
        }
      } else if (state is DeviceDisconnected) {
        if (ControlMeasurePageUtils().measured == false) {
          bodyFatPercentage = boneMass = basalMetabolism = boneMass =
              visceralFatLevel =
                  proteinPercentage = bodyWaterPercentage = dataDefaultValue;
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
            buildItem(AppLocalizations.of(context)!.bcm_fat, bodyFatPercentage),
            buildItem(
                AppLocalizations.of(context)!.bcm_metabolism, basalMetabolism),
            buildItem(AppLocalizations.of(context)!.bcm_visceralfat,
                visceralFatLevel),
            buildItem(AppLocalizations.of(context)!.bcm_bone_mass, boneMass),
            buildItem(
                AppLocalizations.of(context)!.bcm_water, bodyWaterPercentage),
            buildItem(AppLocalizations.of(context)!.bcm_protein_percentage,
                proteinPercentage),
          ],
        ),
      );
    });
  }
}
