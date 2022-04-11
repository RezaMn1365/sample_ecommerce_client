import 'package:flutter/material.dart';
import 'package:flutter_application_1/helpers/storage/storage_driver.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveStorage extends StorageDriver {
  // late var user;
  @override
  Future<String?> getString(String key) async {
    // await Hive.initFlutter();
    // user = await Hive.openBox('user');
    var user = Hive.box('user');
    String? value = await user.get(key);
    return value;
  }

  @override
  Future<double?> getDouble(String key) async {
    // await Hive.initFlutter();
    // user = await Hive.openBox('user');
    var user = Hive.box('user');
    double? value = await user.get(key);
    return value;
  }

  @override
  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    await Hive.openBox('user');
  }

  @override
  Future<void> putString(String key, String value) async {
    // await Hive.initFlutter();
    // user = await Hive.openBox('user');
    var user = Hive.box('user');
    await user.put(key, value);
  }

  @override
  Future<void> putDouble(String key, double value) async {
    // await Hive.initFlutter();
    // user = await Hive.openBox('user');
    var user = Hive.box('user');
    await user.put(key, value);
  }

  @override
  Future<void> clear() async {
    // await Hive.initFlutter();
    // await Hive.openBox('user');
    var user = Hive.box('user');
    await Hive.box('user').clear();
  }
}
