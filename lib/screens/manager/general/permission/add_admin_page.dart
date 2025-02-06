import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_kiosk_software/common/common.dart';
import 'package:simple_kiosk_software/utils/permission_config.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddAdminPage extends StatefulWidget {
  Function callBack;
  AddAdminPage({required this.callBack});

  @override
  AddAdminPageState createState() => AddAdminPageState();
}

class AddAdminPageState extends State<AddAdminPage> {
  Role role = Role();
  List<String> allPermissionList = [];

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
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
            Text("Assign accounts and passwords to administrators",
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
            Spacer(),
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
                role.accountClass = RoleClass.admin;
                role.permissionList.addAll(allPermissionList);
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
