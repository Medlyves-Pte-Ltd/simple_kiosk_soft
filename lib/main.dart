import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_devices_sdk/log/log_printer.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:simple_kiosk_software/remote/blocs/appointment/appointment_bloc.dart';
import 'package:simple_kiosk_software/blocs/locale/locale_bloc.dart';
import 'package:simple_kiosk_software/blocs/locale/locale_state.dart';
import 'package:simple_kiosk_software/blocs/device/device_bloc.dart';
import 'package:simple_kiosk_software/remote/blocs/liveness/liveness_bloc.dart';
import 'package:simple_kiosk_software/remote/blocs/teleconsultation/teleconsultation_bloc.dart';
import 'package:simple_kiosk_software/remote/config/firebase_options.dart';
import 'package:simple_kiosk_software/remote/repositories/appointment_repository.dart';
import 'package:simple_kiosk_software/remote/teleconsultation/tc_page.dart';
import 'package:simple_kiosk_software/remote/vitals/viewmodels/vital_measurement_controller.dart';
import 'package:simple_kiosk_software/screens/route_manager.dart';
import 'package:simple_kiosk_software/remote/services/appointment_api.dart';
import 'package:simple_kiosk_software/utils/app_config.dart';
import 'package:simple_kiosk_software/utils/kiosk_config.dart';
import 'package:simple_kiosk_software/utils/permission_utils.dart';
import 'package:simple_kiosk_software/remote/utils/shared_prefs.dart';
import 'package:simple_kiosk_software/utils/shared_preferences.dart';
import 'package:screen_brightness/screen_brightness.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesUtil.init();
  // 检查权限
  await PermissionUtils().getStoragePermission();
  await PermissionUtils().getCameraPermission();
  await PermissionUtils().getMicroPhonePermission();
  await PermissionUtils().getManageExternalStoragePermission();
  // app配置初始化
  await AppConfig().init();
  await KioskConfig().init();

  SharedPrefs.setData('appointmentId', "");

  final appointmentRepository = AppointmentRepository(AppointmentApi());
  final AppointmentBloc appointmentBloc =
      AppointmentBloc(appointmentRepository);
  final DeviceBloc deviceBloc = DeviceBloc(appointmentBloc);
  final TeleconsultationBloc teleconsultationBloc =
      TeleconsultationBloc(deviceBloc, appointmentRepository);
  final LivenessBloc livenessBloc = LivenessBloc();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<VitalMeasurementsController>(
          create: (context) => VitalMeasurementsController(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => appointmentBloc,
          ),
          BlocProvider(
            create: (context) => teleconsultationBloc,
          ),
          BlocProvider<DeviceBloc>(
            create: (context) => deviceBloc,
          ),
          BlocProvider(
            create: (context) => livenessBloc,
          ),
          BlocProvider<LocaleCubit>(
            create: (context) => LocaleCubit(),
          ),
        ],
        child: FlutterSizer(builder: (context, orientation, screenType) {
          return MyApp();
        }),
      ),
    ),
  );
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
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Timer? _timer;
  int _counter = 0;

  @override
  void initState() {
    super.initState();

    if (AppConfig().ecoMode) {
      setSystemScreenBrightness(0.9);
      _startTimer();
    }
  }

  @override
  void dispose() {
    if (AppConfig().ecoMode) {
      _timer?.cancel();
    }

    super.dispose();
  }

  Future<void> setSystemScreenBrightness(double brightness) async {
    try {
      await ScreenBrightness.instance.setSystemScreenBrightness(brightness);
    } catch (e) {
      LogPrinter.log("set system brightness failed : " + e.toString());
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (Timer timer) {
      setState(() {
        _counter++;
        if (_counter == AppConfig().ecoModeTimeMinute) {
          setSystemScreenBrightness(0.01);
          timer.cancel();
          LogPrinter.log(
              "user does not operate for a long time, the screen darkens and the timer stops");
        }
      });
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _counter = 0;
    });
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () async {
            if (AppConfig().ecoMode) {
              _resetTimer();
              await setSystemScreenBrightness(0.9);
            }
          },
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: state.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            onGenerateRoute: (settings) {
              if (settings.name == "/TCMeetingScreen") {
                final args = settings.arguments as Map<String, dynamic>?;
                return MaterialPageRoute(
                  builder: (_context) => BlocProvider(
                    create: (_) => TeleconsultationBloc(_context.read(),
                        AppointmentRepository(AppointmentApi())),
                    child: TCMeetingScreen(arguments: args),
                  ),
                );
              } else {
                return onCustomGenerateRoute(settings);
              }
            },
            //initialRoute: "/LanguagePage",
            initialRoute: "/DeviceStartPage",
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ThemeData(
              textTheme: GoogleFonts.robotoTextTheme(textTheme).copyWith(
                bodyMedium: GoogleFonts.roboto(
                    textStyle:
                        textTheme.bodyMedium), //measurement readings text
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
          ),
        );
      },
    );
  }
}
