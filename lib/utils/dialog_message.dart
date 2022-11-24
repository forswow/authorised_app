import 'package:flutter/material.dart';

class DialogMessage {
  static final messageKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String? errorCode) {
    if (errorCode == null) return;
    final snackBar = SnackBar(content: Text(_errorMessage(errorCode)));
    messageKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static String _errorMessage(String code) {
    switch (code) {
      case "invalid-email":
        return "Your email address appears to be malformed.";

      case "wrong-password":
        return "Your password is wrong.";

      case "user-not-found":
        return "User with this email doesn't exist.";

      case "user-disabled":
        return "User with this email has been disabled.";

      case "too-many-requests":
        return "Too many requests. Try again later.";

      case "operation-not-allowed":
        return "Signing in with Email and Password is not enabled.";

      default:
        return "An undefined Error happened.";
    }
  }
}
