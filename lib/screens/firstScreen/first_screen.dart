import '../menuDrawer/menu_drawer.dart';
import 'package:flutter/material.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key? key}) : super(key: key);
  static const routeName = '/first';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Screen'),
      ),
      drawer: const MenuDrawer(),
      body: const Center(
        child: Text('First Screen'),
      ),
    );
  }
}
