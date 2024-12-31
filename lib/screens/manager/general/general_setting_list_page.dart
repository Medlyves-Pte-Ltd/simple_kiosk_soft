import 'package:flutter/material.dart';
import 'package:flutter_devices_sdk/view/colors.dart';
import 'package:simple_kiosk_software/common/footer.dart';
import 'package:simple_kiosk_software/utils/app_config.dart';
import 'package:simple_kiosk_software/utils/permission_config.dart';

class GeneralSettingListPage extends StatefulWidget {
  @override
  State<GeneralSettingListPage> createState() => GeneralSettingListPageState();
}

class GeneralSettingListPageState extends State<GeneralSettingListPage> {
  bool allowEdit = true;
  // 屏幕宽度
  double width = 0;
  // 屏幕高度
  double height = 0;
  var ecoModeTimeMinuteControl =
      TextEditingController(text: AppConfig().ecoModeTimeMinute.toString());
  var measureAutomaticStopTimeControl = TextEditingController(
      text: AppConfig().measureAutomaticStopTimeSecond.toString());

  @override
  void initState() {
    super.initState();
    allowEdit = PermissionConfig().havePermission(PermissionModules.General);
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
                context, '/SettingListPage', ((route) => false));
          },
        ),
        title: Text('general'),
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
                      Visibility(
                          visible: PermissionConfig()
                              .havePermission(PermissionModules.Permission),
                          child: Column(
                            children: [
                              ListTile(
                                selectedColor: ColorPalette.materialGreen,
                                title: Text('Permission Configuration'),
                                subtitle: Text(''),
                                leading: CircleAvatar(
                                  child: Icon(Icons.perm_identity_outlined),
                                ),
                                trailing: Icon(Icons.arrow_forward_ios_rounded),
                                onTap: () {
                                  // 处理点击事件
                                  Navigator.pushNamed(
                                      context, "/PermissionConfigPage");
                                },
                              ),
                            ],
                          )),
                      buildDivider(),
                      ListTile(
                        selectedColor: ColorPalette.materialGreen,
                        title: Text('Change Password'),
                        subtitle: Text(''),
                        leading: CircleAvatar(
                          child: Icon(Icons.password_outlined),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios_rounded),
                        onTap: () {
                          // 处理点击事件
                          Navigator.pushNamed(context, "/ModifyPasswordPage");
                        },
                      ),
                      buildDivider(),
                      // 测试结果输出
                      allowEdit
                          ? SwitchListTile(
                              title: Text('Test results export to csv file',
                                  style: TextStyle(fontSize: height * 0.012)),
                              value: AppConfig().testResultOutCsv,
                              onChanged: (bool value) {
                                AppConfig().testResultOutCsv = value;
                                setState(() {});
                              },
                            )
                          : IgnorePointer(
                              ignoring: true,
                              child: SwitchListTile(
                                title: Text('Test results export to csv file',
                                    style: TextStyle(fontSize: height * 0.012)),
                                value: AppConfig().testResultOutCsv,
                                activeTrackColor: Colors.grey,
                                inactiveThumbColor: Colors.red,
                                inactiveTrackColor: Colors.grey,
                                onChanged: (bool value) {},
                              ),
                            ),
                      buildDivider(),
                      allowEdit
                          ? SwitchListTile(
                              title: Text('Eco mode',
                                  style: TextStyle(fontSize: height * 0.012)),
                              value: AppConfig().ecoMode,
                              onChanged: (bool value) {
                                AppConfig().ecoMode = value;
                                setState(() {});
                              },
                            )
                          : IgnorePointer(
                              ignoring: true,
                              child: SwitchListTile(
                                title: Text('Eco mode',
                                    style: TextStyle(fontSize: height * 0.012)),
                                value: AppConfig().ecoMode,
                                activeTrackColor: Colors.grey,
                                inactiveThumbColor: Colors.red,
                                inactiveTrackColor: Colors.grey,
                                onChanged: (bool value) {},
                              ),
                            ),
                      buildDivider(),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          child: Row(
                            children: [
                              Text(
                                "Eco mode time minute",
                                style: TextStyle(fontSize: height * 0.012),
                              ),
                              const Spacer(),
                              SizedBox(
                                  width: width * 0.1,
                                  child: TextField(
                                    readOnly: !allowEdit,
                                    keyboardType: TextInputType.number,
                                    autocorrect: false,
                                    controller: ecoModeTimeMinuteControl,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    cursorColor:
                                        const Color.fromRGBO(103, 155, 206, 1),
                                    style: TextStyle(fontSize: height * 0.012),
                                    onSubmitted: (text) {
                                      setState(() {});
                                      if (text.isEmpty) {
                                        return;
                                      }
                                      AppConfig().ecoModeTimeMinute =
                                          int.parse(text);
                                    },
                                  )),
                            ],
                          )),
                      buildDivider(),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          child: Row(
                            children: [
                              Text(
                                "Measure automatic stop time second",
                                style: TextStyle(fontSize: height * 0.012),
                              ),
                              const Spacer(),
                              SizedBox(
                                  width: width * 0.1,
                                  child: TextField(
                                    readOnly: !allowEdit,
                                    keyboardType: TextInputType.number,
                                    autocorrect: false,
                                    controller: measureAutomaticStopTimeControl,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    cursorColor:
                                        const Color.fromRGBO(103, 155, 206, 1),
                                    style: TextStyle(fontSize: height * 0.012),
                                    onSubmitted: (text) {
                                      setState(() {});
                                      if (text.isEmpty) {
                                        return;
                                      }
                                      AppConfig()
                                              .measureAutomaticStopTimeSecond =
                                          int.parse(text);
                                    },
                                  )),
                            ],
                          )),
                      buildDivider(),
                      allowEdit
                          ? SwitchListTile(
                              title: Text('Only use input log in',
                                  style: TextStyle(fontSize: height * 0.012)),
                              value: AppConfig().onlyInputLogin,
                              onChanged: (bool value) {
                                AppConfig().onlyInputLogin = value;
                                setState(() {});
                              },
                            )
                          : IgnorePointer(
                              ignoring: true,
                              child: SwitchListTile(
                                title: Text('Only use input log in',
                                    style: TextStyle(fontSize: height * 0.012)),
                                value: AppConfig().onlyInputLogin,
                                activeTrackColor: Colors.grey,
                                inactiveThumbColor: Colors.red,
                                inactiveTrackColor: Colors.grey,
                                onChanged: (bool value) {},
                              ),
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
