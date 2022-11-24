import '../../providers/settings_provider.dart';
import '../../utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    // final model = context.read<SettingsProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.lang,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Flexible(
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
                    onPressed: (index) =>
                        context.read<SettingsProvider>().changeLanguage(index),
                    isSelected:
                        context.watch<SettingsProvider>().selectedLanguage,
                    children: context.watch<SettingsProvider>().language),
              ),
              const Divider(),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context)!.change_theme,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SwitchListTile(
                    title: Text(Shared.getTheme
                        ? AppLocalizations.of(context)!.dark
                        : AppLocalizations.of(context)!.light),
                    value: Shared.getTheme,
                    onChanged: context.read<SettingsProvider>().changeTheme,
                    secondary: Shared.getTheme
                        ? const Icon(Icons.dark_mode)
                        : const Icon(Icons.light_mode),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
