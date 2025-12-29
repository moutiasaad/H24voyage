import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageChangeProvider with ChangeNotifier {
  Locale _currentLocale = const Locale("en");

  Locale get currentLocale => _currentLocale;

  LanguageChangeProvider() {
    _loadLocale(); // load saved language on start
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('language_code') ?? 'fr';
    _currentLocale = Locale(code);
    notifyListeners();
  }

  Future<void> changeLocale(String locale) async {
    _currentLocale = Locale(locale);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale);

    notifyListeners();
  }
}
