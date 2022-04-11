import 'package:flutter_application_1/helpers/navigation.dart' as Navigation;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TextSpanBulider extends StatelessWidget {
  TextSpanBulider({Key? key}) : super(key: key);

  String normalText = '';
  String clickableText = '';
  String jumpPage = '';
  TextSpanBulider.login(this.normalText, this.clickableText, this.jumpPage,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        //width: MediaQuery.of(context).size.width * 0.50,
        //height: MediaQuery.of(context).size.height * 0.10,
        child: Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Center(
        child: RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: [
              TextSpan(
                text: normalText,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    decoration: TextDecoration.none),
              ),
              TextSpan(
                text: clickableText,
                style: const TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 17,
                    decoration: TextDecoration.none),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    if (jumpPage == 'login') {
                      return Navigation.gotoLoginPage(context);
                    }
                    if (jumpPage == 'register') {
                      return Navigation.gotoRegisterPage(context,
                          replace: false);
                    }
                    if (jumpPage == 'passwordReset') {
                      return Navigation.gotoPasswordResetPage(context);
                    }
                  },
              )
            ],
          ),
        ),
      ),
    ));
  }
}
