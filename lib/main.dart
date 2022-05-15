import 'package:flutter/material.dart';
import 'package:flutter_application_1/router/locator.dart';
import 'package:flutter_application_1/router/navigation_service.dart';
import 'package:flutter_application_1/router/router.dart';
import 'app_screen/splash_page.dart';
import 'helpers/storage/storage.dart';
import 'package:flutter_application_1/router/route_paths.dart' as routes;

void main() async {
  setupLocator();
  await Storage().init();

  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'sample_ecommerce_client',
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
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: generateRoute,
      initialRoute: routes.SplashRoute,
      home: const SplashScreen(),
    );
  }
}
