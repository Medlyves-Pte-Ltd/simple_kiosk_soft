import 'package:flutter/material.dart';
import 'package:simple_kiosk_software/screens/measurement_screen.dart';
import 'package:simple_kiosk_software/screens/summary_screen.dart';
import 'package:simple_kiosk_software/screens/user_login.dart';
import 'package:simple_kiosk_software/screens/language/language_page.dart';
import 'package:simple_kiosk_software/screens/kiosk_manager.dart';

// 如果需要从构造函数中获取参数,使用如下
// If you need to obtain parameters from a constructor, use the following
// "/summary": (context, {args}) => MeasurementScreen(args: args),
// MeasurementScreen(Map<String, dynamic> args)
// Navigator.pushNamed(context, "/summary", args: {'type': 1})

// 定义路由列表
// Define routing list
final Map<String, Function> routes = {
  '/': (context, {args}) => const LanguagePage(),
  '/login': (context, {args}) => const UserLogin(),
  '/measurement': (context, {args}) => const MeasurementScreen(),
  '/summary': (context, {args}) => const SummaryScreen(),
  '/kiosk_manager': (context, {args}) => KioskManager()
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
