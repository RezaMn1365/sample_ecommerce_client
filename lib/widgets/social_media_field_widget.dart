import 'package:flutter/material.dart';

import 'my_text_form_field.dart';

class SocialMediaRegisterField extends StatefulWidget {
  String currentMediaSelected;

  TextEditingController socialmediaController = TextEditingController();
  final VoidCallback onDeleteClicked;
  final VoidCallback onAddClicked;
  final Function onPopUpItemSelected;
  final List<PopupItem> list;
  // final List<String> defautItemList;
  bool showPopUpBottom = true;

  SocialMediaRegisterField({
    Key? key,
    required this.onAddClicked,
    required this.onDeleteClicked,
    required this.socialmediaController,
    required this.onPopUpItemSelected,
    required this.list,
    required this.showPopUpBottom,
    required this.currentMediaSelected,
  }) : super(key: key);
//
  @override
  _SocialMediaRegisterFieldState createState() =>
      _SocialMediaRegisterFieldState();
}

class _SocialMediaRegisterFieldState extends State<SocialMediaRegisterField> {
//
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Expanded(
        //     flex: 2,
        //     child: ElevatedButton(
        //       style: ElevatedButton.styleFrom(
        //           primary: Colors.transparent,
        //           shape: const CircleBorder(),
        //           alignment: Alignment.center),
        //       onPressed: () {
        //         // fieldNumber = '-';
        //         widget.onDeleteClicked();
        //         // print(fieldNumber);
        //       },
        //       child: const Icon(
        //         Icons.delete,
        //         color: Colors.black26,
        //       ),
        //     )),

        Expanded(
          flex: 1,
          child: widget.showPopUpBottom == true
              ? PopupMenuButton(
                  offset: const Offset(20, 50),
                  elevation: 25,
                  color: Colors.grey,
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (BuildContext context) {
                    return widget.list.map(
                      (PopupItem choice) {
                        return PopupMenuItem(
                          onTap: () {
                            // _socialMediaSetter(choice.name);
                            widget.onPopUpItemSelected(choice);
                          },
                          value: choice,
                          child: //Text(choice.name),
                              ListTile(
                            leading: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                foregroundImage: AssetImage(choice.address)),
                            title: Text(choice.name),
                          ),
                        );
                      },
                    ).toList();
                  },
                )
              : const SizedBox(
                  width: 2,
                ),
        ),

        // => <PopupMenuEntry>[
        // PopupMenuItem(
        //   onTap: () => _socialMediaSetter('whatsapp'),
        //   child: const ListTile(
        //     leading: CircleAvatar(
        //         backgroundColor: Colors.transparent,
        //         foregroundImage: AssetImage('images/whatsapp.png')),
        //     title: Text('whatsapp'),
        //   ),
        // ),
        // PopupMenuItem(
        //   onTap: () => _socialMediaSetter('instagram'),
        //   child: const ListTile(
        //     leading: CircleAvatar(
        //         backgroundColor: Colors.transparent,
        //         foregroundImage: AssetImage('images/instagram.png')),
        //     title: Text('instagram'),
        //   ),
        // ),
        // PopupMenuItem(
        //   onTap: () => _socialMediaSetter('facebook'),
        //   child: const ListTile(
        //     leading: CircleAvatar(
        //         backgroundColor: Colors.transparent,
        //         foregroundImage: AssetImage('images/facebook.png')),
        //     title: Text('facebook'),
        //   ),
        // ),
        // PopupMenuItem(
        //   onTap: () => _socialMediaSetter('twitter'),
        //   child: const ListTile(
        //     leading: CircleAvatar(
        //         backgroundColor: Colors.transparent,
        //         foregroundImage: AssetImage('images/twitter.png')),
        //     title: Text('twitter'),
        //   ),
        // ),
        // ],
        // ),

        Expanded(
          flex: 8,
          child: MyTextFormField.social(
            // type: 'socialmedia',
            hint: '${widget.currentMediaSelected} address',
            lable: ' ${widget.currentMediaSelected}',
            xController: widget.socialmediaController,
            textFormFieldPaddingValue: 1,
            socialMediaLogo: _socialMediaSetter1(widget.currentMediaSelected),
          ),
        ),
        // Expanded(
        //   flex: 2,
        //   child: ElevatedButton(
        //     style: ElevatedButton.styleFrom(
        //         primary: Colors.transparent,
        //         shape: const CircleBorder(),
        //         alignment: Alignment.center),
        //     onPressed: () {
        //       widget.onAddClicked();
        //     },
        //     child: const Icon(Icons.add),
        //   ),
        // ),
      ],
    );
  }

  String _socialMediaSetter1(String media) {
    if (media == 'whatsapp') {
      return 'images/whatsapp.png';
    } else if (media == 'instagram') {
      return 'images/instagram.png';
    } else if (media == 'twitter') {
      return 'images/twitter.png';
    } else if (media == 'facebook') {
      return 'images/facebook.png';
    } else {
      return 'images/whatsapp.png';
    }
  }

//
  void _socialMediaSetter(String media) {
    if (media == 'whatsapp') {
      // widget.socialMediaLogo = 'images/whatsapp.png';
      widget.currentMediaSelected = 'whatsapp';
      setState(() {});
    } else if (media == 'instagram') {
      // widget.socialMediaLogo = 'images/instagram.png';
      widget.currentMediaSelected = 'instagram';
      setState(() {});
    } else if (media == 'twitter') {
      // widget.socialMediaLogo = 'images/twitter.png';
      widget.currentMediaSelected = 'twitter';
      setState(() {});
    } else if (media == 'facebook') {
      // widget.socialMediaLogo = 'images/facebook.png';
      widget.currentMediaSelected = 'facebook';
      setState(() {});
    } else {
      // widget.socialMediaLogo = 'images/whatsapp.png';
      widget.currentMediaSelected = 'whatsapp';
      setState(() {});
    }
  }
}

class PopupItem {
  int value;
  String name;
  String address;
  PopupItem(this.value, this.name, this.address);
}
