import 'package:flutter/foundation.dart';
import 'package:flutter_devices_sdk/devices/device_config.dart';
import 'package:flutter_devices_sdk/project_type.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:simple_kiosk_software/blocs/locale/locale_bloc.dart';
import 'package:simple_kiosk_software/blocs/locale/locale_state.dart';
import 'package:simple_kiosk_software/blocs/device/device_bloc.dart';
import 'package:simple_kiosk_software/screens/route_manager.dart';
import 'package:simple_kiosk_software/utils/permission_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 检查权限
  await PermissionUtils().getStoragePermission();
  await PermissionUtils().getCameraPermission();
  await PermissionUtils().getMicroPhonePermission();

  // // 设备初始化
  // await DeviceConfig().clearDeviceConfigStorage();
  // await DeviceConfig().init(ProjectType.simple_kiosk_software);
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<DeviceBloc>(
        create: (context) => DeviceBloc(),
      ),
      BlocProvider<LocaleCubit>(
        create: (context) => LocaleCubit(),
      ),
    ],
    child: MyApp(),
  ));
  // 设置应用程序只支持竖屏方向
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // 隐藏系统状态栏和导航栏
  // Hides the system status bar and navigation bar
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: state.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          onGenerateRoute: onCustomGenerateRoute,
          //initialRoute: "/LanguagePage",
          //initialRoute: "/DevicePage",
          //initialRoute: "/Summary",
          //initialRoute: "/KioskManager",
          //initialRoute: "/HeightWeightMeasure",
          initialRoute: "/TestDevice",
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            textTheme: GoogleFonts.robotoTextTheme(textTheme).copyWith(
              bodyMedium: GoogleFonts.roboto(
                  textStyle: textTheme.bodyMedium), //measurement readings text
              labelMedium: GoogleFonts.roboto(
                  textStyle: textTheme.labelMedium), //navigation button text
              titleSmall: GoogleFonts.roboto(
                  textStyle: textTheme.titleSmall), //widget title
              titleLarge: GoogleFonts.roboto(
                  textStyle: textTheme
                      .titleLarge), //Selection buttons and Header titles
              titleMedium: GoogleFonts.roboto(
                  textStyle: textTheme.titleMedium), //Get Started button
            ),
          ),
          builder: (context, child) => ResponsiveWrapper.builder(
            child,
            maxWidth: 1200,
            minWidth: 420,
            defaultScale: true,
            breakpoints: [
              const ResponsiveBreakpoint.resize(600, name: MOBILE),
            ],
            mediaQueryData: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.02)),
          ),
        );
      },
    );
  }
}
