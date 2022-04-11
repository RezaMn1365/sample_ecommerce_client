import 'dart:convert';

import 'package:flutter_application_1/helpers/my_dialog.dart';
import 'package:flutter_application_1/helpers/storage/icon_builder.dart';
import 'package:flutter_application_1/helpers/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/helpers/navigation.dart' as Navigation;
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/widgets/helpers/svg_provider.dart';
import 'package:flutter_application_1/widgets/my_text_form_field.dart';
import 'package:flutter_application_1/widgets/text_span.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/network/server_requests.dart'
    as serverRequest;

class PasswordReseFillingtPage extends StatefulWidget {
  String requestId = '';
  String email = '';
  PasswordReseFillingtPage(
      {Key? key, required this.requestId, required this.email})
      : super(key: key);

  @override
  _PasswordReseFillingtPageState createState() =>
      _PasswordReseFillingtPageState();
}

class _PasswordReseFillingtPageState extends State<PasswordReseFillingtPage> {
  TextEditingController codeController = TextEditingController();
  TextEditingController repeatpassController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool invalidCode = false;
  bool invalidPass = false;
  bool invalidPass2 = false;
  bool invalidEquality = false;
  bool resetingPassword = false;
  bool resetedPassword = false;
  final _formKey = GlobalKey<FormState>();
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
                            'Set your new password',
                            style: TextStyle(fontSize: 20),
                          ))),
                      const Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 20),
                          child: Center(
                              child: Text(
                            'Please enter the code which you recieved by Email',
                            style: TextStyle(fontSize: 14),
                          ))),
                      MyTextFormField.norm(
                          type: 'norm',
                          hint: 'Please enter the code',
                          lable: 'Code',
                          xController: codeController,
                          textFormFieldPaddingValue: 15),
                      MyTextFormField.pass(
                        type: 'password',
                        hint: 'Please enter password',
                        lable: 'Password',
                        xController: passController,
                        textFormFieldPaddingValue: 25,
                        validatorIconWidgetsize:
                            MediaQuery.of(context).size.width * 0.35,
                        upperValidationNumbers: 1,
                        specialValidationNumbers: 1,
                        numericValidationNumbers: 2,
                        lengthValidationNumbers: 8,
                      ),
                      MyTextFormField.norm(
                          type: 'repeatpassword',
                          hint: 'Please repeat password',
                          lable: 'Repeat password',
                          xController: repeatpassController,
                          textFormFieldPaddingValue: 25),
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
                                      resetingPassword != true) {
                                    setState(() {
                                      resetingPassword = true;
                                    });
                                    resetedPassword =
                                        await _performPasswordReset();
                                    if (resetedPassword) {
                                      await Future.delayed(
                                          const Duration(seconds: 2));

                                      Navigation.gotoLoginPage(context,
                                          replace: true);
                                    }
                                  }
                                },
                                child: resetingPassword
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
    var code = codeController.text;
    var password = passController.text;
    var password2 = repeatpassController.text;

    setState(() {
      invalidCode = false;
      invalidPass = false;
      invalidPass2 = false;
      invalidEquality = false;
      if (code == '') invalidCode = true;
      if (password == '') invalidPass = true;
      if (password2 == '') invalidPass2 = true;
      if (password != password2) invalidEquality = true;
    });

    return !invalidCode && !invalidPass2 && !invalidPass && !invalidEquality;
  }

  Future<bool> _performPasswordReset() async {
    if (!_myValidate()) {
      MyDialog.show(context, 'Password Reset Failed', 'Please fill all fields');
      return false;
    } else {
      var passwordResetResponse = await serverRequest.passwordResetAPI(
          context,
          widget.email,
          codeController.text,
          widget.requestId,
          passController.text,
          repeatpassController.text);
      if (passwordResetResponse['success'] == true) {
        MyDialog.showWithDelay(
            context, 'Message', 'Password reset successfully');
        return true;
      } else {
        MyDialog.show(
            context, 'Message', 'Password Reset Failed, Please retry');
        return false;
      }
    }
  }
}
