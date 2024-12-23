import 'package:flutter/material.dart';
import 'package:simple_kiosk_software/screens/manager/device_manger/calibration/weight_calibration.dart';
import 'package:simple_kiosk_software/screens/manager/device_manger/device_config_page.dart';
import 'package:simple_kiosk_software/screens/manager/device_manger/device_relate_setting_page.dart';
import 'package:simple_kiosk_software/screens/manager/device_manger/device_usb_relay_page.dart';
import 'package:simple_kiosk_software/screens/manager/general/modify_password_page.dart';
import 'package:simple_kiosk_software/screens/manager/general/permission/permission_config_page.dart';
import 'package:simple_kiosk_software/screens/manager/device_manger/device_reading_range_edit_page.dart';
import 'package:simple_kiosk_software/screens/measurement_pages/blood_fit_measure.dart';
import 'package:simple_kiosk_software/screens/measurement_pages/blood_glucose_measure.dart';
import 'package:simple_kiosk_software/screens/measurement_pages/blood_oxygen_measure.dart';
import 'package:simple_kiosk_software/screens/measurement_pages/blood_pressure_measure.dart';
import 'package:simple_kiosk_software/screens/measurement_pages/body_composition_measure.dart';
import 'package:simple_kiosk_software/screens/measurement_pages/ecg_measure.dart';
import 'package:simple_kiosk_software/screens/scanner_page.dart';
import 'package:simple_kiosk_software/screens/summary_pages/summary_layout_widget.dart';
import 'package:simple_kiosk_software/screens/device_start_page.dart';
import 'package:simple_kiosk_software/screens/manager/device_manger/device_diagnostic_page.dart';
import 'package:simple_kiosk_software/screens/user_login_page.dart';
import 'package:simple_kiosk_software/screens/language/language_page.dart';
import 'package:simple_kiosk_software/screens/manager/kiosk_manager/kiosk_manager.dart';
import 'package:simple_kiosk_software/screens/measurement_pages/height_weight_measure.dart';
import 'package:simple_kiosk_software/screens/measurement_pages/body_temperature_measure.dart';
import 'package:simple_kiosk_software/screens/manager/setting_list_page.dart';
import 'package:flutter_devices_sdk/view/usb_info/usb_info_page.dart';
import 'manager/device_manger/calibration/calibration_setting_list_page.dart';
import 'manager/device_manger/calibration/height_calibration_page.dart';
import 'manager/device_manger/device_manger_setting_list_page.dart';
import 'manager/general/general_setting_list_page.dart';

// 如果需要从构造函数中获取参数,使用如下
// If you need to obtain parameters from a constructor, use the following
// "/summary": (context, {arguments}) => MeasurementScreen(arguments: arguments),
// MeasurementScreen(Map<String, dynamic> arguments)
// Navigator.pushNamed(context, "/summary", arguments: {'type': 1})

// 定义路由列表
// Define routing list
final Map<String, Function> routes = {
  '/LanguagePage': (context, {arguments}) => const LanguagePage(),
  '/login': (context, {arguments}) => const UserLoginPage(),
  '/KioskManager': (context, {arguments}) => KioskManager(),
  '/HeightWeightMeasure': (context, {arguments}) => HeightWeightMeasure(),
  '/BodyTemperatureMeasure': (context, {arguments}) => BodyTemperatureMeasure(),
  '/BloodOxygenMeasure': (context, {arguments}) => BloodOxygenMeasure(),
  '/BloodPressureMeasure': (context, {arguments}) => BloodPressureMeasure(),
  '/BodyCompositionMeasure': (context, {arguments}) => BodyCompositionMeasure(),
  '/BloodFitMeasure': (context, {arguments}) => BloodFitMeasure(),
  '/BloodGlucoseMeasure': (context, {arguments}) => BloodGlucoseMeasure(),
  '/Summary': (context, {arguments}) => SummaryLayoutWidget(),
  '/ScannerPage': (context, {arguments}) => ScannerPage(),
  '/ECGMeasure': (context, {arguments}) => ECGMeasure(),
  '/DeviceStartPage': (context, {arguments}) => DeviceStartPage(),
  '/DeviceDiagnosticPage': (context, {arguments}) => DeviceDiagnosticPage(),
  '/SettingListPage': (context, {arguments}) => SettingListPage(),
  '/UsbInfoPage': (context, {arguments}) => UsbInfoPage(),
  '/DeviceReadingRangeEditPage': (context, {arguments}) =>
      DeviceReadingRangeEditPage(),
  '/DeviceConfigPage': (context, {arguments}) => DeviceConfigPage(),
  '/ModifyPasswordPage': (context, {arguments}) => ModifyPasswordPage(),
  '/PermissionConfigPage': (context, {arguments}) => PermissionConfigPage(),
  '/CalibrationSettingListPage': (context, {arguments}) =>
      CalibrationSettingListPage(),
  '/HeightCalibrationPage': (context, {arguments}) => HeightCalibrationPage(),
  '/GeneralSettingListPage': (context, {arguments}) => GeneralSettingListPage(),
  '/DeviceMangerSettingListPage': (context, {arguments}) =>
      DeviceMangerSettingListPage(),
  '/DeviceUsbRelayPage': (context, {arguments}) => DeviceUsbRelayPage(),
  '/WeightCalibration': (context, {arguments}) => WeightCalibration(),
  '/DeviceRelateSettingPage': (context, {arguments}) =>
      DeviceRelateSettingPage(),
};

// 定义通用的onGenerateRoute
// Define a universal onGenerateRoute
var onCustomGenerateRoute = (RouteSettings settings) {
  String? routeName = settings.name;
  Function? pageContentBuilder = routes[routeName];
  Object? args = settings.arguments;
  if (pageContentBuilder != null) {
    if (args != null) {
      final Route route = MaterialPageRoute(builder: (context) {
        return pageContentBuilder(context, arguments: args);
      });
      return route;
    } else {
      return MaterialPageRoute(
          builder: (context) => pageContentBuilder(context));
    }
  }
};
