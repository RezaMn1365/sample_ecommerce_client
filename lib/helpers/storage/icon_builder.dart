import 'package:flutter/material.dart';
import 'package:flutter_application_1/helpers/navigation.dart' as Navigation;
import 'package:flutter_application_1/widgets/my_snackbar.dart' as mysnackbar;

class MiniClickableIcons extends StatelessWidget {
  String address = 'images/14.png';
  String authenticationPage = '';
  MiniClickableIcons.show(this.address, this.authenticationPage, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.all(10),

      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage(address),
          fit: BoxFit.scaleDown,
        ),
      ),
      child: GestureDetector(
        onTap: () {
          if (authenticationPage == 'googleauthentication') {
            debugPrint('Google Clicked');
            mysnackbar.showSnackBar(context, 'Google');
            // Navigation.gotoHomePage(context);
          }
          if (authenticationPage == 'twiterauthentication') {
            debugPrint('Twiter Clicked');
            mysnackbar.showSnackBar(context, 'Twiter');
            // Navigation.gotoHomePage(context);
          }
          if (authenticationPage == 'facebookauthentication') {
            debugPrint('Facebook Clicked');
            mysnackbar.showSnackBar(context, 'Facebook');
            // Navigation.gotoHomePage(context);
          }
        },
      ),
      // child: image,
    );
  }
}

class MainLogoBuilder extends StatelessWidget {
  String address = 'images/14.png';
  MainLogoBuilder.show(this.address, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        image: DecorationImage(
          image: AssetImage(address),
          fit: BoxFit.scaleDown,
        ),
      ),
      // child: GestureDetector(
      //   onTap: () {

      //     }
    );
    // child: image,
  }
}
