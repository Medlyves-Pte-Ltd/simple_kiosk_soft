import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:simple_kiosk_software/blocs/locale/locale_bloc.dart';
import 'package:simple_kiosk_software/blocs/locale/locale_state.dart';
import 'package:simple_kiosk_software/blocs/device/device_bloc.dart';
import 'package:flutter_devices_sdk/devices/device_config.dart';
import 'package:simple_kiosk_software/screens/route_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DeviceConfig().init();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<DeviceBloc>(
        create: (context) => DeviceBloc(),
      ),
      BlocProvider<LocaleCubit>(
        create: (context) => LocaleCubit(),
      ),
    ],
    child: const MyApp(
      key: Key("root"),
    ),
  ));

  // 隐藏系统状态栏和导航栏
  // Hides the system status bar and navigation bar
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          //initialRoute: "/",
          initialRoute: "/HeightWeightMeasure",
          //initialRoute: "/BodyTemperatureMeasure",
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
