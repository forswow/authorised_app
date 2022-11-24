import 'dialog_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi {
  static final _googleSignIn = GoogleSignIn();
  static GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();

  static Future signUpWithMail(
          {required String email, required String password}) async =>
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .onError((FirebaseAuthException error, stackTrace) =>
              DialogMessage.showSnackBar(error.code));

  static Future signInWithMail(
          {required String email, required String password}) async =>
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .onError((FirebaseAuthException error, stackTrace) =>
              DialogMessage.showSnackBar(error.code));

  static Future signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
    } on PlatformException catch (errorMessage) {
      DialogMessage.showSnackBar(errorMessage.message);
    }
  }

  static Future<UserCredential> signInWithApple() async {
    final appleProvider = AppleAuthProvider();
    if (kIsWeb) {
      return await FirebaseAuth.instance.signInWithPopup(appleProvider);
    } else {
      return await FirebaseAuth.instance.signInWithProvider(appleProvider);
    }
  }

  static Future<UserCredential> signInWithMicrosoft() async {
    final microsoftProvider = MicrosoftAuthProvider();
    if (kIsWeb) {
      return await FirebaseAuth.instance.signInWithPopup(microsoftProvider);
    } else {
      return await FirebaseAuth.instance.signInWithProvider(microsoftProvider);
    }
  }

  static Future logout() async => _googleSignIn.currentUser != null
      ? await _googleSignIn
          .disconnect()
          .whenComplete(() => FirebaseAuth.instance.signOut())
      : await FirebaseAuth.instance.signOut();
}
