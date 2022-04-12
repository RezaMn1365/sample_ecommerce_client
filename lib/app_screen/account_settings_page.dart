import 'dart:convert';

import 'package:flutter_application_1/app_screen/map_snapshot_provider.dart';
import 'package:flutter_application_1/app_screen/register_page.dart';
import 'package:flutter_application_1/helpers/my_dialog.dart';
import 'package:flutter_application_1/helpers/storage/icon_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/widgets/my_spacer.dart';
import 'package:flutter_application_1/widgets/my_text_form_field.dart';
import 'package:flutter_application_1/widgets/social_media_item.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_application_1/network/server_requests.dart'
    as serverRequest;
import 'package:shimmer/shimmer.dart';

class AccountSettingsPage extends StatelessWidget {
  AccountSettingsPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
        // MaterialApp(      home:
        DefaultTabController(
      length: 2,
      child: Scaffold(
        // backgroundColor: Colors.white70,
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.person), text: 'Profile update'),
              Tab(icon: Icon(Icons.lock), text: 'Password update'),
              // Tab(icon: Icon(Icons.directions_bike)),
            ],
          ),
          title: const Text('Account Settings'),
          centerTitle: true,
          titleSpacing: 5,
          toolbarHeight: 30,
        ),
        body: TabBarView(
          children: [
            ProfileUpdatePage(),
            PasswordUpdatePage(),
          ],
        ),
      ),
      // ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////

class ProfileUpdatePage extends StatefulWidget {
  String requestId = '';
  String email = '';
  // User user;
  ProfileUpdatePage({
    Key? key,
  }) : super(key: key);

  @override
  _ProfileUpdatePageState createState() => _ProfileUpdatePageState();
}

// class _AccountSettingsPageState extends State<AccountSettingsPage> {

class _ProfileUpdatePageState extends State<ProfileUpdatePage>
    with AutomaticKeepAliveClientMixin {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

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

  SocialMediaModel? socialMedia;
  LocationModel? location;

  bool invalidFirstName = false;
  bool invalidLastName = false;
  bool loading = false;
  bool updating = false;
  bool updated = false;

  final _formKey = GlobalKey<FormState>();

  List<SocialMediaItem> socialMedias = List.empty(growable: true);

  @override
  void initState() {
    Future.delayed(Duration.zero, () => _onceAfterBuild());
    super.initState();
  }

  void _onceAfterBuild() async {
    await fetchProfileData();
    _socialMediaFieldGenerator();
    setState(() {});
  }

  Future<void> _onRefresh() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    await fetchProfileData();
    setState(() {});
  }

  Future<void> fetchProfileData() async {
    var userMap = await serverRequest.getProfileAPI(context);
    if (userMap['success'] == true) {
      firstnameController.text = userMap['payload']!['profile']!['first_name'];
      lastnameController.text = userMap['payload']!['profile']!['last_name'];
      // emailController.text = userMap['payload']!['email'];
      addressController.text = userMap['payload']['profile']['address'];
      cityController.text = userMap['payload']['profile']['city'];
      countryController.text = userMap['payload']['profile']['country'];
      nationalidontroller.text = userMap['payload']['profile']['national_id'];
      provinceController.text = userMap['payload']['profile']['province'];
      zipController.text = userMap['payload']['profile']['zip'];
      location = LocationModel(
        LatLng(userMap['payload']['profile']['location']['coordinates'][0],
            userMap['payload']['profile']['location']['coordinates'][1]),
      );
      whatsappSocialmediaController.text =
          userMap['payload']['profile']['social_media']['USER_WHATSAPP'];
      instagramSocialmediaController.text =
          userMap['payload']['profile']['social_media']['USER_INSTAGRAM'];
      facebookSocialmediaController.text =
          userMap['payload']['profile']['social_media']['USER_FACEBOOK'];
      twitterSocialmediaController.text =
          userMap['payload']['profile']['social_media']['USER_TWITTER'];

      loading = true;
    } else {
      loading = false; //turn progress circule off
    }
  }

  Widget shimmerEffect() {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Shimmer.fromColors(
        baseColor: Colors.black26,
        highlightColor: Colors.black12,
        child: const Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            ),
          ),
          // elevation: 1,
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
            ),
            tileColor: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white70,
      //appBar: AppBar(
      //  title: const Text('Register Page'),
      //),
      //resizeToAvoidBottomInset: false,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Form(
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
                    // svgProvider(),
                    MainLogoBuilder.show('images/C1.png'),
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Center(
                        child: Text(
                          'Update your profile',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 20),
                      child: Center(
                        child: Text(
                          'Please enter your new profile information then click the Update button',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                    loading
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              MyTextFormField.norm(
                                  type: 'name',
                                  hint: 'Please enter your Name',
                                  lable: 'First Name',
                                  xController: firstnameController,
                                  textFormFieldPaddingValue: 25),
                              // : shimmerEffect(),
                              MyTextFormField.norm(
                                  type: 'username',
                                  hint: 'Please enter your Username',
                                  lable: 'Last name',
                                  xController: lastnameController,
                                  textFormFieldPaddingValue: 25),

                              MySpacer.vertical(40),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Social Media Account'),
                                  IconButton(
                                      onPressed: _onSocialAddPressed,
                                      icon: const Icon(Icons.add)),
                                ],
                              ),
                              ...socialMedias,

                              MyTextFormField.norm(
                                  type: 'phone',
                                  hint: 'Please enter your phone number',
                                  lable: 'Phone Number',
                                  xController: phoneController,
                                  textFormFieldPaddingValue: 25),

                              MyTextFormField.norm(
                                  type: 'country',
                                  hint: 'Please enter your country',
                                  lable: 'Country',
                                  xController: countryController,
                                  textFormFieldPaddingValue: 25),
                              MyTextFormField.norm(
                                  type: 'province',
                                  hint: 'Please enter your province',
                                  lable: 'Province',
                                  xController: provinceController,
                                  textFormFieldPaddingValue: 25),
                              MyTextFormField.norm(
                                  type: 'city',
                                  hint: 'Please enter your city',
                                  lable: 'City',
                                  xController: cityController,
                                  textFormFieldPaddingValue: 25),
                              MyTextFormField.norm(
                                  type: 'zip',
                                  hint: 'Please enter your zip postal code',
                                  lable: 'ZIP',
                                  xController: zipController,
                                  textFormFieldPaddingValue: 25),

                              Padding(
                                padding: const EdgeInsets.only(top: 40),
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  child: MapSnapShotProvider(
                                      location?.location ?? const LatLng(0, 0),
                                      onLocationUpdated: (loc) {
                                    location = LocationModel(loc);
                                    setState(() {});
                                  }),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 40,
                                ),
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.09,
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                        elevation:
                                            MaterialStateProperty.all(15),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate() &&
                                            updating != true) {
                                          updating = true;

                                          await _performProfileUpdate();
                                        }
                                        setState(() {
                                          // updating = false;
                                        });
                                      },
                                      child: updating
                                          ? const CircularProgressIndicator(
                                              color: Colors.white,
                                            )
                                          : const Text('Update profile')),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              shimmerEffect(),
                              shimmerEffect(),
                              shimmerEffect(),
                              shimmerEffect(),
                              shimmerEffect(),
                              shimmerEffect(),
                              shimmerEffect(),
                            ],
                          )
                  ],
                )),

            // )
          ),
        ),
      ),
    );
  }

  List<SocialMediaName> usedSocialMediaNames = [];

  void _socialMediaFieldGenerator() {
    if (whatsappSocialmediaController.text.isNotEmpty) {
      socialMedias.add(SocialMediaItem.byName(
          _items,
          SocialMediaName.Whatsapp,
          _socialMediaControllerSelector(SocialMediaName.Whatsapp),
          _deleteSocialMediaItem));
      setState(() {});
      usedSocialMediaNames.add(SocialMediaName.Whatsapp);
    }
    if (instagramSocialmediaController.text.isNotEmpty) {
      socialMedias.add(SocialMediaItem.byName(
          _items,
          SocialMediaName.Instagram,
          _socialMediaControllerSelector(SocialMediaName.Instagram),
          _deleteSocialMediaItem));
      setState(() {});
      usedSocialMediaNames.add(SocialMediaName.Instagram);
    }
    if (facebookSocialmediaController.text.isNotEmpty) {
      socialMedias.add(SocialMediaItem.byName(
          _items,
          SocialMediaName.Facebook,
          _socialMediaControllerSelector(SocialMediaName.Facebook),
          _deleteSocialMediaItem));
      setState(() {});
      usedSocialMediaNames.add(SocialMediaName.Facebook);
    }
    if (twitterSocialmediaController.text.isNotEmpty) {
      socialMedias.add(SocialMediaItem.byName(
          _items,
          SocialMediaName.Twitter,
          _socialMediaControllerSelector(SocialMediaName.Twitter),
          _deleteSocialMediaItem));
      setState(() {});
      usedSocialMediaNames.add(SocialMediaName.Twitter);
    }
  }

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
            Navigator.of(context).pop(context);
            // Navigation.goBack(context);
          },
        ));
      }
    }

    return items;
  }

  TextEditingController _socialMediaControllerSelector(SocialMediaName name) {
    switch (name) {
      case SocialMediaName.Whatsapp:
        return whatsappSocialmediaController;
      case SocialMediaName.Instagram:
        return instagramSocialmediaController;
      case SocialMediaName.Facebook:
        return facebookSocialmediaController;
      case SocialMediaName.Twitter:
        return twitterSocialmediaController;
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

    setState(() {
      switch (name) {
        case SocialMediaName.Whatsapp:
          whatsappSocialmediaController.text = '';
          break;
        case SocialMediaName.Instagram:
          instagramSocialmediaController.text = '';
          break;
        case SocialMediaName.Facebook:
          facebookSocialmediaController.text = '';
          break;
        case SocialMediaName.Twitter:
          twitterSocialmediaController.text = '';
          break;
      }
    });
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

  bool _myValidate() {
    String firstName = firstnameController.text;
    String lastName = lastnameController.text;

    setState(() {
      invalidFirstName = false;
      invalidLastName = false;
      if (firstName == '') invalidFirstName = true;
      if (lastName == '') invalidLastName = true;
    });

    return !invalidLastName && !invalidFirstName;
  }

  Future<bool> _performProfileUpdate() async {
    if (!_myValidate()) {
      MyDialog.show(context, 'Alert', 'Please fill all fields');
      updating = false;
      return false;
    } else {
      var finalSocialModel = SocialMediaModel(
          whatsapp: whatsappSocialmediaController.text,
          facebook: facebookSocialmediaController.text,
          instagram: instagramSocialmediaController.text,
          twitter: twitterSocialmediaController.text);

      var profile = Profile(
          first_name: firstnameController.text,
          last_name: lastnameController.text,
          address: addressController.text,
          city: cityController.text,
          country: countryController.text,
          location: location,
          national_id: nationalidontroller.text,
          province: provinceController.text,
          social_media: finalSocialModel,
          zip: zipController.text);

      print(jsonEncode(finalSocialModel));

      var profileUpdateResponse =
          await serverRequest.updateProfileAPI(context, profile);

      // await Future.delayed(const Duration(seconds: 2), () {
      // MyDialog.showProgress(
      //   context,
      //   'Please wait',
      //   const CircularProgressIndicator(
      //     backgroundColor: Colors.grey,
      //   ),
      // );
      // });

      if (profileUpdateResponse['success'] == true) {
        // Navigator.of(context).pop(context);
        await MyDialog.showWithDelay(context, 'Message',
            '${profileUpdateResponse['payload']['message']}');
        updating = false;
        return true;
      } else {
        await MyDialog.showWithDelay(context, 'Message', 'Unauthorized');
        updating = false;
        return false;
      }
    }
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
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

// class _AccountSettingsPageState extends State<AccountSettingsPage> {

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
  bool passUpdating = false;
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
                              passUpdating != true) {
                            passUpdating = true;
                            passUpdating = await _performPasswordUpdate();
                          }
                          setState(() {});
                        },
                        child: passUpdating
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
      return false;
    } else {
      var passwordUpdateResponse = await serverRequest.updatePasswordAPI(
          context,
          oldPassController.text,
          passController.text,
          repeatpassController.text);
      if (passwordUpdateResponse['success'] == true) {
        await MyDialog.showWithDelay(context, 'Message',
            '${passwordUpdateResponse['payload']['message']}');
        passUpdating = false;
        return true;
      } else {
        await MyDialog.showWithDelay(context, 'Message', 'Unauthorized');
        passUpdating = false;
        return false;
      }
    }
  }
}
