import 'package:flutter/material.dart';
import 'package:flutter_devices_sdk/device_data/body_composition_data.dart';
import 'package:flutter_devices_sdk/device_manager.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:simple_kiosk_software/blocs/locale/locale_bloc.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:simple_kiosk_software/screens/check/base_check_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_kiosk_software/blocs/device/device_bloc.dart';
import 'package:simple_kiosk_software/blocs/device/device_event.dart';
import 'package:simple_kiosk_software/blocs/device/device_state.dart';
import 'package:simple_kiosk_software/utils/control_measure_page_utils.dart';
import 'package:simple_kiosk_software/utils/user_info.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BodyCompositionCheck extends BaseCheckWidget {
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
  final _scrollController = ScrollController();

  BodyCompositionCheck() {
    iconFile = "assets/images/bodycomposition_logo.png";
    underlineColor = ColorPalette.colorbodyComposition;
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

  @override
  bool needUpdate(DeviceType? type) {
    return type == DeviceType.BC_DEVICE;
  }

  Widget buildItem(String title, String? data) {
    String localeCode =
        BlocProvider.of<LocaleCubit>(mainContext).locale.languageCode;
    double ratio = 0.01;
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
      if (!needUpdate(state.deviceType)) {
        return false;
      }

      bool update = false;

      if (state is DeviceConnected) {
        measured = false;
        intracellularWaterPercentage = totalMoisture = protein =
            skeletalMusclePercentage = bodyFatMass = muscleMass = bodyAge =
                extracellularFluid = bodyFatPercentage = basalMetabolism =
                    boneMass = visceralFatLevel = proteinPercentage =
                        bodyWaterPercentage = dataDefaultValue;

        UserInfo().bodyFatPercentage = "";
        UserInfo().bodyFatMass = "";
        UserInfo().basalMetabolism = "";
        UserInfo().boneMass = "";
        UserInfo().visceralFatLevel = "";
        UserInfo().proteinPercentage = "";
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
                extracellularFluid = bodyFatPercentage = basalMetabolism =
                    boneMass = visceralFatLevel = proteinPercentage =
                        bodyWaterPercentage =
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

          measured = true;
          update = true;
        }
      } else if (state is DeviceDisconnected) {
        if (!measured) {
          intracellularWaterPercentage = totalMoisture = protein =
              skeletalMusclePercentage = bodyFatMass = muscleMass = bodyAge =
                  extracellularFluid = bodyFatPercentage = basalMetabolism =
                      boneMass = visceralFatLevel = proteinPercentage =
                          bodyWaterPercentage = dataDefaultValue;
          update = true;
        }
      }

      return update;
    }, builder: (context, state) {
      return RawScrollbar(
          thumbColor: Colors.grey,
          controller: _scrollController,
          thumbVisibility: true, // 一直显示滑动条
          thickness: 6, // 滑动条的宽度
          radius: const Radius.circular(10),
          interactive: true, // 滑动条为true 可拖动
          child: GridView(
            padding: EdgeInsets.symmetric(horizontal: width * 0.005),
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
              buildItem(
                  AppLocalizations.of(context)!.bcm_fat, bodyFatPercentage),
              buildItem(AppLocalizations.of(context)!.bcm_metabolism,
                  basalMetabolism),
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
          ));
    });
  }
}
