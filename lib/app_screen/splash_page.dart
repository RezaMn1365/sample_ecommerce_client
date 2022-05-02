import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/helpers/storage/storage.dart';
import 'package:flutter_application_1/models/notifier.dart';
import 'package:flutter_application_1/network/server_request_new.dart';
import 'package:flutter_application_1/helpers/navigation.dart' as Navigation;
import 'package:provider/provider.dart';

import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Map<String, dynamic> tokens = {};
  String userName = '';

  @override
  void initState() {
    super.initState();

    //++++ ONCE AFTER BUILD
    Future.delayed(Duration.zero, () => _onceAfterBuild());
  }

  //++++ ONCE AFTER BUILD
  void _onceAfterBuild() async {
    bool _refresh = await _checkLastTokens();
    if (_refresh == false) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(
            userName: '',
            passWord: '',
          ),
        ),
      );
    } else if (_refresh == true) {
      // var _refreshResponse = await refreshTokenAPI();
      // userName = _refreshResponse['payload']['username'];
      Navigation.gotoHomePage(context, name: userName);
    }

    // Timer(
    //   const Duration(seconds: 1),
    //   () => Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => LoginPage()),
    //   ),
    // );
  }

  // Timer(
  //   const Duration(seconds: 1),
  //   () => Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (context) => LoginPage()),
  //   ),
  // );
  // }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UnautorizeNevigator(),
      builder: (context, child) {
        return Container(
          color: Colors.black,
          child: Image.asset('images/MaxPower.png'),
        );
      },
    );
  }

  Future<bool> _checkLastTokens() async {
    tokens = await Storage().getTokens();
    // print(tokens);
    // print(DateTime.now().millisecondsSinceEpoch);
    // print(tokens['expirtyMillis']);

    if (tokens['expirtyMillis'] == null ||
        tokens['refreshToken'] == null ||
        tokens['accessToken'] == null) {
      print('false null');
      return false;
    } else {
      if (tokens['expirtyMillis']! < DateTime.now().millisecondsSinceEpoch) {
        var refreshResponse = await tryRefreshToken();
        // print(refreshResponse);
        if (refreshResponse != true) {
          print('refresh null');
          return false;
        } else {
          // userName = refreshResponse['payload']['username'];
          print('true refresh');
          return true;
        }
      } else {
        // var user = await Storage().getUser();
        // userName = user!.profile!.first_name;
        print('true');
        return true;
      }
    }
  }

  // if (tokens['refreshToken'] != null && tokens['accessToken'] != null) {
  //   var refreshResponse = await refreshTokenAPI();
  //   if (refreshResponse['success'] == true) {
  //     userName = refreshResponse['payload']['username'];
  //     bool _successResponse = refreshResponse['success'];
  //     // print(_successResponse);
  //     return _successResponse;
  //   } else {
  //     return false;
  //   }
  // } else {
  //   print(tokens);
  //   return false;
  // }

}
