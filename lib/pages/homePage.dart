import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:test_flutter_app/pages/propertiesPage.dart';
import 'package:test_flutter_app/widgets/propertyCards.dart';
import 'package:test_flutter_app/widgets/simpleButton.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void navigateToPropertiesPage(){
    log("Navigating to properties page");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PropertiesPage()));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Text(
          "Properties",
          style: TextStyle(fontSize: 20),
        ),
        PropertyCards(
          numberOfCards: 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SimpleButton(onPressedFunction: navigateToPropertiesPage)
          ],
        )
      ],
    );
  }
}
