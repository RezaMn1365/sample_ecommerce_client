import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/validator.dart';

import 'helpers/valdation_icon.dart';

class MyTextFormField extends StatefulWidget {
  MyTextFormField({Key? key}) : super(key: key);
  String hint = '';
  String lable = '';
  String type = '';
  TextEditingController xController = TextEditingController();
  double textFormFieldPaddingValue = 10;
  String socialMediaLogo = 'images/whatsapp.png';

  double validatorIconWidgetsize = 180;
  int specialValidationNumbers = 1;
  int numericValidationNumbers = 2;
  int upperValidationNumbers = 1;
  int lengthValidationNumbers = 8;

  MyTextFormField.norm({
    Key? key,
    this.type = 'norm',
    required this.hint,
    required this.lable,
    required this.xController,
    required this.textFormFieldPaddingValue,
  }) : super(key: key);

  MyTextFormField.social(
      {Key? key,
      required this.hint,
      required this.lable,
      required this.xController,
      required this.textFormFieldPaddingValue,
      required this.socialMediaLogo})
      : type = 'socialmedia',
        super(key: key);

  MyTextFormField.pass({
    Key? key,
    required this.type,
    required this.hint,
    required this.lable,
    required this.xController,
    required this.textFormFieldPaddingValue,
    required this.validatorIconWidgetsize,
    required this.specialValidationNumbers,
    required this.numericValidationNumbers,
    required this.upperValidationNumbers,
    required this.lengthValidationNumbers,
  }) : super(key: key);

  @override
  _MyTextFormFieldState createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  final _validator = Validator();
  Color lengthValidationColor = Colors.grey;
  Color upperValidationColor = Colors.grey;
  Color numericValidationColor = Colors.grey;
  Color specialValidationColor = Colors.grey;
  bool lengthValide = false;
  bool upperValide = false;
  bool numericValide = false;
  bool specialValide = false;
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
    widget.xController.addListener(() {
      // if (widget.type == 'password'){
      _callValidator();
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type != 'password' && widget.type != 'socialmedia') {
      return Column(children: [
        Padding(
            padding: EdgeInsets.only(top: widget.textFormFieldPaddingValue),
            child: TextFormField(
              obscureText:
                  widget.type == 'repeatpassword' || widget.type == 'pass'
                      ? _isObscure
                      : false,
              autofillHints: const [AutofillHints.email],
              keyboardType: widget.type == 'email'
                  ? TextInputType.emailAddress
                  : TextInputType.text,
              textCapitalization: widget.type == 'email'
                  ? TextCapitalization.none
                  : TextCapitalization.sentences,
              controller: widget.xController,
              validator: (value) => _callValidator(),
              decoration: InputDecoration(
                // filled: true,
                // fillColor: Colors.purple[50],
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.purple, width: 2.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),

                labelText: widget.lable,
                hintText: widget.hint,
                prefixIcon:
                    _iconPicker(), //type=='password' ? const Icon(Icons.email) : const Icon(Icons.email)  ,
                suffixIcon: widget.type == 'repeatpassword' ||
                        widget.type == 'pass'
                    ? IconButton(
                        enableFeedback: true,
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () => setState(() {
                              _isObscure = !_isObscure;
                            }))
                    : IconButton(
                        onPressed: () => widget.xController.clear(),
                        icon: const Icon(Icons.close)),
              ),
            )),
      ]);
    } else if (widget.type == 'socialmedia') {
      return
          // Column(children: [
          Padding(
              padding: EdgeInsets.only(top: widget.textFormFieldPaddingValue),
              child: TextFormField(
                obscureText: false,
                autofillHints: const [AutofillHints.email],
                keyboardType: TextInputType.emailAddress,
                controller: widget.xController,
                // validator: (value) => _callValidator(),
                decoration: InputDecoration(
                  // filled: true,
                  // fillColor: Colors.purple[50],
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(15.0),
                  ),

                  labelText: widget.lable,
                  hintText: widget.hint,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      widget.socialMediaLogo,
                      width: 20,
                      height: 20,
                      fit: BoxFit.fill,
                    ),
                  ), //type=='password' ? const Icon(Icons.email) : const Icon(Icons.email)  ,
                  suffixIcon: IconButton(
                      onPressed: () => widget.xController.clear(),
                      icon: const Icon(Icons.close)),
                ),
              ));
      // ]);
    } else
    // if (widget.type == 'password')
    {
      return Column(
        children: [
          Padding(
              padding: EdgeInsets.only(top: widget.textFormFieldPaddingValue),
              child: TextFormField(
                obscureText: _isObscure,
                autofillHints: const [AutofillHints.email],
                keyboardType: TextInputType.emailAddress,
                controller: widget.xController,
                validator: (value) => _callValidator(),
                decoration: InputDecoration(
                  // filled: true,
                  // fillColor: Colors.purple[50],
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  labelText: widget.lable,
                  hintText: widget.hint,
                  prefixIcon: _iconPicker(),
                  suffixIcon: IconButton(
                      enableFeedback: true,
                      icon: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () => setState(() {
                            _isObscure = !_isObscure;
                          })),
                ),
              )),
          SizedBox(
              width: widget.validatorIconWidgetsize,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  textValidationWidget(
                    color: upperValidationColor,
                    text: 'Upper',
                    number: '${widget.upperValidationNumbers}',
                    widgetSize: widget.validatorIconWidgetsize,
                  ),
                  textValidationWidget(
                    color: specialValidationColor,
                    text: 'Special',
                    number: '${widget.specialValidationNumbers}',
                    widgetSize: widget.validatorIconWidgetsize,
                  ),
                  textValidationWidget(
                    color: numericValidationColor,
                    text: 'Number',
                    number: '${widget.numericValidationNumbers}',
                    widgetSize: widget.validatorIconWidgetsize,
                  ),
                  textValidationWidget(
                    color: lengthValidationColor,
                    text: 'Lenght',
                    number: '${widget.lengthValidationNumbers}',
                    widgetSize: widget.validatorIconWidgetsize,
                  ),
                ],
              )),
        ],
      );
    }
  }

  Icon _iconPicker() {
    if (widget.type == 'password' ||
        widget.type == 'repeatpassword' ||
        widget.type == 'pass') {
      return const Icon(Icons.lock);
    }
    if (widget.type == 'name') {
      return const Icon(Icons.person);
    }
    if (widget.type == 'username') {
      return const Icon(Icons.person_add);
    }
    if (widget.type == 'email') {
      return const Icon(Icons.email);
    }
    if (widget.type == 'phone') {
      return const Icon(Icons.phone);
    }
    if (widget.type == 'country') {
      return const Icon(Icons.home);
    }
    if (widget.type == 'province') {
      return const Icon(Icons.map);
    }
    if (widget.type == 'city') {
      return const Icon(Icons.location_city);
    }
    if (widget.type == 'address') {
      return const Icon(Icons.home_work);
    }
    if (widget.type == 'zip') {
      return const Icon(Icons.post_add);
    }
    if (widget.type == 'socialmedia') {
      return const Icon(Icons.social_distance);
    } else {
      return const Icon(Icons.person);
    }
  }

  String? _callValidator() {
    if ((widget.type == 'name' || widget.type == 'username') &&
        (!_validator.hasMinLatinOnly(widget.xController.text, 4))) {
      return 'Please enter at least 4 characters';
    } else if (widget.type == 'email' &&
        !EmailValidator.validate(widget.xController.text)) {
      return 'Enter a valid Email address';
    } else if ((widget.type == 'repeatpassword' || widget.type == 'pass') &&
        (widget.xController.text == '')) {
      return 'Password is not matched';
    } else if (widget.type == 'password') {
      if (_validator.hasMinLength(
          widget.xController.text, widget.lengthValidationNumbers)) {
        lengthValidationColor = Colors.green;
      } else {
        lengthValidationColor = Colors.red;
      }

      if (_validator.hasMinNumericChar(
          widget.xController.text, widget.numericValidationNumbers)) {
        numericValidationColor = Colors.green;
      } else {
        numericValidationColor = Colors.red;
      }

      if (_validator.hasMinSpecialChar(
          widget.xController.text, widget.specialValidationNumbers)) {
        specialValidationColor = Colors.green;
      } else {
        specialValidationColor = Colors.red;
      }

      if (_validator.hasMinUppercase(
          widget.xController.text, widget.upperValidationNumbers)) {
        upperValidationColor = Colors.green;
      } else {
        upperValidationColor = Colors.red;
      }
      setState(() {});
      if (upperValidationColor == Colors.red ||
          specialValidationColor == Colors.red ||
          numericValidationColor == Colors.red ||
          lengthValidationColor == Colors.red) {
        return 'Password is weak';
      }

      return null;

      // if (upperValidationColor == Colors.green &&
      //     specialValidationColor == Colors.green &&
      //     numericValidationColor == Colors.green &&
      //     lengthValidationColor == Colors.green) {}

    } else {
      return null;
    }
  }
}
