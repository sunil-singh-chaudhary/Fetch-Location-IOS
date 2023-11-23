// main.dart


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'viewmodel/locationchangenotifier.dart';
import 'screen/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return   MaterialApp(
      home:  ChangeNotifierProvider(
                create: (context) => NotificationChangeNotifier(),
        child: const MyHomePage()),
    );
  }
}
