import 'package:dio/dio.dart';
import 'package:dio_logging_interceptor/dio_logging_interceptor.dart';
import 'package:flutter_application_1/helpers/device_platform_recognition.dart';
import 'package:flutter_application_1/helpers/storage/storage.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/network/basic_api_response.dart';

import 'api_response.dart';

Future<String?> _getAccessToken() async {
  final tokens = await Storage().getTokens();
  String accessToken = tokens['accessToken']!;
  return accessToken;
}

Future<String?> _getRefreshToken() async {
  final tokens = await Storage().getTokens();
  String refreshtoken = tokens['refreshToken']!;
  return refreshtoken;
}

Future<String?> _getDeviceName() async {
  var deviceName = await initPlatformState();
  String clientInfo = deviceName['name'];
  return clientInfo;
}

Future<String?> _getDevicePlatform() async {
  var devicePlatform = await initPlatformState();
  String clientSign = devicePlatform['platform'];
  return clientSign;
}

Future<bool> tryRefreshToken() async {
  String _url = 'http://185.88.154.87:4000/auth/users/refresh';

  var _request = RefreshTokenModel(
      access_token: await _getAccessToken(),
      refresh_token: await _getRefreshToken(),
      client_sign: await _getDevicePlatform(),
      client_info: await _getDeviceName());

  var _dio = Dio();
  _dio.options.contentType = 'application/json; charset=UTF-8';
  _dio.interceptors.add(
    DioLoggingInterceptor(
      level: Level.body,
      compact: false,
    ),
  );

  try {
    var response = await _dio.post(_url, data: _request);

    var _response = BasicApiResponse.fromJson((response.data));

    if (_response.payload) return BasicApiResponse.fromJson((response.data));
  } on DioError catch (e) {
    return _handleExceptions(e, url, null, true, true, firstTry);
  } catch (e) {
    return BasicApiResponse.failed('Failed to get response from server.');
  }
}

//_get//_get//_get//_get//_get//_get//_get//_get//_get//_get//_get//_get
Future<BasicApiResponse> _get(String url,
    {bool firstTry = true, bool authorized = false}) async {
  var _dio = Dio();

  _dio.options.contentType = 'application/json; charset=UTF-8';

  if (authorized) {
    var token = await _getAccessToken();
    if (token != null) {
      _dio.options.headers["Authorization"] = 'Bearer ' + token;
    }
  }

  _dio.interceptors.add(
    DioLoggingInterceptor(
      level: Level.body,
      compact: false,
    ),
  );

  try {
    var response = await _dio.get(
      url,
    );

    return BasicApiResponse.fromJson((response.data));
  } on DioError catch (e) {
    return _handleExceptions(e, url, null, true, true, firstTry);
  } catch (e) {
    return BasicApiResponse.failed('Failed to get response from server.');
  }
}

//post//post//post//post//post//post//post//post//post//post//post//post

Future<BasicApiResponse> _post(String url, dynamic data,
    {bool firstTry = true, bool authorized = false}) async {
  var _dio = Dio();

  _dio.options.contentType = 'application/json; charset=UTF-8';

  if (authorized) {
    var token = await _getAccessToken();
    if (token != null) {
      _dio.options.headers["Authorization"] = 'Bearer ' + token;
    }
  }

  try {
    var response = await _dio.post(
      url,
      data: data,
    );

    print(
        'Response: ${response.statusCode}, ${response.statusMessage}: ${response.data}');

    return BasicApiResponse.fromJson(response.data);
  } on DioError catch (e) {
    return _handleExceptions(e, url, data, true, true, true);
  } catch (e) {
    return BasicApiResponse.failed('Failed to get response from server.');
  }
}

//_handleExceptions//_handleExceptions//_handleExceptions//_handleExceptions
Future<BasicApiResponse> _handleExceptions(DioError e, String url, dynamic data,
    bool isPost, bool authorized, bool firstTry) async {
  if (e.response != null) {
    if (e.response?.statusCode == 400) {
      //Invalid Parameters
      return BasicApiResponse.missingParams(e.response?.data);
    } else if (e.response?.statusCode == 401 && firstTry) {
      // Unauthorized
      var refreshDone = await tryRefreshToken();
      if (refreshDone) {
        if (isPost) {
          print('Recalling $url with $data as POST');
          return await _post(url, data,
              authorized: authorized, firstTry: false);
        } else {
          print('Recalling $url as GET');
          return await _get(url, authorized: authorized, firstTry: false);
        }
      } else {
        //notify to go to login page
        // Shared().notifyLoginRequired();
        return BasicApiResponse.failed('Unauthorized. Login required.');
      }
    }
    return BasicApiResponse.fromJson(e.response?.data);
  }
  if (e.message.contains('SocketException')) {
    return BasicApiResponse.failed('Failed to connect to server.');
  }
  return BasicApiResponse.failed(e.message);
}

Future<ApiResponse<UserProfile>> getProfile() async {
  var response = await _get('http://185.88.154.87:4000/users/profile/get',
      authorized: true);

  var data = UserProfile.fromJson(response.payload);
  // print(data);

  return ApiResponse<UserProfile>(response, data);
}
