import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_flutter_app/pages/createPropertyPage.dart';
import 'package:test_flutter_app/pages/homePage.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:test_flutter_app/pages/propertiesPage.dart';
import 'package:test_flutter_app/pages/settingsPage.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    PersistentTabController _controller;

    _controller = PersistentTabController(initialIndex: 0);

    return PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: const ItemAnimationProperties( // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style15, // Choose the nav bar style with this property.
    );
  }


    List<Widget> _buildScreens() {
        return [
          const HomePage(),
          const CreatePropertyPage(),
          const SettingsPage()
        ];
    }
    
    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
          PersistentBottomNavBarItem(
              icon: const Icon(CupertinoIcons.home),
              title: ("Home"),
              activeColorPrimary: CupertinoColors.activeBlue,
              inactiveColorPrimary: CupertinoColors.systemGrey,
          ),
          PersistentBottomNavBarItem(
              icon: const Icon(CupertinoIcons.add),
              title: ("Settings"),
              activeColorPrimary: CupertinoColors.activeBlue,
              activeColorSecondary: CupertinoColors.white,
              inactiveColorPrimary: CupertinoColors.systemGrey,
          ),
          PersistentBottomNavBarItem(
              icon: const Icon(CupertinoIcons.settings),
              title: ("Settings"),
              activeColorPrimary: CupertinoColors.activeBlue,
              inactiveColorPrimary: CupertinoColors.systemGrey,
          ),
      ];
    }
}
