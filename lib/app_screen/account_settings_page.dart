import 'dart:convert';

import 'package:flutter_application_1/app_screen/map_snapshot_provider.dart';
import 'package:flutter_application_1/app_screen/password_update_tab.dart';
import 'package:flutter_application_1/app_screen/profile_update_tab.dart';
import 'package:flutter_application_1/app_screen/register_page.dart';
import 'package:flutter_application_1/helpers/my_dialog.dart';
import 'package:flutter_application_1/helpers/storage/icon_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/widgets/my_spacer.dart';
import 'package:flutter_application_1/widgets/my_text_form_field.dart';
import 'package:flutter_application_1/widgets/social_media_item.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:shimmer/shimmer.dart';

class AccountSettingsPage extends StatelessWidget {
  AccountSettingsPage({Key? key}) : super(key: key);

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
