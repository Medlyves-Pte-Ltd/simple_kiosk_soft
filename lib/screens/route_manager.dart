import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_kiosk_software/blocs/device/debug_device_bloc.dart';
import 'package:simple_kiosk_software/remote/blocs/teleconsultation/teleconsultation_bloc.dart';
import 'package:simple_kiosk_software/remote/repositories/appointment_repository.dart';
import 'package:simple_kiosk_software/remote/services/appointment_api.dart';
import 'package:simple_kiosk_software/screens/measurement_pages/blood_fit_measure.dart';
import 'package:simple_kiosk_software/screens/measurement_pages/blood_glucose_measure.dart';
import 'package:simple_kiosk_software/screens/measurement_pages/blood_oxygen_measure.dart';
import 'package:simple_kiosk_software/screens/measurement_pages/blood_pressure_measure.dart';
import 'package:simple_kiosk_software/screens/measurement_pages/body_composition_measure.dart';
import 'package:simple_kiosk_software/screens/measurement_pages/ecg_measure.dart';
import 'package:simple_kiosk_software/screens/scanner_page.dart';
import 'package:simple_kiosk_software/screens/summary_pages/summary_layout_widget.dart';
import 'package:simple_kiosk_software/screens/device_page.dart';
import 'package:simple_kiosk_software/screens/test_device.dart';
import 'package:simple_kiosk_software/screens/user_login.dart';
import 'package:simple_kiosk_software/screens/language/language_page.dart';
import 'package:simple_kiosk_software/screens/kiosk_manager.dart';
import 'package:simple_kiosk_software/screens/measurement_pages/height_weight_measure.dart';
import 'package:simple_kiosk_software/screens/measurement_pages/body_temperature_measure.dart';
import 'package:simple_kiosk_software/remote/teleconsultation/tc_page.dart';

// 如果需要从构造函数中获取参数,使用如下
// If you need to obtain parameters from a constructor, use the following
// "/summary": (context, {arguments}) => MeasurementScreen(arguments: arguments),
// MeasurementScreen(Map<String, dynamic> arguments)
// Navigator.pushNamed(context, "/summary", arguments: {'type': 1})

// 定义路由列表
// Define routing list
final Map<String, Function> routes = {
  '/LanguagePage': (context, {arguments}) => const LanguagePage(),
  '/login': (context, {arguments}) => const UserLogin(),
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
  '/DevicePage': (context, {arguments}) => DevicePage(),
  '/TestDevice': (context, {arguments}) => TestDevice(),
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
