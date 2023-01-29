import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:test_flutter_app/pages/loginPage.dart';
import 'package:test_flutter_app/widgets/simpleButton.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          SimpleButton(
              onPressedFunction: () async => {
                    await FirebaseAuth.instance.signOut(),
                                          PersistentNavBarNavigator.pushNewScreen(context, screen: LoginPage(), withNavBar: false)
                  },
              buttonLabel: "sign out")
        ],
      ),
    );
  }
}
