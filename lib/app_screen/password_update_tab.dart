import 'package:flutter/material.dart';
import 'package:flutter_application_1/helpers/my_dialog.dart';
import 'package:flutter_application_1/helpers/storage/icon_builder.dart';
import 'package:flutter_application_1/network/server_request_new.dart';
import 'package:flutter_application_1/widgets/my_text_form_field.dart';

class PasswordUpdatePage extends StatefulWidget {
  String requestId = '';
  String email = '';
  // User user;
  PasswordUpdatePage({
    Key? key,
  }) : super(key: key);

  @override
  _PasswordUpdatePageState createState() => _PasswordUpdatePageState();
}

class _PasswordUpdatePageState extends State<PasswordUpdatePage>
    with AutomaticKeepAliveClientMixin {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  TextEditingController repeatpassController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController oldPassController = TextEditingController();

  String password = '';
  String password2 = '';

  bool invalidCode = false;
  bool invalidPass = false;
  bool invalidPass2 = false;
  bool invalidEquality = false;
  bool passUpdatingIndicator = false;
  bool passUpdateResponse = false;
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
              // top: MediaQuery.of(context).size.height * 0.10,
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
                      'Update your password',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 20),
                  child: Center(
                    child: Text(
                      'Please enter you old password and new password to update your password!',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                MyTextFormField.norm(
                    type: 'repeatpassword',
                    hint: 'Please enter old password',
                    lable: 'Old password',
                    xController: oldPassController,
                    textFormFieldPaddingValue: 25),
                MyTextFormField.pass(
                  type: 'password',
                  hint: 'Please enter new password',
                  lable: 'New password',
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
                    hint: 'Please repeat new password',
                    lable: 'Repeat new password',
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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate() &&
                              passUpdatingIndicator != true) {
                            passUpdatingIndicator = true;
                            passUpdateResponse = await _performPasswordUpdate();
                          }
                          setState(() {});
                        },
                        child: passUpdatingIndicator
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text('Update password')),
                  ),
                ),
              ],
            ),
          ),

          // )
        ),
      ),
    );
  }

  bool _myValidate() {
    var password = passController.text;
    var password2 = repeatpassController.text;

    setState(() {
      invalidPass = false;
      invalidPass2 = false;

      if (password == '') invalidPass = true;
      if (password2 == '') invalidPass2 = true;
      if (password != password2) invalidEquality = true;
    });

    return !invalidPass2 && !invalidPass && !invalidEquality;
  }

  Future<bool> _performPasswordUpdate() async {
    if (!_myValidate()) {
      MyDialog.show(context, 'Password Reset Failed', 'Please fill all fields');
      passUpdatingIndicator = false;
      return false;
    } else {
      var passwordUpdateResponse = await updatePassword(oldPassController.text,
          passController.text, repeatpassController.text);
      if (passwordUpdateResponse.success) {
        await MyDialog.showWithDelay(
            context, 'Message', '${passwordUpdateResponse.payload['message']}');
        passUpdatingIndicator = false;
        return true;
      } else {
        await MyDialog.showWithDelay(context, 'Message', 'Unauthorized!');
        passUpdatingIndicator = false;
        return false;
      }
    }
  }

  // Future<bool> _performPasswordUpdate() async {
  //   if (!_myValidate()) {
  //     MyDialog.show(context, 'Password Reset Failed', 'Please fill all fields');
  //     return false;
  //   } else {
  //     var passwordUpdateResponse = await serverRequest.updatePasswordAPI(
  //         context,
  //         oldPassController.text,
  //         passController.text,
  //         repeatpassController.text);
  //     if (passwordUpdateResponse['success'] == true) {
  //       await MyDialog.showWithDelay(context, 'Message',
  //           '${passwordUpdateResponse['payload']['message']}');
  //       passUpdating = false;
  //       return true;
  //     } else {
  //       await MyDialog.showWithDelay(context, 'Message', 'Unauthorized');
  //       passUpdating = false;
  //       return false;
  //     }
  //   }
  // }
}
