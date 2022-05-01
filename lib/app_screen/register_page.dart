import 'dart:convert';
import 'package:flutter_application_1/app_screen/map_snapshot_provider.dart';
import 'package:flutter_application_1/helpers/my_dialog.dart';
import 'package:flutter_application_1/helpers/storage/icon_builder.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/network/server_request_new.dart';
import 'package:flutter_application_1/widgets/my_spacer.dart';
import 'package:flutter_application_1/widgets/my_text_form_field.dart';
import 'package:flutter_application_1/widgets/social_media_item.dart';
import 'package:flutter_application_1/widgets/social_media_register_field.dart';
import 'package:flutter_application_1/widgets/text_span.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/helpers/navigation.dart' as Navigation;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  List<SocialMediaRegisterField> items = [];
  List<TextEditingController> socialmediaController = [];

  List<int> numberOfFieldsUpdate = [];

  int itemNumber = 1;

//+++++++++ Move all of theme to State class
  TextEditingController passController = TextEditingController();
  TextEditingController repeatpassController = TextEditingController();

  TextEditingController emailController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();

  TextEditingController phoneController = TextEditingController();
  TextEditingController nationalidontroller = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController provinceController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController zipController = TextEditingController();

  TextEditingController whatsappSocialmediaController = TextEditingController();
  TextEditingController instagramSocialmediaController =
      TextEditingController();
  TextEditingController facebookSocialmediaController = TextEditingController();
  TextEditingController twitterSocialmediaController = TextEditingController();

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String firstname = '';
  String password = '';
  String lastname = '';
  String email = '';
  String password2 = '';
  String phone = '';
  String national_id = '';
  String country = '';
  String province = '';
  String city = '';
  String address = '';
  String zip = '';
  late SocialMediaModel socialMedia;
  LocationModel? location;
  bool registering = false;
  bool registerSuccess = false;

  List<SocialMediaItem> socialMedias = List.empty(growable: true);

  String name = '';
  String displayError = '';
  String dialogTitle = '';
  String socialMediaLogo = 'images/whatsapp.png';
  String socialMediaTitle = 'whatsapp';
  String currentMediaSelected = 'whatsapp';
  List<String> currentMedia = ['whatsapp'];

  bool invalidFirstname = false;
  bool invalidPassword = false;
  bool invalidLastName = false;
  bool invalidEmail = false;
  bool invalidPassword2 = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    var initalLocation = LocationModel(const LatLng(0.1, 0.1));
    location = initalLocation;
    var initalSocialModel = SocialMediaModel(
        whatsapp: '', facebook: '', instagram: '', twitter: '');
    socialMedia = initalSocialModel;

    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blue[50],
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
                    type: 'name',
                    hint: 'Please enter your Name',
                    lable: 'First Name',
                    xController: widget.firstnameController,
                    textFormFieldPaddingValue: 25),
                MyTextFormField.norm(
                    type: 'username',
                    hint: 'Please enter your Username',
                    lable: 'Last name',
                    xController: widget.lastnameController,
                    textFormFieldPaddingValue: 25),
                MyTextFormField.norm(
                    type: 'email',
                    hint: 'Please enter your Email address',
                    lable: 'Email',
                    xController: widget.emailController,
                    textFormFieldPaddingValue: 25),
                MyTextFormField.pass(
                  type: 'password',
                  hint: 'Please enter your password',
                  lable: 'Password',
                  xController: widget.passController,
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
                    hint: 'Please repeat your password',
                    lable: 'Password',
                    xController: widget.repeatpassController,
                    textFormFieldPaddingValue: 25),
                MyTextFormField.norm(
                    type: 'phone',
                    hint: 'Please enter your phone number',
                    lable: 'Phone Number',
                    xController: widget.phoneController,
                    textFormFieldPaddingValue: 25),
                MySpacer.vertical(40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Social Media Account'),
                    IconButton(
                        onPressed: _onSocialAddPressed,
                        icon: const Icon(Icons.add)),
                  ],
                ),
                ...socialMedias,
                MyTextFormField.norm(
                    type: 'country',
                    hint: 'Please enter your country',
                    lable: 'Country',
                    xController: widget.countryController,
                    textFormFieldPaddingValue: 25),
                MyTextFormField.norm(
                    type: 'province',
                    hint: 'Please enter your province',
                    lable: 'Province',
                    xController: widget.provinceController,
                    textFormFieldPaddingValue: 25),
                MyTextFormField.norm(
                    type: 'city',
                    hint: 'Please enter your city',
                    lable: 'City',
                    xController: widget.cityController,
                    textFormFieldPaddingValue: 25),
                MyTextFormField.norm(
                    type: 'zip',
                    hint: 'Please enter your zip postal code',
                    lable: 'ZIP',
                    xController: widget.zipController,
                    textFormFieldPaddingValue: 25),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: MapSnapShotProvider(
                        location?.location ?? const LatLng(1.0, 1.0),
                        onLocationUpdated: (loc) {
                      location = LocationModel(loc);
                      setState(() {});
                    }
                        // initalLocation: location,
                        ),
                  ),
                ),
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
                              registering != true) {
                            setState(() {
                              registering = true;
                            });
                            registerSuccess = await _performRegister();
                          }
                          setState(() {});
                          if (registerSuccess) {
                            await Future.delayed(const Duration(seconds: 2));
                            Navigation.gotoLoginPage(context,
                                userName: widget.emailController.text,
                                passWord: widget.passController.text,
                                replace: true);
                          }
                        },
                        child: registering
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text('Register')),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: TextSpanBulider.login(
                        'Already registered? click  ', 'login', 'login')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _validate() {
    firstname = widget.firstnameController.text;
    password = widget.passController.text;
    lastname = widget.lastnameController.text;
    email = widget.emailController.text;
    password2 = widget.repeatpassController.text;

    setState(() {
      invalidFirstname = false;
      invalidPassword = false;
      invalidLastName = false;
      invalidEmail = false;
      invalidPassword2 = false;
      if (firstname == '') invalidFirstname = true;
      if (password == '') invalidPassword = true;
      if (lastname == '') invalidLastName = true;
      if (email == '') invalidEmail = true;
      if (password2 == '' || password2 != password) {
        invalidPassword2 = true;
      }
    });

    return !invalidFirstname &&
        !invalidPassword &&
        !invalidLastName &&
        !invalidEmail &&
        !invalidPassword2;
  }

  Future<bool> _performRegister() async {
    if (_validate()) {
      firstname = widget.firstnameController.text;
      lastname = widget.lastnameController.text;
      password = widget.passController.text;
      password2 = widget.repeatpassController.text;
      email = widget.emailController.text;
      phone = widget.phoneController.text;

      national_id = widget.nationalidontroller.text;
      country = widget.countryController.text;
      province = widget.provinceController.text;
      city = widget.cityController.text;
      address = widget.addressController.text;
      zip = widget.zipController.text;
      location = location;

      socialMedia.whatsapp = widget.whatsappSocialmediaController.text;
      socialMedia.instagram = widget.instagramSocialmediaController.text;
      socialMedia.facebook = widget.facebookSocialmediaController.text;
      socialMedia.twitter = widget.twitterSocialmediaController.text;

      // print(social_media.toString());

      var profile = Profile(
          first_name: firstname,
          last_name: lastname,
          address: address,
          city: city,
          country: country,
          location: location,
          national_id: national_id,
          province: province,
          social_media: socialMedia,
          zip: zip);
      var newUser = User(
          password: password,
          password2: password2,
          email: email,
          profile: profile,
          phone: phone);

      var registerResponse = await register(newUser);
      if (registerResponse.success == true) {
        await MyDialog.showWithDelay(
            context, 'Message', '${registerResponse.data!.message}');
        registering = false;

        // Map<String, dynamic> registerResponse =
        //     await serverRequest.registerAPI(context, newUser);
        // if (registerResponse['success'] == true) {
        //   await MyDialog.showWithDelay(
        //       context, 'Message', '${registerResponse['payload']['message']}');
        //   registering = false;
        return true;
      }
      if (registerResponse.success == false) {
        await MyDialog.showWithDelay(context, 'Network Problem',
            'Please check your internet connection');
        registering = false;
        return false;
      }
      return false;
    } else {
      await MyDialog.showWithDelay(
          context, 'Alert', 'Please fill all required fields');
      registering = false;
      return false;
    }
  }

  List<SocialMediaName> usedSocialMediaNames = [];

  int _items = 0;
  void _onSocialAddPressed() {
    MyDialog.showWidget(
        context,
        'Select Media',
        Column(
          children: _generateSocialMediaDialogItems(),
        ));

    // socialMedias.add(SocialMediaItem.whatsapp(
    //     _items, TextEditingController(), _deleteSocialMediaItem));
    _items++;
  }

  List<Widget> _generateSocialMediaDialogItems() {
    var names = SocialMediaName.values;

    List<Widget> items = [];
    for (var name in names) {
      if (!usedSocialMediaNames.contains(name)) {
        items.add(_createSocialMediaSelectableItem(
          name,
          () {
            socialMedias.add(SocialMediaItem.byName(_items, name,
                _socialMediaControllerSelector(name), _deleteSocialMediaItem));
            setState(() {});
            usedSocialMediaNames.add(name);
            Navigation.goBack(context);
          },
        ));
      }
    }

    return items;
  }

  TextEditingController _socialMediaControllerSelector(SocialMediaName name) {
    switch (name) {
      case SocialMediaName.Whatsapp:
        return widget.whatsappSocialmediaController;
      case SocialMediaName.Instagram:
        return widget.instagramSocialmediaController;
      case SocialMediaName.Facebook:
        return widget.facebookSocialmediaController;
      case SocialMediaName.Twitter:
        return widget.twitterSocialmediaController;
    }
  }

  void _deleteSocialMediaItem(SocialMediaName name) {
//+++++ GOOD
    // SocialMediaItem? selectedItem;
    // for (var item in socialMedias) {
    //   if (item.id == id) {
    //     selectedItem = item;
    //     break;
    //   }
    // }

    // socialMedias.remove(selectedItem);

//+++++ NOT GOOD
    // int selectedIndex = -1;
    // for (int i = 0; i < socialMedias.length; i++) {
    //   if (socialMedias[i].id == id) {
    //     selectedIndex = i;
    //     break;
    //   }
    // }
    // if (selectedIndex != -1) socialMedias.removeAt(selectedIndex);

//+++++ BEST (LONG)
    // socialMedias.removeWhere((item) {
    //   return item.id == id;
    // });

//+++++ BEST (SHORT)

    socialMedias.removeWhere((item) => item.name == name);

    usedSocialMediaNames.remove(name);

    setState(() {});
  }

  Widget _createSocialMediaSelectableItem(
      SocialMediaName name, VoidCallback onClick) {
    String title = '';
    String logo = '';
    switch (name) {
      case SocialMediaName.Whatsapp:
        title = 'Whatsapp';
        logo = Logos.WHATSAPP_ICON;
        break;
      case SocialMediaName.Instagram:
        title = 'Instagram';
        logo = Logos.INTSTAGRAM_ICON;
        break;
      case SocialMediaName.Facebook:
        title = 'Facebook';
        logo = Logos.FACEBOOK_ICON;
        break;
      case SocialMediaName.Twitter:
        title = 'Twitter';
        logo = Logos.TWITTER_ICON;
        break;
    }
    return GestureDetector(
      onTap: onClick,
      child: Card(
        margin: const EdgeInsets.only(top: 15),
        elevation: 5,
        color: Colors.grey[200],
        child: Row(
          children: [
            Image.asset(
              logo,
              width: 40,
              height: 40,
              fit: BoxFit.fill,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(title),
          ],
        ),
      ),
    );
  }
}

enum SocialMediaName { Whatsapp, Instagram, Facebook, Twitter }
