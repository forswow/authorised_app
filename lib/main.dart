import 'providers/settings_provider.dart';
import 'screens/firstScreen/first_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'utils/dialog_message.dart';
import 'utils/navkey.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'providers/auth_provider.dart';
import 'screens/authScreen/auth_screen.dart';
import 'utils/shared.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Shared.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
      ],
      child: Consumer2<AuthProvider, SettingsProvider>(
        builder: (context, auth, settings, child) => MaterialApp(
          scaffoldMessengerKey: DialogMessage.messageKey,
          navigatorKey: NavKey.navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: settings.theme,
          locale: settings.locale,
          supportedLocales: L10n.all,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          title: 'Authorized G/A',
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasData) {
                return const FirstScreen();
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('Error'),
                );
              }
              return const AuthScreen();
            },
          ),
          routes: {
            FirstScreen.routeName: (ctx) => const FirstScreen(),
            SettingsScreen.routeName: (ctx) => const SettingsScreen(),
          },
        ),
      ),
    );
  }
}
