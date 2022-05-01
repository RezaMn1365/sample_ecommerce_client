import 'dart:convert';

import 'package:flutter_application_1/helpers/my_dialog.dart';
import 'package:flutter_application_1/helpers/storage/icon_builder.dart';
import 'package:flutter_application_1/helpers/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/helpers/navigation.dart' as Navigation;
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/network/server_request_new.dart';
import 'package:flutter_application_1/widgets/helpers/svg_provider.dart';
import 'package:flutter_application_1/widgets/my_text_form_field.dart';
import 'package:flutter_application_1/widgets/text_span.dart';
import 'package:http/http.dart' as http;

class PasswordResetPage extends StatefulWidget {
  PasswordResetPage({Key? key}) : super(key: key);

  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  TextEditingController emailController = TextEditingController();
  bool invalidEmail = false;
  final _formKey = GlobalKey<FormState>();
  String _requestId = '';
  bool emailValidating = false;
  bool emailValidated = false;
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.white70,
        //appBar: AppBar(
        //  title: const Text('Register Page'),
        //),
        //resizeToAvoidBottomInset: false,
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.only(
                    left: 25,
                    right: 25,
                    top: 25, //MediaQuery.of(context).size.height * 0.10,
                    bottom: 25,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // MainLogoBuilder.show('images/MX.png'),
                      MainLogoBuilder.show('images/C1.png'),
                      // svgProvider(),
                      const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Center(
                              child: Text(
                            'Forgot password?',
                            style: TextStyle(fontSize: 20),
                          ))),
                      const Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 20),
                          child: Center(
                              child: Text(
                            'We just need your registered Email address to send you password reset code',
                            style: TextStyle(fontSize: 14),
                          ))),
                      MyTextFormField.norm(
                          type: 'email',
                          hint: 'Please enter your Email address',
                          lable: 'Email',
                          xController: emailController,
                          textFormFieldPaddingValue: 15),
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
                                      emailValidating != true) {
                                    setState(() {
                                      emailValidating = true;
                                    });
                                    emailValidated =
                                        await _performPasswordResetCode();

                                    if (emailValidated) {
                                      await Future.delayed(
                                          const Duration(seconds: 2));
                                      Navigation.gotoPasswordReseFillingtPage(
                                          context,
                                          id: _requestId,
                                          email: emailController.text,
                                          replace: true);
                                    }
                                  }
                                },
                                child: emailValidating
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text('Reset Password')),
                          )),
                      TextSpanBulider.login('Not registered yet? click  ',
                          'register', 'register'),
                    ],
                  )),

              // )
            )));
  }

  bool _myValidate() {
    var email = emailController.text;

    setState(() {
      invalidEmail = false;
      if (email == '') invalidEmail = true;
    });

    return !invalidEmail;
  }

  Future<bool> _performPasswordResetCode() async {
    var email = emailController.text;

    if (!_myValidate()) {
      MyDialog.show(context, 'Password Reset Failed',
          'Please enter registered Email address');
      return false;
    } else {
      var passwordResetResponse = await getPasswordResetCode(email);
      if (passwordResetResponse.success) {
        _requestId = passwordResetResponse.data!.request_id as String;
        MyDialog.show(
            context, 'Message', '${passwordResetResponse.data!.message}');
        return true;
      } else {
        MyDialog.show(context, 'Message', 'Email address is not valid');
        return false;
      }

      // var passwordResetResponse =
      //     await serverRequest.getPasswordResetCodeAPI(context, email);
      // if (passwordResetResponse['success'] == true) {
      //   _requestId = passwordResetResponse['payload']['request_id'] as String;
      //   MyDialog.show(context, 'Message', 'Email address is valid');
      //   return true;
      // } else {
      //   return false;
      // }
    }
  }
}
