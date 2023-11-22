// main.dart


import 'package:flutter/material.dart';
import 'package:flutter_ios_demo_app/Platform.dart';
import 'package:flutter_ios_demo_app/locationchangenotifier.dart';
import 'package:provider/provider.dart';

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  void initState() {
    super.initState();
    requestLocationPermission();
    getLocationContiniouslly(context);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Location Updates'),
      ),
      body: Consumer<NotificationChangeNotifier>(
        builder: (context, notifier, child) =>
         Center(
          child: Text(' location IOS -->  ${notifier.lattitude}, ${notifier.longitude}'),
        ),
      ),
    );
  }
  
}
