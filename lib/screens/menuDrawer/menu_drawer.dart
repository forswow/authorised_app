import '../settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(children: [
        DrawerHeader(
          child: Center(
              child: Text(
            AppLocalizations.of(context)!.menu,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          )),
        ),
        ListTile(
          leading: const Icon(
            Icons.settings,
            size: 32,
          ),
          title: Text(
            AppLocalizations.of(context)!.settings,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          onTap: () =>
              Navigator.of(context).pushNamed(SettingsScreen.routeName),
        ),
        ListTile(
          leading: const Icon(
            Icons.exit_to_app,
            size: 32,
          ),
          title: Text(
            AppLocalizations.of(context)!.logout,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          onTap: () => context.read<AuthProvider>().logout(),
        ),
      ]),
    );
  }
}
