import 'package:flutter/material.dart';
import 'package:flutter_devices_sdk/view/colors.dart';
import 'package:simple_kiosk_software/common/footer.dart';
import 'package:simple_kiosk_software/utils/permission_config.dart';

class WeightCalibrationSettingListPage extends StatefulWidget {
  @override
  State<WeightCalibrationSettingListPage> createState() =>
      WeightCalibrationSettingListPageState();
}

class WeightCalibrationSettingListPageState
    extends State<WeightCalibrationSettingListPage> {
  // 屏幕宽度
  double width = 0;
  // 屏幕高度
  double height = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 分割线
  Widget buildDivider() {
    return Divider(
      height: 2.0, // 分隔线高度
      thickness: 1.0, // 分隔线厚度
      color: Colors.grey, // 分隔线颜色
      indent: width * 0.06, // 左缩进
      endIndent: width * 0.06, // 右缩进
    );
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, '/CalibrationSettingListPage', ((route) => false));
          },
        ),
        title: Text('Weight Calibration Setting List Page'),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
              child: RawScrollbar(
                  thumbColor: ColorPalette.darkGrey,
                  // 一直显示滑动条
                  thumbVisibility: true,
                  // 滑动条的宽度
                  thickness: 6,
                  radius: const Radius.circular(10),
                  // 滑动条为true 可拖动
                  interactive: true,
                  child: ListView(
                    children: [
                      ListTile(
                        selectedColor: ColorPalette.materialGreen,
                        title: Text('Singe Point Calibration'),
                        subtitle: Text(''),
                        leading: CircleAvatar(
                          child: Icon(Icons.accessibility_rounded),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios_rounded),
                        onTap: () {
                          // 处理点击事件
                          Navigator.pushNamed(
                              context, "/SingerPointWeightCalibrationPage");
                        },
                      ),
                      buildDivider(),
                      ListTile(
                        selectedColor: ColorPalette.materialGreen,
                        title: Text('Three Point Calibration'),
                        subtitle: Text(''),
                        leading: CircleAvatar(
                          child: Icon(Icons.settings_accessibility),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios_rounded),
                        onTap: () {
                          // 处理点击事件
                          Navigator.pushNamed(
                              context, "/ThreePointWeightCalibrationPage");
                        },
                      ),
                      buildDivider(),
                    ],
                  ))),
          Footer(),
        ],
      ),
    );
  }
}
