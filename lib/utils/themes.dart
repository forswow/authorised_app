import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Themes {
  static final lightTheme = ThemeData.light().copyWith(
    brightness: Brightness.light,
    useMaterial3: true,
    backgroundColor: const Color(0xffF2F6FC),
    primaryColor: const Color(0xFFECECeC),
    cardColor: const Color(0xffffffff),
    bottomAppBarColor: const Color(0xFFE4F8Ff),
    scaffoldBackgroundColor: const Color(0xFFF2F6FC),
    bottomAppBarTheme: const BottomAppBarTheme(
      color: Colors.white70,
    ),
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
  );
  static final darkTheme = ThemeData.dark().copyWith(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xff0f0f10),
      backgroundColor: const Color(0xff0f0f10),
      primaryColor: const Color(0xff424242),
      cardColor: const Color(0xff3e4042),
      bottomAppBarTheme: BottomAppBarTheme(
        color: Colors.grey.shade700,
      ),
      bottomAppBarColor: const Color(0xFF151515),
      appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          color: Colors.black54));
}
