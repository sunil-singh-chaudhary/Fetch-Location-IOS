import 'package:flutter/material.dart';


class NotificationChangeNotifier extends ChangeNotifier {
  String _lat = '0.0';
  String _long = '0.0';
  String get lattitude => _lat;
  String get longitude => _long;
  void updateMessage(String lat, String long) {
    _lat = lat;
     _long = long;
    notifyListeners();
  }
}
