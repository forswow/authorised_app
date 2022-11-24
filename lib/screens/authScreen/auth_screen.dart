import 'auth_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/settings_provider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);
  static const routName = '/auth';

  @override
  Widget build(BuildContext context) {
    final model = context.read<SettingsProvider>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SizedBox(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/sfera.jpg',
                  fit: BoxFit.fitHeight,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: AuthCard(),
                ),
              ]),
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: ToggleButtons(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            selectedBorderColor: Colors.green[700],
            selectedColor: Colors.white,
            fillColor: Colors.green[200],
            color: Colors.green[400],
            constraints: const BoxConstraints(
              minHeight: 40.0,
              minWidth: 80.0,
            ),
            onPressed: (index) => model.changeLanguage(index),
            isSelected: context.watch<SettingsProvider>().selectedLanguage,
            children: context.watch<SettingsProvider>().language),
      ),
    );
  }
}
