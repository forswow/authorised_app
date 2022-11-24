import 'package:authorised_app/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

final tUser = MockUser(
  isAnonymous: false,
  uid: 'T3STU1D',
  email: 'foo@test.com',
);
@GenerateNiceMocks([MockSpec<AuthRepo>()])
Future<void> main() async {
  test('Не возвращает юзера, если он не вошел в систему', () async {
    final auth = MockFirebaseAuth();
    final user = auth.currentUser;
    expect(user, isNull);
  });
  group('Emits юзера при запуске приложения', () {
    test('null если не авторизован', () async {
      final auth = MockFirebaseAuth();
      expect(auth.authStateChanges(), emits(null));
    });
    test('юзер если авторизован', () async {
      final auth = MockFirebaseAuth(signedIn: true);
      expect(auth.authStateChanges(), emitsInOrder([isA<User>()]));
      expect(auth.userChanges(), emitsInOrder([isA<User>()]));
    });
  });

  group('Возвращаем mock нового пользователя', () {
    test('с помощью почты и пароля', () async {
      const email = 'foo@test.com';
      const password = 'some!password';
      final auth = MockFirebaseAuth();
      final result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = result.user!;
      expect(user.email, email);
      expect(auth.authStateChanges(), emitsInOrder([null, isA<User>()]));
      expect(auth.userChanges(), emitsInOrder([null, isA<User>()]));
      expect(user.isAnonymous, isFalse);
    });
  });

  group('Получаем пользователя после авторизации', () {
    test('с учетными данными', () async {
      final auth = MockFirebaseAuth(mockUser: tUser);

      final credential = FakeAuthCredential();
      final result = await auth.signInWithCredential(credential);
      final user = result.user!;
      expect(user, tUser);
      expect(auth.authStateChanges(), emitsInOrder([null, isA<User>()]));
      expect(auth.userChanges(), emitsInOrder([null, isA<User>()]));
      expect(user.isAnonymous, isFalse);
    });

    test('с помощью почты и пароля', () async {
      final auth = MockFirebaseAuth(mockUser: tUser);
      final result = await auth.signInWithEmailAndPassword(
          email: 'foo@testmail.com', password: 'foopassword');
      final user = result.user;
      expect(user, tUser);
      expect(auth.authStateChanges(), emitsInOrder([null, isA<User>()]));
      expect(auth.userChanges(), emitsInOrder([null, isA<User>()]));
    });
  });

  test('Получаем пользователя, если вошли в систему', () async {
    final auth = MockFirebaseAuth(signedIn: true, mockUser: tUser);
    final user = auth.currentUser;
    expect(user, tUser);
  });

  test('Получаем null после выхода', () async {
    final auth = MockFirebaseAuth(signedIn: true, mockUser: tUser);
    final user = auth.currentUser;
    await auth.signOut();
    expect(auth.currentUser, isNull);
    expect(auth.authStateChanges(), emitsInOrder([user, null]));
    expect(auth.userChanges(), emitsInOrder([user, null]));
  });

  test('Вход с помощью пароля и почты', () async {
    final auth = MockFirebaseAuth(
      authExceptions: AuthExceptions(
        signInWithEmailAndPassword: FirebaseAuthException(code: 'bla'),
      ),
    );
    expect(
      () async =>
          await auth.signInWithEmailAndPassword(email: '', password: ''),
      throwsA(isA<FirebaseAuthException>()),
    );
  });

  test('Создание пользователя с помощью пароля и почты', () async {
    final auth = MockFirebaseAuth(
        authExceptions: AuthExceptions(
            createUserWithEmailAndPassword:
                FirebaseAuthException(code: 'bla')));
    expect(
      () async =>
          await auth.createUserWithEmailAndPassword(email: '', password: ''),
      throwsA(isA<FirebaseAuthException>()),
    );
  });
}

class FakeAuthCredential implements AuthCredential {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
