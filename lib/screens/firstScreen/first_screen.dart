import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key? key}) : super(key: key);
  static const routeName = '/first';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Screen'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<Auth>().logout();
            },
            icon: Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: Center(
        child: Text('First Screen'),
      ),
    );
  }
}
