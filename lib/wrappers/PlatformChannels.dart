import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../viewmodel/locationchangenotifier.dart';

const methodChannel =  MethodChannel('com.rocky.flutter_location');
const eventChannel = EventChannel('com.location.eventchannel');

  void requestLocationPermission() async {
    try {
      final bool result = await methodChannel.invokeMethod('requestLocationPermission');
      debugPrint('Location Result: $result');
    } on PlatformException catch (e) {
      debugPrint('Error requesting location permission: ${e.message}');
    }
  }


  void getLocationContiniouslly( BuildContext context) {
    eventChannel.receiveBroadcastStream().listen((event) {

    if (event is Map<dynamic, dynamic>) {
        double latitude = event['latitude'];
        double longitude = event['longitude'];
        debugPrint('Received location update - Latitude: $latitude, Longitude: $longitude');
        // TODO: Update lat long to Provider

            Provider.of<NotificationChangeNotifier>(context, listen: false)
        .updateMessage(latitude.toString(), longitude.toString());

      }
    },
    onError: (dynamic error) {
      debugPrint('Flutter side Error receiving location update: $error');
    },
  );
    
  }
