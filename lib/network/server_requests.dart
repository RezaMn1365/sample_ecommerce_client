import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/helpers/device_platform_recognition.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_application_1/helpers/my_dialog.dart';
import 'package:flutter_application_1/helpers/storage/storage.dart';
import 'package:flutter_application_1/models/user.dart';

Future<Map<String, dynamic>> registerAPI(
    BuildContext context, User user) async {
  Map<String, bool> _error = {"success": false};
  try {
    final response =
        await http.post(Uri.parse('http://185.88.154.87:4000/users/create'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(user));
    // print(jsonEncode(user));

    if (response.statusCode == 200) {
      print('200');
      // print(jsonDecode(response.body));
      return jsonDecode(response.body);
    }
    if (response.statusCode == 400) {
      // print('400');
      // print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } else {
      // throw Exception('Failed to register');
      return jsonDecode(response.body);
    }
  } catch (error) {
    return _error;
  } finally {
    // return _error;
  }
}

// Future<Map<String, dynamic>> registerAPI(BuildContext context, User user) async {
//     final response =
//         await http.post(Uri.parse('http://185.88.154.87:4000/users/create'),
//             headers: <String, String>{
//               'Content-Type': 'application/json; charset=UTF-8',
//             },
//             body: jsonEncode(user));
//     print(jsonEncode(user));

//     if (response.statusCode == 200) {
//       print('200');
//       print(jsonDecode(response.body));
//       return jsonDecode(response.body);
//     }
//     if (response.statusCode == 400) {
//       print('400');
//       print(jsonDecode(response.body));
//       return jsonDecode(response.body);
//     } else {
//       MyDialog.show(context, 'Network Problem',
//           'Please check your internet connection' '!');
//       // throw Exception('Failed to register');
//     }
//   }
Future<Map?> _performLogout(BuildContext context) async {
  final tokens = await Storage().getTokens();
  String accesstoken = tokens['accessToken']!;
  Map<String, bool> _error = {"success": false};
  try {
    final response = await http.post(
        Uri.parse('http://185.88.154.87:4000/auth/users/logout'),
        headers: <String, String>{
          //'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer " + accesstoken,
        },
        body: {});

    if (response.statusCode == 200) {
      print('200');
      await Storage().clearUser();
      return jsonDecode(response.body);
    }
    if (response.statusCode == 400) {
      print('400');
      return jsonDecode(response.body);
    } else {
      MyDialog.show(context, 'Network Problem',
          'Please check your internet connection' '!');
      // throw Exception('Failed to logout');
    }
  } catch (error) {
    // print('error');
    return _error;
  } finally {
    // return _error;
  }
}

Future<Map<String, dynamic>> authenticateAPI(
    BuildContext context, String email, String pass) async {
  var getDeviceInfo = await initPlatformState();
  String clientInfo = getDeviceInfo['name'];
  String clientSign = getDeviceInfo['platform'];

  var authenticate = Authenticate(
      email: email,
      password: pass,
      client_sign: clientSign,
      client_info: clientInfo);
  Map<String, bool> _error = {"success": false};
  try {
    final response = await http.post(
        Uri.parse('http://185.88.154.87:4000/auth/users/authenticate'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(authenticate));
    // print(jsonEncode(authenticate));

    if (response.statusCode == 200) {
      print('authenticate 200');
      // print(jsonDecode(response.body));
      return jsonDecode(response.body);
    }
    if (response.statusCode == 400) {
      print('authenticate 400');
      // print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } else {
      // throw Exception('Failed to authenticate');
      // print('error');
      MyDialog.show(
          context, 'Failed', '${jsonDecode(response.body)['message']}');
      return jsonDecode(response.body);
    }
  } catch (error) {
    // print('error');
    return _error;
  } finally {
    // return _error;
  }
}

Future<Map<String, dynamic>> refreshTokenAPI() async {
  var getDeviceInfo = await initPlatformState();
  String clientInfo = getDeviceInfo['name'];
  String clientSign = getDeviceInfo['platform'];

  Map<String, dynamic> tokens = await Storage().getTokens();
  // print(tokens);

  var refresh = RefreshTokenModel(
      access_token: tokens['accessToken'],
      refresh_token: tokens['refreshToken'],
      client_sign: clientSign,
      client_info: clientInfo);

  Map<String, bool> _error = {"success": false};

  try {
    final response = await http.post(
        Uri.parse('http://185.88.154.87:4000/auth/users/refresh'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(refresh));
    // print(jsonEncode(refresh));

    if (response.statusCode == 200) {
      print('refresh 200');
      // print(jsonDecode(response.body));

      String _accessToken =
          jsonDecode(response.body)['payload']['access_token'] as String;
      String _refreshToken =
          jsonDecode(response.body)['payload']['refresh_token'] as String;

      int _expirtyMillis = jsonDecode(response.body)['payload']['expiry'];
      _expirtyMillis =
          DateTime.now().millisecondsSinceEpoch + (_expirtyMillis * 100);

      await Storage().storeTokens(
          accessToken: _accessToken,
          refreshToken: _refreshToken,
          expirtyMillis: _expirtyMillis);

      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      print('refresh 400');
      // print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      print('refresh 401');
      // print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } else {
      print('refresh unknown');
      return jsonDecode(response.body);
    }
  } catch (error) {
    print('refresh error');
    return _error;
  } finally {
    // return _error;
  }
}

Future<Map<String, dynamic>> performLogout() async {
  final tokens = await Storage().getTokens();
  String accesstoken = tokens['accessToken']!;
  Map<String, bool> _error = {"success": false};
  try {
    final response = await http.post(
        Uri.parse('http://185.88.154.87:4000/auth/users/logout'),
        headers: <String, String>{
          //'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer " + accesstoken,
        },
        body: {});

    if (response.statusCode == 200) {
      print('logout 200');
      await Storage().clearUser();
      return jsonDecode(response.body);
    }
    if (response.statusCode == 400) {
      // print('400');
      return jsonDecode(response.body);
    } else {
      // throw Exception('Failed to logout');
      return jsonDecode(response.body);
    }
  } catch (error) {
    return _error;
  } finally {
    // return _error;
  }
}

Future<Map<String, dynamic>> getPasswordResetCodeAPI(
    BuildContext context, String email) async {
  var resetPassCodeRequestBody = RequestPasswordResetCodeModel(email: email);
  Map<String, bool> _error = {"success": false};
  try {
    final response = await http.post(
        Uri.parse('http://185.88.154.87:4000/users/password/request'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(resetPassCodeRequestBody));
    print(jsonEncode(resetPassCodeRequestBody));

    if (response.statusCode == 200) {
      print('getPasswordResetCode 200');
      // print(jsonDecode(response.body));

      return jsonDecode(response.body);
    }
    if (response.statusCode == 400) {
      print('getPasswordResetCode 400');
      MyDialog.show(
          context, 'Failed', '${jsonDecode(response.body)['message']}');
      // print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } else {
      // print(jsonDecode(response.body));
      MyDialog.show(
          context, 'Failed', '${jsonDecode(response.body)['message']}');
      return jsonDecode(response.body);
      // throw Exception('Failed to reset password');
    }
  } catch (error) {
    return _error;
  } finally {
    // return _error;
  }
}

Future<Map<String, dynamic>> passwordResetAPI(
    BuildContext context,
    String email,
    String code,
    String requestId,
    String pass,
    String repeatpass) async {
  var resetPassRequestBody = RequestPasswordResetModel(
      email: email,
      code: code,
      requestId: requestId,
      password: pass,
      password2: repeatpass);
  Map<String, bool> _error = {"success": false};
  try {
    final response = await http.post(
        Uri.parse('http://185.88.154.87:4000/users/password/reset'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(resetPassRequestBody));
    // print(jsonEncode(resetPassRequestBody));

    if (response.statusCode == 200) {
      print('passwordReset 200');
      // print(jsonDecode(response.body));

      MyDialog.show(context, 'Success',
          jsonDecode(response.body)['payload']['message'].toString());

      return jsonDecode(response.body);
    }
    if (response.statusCode == 400) {
      print('passwordReset 400');
      // print(jsonDecode(response.body));
      MyDialog.show(
          context, 'Failed', '${jsonDecode(response.body)['message']}');
      return jsonDecode(response.body);
    } else {
      MyDialog.show(
          context, 'Failed', '${jsonDecode(response.body)['message']}');
      // print(jsonDecode(response.body));
      return jsonDecode(response.body);
      // throw Exception('Failed to reset password');
    }
  } catch (error) {
    return _error;
  } finally {
    // return _error;
  }
}

Future<Map<String, dynamic>> updatePasswordAPI(BuildContext context,
    String oldpassword, String password, String repeatpass) async {
  var updatePassRequestBody = UpdatePasswordModel(
      oldpasswordcode: oldpassword, password: password, password2: repeatpass);

  final tokens = await Storage().getTokens();
  String accesstoken = tokens['accessToken']!;
  Map<String, bool> _error = {"success": false};
  try {
    final response = await http.post(
        Uri.parse('http://185.88.154.87:4000/users/password/update'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer " + accesstoken,
        },
        body: jsonEncode(updatePassRequestBody));
    print(jsonEncode(updatePassRequestBody));

    if (response.statusCode == 200) {
      print('update pass 200');
      print(jsonDecode(response.body));

      return jsonDecode(response.body);
    }
    if (response.statusCode == 400) {
      print('400');
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } else {
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    }
  } catch (error) {
    return _error;
  } finally {
    // return _error;
  }
}

Future<Map<String, dynamic>> getProfileAPI(BuildContext context) async {
  final tokens = await Storage().getTokens();
  String accesstoken = tokens['accessToken']!;
  Map<String, bool> _error = {"success": false};
  try {
    final response = await http.get(
      Uri.parse('http://185.88.154.87:4000/users/profile/get'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer " + accesstoken,
      },
      //  body: {}
    );

    if (response.statusCode == 200) {
      print('get profile 200');
      print(jsonDecode(response.body));

      return jsonDecode(response.body);
    }
    if (response.statusCode == 400) {
      // print('400');
      return jsonDecode(response.body);
    }
    if (response.statusCode == 401) {
      print('401');

      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  } catch (error) {
    return _error;
  } finally {
    // return _error;
  }
}

Future<Map<String, dynamic>> updateProfileAPI(
    BuildContext context, Profile profile) async {
  final tokens = await Storage().getTokens();
  String accesstoken = tokens['accessToken']!;

  var newProfile = ProfileUpdateModel(
      first_name: profile.first_name,
      last_name: profile.last_name,
      address: profile.address,
      city: profile.city,
      country: profile.country,
      location: profile.location,
      national_id: profile.national_id,
      province: profile.province,
      social_media: profile.social_media,
      zip: profile.zip);
  Map<String, bool> _error = {"success": false};
  try {
    final response = await http.post(
        Uri.parse('http://185.88.154.87:4000/users/profile/update'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer " + accesstoken,
        },
        body: jsonEncode(newProfile));
    // print(jsonEncode(profile));

    if (response.statusCode == 200) {
      print('profile update 200');
      // print(jsonDecode(response.body));
      return jsonDecode(response.body);
    }
    if (response.statusCode == 400) {
      // print('400');
      // print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } else {
      // throw Exception('Failed to register');
      return jsonDecode(response.body);
    }
  } catch (error) {
    return _error;
  } finally {
    // return _error;
  }
}

Future<Map<String, dynamic>> getLoginHistoryAPI(
    int page, int size, bool getCount) async {
  final tokens = await Storage().getTokens();
  String accesstoken = tokens['accessToken']!;

  var params = {
    "page": 1,
    "size": 10,
    "get_count": true,
  };
  await Future.delayed(const Duration(milliseconds: 250));
  Map<String, bool> _error = {"success": false};
  try {
    final response = await http.get(
      //+++++++++++ MAKE SURE get_count is True only on first page download. for rest of the pages make get_count = false
      Uri.parse(
          'http://185.88.154.87:4000/auth/users/history?page=$page&size=$size&get_count=$getCount'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer " + accesstoken,
      },
      //  body: {}
    );

    if (response.statusCode == 200) {
      print('get login history 200');
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    }
    if (response.statusCode == 400) {
      // print('400');
      // print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } else {
      // print(jsonDecode(response.body));
      return jsonDecode(response.body);
    }
  } catch (error) {
    return _error;
  } finally {
    // return _error;
  }
}

Future<Map<String, dynamic>> getActiveSessionAPI(BuildContext context) async {
  final tokens = await Storage().getTokens();
  String accesstoken = tokens['accessToken']!;
  Map<String, bool> _error = {"success": false};
  try {
    final response = await http.get(
      Uri.parse('http://185.88.154.87:4000/auth/users/sessions'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer " + accesstoken,
      },
      //  body: {}
    );

    if (response.statusCode == 200) {
      print('get active session 200');
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    }
    if (response.statusCode == 400) {
      // print('400');
      // print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } else {
      // print(jsonDecode(response.body));
      return jsonDecode(response.body);
    }
  } catch (error) {
    return _error;
  } finally {
    // return _error;
  }
}

Future<Map<String, dynamic>> terminateActiveSessionAPI(
    BuildContext context, String sessionId) async {
  final tokens = await Storage().getTokens();
  String accesstoken = tokens['accessToken']!;
  Map<String, bool> _error = {"success": false};
  try {
    var terminateActiveSession = TerminateActiveSession(sessionId: sessionId);

    final response = await http.post(
        Uri.parse('http://185.88.154.87:4000/auth/users/terminate'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer " + accesstoken,
        },
        body: jsonEncode(terminateActiveSession));
    print(jsonEncode(terminateActiveSession));

    if (response.statusCode == 200) {
      print('terminateActiveSession 200');
      // print(jsonDecode(response.body));
      return jsonDecode(response.body);
    }
    if (response.statusCode == 400) {
      // print('400');
      // print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } else {
      // throw Exception('Failed to register');
      return jsonDecode(response.body);
    }
  } catch (error) {
    return _error;
  } finally {
    // return _error;
  }
}
