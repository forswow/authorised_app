import 'package:shared_preferences/shared_preferences.dart';

class Shared {
  static late SharedPreferences _prefs;

  factory Shared() => Shared._internal();
  Shared._internal();

  static Future<void> init() async =>
      _prefs = await SharedPreferences.getInstance();

  static bool get getTheme => _prefs.getBool('theme') ?? false;
  static set setTheme(bool isDark) => _prefs.setBool('theme', isDark);

  static String get getLocale => _prefs.getString('locale') ?? 'en';
  static set setLocale(String locale) => _prefs.setString('locale', locale);
}
