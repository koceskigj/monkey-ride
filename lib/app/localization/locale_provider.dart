import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;
  bool get isEnglish => _locale.languageCode == 'en';
  bool get isMacedonian => _locale.languageCode == 'mk';

  void toggleLocale() {
    _locale = _locale.languageCode == 'en'
        ? const Locale('mk')
        : const Locale('en');
    notifyListeners();
  }

  void setLocale(Locale locale) {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
  }
}