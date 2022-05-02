import 'package:flutter/material.dart';
import 'app_screen/splash_page.dart';
import 'helpers/storage/storage.dart';
import 'widgets/helpers/theme_data.dart';

void main() async {
  // Storage().initUser();
  await Storage().init();

  // ThemeData themeData() {
  //   return ThemeData(
  //     inputDecorationTheme: const InputDecorationTheme(
  //       border:
  //           OutlineInputBorder(borderSide: BorderSide(color: Colors.purple)),
  //       focusedBorder:
  //           OutlineInputBorder(borderSide: BorderSide(color: Colors.purple)),
  //       enabledBorder:
  //           OutlineInputBorder(borderSide: BorderSide(color: Colors.purple)),
  //       errorBorder:
  //           OutlineInputBorder(borderSide: BorderSide(color: Colors.purple)),
  //       focusedErrorBorder:
  //           OutlineInputBorder(borderSide: BorderSide(color: Colors.purple)),

  //     ),
  //   );
  // }

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: //themeData(),
        // ThemeData(
        //     primaryColor: Colors.purple,
        //     // ignore: deprecated_member_use
        //     accentColor: Colors.black),

        // MyTheme.defaultTheme,
        ThemeData(
      colorScheme: const ColorScheme(
          primary: Colors.purple,
          primaryVariant: Colors.deepPurple,
          secondary: Colors.green,
          secondaryVariant: Colors.white70,
          surface: Colors.purple,
          background: Colors.purple,
          error: Colors.red,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: Colors.black,
          onBackground: Colors.white,
          onError: Colors.red,
          brightness: Brightness.light),
      // brightness: Brightness.light,
      // primaryColor: Colors.purple,
    ),
    title: 'sample_ecommerce_client',
    home: const SplashScreen(),
  ));
}
