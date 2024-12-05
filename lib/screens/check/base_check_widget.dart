import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:flutter_devices_sdk/view/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_kiosk_software/blocs/device/device_state.dart';
import 'package:simple_kiosk_software/blocs/device/device_bloc.dart';
import 'package:simple_kiosk_software/utils/permission_config.dart';

class BaseCheckWidget extends StatelessWidget {
  bool isStart = false;
  // 是否测过
  bool measured = false;
  // 数据默认值
  String dataDefaultValue = "- - -";
  // 标题
  String title = "";
  String iconFile = "";
  // 屏幕宽度
  double width = 0;
  // 屏幕高度
  double height = 0;
  late Color underlineColor;
  // StatelessWidget需要保存上下文才能进行页面跳转，翻译
  late BuildContext mainContext;

  void init() {}
  // 开始
  Future<void> onStart() async {}

  // 停止
  Future<void> onStop() async {}

  // 子类需要实现的数据显示函数
  Widget buildCardDataShowArea() {
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    mainContext = context;
    init();
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(mainContext).canvasColor,
            border: Border.all(
              width: 1,
              color: Colors.grey[300] ?? Colors.grey,
            )),
        child: Column(
          children: [
            buildCardTopArea(),
            startButton(),
            Expanded(child: buildCardDataShowArea()),
          ],
        ),
      ),
    );
  }

  // 卡片顶部区域
  Widget buildCardTopArea() {
    double imageSize = height * 0.03;
    double titleFontSize = height * 0.014;
    return Row(
      children: [
        Image.asset(
          iconFile,
          width: imageSize,
          height: imageSize,
        ),
        const SizedBox(width: 3),
        Padding(
          padding: EdgeInsets.symmetric(vertical: height * 0.01),
          child: IntrinsicWidth(
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: titleFontSize),
                ),
                Container(
                  color: underlineColor,
                  height: 1.5,
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        // InkWell(
        //   onTap: () async {
        //     await onStart();
        //   },
        //   child: Container(
        //     height: height * 0.03,
        //     width: width * 0.1,
        //     decoration: BoxDecoration(
        //       color: ColorPalette.materialGreen,
        //       borderRadius: BorderRadius.circular(10),
        //     ),
        //     child: Center(
        //       child: Text("开始",
        //           textAlign: TextAlign.center,
        //           style: TextStyle(
        //               fontWeight: FontWeight.bold,
        //               fontSize: 11,
        //               color: Colors.white)),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  bool needUpdate(DeviceType? type) {
    return false;
  }

  Widget startButton() {
    //return const SizedBox.shrink();
    double btnFontSize = height * 0.01;
    String btnText = AppLocalizations.of(mainContext)!.start;
    return BlocBuilder<DeviceBloc, DeviceState>(buildWhen: (previous, state) {
      if (!needUpdate(state.deviceType)) {
        return false;
      }

      bool update = false;

      if (state is DeviceConnected) {
        btnText = AppLocalizations.of(mainContext)!.stop;
        update = true;
      } else if (state is DeviceDisconnected) {
        btnText = AppLocalizations.of(mainContext)!.start;
        update = true;
      }

      return update;
    }, builder: (context, state) {
      return PermissionConfig().havePermission(PermissionModules.DeviceDiagnostic)
          ? InkWell(
              onTap: () async {
                if (btnText == AppLocalizations.of(mainContext)!.stop) {
                  await onStop();
                } else {
                  await onStart();
                }
              },
              child: Container(
                height: height * 0.03,
                width: width * 0.1,
                decoration: BoxDecoration(
                  color: ColorPalette.materialGreen,
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
            )
          : Container(
              height: height * 0.03,
              width: width * 0.1,
              decoration: BoxDecoration(
                color: ColorPalette.darkGrey,
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
            );
    });
  }
}
