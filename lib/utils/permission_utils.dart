import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  // 麦克风权限
  Future<bool> getMicroPhonePermission() async {
    PermissionStatus status = await Permission.microphone.status;
    if (status.isRestricted || status.isDenied) {
      PermissionStatus requestStatus = await Permission.microphone.request();
      // 返回用户是否授权成功
      return requestStatus.isGranted;
    }

    // 用户已授权或未询问
    return status.isGranted;
  }

  // 存储权限
  Future<void> getStoragePermission() async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    AndroidDeviceInfo android = await plugin.androidInfo;
    if (android.version.sdkInt < 33) {
      if (await Permission.storage.request().isGranted) {
      } else if (await Permission.storage.request().isPermanentlyDenied) {
        await openAppSettings();
      }
    } else {
      if (await Permission.photos.request().isGranted) {
      } else if (await Permission.photos.request().isPermanentlyDenied) {
        await openAppSettings();
      } else if (await Permission.photos.request().isDenied) {}
    }
  }

  // 相机权限
  Future<bool> getCameraPermission() async {
    PermissionStatus status = await Permission.camera.status;
    if (status.isRestricted || status.isDenied) {
      PermissionStatus requestStatus = await Permission.camera.request();
      // 返回用户是否授权成功
      return requestStatus.isGranted;
    }

    // 用户已授权或未询问
    return status.isGranted;
  }

  // 安卓权限
  Future<bool> getInstallPermission() async {
    PermissionStatus status = await Permission.requestInstallPackages.status;
    if (status.isRestricted || status.isDenied) {
      PermissionStatus requestStatus = await Permission.storage.request();
      // 返回用户是否授权成功
      return requestStatus.isGranted;
    }

    // 用户已授权或未询问
    return status.isGranted;
  }

  // 私有构造函数
  PermissionUtils._internal();
  // 保存单例
  static final PermissionUtils _instance = PermissionUtils._internal();
  // 工厂构造函数
  factory PermissionUtils() => _instance;
}
