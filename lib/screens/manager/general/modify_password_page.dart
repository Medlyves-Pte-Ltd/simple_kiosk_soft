import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_devices_sdk/log/log_printer.dart';
import 'package:flutter_devices_sdk/view/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_kiosk_software/common/footer.dart';
import 'package:simple_kiosk_software/utils/permission_config.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class ModifyPasswordPage extends StatefulWidget {
  const ModifyPasswordPage({super.key});

  @override
  ModifyPasswordPageState createState() => ModifyPasswordPageState();
}

class ModifyPasswordPageState extends State<ModifyPasswordPage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  String _oldPassword = ''; // 旧密码
  String _newPassword = ''; // 新密码

  // 屏幕宽度
  double width = 0;
  // 屏幕高度
  double height = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Change Password'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.1,
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
              leftIcon: const Icon(Icons.password),
              leftLabel: '',
              contentAlignment: TextAlign.left,
              controller: _oldPasswordController,
              backgroundColor: Colors.white,
              hintText: 'Old password (6-20 letters, numbers)',
              hintTextStyle: TextStyle(fontSize: height * 0.015),
              onChanged: (text) {
                _oldPassword = text;
                setState(() {});
              },
              onClearTap: () {
                _oldPasswordController.clear();
                setState(() {});
              },
            ),
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
              leftIcon: const Icon(Icons.password),
              leftLabel: '',
              contentAlignment: TextAlign.left,
              controller: _newPasswordController,
              backgroundColor: Colors.white,
              hintText: 'New password (6-20 letters, numbers)',
              hintTextStyle: TextStyle(fontSize: height * 0.015),
              onChanged: (text) {
                _newPassword = text;
                setState(() {});
              },
              onClearTap: () {
                _newPasswordController.clear();
                setState(() {});
              },
            ),
            SizedBox(
              height: height * 0.01,
            ),
            ElevatedButton(
              onPressed: onModify,
              child: Text('Modify'),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            const Spacer(),
            Footer(),
          ],
        ),
      ),
    );
  }

  void onModify() async {
    String errorInfo = "";

    if (_oldPassword.isEmpty) {
      Fluttertoast.showToast(msg: "The old password cannot be empty");
      return;
    }

    if (PermissionConfig().curRole.password != _oldPassword) {
      errorInfo = "Modification failed, original password is incorrect";
      LogPrinter.log(errorInfo);
      Fluttertoast.showToast(msg: errorInfo);
      return;
    }

    if (_newPassword.isEmpty) {
      Fluttertoast.showToast(msg: "The new password cannot be empty");
      return;
    }

    if (_newPassword.length < 6 || _newPassword.length > 20) {
      Fluttertoast.showToast(msg: "Password (6-20 letters, numbers)");
      return;
    }

    errorInfo = await PermissionConfig().modifyPassword(_newPassword);
    if (errorInfo.isEmpty) {
      Fluttertoast.showToast(msg: "Modified successfully");
    } else {
      Fluttertoast.showToast(msg: "Modification failed");
    }
  }
}
