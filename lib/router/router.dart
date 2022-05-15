import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_screen/login_page.dart';
import 'package:flutter_application_1/app_screen/splash_page.dart';
import 'package:flutter_application_1/router/route_paths.dart' as routes;

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case routes.LoginPage:
      return MaterialPageRoute(
          builder: (context) => LoginPage(userName: '', passWord: ''));
    case routes.SplashRoute:
      return MaterialPageRoute(builder: (context) => const SplashScreen());
    default:
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(
            child: Text('No path for ${settings.name}'),
          ),
        ),
      );
  }
}
