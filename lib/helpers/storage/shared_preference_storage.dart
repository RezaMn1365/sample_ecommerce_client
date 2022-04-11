import 'package:flutter/material.dart';
import 'package:flutter_application_1/helpers/storage/storage_driver.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceStorage extends StorageDriver {
  late SharedPreferences _preferences;

  @override
  Future<String?> getString(String key) async {
    _preferences = await SharedPreferences?.getInstance();
    return _preferences.getString(key);
  }

  @override
  Future<double?> getDouble(String key) async {
    _preferences = await SharedPreferences?.getInstance();
    return _preferences.getDouble(key);
  }

  @override
  Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    // await Future.delayed(Duration(seconds: 2));
    await SharedPreferences?.getInstance();
    //return _preferences;
  }

  @override
  Future<void> putString(String key, String value) async {
    _preferences = await SharedPreferences?.getInstance();
    await _preferences.setString(key, value);
  }

  @override
  Future<void> putDouble(String key, double value) async {
    _preferences = await SharedPreferences?.getInstance();
    await _preferences.setDouble(key, value);
  }

  @override
  Future<void> clear() async {
    _preferences = await SharedPreferences?.getInstance();
    await _preferences.clear();
  }
}
