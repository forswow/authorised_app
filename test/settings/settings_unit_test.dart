import 'package:authorised_app/providers/settings_provider.dart';
import 'package:authorised_app/utils/themes.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings_unit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SettingsProvider>()])
Future<void> main() async {
  late MockSettingsProvider mock;
  late SharedPreferences pref;
  setUp(() async {
    mock = MockSettingsProvider();
  });

  group("Проверка Настроек", () {
    test('темы', () {
      when(mock.theme).thenReturn(Themes.lightTheme);
      expect(mock.theme, Themes.lightTheme);
      when(mock.theme).thenReturn(Themes.darkTheme);
      expect(mock.theme, Themes.darkTheme);
    });

    test("списка языков", () {
      when(mock.locale).thenReturn(const Locale('English'));
      expect(mock.locale, const Locale('English'));

      when(mock.locale).thenReturn(const Locale('Русский'));
      expect(mock.locale, const Locale('Русский'));

      when(mock.locale).thenReturn(const Locale('Français'));
      expect(mock.locale, const Locale('Français'));
    });
  });

  group("Проверка сохранения", () {
    test('английского языка', () async {
      SharedPreferences.setMockInitialValues(
          {'locale': const Locale('en').languageCode});
      pref = await SharedPreferences.getInstance();
      expect(pref.getString('locale'), 'en');
    });
    test('русского языка', () async {
      SharedPreferences.setMockInitialValues(
          {'locale': const Locale('ru').languageCode});
      pref = await SharedPreferences.getInstance();
      expect(pref.getString('locale'), 'ru');
    });
    test('французского языка', () async {
      SharedPreferences.setMockInitialValues(
          {'locale': const Locale('fr').languageCode});
      pref = await SharedPreferences.getInstance();
      expect(pref.getString('locale'), 'fr');
    });
  });
}
