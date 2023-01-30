import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:test_flutter_app/models/user.dart' as AppUser;
import 'package:test_flutter_app/pages/loginPage.dart';
import 'package:test_flutter_app/services/dbService.dart';
import 'package:test_flutter_app/services/fireAuth.dart';
import 'package:test_flutter_app/widgets/simpleButton.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  User? currentUser = FireAuth.getCurrentUser();
  AppUser.User? myUser;
  getUser() async {
    await DbService.getUserDocument(currentUser!.uid)
        .then((value) => setState(() {
              myUser = value;
            }));
  }

  @override
  Widget build(BuildContext context) {
    if(myUser == null){
      getUser.call();
    }

    return Container(
      child: ListView(
        children: [
          Text(
              "Hello ${myUser != null && myUser!.firstName != null ? myUser!.firstName! : "User"}"),
          SimpleButton(
              onPressedFunction: () async => {
                    await FireAuth.signOut(),
                    PersistentNavBarNavigator.pushNewScreen(context,
                        screen: LoginPage(), withNavBar: false)
                  },
              buttonLabel: "sign out"),
          SimpleButton(
              onPressedFunction: () =>
                  {log(FireAuth.getCurrentUser().toString())},
              buttonLabel: "${myUser?.firstName}"),
        ],
      ),
    );
  }
}
