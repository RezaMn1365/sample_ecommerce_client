import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_screen/account_settings_page.dart';
import 'package:flutter_application_1/app_screen/active_session_page.dart';
import 'package:flutter_application_1/app_screen/login_history_page.dart';
import 'package:flutter_application_1/app_screen/home_page.dart';
import 'package:flutter_application_1/app_screen/login_page.dart';
import 'package:flutter_application_1/app_screen/map_google_page.dart';
import 'package:flutter_application_1/app_screen/password_reset_filling_page.dart';
import 'package:flutter_application_1/app_screen/password_reset_page.dart';
import 'package:flutter_application_1/app_screen/register_page.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/main.dart';

void _goToPage(BuildContext context, bool replace, Widget page) {
  if (replace) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return page;
        },
      ),
    );
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return page;
        },
      ),
    );
  }
}

void gotoRegisterPage(BuildContext context, {bool replace = true}) {
  _goToPage(context, replace, RegisterPage());
}

void gotoPasswordResetPage(BuildContext context, {bool replace = false}) {
  _goToPage(context, replace, PasswordResetPage());
}

void gotoPasswordReseFillingtPage(BuildContext context,
    {bool replace = false, String id = '', String email = ''}) {
  _goToPage(
      context,
      replace,
      PasswordReseFillingtPage(
        requestId: id,
        email: email,
      ));
}

void gotoHomePage(BuildContext context,
    {bool replace = true, String name = ''}) {
  _goToPage(context, replace, HomePage(context, uname: name));
}

void gotoLoginPage(
  BuildContext context, {
  bool replace = true,
  var pageColor,
  String userName = '',
  String passWord = '',
}) {
  _goToPage(
      context,
      replace,
      LoginPage(
        userName: userName,
        passWord: passWord,
      ));
}

void gotoLoginHistoryPage(
  BuildContext context, {
  bool replace = false,
}) {
  _goToPage(context, replace, LoginHistoryPage());
}

void gotoActiveSessionPage(
  BuildContext context, {
  bool replace = false,
}) {
  _goToPage(context, replace, ActiveSessionPage());
}

// void gotoActiveSessionPage(BuildContext context,
//     {bool replace = false, required Map activeSession}) {
//   _goToPage(
//       context,
//       replace,
//       ActiveSessionPage(
//         activeSession: activeSession,
//       ));
// }

void gotoAccountSettingsPage(
  BuildContext context,
  // User user,
  {
  bool replace = false,
}) {
  _goToPage(
      context,
      replace,
      AccountSettingsPage(

          // user: user,
          ));
}

void goBack(BuildContext context) {
  Navigator.pop(context);
}
