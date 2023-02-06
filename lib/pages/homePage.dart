import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:test_flutter_app/models/inventoryCheck.dart';
import 'package:test_flutter_app/pages/propertiesPage.dart';
import 'package:test_flutter_app/widgets/customAppBar.dart';
import 'package:test_flutter_app/widgets/inventoryCheckCard.dart';
import 'package:test_flutter_app/widgets/propertyCards.dart';
import 'package:test_flutter_app/widgets/simpleButton.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void navigateToPropertiesPage() {
    log("Navigating to properties page");

    PersistentNavBarNavigator.pushNewScreen(context,
        screen: const PropertiesPage());
  }

  InventoryCheck tempInvCheck = InventoryCheck(
      comments: List.of(<String>["comment1"]),
      clerkName: "Jason Stathum",
      dateCompleted: "03/02/2023",
      propertyAddress: "24 Valencia Croft, Birmingham, B35 7PH",
      checkIn: true);
  InventoryCheck tempInvCheck2 = InventoryCheck(
      comments: List.of(<String>[]),
      clerkName: "Chris Rock",
      dateCompleted: "28/11/2022",
      propertyAddress: "18 The Cedars, Fleet, GU51 3YL",
      checkIn: false);
  InventoryCheck tempInvCheck3 = InventoryCheck(
      comments: List.of(<String>["comment1", "comment2", "comment3"]),
      clerkName: "John Cena",
      dateCompleted: "30/10/2022",
      propertyAddress: "9 Broken Close, Cheshire, CH6 9HA",
      checkIn: true);

  @override
  Widget build(BuildContext context) {
    List<InventoryCheckCard> temporaryCards = [
      InventoryCheckCard(
        inventoryCheck: tempInvCheck,
      ),
      InventoryCheckCard(inventoryCheck: tempInvCheck2),
      InventoryCheckCard(inventoryCheck: tempInvCheck3)
    ];

    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Your properties",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 15.0),
              PropertyCards(
                numberOfCards: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SimpleButton(
                    onPressedFunction: navigateToPropertiesPage,
                    buttonLabel: "View more",
                  )
                ],
              ),
              const SizedBox(height: 15.0),
              const Text(
                "Recent inventory checks",
                style: TextStyle(fontSize: 17),
              ),
              const SizedBox(height: 15.0),
              SizedBox(
                height: 180,
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: temporaryCards.length,
                  itemBuilder: (BuildContext context, int index) =>
                      temporaryCards[index],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SimpleButton(
                    onPressedFunction: () {
                      log("view more inventory checks");
                    },
                    buttonLabel: "View more",
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getUserData() {}
}
