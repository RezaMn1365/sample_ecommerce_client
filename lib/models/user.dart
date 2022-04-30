// class User {
// final String firstName;
// final String password;
// final String? email;
// final String username;

// final String password; //[REQUIRED]
// final String password2; //[REQUIRED]
// final String email; //[REQUIRED]

// final String first_name; //[REQUIRED]
// final String last_name; //[REQUIRED]

// final String? phone;
// final String? national_id;
// final String? country;
// final String? province;
// final String? city;
// final String? address;
// final String? zip;
// final String? location;
// final String? social_media;

// User({
//   required this.first_name,
//   required this.last_name,
//   required this.password,
//   required this.password2,
//   required this.email,
//   this.phone,
//   this.national_id,
//   this.country,
//   this.province,
//   this.city,
//   this.address,
//   this.zip,
//   this.location,
//   this.social_media,
// });
// }

import 'package:google_maps_flutter/google_maps_flutter.dart';

class User {
  String password = ''; //[REQUIRED]
  String password2 = ''; //[REQUIRED]
  String email = ''; //[REQUIRED]
  String? phone = '';
  Profile? profile;

  User(
      {required this.password,
      required this.password2,
      required this.email,
      required this.profile,
      this.phone});

  Map toJson() {
    Map? profile = this.profile != null ? this.profile!.toJson() : null;

    return {
      'email': email,
      'password': password,
      'password2': password2,
      'profile': profile,
    };
  }
}

class Profile {
  String first_name = ''; //[REQUIRED]
  String last_name = ''; //[REQUIRED]
  String? national_id = '';
  String? country = '';
  String? province = '';
  String? city = '';
  String? address = '';
  String? zip = '';
  LocationModel? location;
  SocialMediaModel? social_media;

  Profile({
    required this.first_name,
    required this.last_name,
    this.national_id,
    this.country,
    this.province,
    this.city,
    this.address,
    this.zip,
    this.location,
    this.social_media,
  });

  Map toJson() => {
        'first_name': first_name,
        'last_name': last_name,
        'national_id': national_id,
        'country': country,
        'province': province,
        'city': city,
        'address': address,
        'zip': zip,
        'location': location,
        'social_media': social_media,
      };

  static Profile? fromJson(dynamic json) {
    try {
      var first_name = json['first_name'];
      var last_name = json['last_name'];
      var national_id = json['national_id'];
      var country = json['country'];
      var province = json['province'];
      var city = json['city'];
      var address = json['address'];
      var zip = json['zip'];
      var location = LocationModel.fromJson(json['location']['coordinates']);
      var social_media = SocialMediaModel.fromJson(json['social_media']);

      if (first_name != null && last_name != null) {
        return Profile(
            first_name: first_name,
            last_name: last_name,
            address: address,
            city: city,
            country: country,
            location: location,
            national_id: national_id,
            province: province,
            social_media: social_media,
            zip: zip);
      }
    } catch (e) {}
    return null;
  }
}

class SocialMediaModel {
  String? whatsapp = '';
  String? instagram = '';
  String? twitter = '';
  String? facebook = '';

  SocialMediaModel(
      {this.whatsapp, this.instagram, this.facebook, this.twitter});

  Map toJson() => {
        "USER_WHATSAPP": whatsapp,
        "USER_INSTAGRAM": instagram,
        "USER_FACEBOOK": facebook,
        "USER_TWITTER": twitter,
      };

  static SocialMediaModel? fromJson(dynamic json) {
    try {
      var USER_WHATSAPP = json['USER_WHATSAPP'];
      var USER_INSTAGRAM = json['USER_INSTAGRAM'];
      var USER_FACEBOOK = json['USER_FACEBOOK'];
      var USER_TWITTER = json['USER_TWITTER'];

      if (USER_WHATSAPP != null &&
          USER_INSTAGRAM != null &&
          USER_TWITTER != null &&
          USER_FACEBOOK != null) {
        return SocialMediaModel(
            whatsapp: USER_WHATSAPP,
            instagram: USER_INSTAGRAM,
            facebook: USER_FACEBOOK,
            twitter: USER_TWITTER);
      }
    } catch (e) {}
    return null;
  }
}

class LocationModel {
  // double? latitude;
  // double? longitud;
  //+++++++++++++++++++++++ DONT USE DYNAMIC
  LatLng location;

  LocationModel(this.location);

  Map toJson() => {
        "coordinates": [location.latitude, location.longitude]
      };

  static LocationModel? fromJson(dynamic json) {
    try {
      var latitude = json[0];
      var longitude = json[1];

      if (latitude != null && longitude != null) {
        return LocationModel(LatLng(latitude, longitude));
      }
    } catch (e) {}
    return null;
  }
}

class Authenticate {
  String email = '';
  String password = '';
  String client_sign = '';
  String client_info = '';

  Authenticate(
      {required this.email,
      required this.password,
      required this.client_sign,
      required this.client_info});

  Map toJson() => {
        'email': email,
        'password': password,
        'client_sign': client_sign,
        'client_info': client_info,
      };
}

class RefreshTokenModel {
  String? access_token = '';
  String? refresh_token = '';
  String? client_sign = '';
  String? client_info = '';

  RefreshTokenModel(
      {required this.access_token,
      required this.refresh_token,
      required this.client_sign,
      required this.client_info});

  Map toJson() => {
        'access_token': access_token,
        'refresh_token': refresh_token,
        'client_sign': client_sign,
        'client_info': client_info,
      };
}

class RequestPasswordResetCodeModel {
  String? email = '';

  RequestPasswordResetCodeModel({
    required this.email,
  });

  Map toJson() => {
        'email': email,
      };
}

class RequestPasswordResetModel {
  String? email = '';
  String? requestId = '';
  String? code = '';
  String? password = '';
  String? password2 = '';

  RequestPasswordResetModel({
    required this.email,
    required this.requestId,
    required this.code,
    required this.password,
    required this.password2,
  });

  Map toJson() => {
        'email': email,
        "request_id": requestId,
        "code": code,
        "password": password,
        "password2": password2,
      };
}

class UpdatePasswordModel {
  String? oldpasswordcode = '';
  String? password = '';
  String? password2 = '';

  UpdatePasswordModel({
    required this.oldpasswordcode,
    required this.password,
    required this.password2,
  });

  Map toJson() => {
        "old_password": oldpasswordcode,
        "password": password,
        "password2": password2
      };
}

class ProfileUpdateModel {
  String first_name = ''; //[REQUIRED]
  String last_name = ''; //[REQUIRED]
  String? national_id = '';
  String? country = '';
  String? province = '';
  String? city = '';
  String? address = '';
  String? zip = '';
  LocationModel? location;
  SocialMediaModel? social_media;

  ProfileUpdateModel({
    required this.first_name,
    required this.last_name,
    this.national_id,
    this.country,
    this.province,
    this.city,
    this.address,
    this.zip,
    this.location,
    this.social_media,
  });

  Map toJson() => {
        "profile": {
          'first_name': first_name,
          'last_name': last_name,
          'national_id': national_id,
          'country': country,
          'province': province,
          'city': city,
          'address': address,
          'zip': zip,
          'location': location,
          'social_media': social_media,
        }
      };
}

class TerminateActiveSession {
  String? sessionId = '';

  TerminateActiveSession({
    required this.sessionId,
  });

  Map toJson() => {
        "session_id": sessionId,
      };
}

class UserProfile {
  final String username;
  final String email;
  final bool? verified;
  final Profile? profile;

  UserProfile({
    required this.username,
    required this.verified,
    required this.email,
    required this.profile,
  });

  static UserProfile? fromJson(dynamic json) {
    try {
      var username = json['username'];
      var email = json['email'];
      var profile = Profile.fromJson(json['profile']);
      var verified = json['verified'] ?? true;

      if (username != null &&
          email != null &&
          profile != null &&
          verified != null) {
        var newUserProfile = UserProfile(
            username: username,
            email: email,
            profile: profile,
            verified: verified);
        // print(newUserProfile);
        return newUserProfile;
      }
    } catch (e) {}
    return null;
  }
}

class ActiveSessionModel {
  final List? list;

  // final String session_id;
  // final String created_at;
  // final Map? client;

  ActiveSessionModel({
    required this.list,
    // required this.session_id,
    // required this.created_at,
    // required this.client,
  });

  static ActiveSessionModel? fromJson(dynamic json) {
    try {
      var list = json['list'];
      // var session_id = json['session_id'];
      // var created_at = json['created_at'];
      // var client = json['client'];

      if (list != null
          // session_id != null &&
          //  created_at != null &&
          //  client != null
          ) {
        var activeSessionModel = ActiveSessionModel(list: list
            // session_id: session_id,
            // client: client,
            // created_at: created_at,
            );
        // print(newUserProfile);
        return activeSessionModel;
      }
    } catch (e) {}
    return null;
  }
}

class LoginHistoryModel {
  final List? list;
  final Map? pagination;

  LoginHistoryModel({
    required this.list,
    required this.pagination,
  });

  static LoginHistoryModel? fromJson(dynamic json) {
    try {
      var list = json['list'];
      var pagination = json['pagination'];

      if (list != null) {
        var loginHistoryModel =
            LoginHistoryModel(list: list, pagination: pagination);

        return loginHistoryModel;
      }
    } catch (e) {}
    return null;
  }
}
