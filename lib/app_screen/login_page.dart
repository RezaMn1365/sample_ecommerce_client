import 'dart:convert';

import 'package:flutter_application_1/helpers/device_platform_recognition.dart';
import 'package:flutter_application_1/helpers/my_dialog.dart';
import 'package:flutter_application_1/helpers/storage/icon_builder.dart';
import 'package:flutter_application_1/helpers/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/helpers/navigation.dart' as Navigation;
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/widgets/helpers/svg_provider.dart';
import 'package:flutter_application_1/widgets/my_text_form_field.dart';
import 'package:flutter_application_1/widgets/text_span.dart';
import 'package:flutter_application_1/network/server_requests.dart'
    as serverRequest;

class LoginPage extends StatefulWidget {
  String userName = '';
  String passWord = '';
  LoginPage({Key? key, required this.userName, required this.passWord})
      : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // String twiterQuickLogin = 'images/14.png';
  // String facebookQuickLogin = 'images/15.png';
  // String googleQuickLogin = 'images/16.jpg';
  TextEditingController usernameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool invalidUsername = false;
  bool invalidPassword = false;
  bool twiterclicked = false;
  bool facebookclicked = false;
  bool googleclicked = false;
  bool logging = false;
  bool loggingResponse = false;
  final _formKey = GlobalKey<FormState>();
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // _performPrevousDataCheck();
    if (widget.userName.isNotEmpty) {
      usernameController.text = widget.userName;
    }
    if (widget.passWord.isNotEmpty) {
      passController.text = widget.passWord;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.blue[50],
        //appBar: AppBar(
        //  title: const Text('Register Page'),
        //),
        //resizeToAvoidBottomInset: false,
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MainLogoBuilder.show('images/C1.png'),
                      // svgProvider(),
                      MyTextFormField.norm(
                          type: 'username',
                          hint: 'Please enter your username',
                          lable: 'Username',
                          xController: usernameController,
                          textFormFieldPaddingValue: 25),
                      MyTextFormField.norm(
                          type: 'pass',
                          hint: 'Please enter your password',
                          lable: 'Password',
                          xController: passController,
                          textFormFieldPaddingValue: 25),
                      // SizedBox(
                      //   width: MediaQuery.of(context).size.width * 0.50,
                      //   height: MediaQuery.of(context).size.height * 0.10,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.end,
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: [
                      //       Expanded(
                      //         child: MiniClickableIcons.show(
                      //             twiterQuickLogin, 'twiterauthentication'),
                      //       ),
                      //       Expanded(
                      //         child: MiniClickableIcons.show(
                      //             facebookQuickLogin, 'facebookauthentication'),
                      //       ),
                      //       Expanded(
                      //         child: MiniClickableIcons.show(
                      //             googleQuickLogin, 'googleauthentication'),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Padding(
                          padding: const EdgeInsets.only(
                            top: 40,
                          ),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.09,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(15),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate() &&
                                      logging != true) {
                                    setState(() {
                                      logging = true;
                                    });
                                    loggingResponse = await _performLogin();
                                  }
                                  if (loggingResponse) {
                                    await Future.delayed(
                                        const Duration(seconds: 1));
                                    Navigation.gotoHomePage(context,
                                        name: usernameController.text,
                                        replace: true);
                                  } else {
                                    setState(() {
                                      logging = false;
                                    });
                                  }
                                },
                                child: logging
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text('Login')),
                          )),
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 20, right: 20),
                          // child:
                          // SizedBox(
                          //width: MediaQuery.of(context).size.width * 0.10,
                          // height: MediaQuery.of(context).size.height * 0.07,
                          child: TextSpanBulider.login(
                              ' ', 'New registeration?', 'register')
                          // )
                          ),
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 20, right: 20),
                          // child:
                          // SizedBox(
                          //width: MediaQuery.of(context).size.width * 0.10,
                          // height: MediaQuery.of(context).size.height * 0.07,
                          child: TextSpanBulider.login(
                              ' ', 'Forgot password?', 'passwordReset')
                          // )
                          ),
                    ],
                  )),

              // )
            )));
  }

  bool _myValidate() {
    var username = usernameController.text;
    var password = passController.text;

    setState(() {
      invalidUsername = false;
      invalidPassword = false;
      if (username == '') invalidUsername = true;
      if (password == '') invalidPassword = true;
    });

    return !invalidUsername && !invalidPassword;
  }

  Future<bool> _performLogin() async {
    // var user =
    // await Storage().getUser(); // In Java: Storage.getInstance().getUser();
    var username = usernameController.text;
    var password = passController.text;

    if (!_myValidate()) {
      MyDialog.show(
          context, 'Login Failed', 'Please fill all required fields.');
      return false;
    } else {
      var authenticateResponse = await serverRequest.authenticateAPI(
        context,
        username,
        password,
      );

      if (authenticateResponse['success'] == true &&
          authenticateResponse['payload']['verified'] == true) {
        print(authenticateResponse);
        int _expiryTime = authenticateResponse['payload']['expiry'];
        int _expirtyMillis =
            DateTime.now().millisecondsSinceEpoch + (_expiryTime * 100);
        String _accessToken =
            authenticateResponse['payload']['access_token'] as String;
        String _refreshToken =
            authenticateResponse['payload']['refresh_token'] as String;
        // await Storage().storeUser(User(password: 'password', password2: 'password2', email: username, profile: 'profile'))
        await Storage().storeTokens(
            accessToken: _accessToken,
            refreshToken: _refreshToken,
            expirtyMillis: _expirtyMillis);

        return true;
      }
      if (authenticateResponse['success'] == false) {
        MyDialog.show(context, 'Login Failed', 'Invalid Username or Password');

        // usernameController.text = '';
        // passController.text = '';
        return false;
      } else {
        MyDialog.show(
            context, 'Login Failed', 'Please check your network connection');
      }
      return false;
    }
  }

  // _performPrevousDataCheck() async {
  //   var userPrevious = await Storage().getUser();
  //   if (userPrevious != null) {
  //     usernameController.text = userPrevious.profile!.first_name;
  //     passController.text = userPrevious.password;
  //   }
  // }
}
