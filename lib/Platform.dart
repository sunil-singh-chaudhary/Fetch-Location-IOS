import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ios_demo_app/locationchangenotifier.dart';
import 'package:provider/provider.dart';

const platform =  MethodChannel('com.rocky.flutter_location');
const eventChannel = EventChannel('com.location.eventchannel');

  void requestLocationPermission() async {
    const platform = MethodChannel('com.rocky.flutter_location');
    try {
      final bool result = await platform.invokeMethod('requestLocationPermission');
      debugPrint('Location Permission Result: $result');
    } on PlatformException catch (e) {
      debugPrint('Error requesting location permission: ${e.message}');
    }
  }

// Dart code

  void getLocationContiniouslly( BuildContext context) {
    eventChannel.receiveBroadcastStream().listen((event) {

    if (event is Map<dynamic, dynamic>) {
        double latitude = event['latitude'];
        double longitude = event['longitude'];
        debugPrint('Received location update - Latitude: $latitude, Longitude: $longitude');
        // Handle the location data as needed
            Provider.of<NotificationChangeNotifier>(context, listen: false)
        .updateMessage(latitude.toString(), longitude.toString());

      }
    },
    onError: (dynamic error) {
      debugPrint('Error receiving location update: $error');
    },
  );
    
  }
