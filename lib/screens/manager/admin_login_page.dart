import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_devices_sdk/view/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminLoginPage extends StatefulWidget {
  @override
  AdminLoginPageState createState() => AdminLoginPageState();
}

class AdminLoginPageState extends State<AdminLoginPage> {
  late final TextEditingController _accountController;
  late final TextEditingController _passwordController;
  // 管理员默认的账号和密码
  // Administrator's default account and password
  final _defaultAccount = 'admin';
  final _defaultPassword = '666666';

  String _account = ''; // 账号
  String _password = ''; // 密码
  // 屏幕宽度
  double width = 0;
  // 屏幕高度
  double height = 0;

  @override
  void initState() {
    super.initState();
    _accountController = TextEditingController(text: _account);
    _passwordController = TextEditingController(text: _password);
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return renderBody();
  }

  Widget renderBody() {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/admin_head.png'),
                radius: height * 0.05,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              SizedBox(
                height: height * 0.06,
                child: _getAccountInput(width),
              ),
              SizedBox(
                height: height * 0.06,
                child: _getPasswordInput(width),
              ),
              _getLoginButton(width)
            ],
          ),
        ));
  }

  Widget _getLoginButton(double width) {
    return Container(
      height: height * 0.04,
      width: width * 0.3,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ColorPalette.materialGreen,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor:
              MaterialStateProperty.all<Color>(ColorPalette.materialGreen),
        ),
        onPressed: onLogin,
        child: Text(
          'Login',
          style: TextStyle(fontSize: height * 0.018),
        ),
      ),
    );
  }

  void onLogin() async {
    _password = _password.trim();
    _account = _account.trim();

    if (_account.isEmpty) {
      Fluttertoast.showToast(msg: "The account cannot be empty");
      return;
    }

    if (_password.isEmpty) {
      Fluttertoast.showToast(msg: "Password cannot be empty");
      return;
    }

    if (_defaultAccount != _account) {
      Fluttertoast.showToast(
        msg: "The administrator account is incorrect",
      );
      return;
    }

    if (_defaultPassword != _password) {
      Fluttertoast.showToast(
        msg: "The administrator password is incorrect",
      );
      return;
    }

    Navigator.pushNamedAndRemoveUntil(
        context, '/SettingListPage', ((route) => false));
  }

  Widget _getInputTextField(
    double width,
    TextInputType keyboardType, {
    List<TextInputFormatter>? inputFormatters,
    FocusNode? focusNode,
    controller = TextEditingController,
    onChanged = Function,
    InputDecoration? decoration,
    bool obscureText = false,
    height = 50.0,
  }) {
    return Container(
      height: height,
      width: width,
      margin: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          TextField(
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
            focusNode: focusNode,
            obscureText: obscureText,
            controller: controller,
            decoration: decoration,
            onChanged: onChanged,
          ),
          Divider(
            height: 1.0,
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }

  Widget _getAccountInput(double width) {
    return _getInputTextField(
      width,
      TextInputType.text,
      inputFormatters: [
        LengthLimitingTextInputFormatter(11),
        FilteringTextInputFormatter.allow(
          // 仅支持字母数字
          RegExp("[a-zA-Z]|[0-9]"),
        ),
        // 禁止输入空格
        FilteringTextInputFormatter.deny(
          RegExp(r"[\\s]"),
        )
      ],
      controller: _accountController,
      decoration: InputDecoration(
        hintText: "Administrator account",
        hintStyle: TextStyle(fontSize: height * 0.015),
        icon: Icon(
          Icons.person,
          size: height * 0.03,
        ),
        border: InputBorder.none,
        //使用 GestureDetector 实现手势识别
        suffixIcon: GestureDetector(
          child: Offstage(
            offstage: _account == '',
            child: const Icon(Icons.clear),
          ),
          //点击清除文本框内容
          onTap: () {
            setState(() {
              _account = '';
              _accountController.clear();
            });
          },
        ),
      ),
      //使用 onChanged 完成双向绑定
      onChanged: (value) {
        setState(() {
          _account = value;
        });
      },
    );
  }

  Widget _getPasswordInput(double width) {
    return _getInputTextField(
      width,
      TextInputType.text,
      inputFormatters: [
        LengthLimitingTextInputFormatter(20),
        FilteringTextInputFormatter.allow(
          // 支持字母和数字
          RegExp("[a-zA-Z]|[0-9]"),
        )
      ],
      obscureText: true,
      controller: _passwordController,
      decoration: InputDecoration(
        hintText: "Password (6-20 letters, numbers)",
        hintStyle: TextStyle(fontSize: height * 0.015),
        icon: Icon(
          Icons.lock,
          size: height * 0.03,
        ),
        suffixIcon: GestureDetector(
          child: Offstage(
            offstage: _password == '',
            child: const Icon(Icons.clear),
          ),
          onTap: () {
            setState(() {
              _password = '';
              _passwordController.clear();
            });
          },
        ),
        border: InputBorder.none,
      ),
      onChanged: (value) {
        setState(() {
          _password = value;
        });
      },
    );
  }
}
