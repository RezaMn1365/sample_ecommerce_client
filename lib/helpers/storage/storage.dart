import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/helpers/storage/hive_storage.dart';
import 'package:flutter_application_1/helpers/storage/storage_driver.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'shared_preference_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//REQUIRED FIELDS
//const String KEY_USERNAME = 'USERNAME';
const String KEY_FIRSTNAME = 'FIRSTNAME';
const String KEY_LASTNAME = 'LASTNAME';
const String KEY_PASSWORD = 'PASSWORD';
const String KEY_PASSWORD2 = 'PASSWORD2';
const String KEY_EMAIL = 'EMAIL';

//OPTIONAL FIELDS
const String KEY_PHONE = 'PHONE';
const String KEY_NATIONALID = 'NATIONALID';
const String KEY_COUNTRY = 'COUNTRY';
const String KEY_PROVINCE = 'PROVINCE';
const String KEY_CITY = 'CITY';
const String KEY_ADDRESS = 'ADDRESS';
const String KEY_ZIP = 'ZIP';
const String KEY_LOCATION = 'LOCATION';
const String KEY_SOCIALMEDIA = 'SOCIALMEDIA';

const String KEY_ACCESSTOKEN = 'ACCESSTOKEN';
const String KEY_REFERESHTOKEN = 'REFERESHTOKEN';

const String KEY_HIVE_SECURE_TOKEN_BOX = 'KEY_HIVE_SECURE_TOKEN_BOX';

const String KEY_ACCESSTOKENT = 'ACCESSTOKENT';
const String KEY_REFERESHTOKENT = 'REFERESHTOKENT';
const String KEY_EXPIRTY_MILLIS = 'EXPIRTY_MILLIS';

const String KEY_LONGITUDE = 'LONGITUDE';
const String KEY_LATITUDE = 'LATITUDE';

const String USER_TWITTER = 'USER_TWITTER';
const String USER_FACEBOOK = 'USER_FACEBOOK';
const String USER_INSTAGRAM = 'USER_INSTAGRAM';
const String USER_WHATSAPP = 'USER_WHATSAPP';

const String SECURE_STORAGE_KEY1 = 'HIVE_ENCYPTED_KEY1';
const String SECURE_STORAGE_KEY2 = 'HIVE_ENCYPTED_KEY2';

const String SECURE_STORAGE_TOKEN_KEY = 'SECURE_STORAGE_TOKEN_KEY';

const FlutterSecureStorage secureStorage1 = FlutterSecureStorage();
final secureKey1 = Hive.generateSecureKey();

class Storage {
  late StorageDriver _storage;

//MAKE SINGLETON
  static final Storage _singleton = Storage._internal();
  factory Storage() {
    return _singleton;
  }
  //In java
  // static Storage getInstance() {
  //   return _singleton;
  // }
  Storage._internal();
  //END OF SINGLETON

  Future<void> init() async {
    // WidgetsFlutterBinding.ensureInitialized();
    _storage = HiveStorage();
    await _storage.init();

    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    bool containsEncryptionKey =
        await secureStorage.containsKey(key: SECURE_STORAGE_TOKEN_KEY);

    List<int> hiveSecureKey;

    if (!containsEncryptionKey) {
      var newHiveSecureKey = Hive.generateSecureKey();
      hiveSecureKey = newHiveSecureKey;
      await secureStorage.write(
          key: SECURE_STORAGE_TOKEN_KEY, value: json.encode(newHiveSecureKey));
    } else {
      var initialSecureStorageKey =
          await secureStorage.read(key: SECURE_STORAGE_TOKEN_KEY);
      hiveSecureKey =
          (json.decode(initialSecureStorageKey!) as List<dynamic>).cast<int>();
    }
    await Hive.openBox(KEY_HIVE_SECURE_TOKEN_BOX,
        encryptionCipher: HiveAesCipher(hiveSecureKey));

    // _storage = SqliteStorage();
    // _storage = SharedPreferenceStorage();
  }

  Future<User?> getUser() async {
    String? firstname = await _storage.getString(KEY_FIRSTNAME);
    String? lastname = await _storage.getString(KEY_LASTNAME);
    String? password = await _storage.getString(KEY_PASSWORD);
    String? password2 = await _storage.getString(KEY_PASSWORD2);
    String? email = await _storage.getString(KEY_EMAIL);

    String? phone = await _storage.getString(KEY_PHONE);
    String? national_id = await _storage.getString(KEY_NATIONALID);
    String? country = await _storage.getString(KEY_COUNTRY);
    String? province = await _storage.getString(KEY_PROVINCE);
    String? city = await _storage.getString(KEY_CITY);
    String? address = await _storage.getString(KEY_ADDRESS);
    String? zip = await _storage.getString(KEY_ZIP);

    // Map<String, dynamic> location = {
    //   'type': 'point',
    //   'coordinates': [
    //   ]
    // };

    // Map<String, String?> social_media = {
    var twitt = await _storage.getString(USER_TWITTER);
    var face = await _storage.getString(USER_TWITTER);
    var inst = await _storage.getString(USER_TWITTER);
    var what = await _storage.getString(USER_TWITTER);
    // };
    var social_media = SocialMediaModel(
        whatsapp: what, instagram: inst, facebook: face, twitter: twitt);

    if (firstname != null &&
        lastname != null &&
        password != null &&
        password2 != null &&
        email != null) {
      return User(
        password: password,
        password2: password2,
        email: email,
        phone: phone,
        profile: Profile(
            first_name: firstname,
            last_name: lastname,
            national_id: national_id,
            country: country,
            province: province,
            city: city,
            address: address,
            zip: zip,
            // location: location,
            social_media: social_media),
      );
    } else {
      return User(
          password: '',
          password2: '',
          email: '',
          phone: '',
          profile: Profile(
            first_name: '',
            last_name: '',
            national_id: '',
            country: '',
            province: '',
            city: '',
            address: '',
            zip: '',
            // location: ,
            // social_media: ,
          ));
    }
  }

  Future storeUser(User user) async {
    await _storage.putString(KEY_FIRSTNAME, user.profile!.first_name);
    await _storage.putString(KEY_LASTNAME, user.profile!.last_name);
    await _storage.putString(KEY_PASSWORD, user.password);
    await _storage.putString(KEY_PASSWORD2, user.password2);
    await _storage.putString(KEY_EMAIL, user.email);

    if (user.phone != null) {
      await _storage.putString(KEY_PHONE, user.phone!);
    }
    if (user.profile!.national_id != null) {
      await _storage.putString(KEY_NATIONALID, user.profile!.national_id!);
    }
    if (user.profile!.country != null) {
      await _storage.putString(KEY_COUNTRY, user.profile!.country!);
    }
    if (user.profile!.province != null) {
      await _storage.putString(KEY_PROVINCE, user.profile!.province!);
    }
    if (user.profile!.city != null) {
      await _storage.putString(KEY_CITY, user.profile!.city!);
    }
    if (user.profile!.address != null) {
      await _storage.putString(KEY_ADDRESS, user.profile!.address!);
    }
    if (user.profile!.zip != null) {
      await _storage.putString(KEY_ZIP, user.profile!.zip!);
    }
    // if (user.profile!.location != null) {
    //   _storage.putString(KEY_LOCATION, user.profile!.location!);
    // }
    if (user.profile!.social_media != null) {
      await _storage.putString(
          USER_TWITTER, user.profile!.social_media!.twitter!);
      await _storage.putString(
          USER_FACEBOOK, user.profile!.social_media!.facebook!);
      await _storage.putString(
          USER_INSTAGRAM, user.profile!.social_media!.instagram!);
      await _storage.putString(
          USER_WHATSAPP, user.profile!.social_media!.whatsapp!);
    }
  }

  Future storeTokens(
      {required String accessToken,
      required String refreshToken,
      required int expirtyMillis}) async {
    // final encryptedBox1 = await Hive.openBox(KEY_HIVE_SECURE_TOKEN_BOX,
    //     encryptionCipher: HiveAesCipher(secureKey1));

    final _encryptedBox = Hive.box(KEY_HIVE_SECURE_TOKEN_BOX);
    await _encryptedBox.put(KEY_ACCESSTOKENT, accessToken);
    await _encryptedBox.put(KEY_REFERESHTOKENT, refreshToken);
    await _encryptedBox.put(KEY_EXPIRTY_MILLIS, expirtyMillis);

    // await secureStorage1.write(
    //   key: SECURE_STORAGE_TOKEN_KEY,
    //   value: json.encode(secureKey1),
    // );
    // print(accessToken);
    // print(refreshToken);

    // final _secureKey1 =
    //     await secureStorage1.read(key: SECURE_STORAGE_TOKEN_KEY);
    // List<int> _encryptionKey1 =
    //     (json.decode(_secureKey1!) as List<dynamic>).cast<int>();

    // final _encryptedBox1 = await Hive.openBox(KEY_HIVESECURETOKENBOX,
    //     encryptionCipher: HiveAesCipher(_encryptionKey1));
    // String access = _encryptedBox1.get(KEY_ACCESSTOKENT);
    // String ref = _encryptedBox1.get(KEY_REFERESHTOKENT);
    // // _encryptedBox1.close();
    // print(access);
    // print(ref);

    // final secureKey2 = Hive.generateSecureKey();
    // final encryptedBox2 = await Hive.openBox(KEY_REFERESHTOKENT,
    //     encryptionCipher: HiveAesCipher(secureKey2));
    // await encryptedBox2.put(KEY_REFERESHTOKENT, refreshToken);

    // await secureStorage2.write(
    //   key: SECURE_STORAGE_KEY2,
    //   value: json.encode(secureKey2),
    // );

    // final _secureKey2 = await secureStorage2.read(key: SECURE_STORAGE_KEY2);
    // List<int> _encryptionKey2 =
    //     (json.decode(_secureKey2!) as List<dynamic>).cast<int>();

    // final _encryptedBox2 = await Hive.openBox(KEY_REFERESHTOKENT,
    //     encryptionCipher: HiveAesCipher(_encryptionKey2));
    // String refresh = _encryptedBox2.get(KEY_REFERESHTOKENT);
    // // _encryptedBox1.close();
    // print(refresh);

    // await _storage.putString(KEY_REFERESHTOKEN, refreshToken);
    // await _storage.putString(KEY_ACCESSTOKEN, accessToken);
  }

  Future storeLocation(
      {required double latitude, required double longitude}) async {
    await _storage.putDouble(KEY_LATITUDE, latitude);
    await _storage.putDouble(KEY_LONGITUDE, longitude);
  }

  Future<Map<String, dynamic>> getTokens() async {
    // String? accessToken = await _storage.getString(KEY_ACCESSTOKEN);
    // String? refreshToken = await _storage.getString(KEY_REFERESHTOKEN);

    // final _secureKey1 =
    //     await secureStorage1.read(key: SECURE_STORAGE_TOKEN_KEY);
    // List<int> _encryptionKey1 =
    //     (json.decode(_secureKey1!) as List<dynamic>).cast<int>();

    // final _encryptedBox1 = await Hive.openBox(KEY_HIVE_SECURE_TOKEN_BOX,
    //     encryptionCipher: HiveAesCipher(_encryptionKey1));

    final _encryptedBox = Hive.box(KEY_HIVE_SECURE_TOKEN_BOX);
    String? accessToken = _encryptedBox.get(KEY_ACCESSTOKENT);
    String? refreshToken = _encryptedBox.get(KEY_REFERESHTOKENT);
    int? expirtyMillis = _encryptedBox.get(KEY_EXPIRTY_MILLIS);
    // _encryptedBox1.close();
    // print(accessToken);
    // print(refreshToken);

    if (accessToken != 'null' && refreshToken != 'null') {
      return {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'expirtyMillis': expirtyMillis
      };
    } else {
      return {
        'accessToken': 'null',
        'refreshToken': 'null',
        'expirtyMillis': null
      };
    }
  }

  Future<void> clearUser() async {
    await _storage.clear();
  }
}
