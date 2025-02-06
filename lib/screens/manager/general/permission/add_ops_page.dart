import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_kiosk_software/common/common.dart';
import 'package:simple_kiosk_software/utils/permission_config.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddOpsPage extends StatefulWidget {
  Function callBack;
  AddOpsPage({required this.callBack});

  @override
  AddOpsPageState createState() => AddOpsPageState();
}

class AddOpsPageState extends State<AddOpsPage> {
  Role role = Role();
  List<String> allPermissionList = [];
  List<String> selectPermissionList = [];

  final ScrollController _scrollController = ScrollController();
  TextEditingController _accountController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // 屏幕宽度
  double width = 0;
  // 屏幕高度
  double height = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for (var it in PermissionModules.values) {
      allPermissionList.add(it.name);
      selectPermissionList.add(it.name);
    }

    // ops移除权限
    allPermissionList.remove(PermissionModules.Permission.name);
    selectPermissionList.remove(PermissionModules.Permission.name);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void checkBoxChanged(int index, bool selected) {
    if (!selected) {
      selectPermissionList.remove(allPermissionList[index]);
    } else {
      selectPermissionList.add(allPermissionList[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(
              height: height * 0.06,
            ),
            Text("Assign accounts and passwords to ops",
                maxLines: 3, softWrap: true),
            SizedBox(
              height: height * 0.01,
            ),
            TDInput(
              width: width * 0.8,
              inputFormatters: [
                LengthLimitingTextInputFormatter(20),
                FilteringTextInputFormatter.allow(
                  // 仅支持字母数字
                  RegExp("[a-zA-Z]|[0-9]"),
                ),
              ],
              leftIcon: const Icon(Icons.person),
              leftLabel: '',
              contentAlignment: TextAlign.left,
              controller: _accountController,
              backgroundColor: Colors.white,
              hintText: 'Account',
              hintTextStyle: TextStyle(fontSize: height * 0.015),
              onSubmitted: (text) {
                role.account = text;
                setState(() {});
              },
              onClearTap: () {
                _accountController.clear();
                setState(() {});
              },
            ),
            SizedBox(
              height: height * 0.01,
            ),
            TDInput(
              type: TDInputType.normal,
              inputFormatters: [
                LengthLimitingTextInputFormatter(20),
                FilteringTextInputFormatter.allow(
                  // 支持字母和数字
                  RegExp("[a-zA-Z]|[0-9]"),
                )
              ],
              leftIcon: const Icon(Icons.password),
              leftLabel: '',
              contentAlignment: TextAlign.left,
              controller: _passwordController,
              backgroundColor: Colors.white,
              hintText: 'Password (6-20 letters, numbers)',
              hintTextStyle: TextStyle(fontSize: height * 0.015),
              onSubmitted: (text) {
                role.password = text;
                setState(() {});
              },
              onClearTap: () {
                _passwordController.clear();
                setState(() {});
              },
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Row(
              children: [
                Text("Assign permissions to this role"),
                const Spacer(),
              ],
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Expanded(
                child: RawScrollbar(
              thumbColor: Theme.of(context).primaryColor,
              controller: _scrollController,
              thumbVisibility: true, // 一直显示滑动条
              thickness: width * 0.01, // 滑动条的宽度
              radius: const Radius.circular(10),
              interactive: true, // 滑动条为true 可拖动
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: height * 0.01,
                  mainAxisSpacing: height * 0.01,
                  childAspectRatio: 3 / 2,
                ),
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: allPermissionList.length,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return TDCheckbox(
                    titleFont: Font(size: 13, lineHeight: 12),
                    checked: true,
                    title: allPermissionList[index],
                    cardMode: true,
                    onCheckBoxChanged: (bool selected) {
                      checkBoxChanged(index, selected);
                    },
                  );
                },
              ),
            )),
            SizedBox(
              height: height * 0.01,
            ),
            ElevatedButton(
              onPressed: () {
                if (role.password.isEmpty) {
                  Fluttertoast.showToast(msg: "The account cannot be empty");
                  return;
                }

                if (role.password.isEmpty) {
                  Fluttertoast.showToast(msg: "Password cannot be empty");
                  return;
                }
                role.accountClass = RoleClass.ops;
                role.permissionList.addAll(selectPermissionList);
                widget.callBack(role);
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
