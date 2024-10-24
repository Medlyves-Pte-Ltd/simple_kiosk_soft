import 'package:flutter/material.dart';
import 'package:flutter_devices_sdk/device_data/body_composition_data.dart';
import 'package:flutter_devices_sdk/device_data/device_data.dart';
import 'package:flutter_devices_sdk/device_manager.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:simple_kiosk_software/remote/blocs/appointment/appointment_bloc.dart';
import 'package:simple_kiosk_software/blocs/locale/locale_bloc.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:simple_kiosk_software/screens/measurement_pages/base_measure_layout_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_kiosk_software/blocs/device/device_bloc.dart';
import 'package:simple_kiosk_software/blocs/device/device_event.dart';
import 'package:simple_kiosk_software/blocs/device/device_state.dart';
import 'package:simple_kiosk_software/utils/app_config.dart';
import 'package:simple_kiosk_software/utils/control_measure_page_utils.dart';
import 'package:simple_kiosk_software/utils/user_info.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  // 肌肉量 kg
  late String muscleMass = '';
  // 身体年龄
  late String bodyAge = "";
  // Extracellular Water Rate (细胞外液率) %
  late String extracellularFluid = ''; //
  // Intracellular Water Rate (细胞内液率)
  late String intracellularWaterPercentage = '';
  // Total moisture (总水分)
  late String totalMoisture = '';
  // 蛋白质
  late String protein = '';
  // Skeletal Muscle Percentage 骨骼肌率
  late String skeletalMusclePercentage = '';
  // Body Fat Mass 脂肪量
  late String bodyFatMass = '';

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
    muscleMass = UserInfo().muscleMass.isNotEmpty
        ? UserInfo().muscleMass
        : dataDefaultValue;
    bodyAge =
        UserInfo().bodyAge.isNotEmpty ? UserInfo().bodyAge : dataDefaultValue;
    extracellularFluid = UserInfo().extracellularFluid.isNotEmpty
        ? UserInfo().extracellularFluid
        : dataDefaultValue;
    intracellularWaterPercentage =
        UserInfo().intracellularWaterPercentage.isNotEmpty
            ? UserInfo().intracellularWaterPercentage
            : dataDefaultValue;
    totalMoisture = UserInfo().totalMoisture.isNotEmpty
        ? UserInfo().totalMoisture
        : dataDefaultValue;
    protein =
        UserInfo().protein.isNotEmpty ? UserInfo().protein : dataDefaultValue;
    skeletalMusclePercentage = UserInfo().skeletalMusclePercentage.isNotEmpty
        ? UserInfo().skeletalMusclePercentage
        : dataDefaultValue;
    bodyFatMass = UserInfo().bodyFatMass.isNotEmpty
        ? UserInfo().bodyFatMass
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
    if (UserInfo().height.isEmpty || UserInfo().weight.isEmpty) {
      Fluttertoast.showToast(msg: AppLocalizations.of(mainContext)!.bcm_prereq);
      return;
    }
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
    String localeCode =
        BlocProvider.of<LocaleCubit>(mainContext).locale.languageCode;
    double ratio = 0.02;
    if (localeCode == "ta" || localeCode == "th") {
      ratio = 0.015;
    } else if (localeCode == "ms") {
      ratio = 0.018;
    }
    double titleFontSize = height * ratio;
    double dataFontSize = height * ratio;

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
        measured = false;
        intracellularWaterPercentage = totalMoisture = protein =
            skeletalMusclePercentage = bodyFatMass = muscleMass = bodyAge =
                extracellularFluid = bodyFatPercentage = boneMass =
                    basalMetabolism = visceralFatLevel = proteinPercentage =
                        bodyWaterPercentage = dataDefaultValue;

        UserInfo().bodyFatPercentage = "";
        UserInfo().bodyFatMass = "";
        UserInfo().basalMetabolism = "";
        UserInfo().boneMass = "";
        UserInfo().visceralFatLevel = "";
        UserInfo().proteinPercentage = "";
        UserInfo().mineral = "";
        UserInfo().bodyWaterPercentage = "";
        UserInfo().muscleMass = "";
        UserInfo().bodyAge = "";
        UserInfo().extracellularFluid = "";

        UserInfo().intracellularWaterPercentage = "";
        UserInfo().totalMoisture = "";
        UserInfo().protein = "";
        UserInfo().skeletalMusclePercentage = "";
        UserInfo().bodyFatMass = "";

        update = true;
      } else if (state is DeviceDataLoading) {
        intracellularWaterPercentage = totalMoisture = protein =
            skeletalMusclePercentage = bodyFatMass = muscleMass = bodyAge =
                extracellularFluid = bodyFatPercentage = boneMass =
                    basalMetabolism = boneMass = visceralFatLevel =
                        proteinPercentage = bodyWaterPercentage =
                            AppLocalizations.of(mainContext)!.loading;
        update = true;
      } else if (state is DeviceDataUpdated) {
        if (state.deviceData is BodyCompositionData) {
          BodyCompositionData bodyCompositionData =
              state.deviceData as BodyCompositionData;
          UserInfo().bodyFatPercentage =
              bodyFatPercentage = bodyCompositionData.bodyFatPercentage ?? "";
          UserInfo().basalMetabolism =
              basalMetabolism = bodyCompositionData.basalMetabolism ?? "";
          UserInfo().boneMass = boneMass = bodyCompositionData.boneMass ?? "";
          UserInfo().visceralFatLevel =
              visceralFatLevel = bodyCompositionData.visceralFatLevel ?? "";
          UserInfo().proteinPercentage =
              proteinPercentage = bodyCompositionData.proteinPercentage ?? "";
          UserInfo().bodyWaterPercentage = bodyWaterPercentage =
              bodyCompositionData.bodyWaterPercentage ?? "";

          UserInfo().muscleMass =
              muscleMass = bodyCompositionData.muscleMass ?? "";
          UserInfo().bodyAge = bodyAge = bodyCompositionData.bodyAge ?? "";
          UserInfo().extracellularFluid = extracellularFluid =
              bodyCompositionData.extracellularWaterPercentage ?? "";

          UserInfo().intracellularWaterPercentage =
              intracellularWaterPercentage =
                  bodyCompositionData.intracellularWaterPercentage ?? "";
          UserInfo().totalMoisture =
              totalMoisture = bodyCompositionData.totalMoisture ?? "";
          UserInfo().protein = protein = bodyCompositionData.protein ?? "";
          UserInfo().skeletalMusclePercentage = skeletalMusclePercentage =
              bodyCompositionData.skeletalMusclePercentage ?? "";
          UserInfo().bodyFatMass =
              bodyFatMass = bodyCompositionData.bodyFatMass ?? "";

          if (AppConfig().enableTC) {
            BlocProvider.of<AppointmentBloc>(mainContext).processNewData({
              'bodyFatPercentage': UserInfo().bodyFatPercentage,
              'basalMetabolism': UserInfo().basalMetabolism,
              'visceralFatLevel': UserInfo().visceralFatLevel,
              'protein': UserInfo().protein,
              "bodyWaterPercentage": UserInfo().bodyWaterPercentage
            });
          }

          ControlMeasurePageUtils().measured = true;
          measured = true;
          update = true;
        }
      } else if (state is DeviceDisconnected) {
        if (!measured) {
          intracellularWaterPercentage = totalMoisture = protein =
              skeletalMusclePercentage = bodyFatMass = muscleMass = bodyAge =
                  extracellularFluid = bodyFatPercentage = boneMass =
                      basalMetabolism = visceralFatLevel = proteinPercentage =
                          bodyWaterPercentage = dataDefaultValue;
          update = true;
        }
      }

      return update;
    }, builder: (context, state) {
      return RawScrollbar(
        thumbColor: ColorPalette.darkGrey,
        // 一直显示滑动条
        thumbVisibility: true,
        // 滑动条的宽度
        thickness: 6,
        radius: const Radius.circular(10),
        // 滑动条为true 可拖动
        interactive: true,
        child: GridView(
          padding: EdgeInsets.symmetric(horizontal: width * 0.005),
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
          physics: const AlwaysScrollableScrollPhysics(), // 禁止滚动
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
            buildItem(
                AppLocalizations.of(context)!.bcm_muscle_mass, muscleMass),
            buildItem(AppLocalizations.of(context)!.body_age, bodyAge),
            buildItem(AppLocalizations.of(context)!.bcm_extrac_fluid,
                extracellularFluid),
            buildItem(AppLocalizations.of(context)!.bcm_intrac_fluid,
                intracellularWaterPercentage),
            buildItem(
                AppLocalizations.of(context)!.bcm_moisture, totalMoisture),
            buildItem(AppLocalizations.of(context)!.bcm_protein, protein),
            buildItem(AppLocalizations.of(context)!.bcm_skeletal,
                skeletalMusclePercentage),
            buildItem(AppLocalizations.of(context)!.bcm_fatmass, bodyFatMass),
          ],
        ),
      );
    });
  }
}
