import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:test_flutter_app/pages/loginPage.dart';

class PageNavigator {
  static void navigateToHomePage(BuildContext context, {bool includeNavBar = false}) {
    PersistentNavBarNavigator.pushNewScreen(context,
        screen: LoginPage(),
        withNavBar: includeNavBar,
        pageTransitionAnimation: PageTransitionAnimation.slideRight);
  }
}
