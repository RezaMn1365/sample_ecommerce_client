import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_screen/register_page.dart';
import 'package:flutter_application_1/widgets/my_text_form_field.dart';

class SocialMediaItem extends StatelessWidget {
  final TextEditingController controller;
  final String logo;
  final String hint;
  final String label;
  final SocialMediaName name;
  final void Function(SocialMediaName name) onDelete;

  SocialMediaItem(this.name, this.label, this.hint, this.logo, this.controller,
      this.onDelete);

  SocialMediaItem.whatsapp(this.name, this.controller, this.onDelete)
      : label = 'Whatsapp',
        hint = 'Whatsapp',
        logo = Logos.WHATSAPP_ICON;

  SocialMediaItem.instagram(this.name, this.controller, this.onDelete)
      : label = 'Instagram',
        hint = 'Instagram',
        logo = Logos.INTSTAGRAM_ICON;

  SocialMediaItem.facebook(this.name, this.controller, this.onDelete)
      : label = 'Facebook',
        hint = 'Facebook',
        logo = Logos.FACEBOOK_ICON;

  SocialMediaItem.twitter(this.name, this.controller, this.onDelete)
      : label = 'Twitter',
        hint = 'Twitter',
        logo = Logos.TWITTER_ICON;

  factory SocialMediaItem.byName(
      id, SocialMediaName name, controller, onDelete) {
    // return SocialMediaItem.facebook(id, controller, (id) { });
    switch (name) {
      case SocialMediaName.Whatsapp:
        return SocialMediaItem.whatsapp(name, controller, onDelete);
      case SocialMediaName.Instagram:
        return SocialMediaItem.instagram(name, controller, onDelete);
      case SocialMediaName.Facebook:
        return SocialMediaItem.facebook(name, controller, onDelete);
      case SocialMediaName.Twitter:
        return SocialMediaItem.twitter(name, controller, onDelete);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: MyTextFormField.social(
            hint: hint,
            lable: label,
            xController: controller,
            textFormFieldPaddingValue: 10,
            socialMediaLogo: logo,
          ),
        ),
        IconButton(
          onPressed: () => onDelete(name),
          icon: const Icon(Icons.delete),
        ),
      ],
    );
  }
}

//+++++++++++++ Move to separated file
class Logos {
  static const String WHATSAPP_ICON = 'images/whatsapp.png';
  static const String INTSTAGRAM_ICON = 'images/instagram.png';
  static const String FACEBOOK_ICON = 'images/facebook.png';
  static const String TWITTER_ICON = 'images/twitter.png';
}
