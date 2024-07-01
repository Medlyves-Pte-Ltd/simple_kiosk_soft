import 'dart:ui';

import 'package:simple_kiosk_software/blocs/locale/locale_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleCubit extends Cubit<LocaleState> {
  Locale locale = const Locale('en');

  LocaleCubit() : super(LocaleState(const Locale('en'))) {
    _loadInitialLocale();
  }

  Future<void> _loadInitialLocale() async {
    // Read system locale
    final Locale systemLocale = PlatformDispatcher.instance.locale;
    await loadLocale(systemLocale);
  }

  Future<void> loadLocale(Locale locale) async {
    this.locale = locale;
    emit(LocaleState(locale));
  }
}
