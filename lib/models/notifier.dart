import 'package:flutter/material.dart';

class UnautorizeNevigator with ChangeNotifier {
  String _data = 'Reza!';

  void update(String data) {
    _data = data;
    notifyListeners();
  }

  String get data => _data;
}