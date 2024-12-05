import 'dart:convert';
import 'dart:io';
import 'package:flutter_devices_sdk/log/log_printer.dart';
import 'package:simple_kiosk_software/utils/app_config.dart';

// 权限模块
enum PermissionModules {
  // Kiosk管理
  KioskManager,
  // 权限
  Permission,
  // 设备配置
  DeviceConfiguration,
  // 设备诊断
  DeviceDiagnostic,
  // Usb调试
  DeviceUSBDebug,
  // 范围编辑
  RangeSetting,
  // 设备校准
  DeviceCalibration,
  // 继电器
  DeviceUsbRelay,
}

// 角色级别
enum RoleClass { admin, ops }

class PermissionConfig {
  // 角色列表
  List<dynamic> roleList = [];
  int listIndex = -1;
  // 当前角色
  Role curRole = Role();

  Future<void> init() async {
    // 加载配置文件
    await loadFile();
  }

  // 登录判断账号密码
  String login(String account, String password) {
    String errorInfo = "";
    listIndex = -1;

    for (int i = 0; i < roleList.length; ++i) {
      if (roleList[i]["account"] as String == account) {
        if (roleList[i]["password"] as String == password) {
          // 枚举转字符串
          curRole.accountClass =
              RoleClass.values.byName(roleList[i]["account_class"]);
          curRole.account = account;
          curRole.password = password;
          curRole.permissionList =
              roleList[i]["permission_list"] as List<dynamic>;
        } else {
          errorInfo = 'Error: account $account password incorrect';
          LogPrinter.log(errorInfo);
          return errorInfo;
        }
        listIndex = i;
        break;
      }
    }

    if (listIndex < 0) {
      errorInfo = 'Error: no $account';
      LogPrinter.log(errorInfo);
      return errorInfo;
    }

    return errorInfo;
  }

  // 有无权限
  bool havePermission(PermissionModules module) {
    return curRole.permissionList.contains(module.name);
  }

  // 修改密码
  Future<String> modifyPassword(String newPassword) async {
    String errorInfo = "";
    if (listIndex < 0) {
      errorInfo = 'Error: no login';
      LogPrinter.log(errorInfo);
      return errorInfo;
    }

    curRole.password = newPassword;
    roleList[listIndex]["password"] = newPassword;
    errorInfo = await saveFile();
    return errorInfo;
  }

  // 添加角色
  Future<String> addRole(Role role) async {
    String errorInfo = "";
    if (!roleList.any((v) => v["account"] as String == role.account)) {
      errorInfo = 'Error: ${role.account} already exist';
      LogPrinter.log(errorInfo);
      return errorInfo;
    }

    roleList.add(role.toJson());
    LogPrinter.log("add account ${role.account} success");
    errorInfo = await saveFile();
    return errorInfo;
  }

  // 删除角色根据账号
  Future<String> deleteRoleByAccount(String account) async {
    int index = -1;
    String errorInfo = "";

    for (int i = 0; i < roleList.length; ++i) {
      if (roleList[i]["account"] as String == account) {
        roleList.removeAt(i);
        LogPrinter.log("delete account ${account} success");
        index = i;
        break;
      }
    }

    if (index < 0) {
      errorInfo = "Error: delete ${account} failed, ${account} not fount";
      LogPrinter.log(errorInfo);
      return errorInfo;
    }

    errorInfo = await saveFile();
    return errorInfo;
  }

  // 删除角色根据序号
  Future<String> deleteRoleByIndex(int index) async {
    String errorInfo = "";
    if (index < roleList.length && index >= 0) {
      roleList.removeAt(index);
      LogPrinter.log("delete account ${roleList[index]["account"]} success");
    } else {
      errorInfo = "Error: delete failed, index:${index} not valid";
      LogPrinter.log(errorInfo);
      return errorInfo;
    }

    errorInfo = await saveFile();
    return errorInfo;
  }

  // 读文件
  Future<String> loadFile() async {
    var file = File('${AppConfig().configDir}/permission_config.json');
    try {
      String json = await file.readAsString();
      roleList = jsonDecode(json);
    } catch (e) {
      LogPrinter.log('Error: $e');
      return 'Error: $e';
    }
    return "";
  }

  // 写文件
  Future<String> saveFile() async {
    String text = jsonEncode(roleList);
    var file = File('${AppConfig().configDir}/permission_config.json');
    try {
      await file.writeAsString(text);
    } catch (e) {
      LogPrinter.log('Error: $e');
      return "Error: $e";
    }

    return "";
  }

  // 私有构造函数
  PermissionConfig._internal();
  // 保存单例
  static final PermissionConfig _instance = PermissionConfig._internal();
  // 工厂构造函数
  factory PermissionConfig() => _instance;
}

// 角色
class Role {
  RoleClass accountClass = RoleClass.admin;
  String account = "";
  String password = "";
  List<dynamic> permissionList = [];

  Map<String, dynamic> toJson() {
    return {
      "account_class": accountClass.name,
      "account": account,
      "password": password,
      "permission_list": permissionList,
    };
  }
}
