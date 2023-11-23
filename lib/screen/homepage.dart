
import 'package:flutter/material.dart';
import 'package:flutter_ios_demo_app/wrappers/PlatformChannels.dart';
import 'package:provider/provider.dart';

import '../viewmodel/locationchangenotifier.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
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
          child: Text('location IOS/Android -->  lat-> ${notifier.lattitude},long-> ${notifier.longitude}'),
        ),
      ),
    );
  }
  
}
