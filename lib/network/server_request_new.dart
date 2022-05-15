import 'package:dio/dio.dart';
import 'package:dio_logging_interceptor/dio_logging_interceptor.dart';
import 'package:flutter_application_1/helpers/device_platform_recognition.dart';
import 'package:flutter_application_1/helpers/storage/storage.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/network/basic_api_response.dart';
import 'package:flutter_application_1/router/locator.dart';
import 'package:flutter_application_1/router/navigation_service.dart';
import 'package:flutter_application_1/router/route_paths.dart' as routes;

import 'api_response.dart';

Future<String?> _getAccessToken() async {
  final tokens = await Storage().getTokens();
  String? accessToken = tokens['accessToken'];
  return accessToken;
}

Future<String?> _getRefreshToken() async {
  final tokens = await Storage().getTokens();
  String? refreshtoken = tokens['refreshToken'];
  return refreshtoken;
}

Future<void> _storeTokens(
    String accessToken, String refreshToken, int expirtyMillis) async {
  await Storage().storeTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expirtyMillis: expirtyMillis);
}

Future<void> _clearTokens() async {
  await Storage().clearUser();
}

Future<String?> _getDeviceName() async {
  var deviceName = await initPlatformState();
  String? clientInfo = deviceName['name'];
  return clientInfo;
}

Future<String?> _getDevicePlatform() async {
  var devicePlatform = await initPlatformState();
  String? clientSign = devicePlatform['platform'];
  return clientSign;
}

Future<bool> tryRefreshToken() async {
  print('Performin refresh tokennnnnnnnnnnnnnnnnnnnnnn');
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

    if (_response.success && _response.payload != null) {
      String _accessToken = _response.payload['access_token'];
      String _refreshToken = _response.payload['refresh_token'];
      int _expirtyMillis = _response.payload['expiry'];
      _expirtyMillis =
          DateTime.now().millisecondsSinceEpoch + (_expirtyMillis * 1000);

      await _storeTokens(_accessToken, _refreshToken, _expirtyMillis);

      return true;
    }
  } on DioError {
    return false;
  } catch (e) {
    return false;
  }
  return false;
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
    return _handleExceptions(e, url, null, false, authorized, firstTry);
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

  _dio.interceptors.add(
    DioLoggingInterceptor(
      level: Level.body,
      compact: false,
    ),
  );

  try {
    var response = await _dio.post(
      url,
      data: data,
    );

    print(
        'Response: ${response.statusCode}, ${response.statusMessage}: ${response.data}');

    return BasicApiResponse.fromJson(response.data);
  } on DioError catch (e) {
    return _handleExceptions(e, url, data, true, authorized, firstTry);
  } catch (e) {
    return BasicApiResponse.failed('Failed to get response from server.');
  }
}

//_handleExceptions//_handleExceptions//_handleExceptions//_handleExceptions//_handleExceptions

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
        _clearTokens();
        final NavigationService _navigationService =
            locator<NavigationService>();
        _navigationService.navigateTo(routes.LoginPage);
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
  var _response = await _get('http://185.88.154.87:4000/users/profile/get',
      authorized: true);

  var data = UserProfile.fromJson(_response.payload);
  // print(data);

  return ApiResponse<UserProfile>(_response, data);
}

Future<BasicApiResponse> updatePassword(
    String oldpassword, String password, String repeatpass) async {
  var updatePassRequestBody = UpdatePasswordModel(
      oldpasswordcode: oldpassword, password: password, password2: repeatpass);

  var _response = await _post(
      'http://185.88.154.87:4000/users/password/update', updatePassRequestBody,
      authorized: true, firstTry: true);

  return _response;
}

Future<BasicApiResponse> updateProfile(Profile profile) async {
  var profileUpdateRequestBody = ProfileUpdateModel(
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

  var _response = await _post('http://185.88.154.87:4000/users/profile/update',
      profileUpdateRequestBody,
      authorized: true, firstTry: true);

  return _response;
}

Future<ApiResponse<ActiveSessionModel>> getActiveSession() async {
  var _response = await _get('http://185.88.154.87:4000/auth/users/sessions',
      authorized: true, firstTry: true);

  var data = ActiveSessionModel.fromJson(_response.payload);
  // print(data);

  return ApiResponse<ActiveSessionModel>(_response, data);
}

Future<BasicApiResponse> terminateActiveSession(String sessionId) async {
  var _request = TerminateActiveSession(sessionId: sessionId);
  var _response = await _post(
      'http://185.88.154.87:4000/auth/users/terminate', _request,
      authorized: true, firstTry: true);

  return _response;
}

Future<ApiResponse<LoginHistoryModel>> getLoginHistory(
    int page, int size, bool getCount) async {
  await Future.delayed(const Duration(milliseconds: 250));

  var _response = await _get(
      'http://185.88.154.87:4000/auth/users/history?page=$page&size=$size&get_count=$getCount',
      authorized: true,
      firstTry: true);

  var data = LoginHistoryModel.fromJson(_response.payload);
  // print(data);

  return ApiResponse<LoginHistoryModel>(_response, data);
}

Future<BasicApiResponse> logout() async {
  var _response = await _post(
      'http://185.88.154.87:4000/auth/users/logout', null,
      authorized: true, firstTry: true);

  return _response;
}

Future<ApiResponse<Authenticate>> authenticate(
    String email, String pass) async {
  var _request = Authenticate(
      email: email,
      password: pass,
      client_sign: await _getDevicePlatform(),
      client_info: await _getDeviceName());

  var _response = await _post(
      'http://185.88.154.87:4000/auth/users/authenticate', _request,
      authorized: true, firstTry: true);

  var data = Authenticate.fromJson(_response.payload);

  if (_response.success && data != null) {
    String _accessToken = _response.payload['access_token'];
    String _refreshToken = _response.payload['refresh_token'];
    int _expirtyMillis = _response.payload['expiry'];
    _expirtyMillis =
        DateTime.now().millisecondsSinceEpoch + (_expirtyMillis * 1000);

    await _storeTokens(_accessToken, _refreshToken, _expirtyMillis);
  }

  return ApiResponse<Authenticate>(_response, data);
}

Future<ApiResponse<User>> register(User user) async {
  var _response = await _post('http://185.88.154.87:4000/users/create', user,
      authorized: true, firstTry: true);

  var data = User.fromJson(_response.payload);

  return ApiResponse<User>(_response, data);
}

Future<ApiResponse<RequestPasswordResetCodeModel>> getPasswordResetCode(
    String email) async {
  var _request = RequestPasswordResetCodeModel(email: email);

  var _response = await _post(
      'http://185.88.154.87:4000/users/password/request', _request,
      authorized: true, firstTry: true);

  var data = RequestPasswordResetCodeModel.fromJson(_response.payload);

  return ApiResponse<RequestPasswordResetCodeModel>(_response, data);
}

Future<BasicApiResponse> passwordReset(String email, String code,
    String requestId, String pass, String repeatpass) async {
  var _request = RequestPasswordResetModel(
      email: email,
      code: code,
      requestId: requestId,
      password: pass,
      password2: repeatpass);

  var _response = await _post(
      'http://185.88.154.87:4000/users/password/reset', _request,
      authorized: true, firstTry: true);

  return _response;
}
