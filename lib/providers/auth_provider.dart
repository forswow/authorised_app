import '../utils/navkey.dart';

import 'package:flutter/widgets.dart';
import '../utils/google_signin_api.dart.dart';

abstract class AuthRepo {
  Future<void> googleLogin();
  Future<void> signIn();
  Future<void> signUp(String email, String password);
  Future<void> login(String email, String password);
  Future<void> logout();
}

class AuthProvider extends ChangeNotifier implements AuthRepo {
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

  @override
  Future googleLogin() async {
    await GoogleSignInApi.signInWithGoogle();
    // await _authLogic(GoogleSignInApi().user.email, GoogleSignInApi().user.id,
    //     'signWithGoogle');
    notifyListeners();
  }

  @override
  Future signIn() async => await GoogleSignInApi.login();

  ///Вызов регистрации аккаунта
  @override
  Future<void> signUp(String email, String password) async =>
      await GoogleSignInApi.signUpWithMail(email: email, password: password);

  ///Вызов авторизации аккаунта
  @override
  Future<void> login(String email, String password) async =>
      await await GoogleSignInApi.signInWithMail(
          email: email, password: password);

  ///Выход из аккаунта
  @override
  Future<void> logout() async {
    GoogleSignInApi.logout();
    NavKey.navigatorKey.currentState?.popUntil((route) => route.isFirst);
  }
}
