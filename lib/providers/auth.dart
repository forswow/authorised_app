import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/httpException.dart/http_exception.dart';

class Auth extends ChangeNotifier {
  static const apiKey = 'AIzaSyCu0egwVGHbLhgZ1DYV4dDPkPry-shjoUA';

  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  bool get isAuth => token != null;

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token!;
    }
    return null;
  }

  String? get userId => _userId;

  Future<void> _authLogic(String email, String password, String segment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$segment?key=$apiKey');
    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      var body = jsonDecode(response.body);
      if (body['error'] != null) {
        throw HttpException(body['error']['message']);
      }
      _token = body['idToken'];
      _userId = body['localId'];
      _expiryDate = DateTime.now().add(
        Duration(seconds: int.parse(body['expiresIn'])),
      );
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = jsonEncode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate?.toIso8601String()
      });
      await prefs.setString('userData', userData);
    } catch (e) {
      rethrow;
    }
  }

  ///Вызов регистрации аккаунта
  Future<void> signUp(String email, String password) async =>
      await _authLogic(email, password, 'signUp');

  ///Вызов авторизации аккаунта
  Future<void> login(String email, String password) async =>
      await _authLogic(email, password, 'signInWithPassword');

  ///Автоматическая авторизация
  ///
  ///Проверяем по ключу есть ли сохранненые данные в локальном хранилище
  ///
  ///Если нет, то возвращаем [false]
  ///
  ///Иначе извлекаем данные из локального хранилища
  ///
  ///Если сохранненая дата времени до текущего времени, то возвращаем [false]
  ///
  ///Передаем сохранненую информацию в токен, юзер айди и в дату времени
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extactedUserData =
        jsonDecode(prefs.getString('userData')!) as Map<String, dynamic>;
    final expiryData = DateTime.parse(extactedUserData['expiryDate'] as String);

    if (expiryData.isBefore(DateTime.now())) {
      return false;
    }
    _token = extactedUserData['token'] as String;
    _userId = extactedUserData['userId'] as String;
    _expiryDate = expiryData;
    notifyListeners();
    return true;
  }

  ///Выход из аккаунта
  Future<void> logout() async {
    _token = '';
    _userId = '';
    _expiryDate = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
  }
}
