import '../l10n/l10n.dart';
import '../utils/shared.dart';
import '../utils/themes.dart';
import 'package:flutter/material.dart';

abstract class SettingsRepo {
  void changeLanguage(int index) {}
  void setLocale(Locale locale) {}
  void changeTheme(bool isDark) {}
}

class SettingsProvider extends ChangeNotifier implements SettingsRepo {
  Locale? _locale;

  List<Text> language = [
    const Text("English"),
    const Text('Русский'),
    const Text('Français'),
  ];
  List<bool> selectedLanguage = [
    Shared.getLocale == 'en',
    Shared.getLocale == 'ru',
    Shared.getLocale == 'fr',
  ];

  @override
  void changeLanguage(int index) {
    for (int i = 0; i < L10n.all.length; i++) {
      selectedLanguage[i] = i == index;
    }
    setLocale(L10n.all[index]);
    notifyListeners();
  }

  Locale? get locale {
    var loc = L10n.all
        .firstWhere((element) => element.languageCode == Shared.getLocale);
    return _locale = loc;
  }

  @override
  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;
    _locale = locale;
    Shared.setLocale = locale.languageCode;
    notifyListeners();
  }

  ThemeData get theme => Shared.getTheme ? Themes.darkTheme : Themes.lightTheme;

  @override
  void changeTheme(bool value) {
    Shared.setTheme = value;
    notifyListeners();
  }
}
