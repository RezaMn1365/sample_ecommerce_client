import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/my_text_form_field.dart';

class SocialMediaRegisterField extends StatefulWidget {
  SocialMediaRegisterField({
    Key? key,
  }
      // required BuildContext context,
      // required socialmediaController,
      //currentMediaSelected
      ) : super(key: key);

  @override
  _SocialMediaRegisterFieldState createState() =>
      _SocialMediaRegisterFieldState();
}

class _SocialMediaRegisterFieldState extends State<SocialMediaRegisterField> {
  String socialMediaLogo = 'images/whatsapp.png';
  String socialMediaTitle = 'whatsapp';
  String currentMediaSelected = 'whatsapp';
  TextEditingController socialmediaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
            flex: 1,
            child: PopupMenuButton(
                offset: const Offset(20, 50),
                elevation: 25,
                color: Colors.grey,
                icon: const Icon(Icons.more_vert),
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                      PopupMenuItem(
                        onTap: () => _socialMediaSetter('whatsapp'),
                        child: const ListTile(
                          leading: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              foregroundImage:
                                  AssetImage('images/whatsapp.png')),
                          title: Text('whatsapp'),
                        ),
                      ),
                      PopupMenuItem(
                        onTap: () => _socialMediaSetter('instagram'),
                        child: const ListTile(
                          leading: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              foregroundImage:
                                  AssetImage('images/instagram.png')),
                          title: Text('instagram'),
                        ),
                      ),
                      PopupMenuItem(
                        onTap: () => _socialMediaSetter('facebook'),
                        child: const ListTile(
                          leading: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              foregroundImage:
                                  AssetImage('images/facebook.png')),
                          title: Text('facebook'),
                        ),
                      ),
                      PopupMenuItem(
                        onTap: () => _socialMediaSetter('twitter'),
                        child: const ListTile(
                          leading: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              foregroundImage:
                                  AssetImage('images/twitter.png')),
                          title: Text('twitter'),
                        ),
                      ),
                    ])),
        Expanded(
          flex: 8,
          child: MyTextFormField.social(
            // type: 'socialmedia',
            hint: '$currentMediaSelected address',
            lable: ' $currentMediaSelected',
            xController: socialmediaController,
            textFormFieldPaddingValue: 15,
            socialMediaLogo: socialMediaLogo,
          ),
        ),
      ],
    );
  }

  void _socialMediaSetter(String media) {
    if (media == 'whatsapp') {
      socialMediaLogo = 'images/whatsapp.png';
      currentMediaSelected = 'whatsapp';
    }
    if (media == 'instagram') {
      socialMediaLogo = 'images/instagram.png';
      currentMediaSelected = 'instagram';
    }
    if (media == 'twitter') {
      socialMediaLogo = 'images/twitter.png';
      currentMediaSelected = 'twitter';
    }
    if (media == 'facebook') {
      socialMediaLogo = 'images/facebook.png';
      currentMediaSelected = 'facebook';
    }
    // else {
    //   socialMediaLogo = 'images/whatsapp.png';
    //   currentMediaSelected = 'whatsapp';
    // }
    // setState(() {});
  }
}


  // dynamic _socialMediaControllerSelector() {
  //   if (socialMediaLogo == 'images/instagram.png') {
  //     return widget.instagramSocialmediaController;
  //   }
  //   if (socialMediaLogo == 'images/whatsapp.png') {
  //     return widget.whatsappSocialmediaController;
  //   }
  //   if (socialMediaLogo == 'images/facebook.png') {
  //     return widget.facebookSocialmediaController;
  //   }
  //   if (socialMediaLogo == 'images/twitter.png') {
  //     return widget.twitterSocialmediaController;
  //   } else {
  //     return widget.whatsappSocialmediaController;
  //   }
  // }


