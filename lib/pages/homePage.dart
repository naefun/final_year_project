import 'dart:developer';

import 'package:test_flutter_app/models/inventoryCheck.dart';
import 'package:test_flutter_app/models/property.dart';
import 'package:test_flutter_app/store/actions.dart' as ReduxActions;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:test_flutter_app/models/inventoryCheckOld.dart';
import 'package:test_flutter_app/models/inventoryCheckRequest.dart';
import 'package:test_flutter_app/pages/propertiesPage.dart';
import 'package:test_flutter_app/services/dbService.dart';
import 'package:test_flutter_app/services/fireAuth.dart';
import 'package:test_flutter_app/widgets/customAppBar.dart';
import 'package:test_flutter_app/widgets/inventoryCheckCard.dart';
import 'package:test_flutter_app/widgets/inventoryCheckCardOld.dart';
import 'package:test_flutter_app/widgets/propertyCards.dart';
import 'package:test_flutter_app/widgets/simpleButton.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<InventoryCheck>? inventoryChecks;
  List<InventoryCheckCard>? inventoryCheckCards;
  List<InventoryCheckRequest>? inventoryCheckRequests;
  List<InventoryCheckCardOld>? inventoryCheckRequestCards;
  List<Property>? properties;
  bool reloadData = false;
  PropertyCards? pCards;

  void navigateToPropertiesPage() {
    log("Navigating to properties page");

    PersistentNavBarNavigator.pushNewScreen(context,
        screen: const PropertiesPage());
  }

  InventoryCheck newTempInvCheck = InventoryCheck(
      id: "f2dedd50-1683-462e-b6b8-ac2943c0b962",
      propertyId: "7a723b2c-846b-4969-8f7a-fdec218baeef",
      complete: true,
      type: 1,
      clerkEmail: "n@n.co",
      checkCompletedDate: "2023-02-21 01:32:32.418722");
  InventoryCheckOld tempInvCheck = InventoryCheckOld(
      comments: List.of(<String>["comment1"]),
      clerkName: "Jason Stathum",
      dateCompleted: "03/02/2023",
      propertyAddress: "24 Valencia Croft, Birmingham, B35 7PH",
      checkIn: true);
  InventoryCheckOld tempInvCheck2 = InventoryCheckOld(
      comments: List.of(<String>[]),
      clerkName: "Chris Rock",
      dateCompleted: "28/11/2022",
      propertyAddress: "18 The Cedars, Fleet, GU51 3YL",
      checkIn: false);
  InventoryCheckOld tempInvCheck3 = InventoryCheckOld(
      comments: List.of(<String>["comment1", "comment2", "comment3"]),
      clerkName: "John Cena",
      dateCompleted: "30/10/2022",
      propertyAddress: "9 Broken Close, Cheshire, CH6 9HA",
      checkIn: true);
  InventoryCheckRequest tempInvCheckReq1 = InventoryCheckRequest(
      type: 1,
      clerkEmail: "clerk@clerk.com",
      checkDate: "21/02/2023",
      propertyId: "1e3a16d9-038e-4073-aa34-03ff6195fabe");
  InventoryCheckRequest tempInvCheckReq2 = InventoryCheckRequest(
      type: 2,
      clerkEmail: "clerkyclerk@clerkyclerk.com",
      checkDate: "21/03/2023",
      propertyId: "1e3a16d9-038e-4073-aa34-03ff6195fabe");

  @override
  Widget build(BuildContext context) {
    if (inventoryChecks == null) getInventoryChecks();
    if (inventoryChecks != null &&
        inventoryChecks!.isNotEmpty &&
        inventoryCheckCards == null) {
      createInventoryCheckCards();
    }
    if (properties == null) getProperties();
    if (properties != null && pCards == null) {
      setPropertyCards();
    }

    List<InventoryCheckCardOld> temporaryCards = [
      InventoryCheckCardOld(
        inventoryCheck: tempInvCheck,
      ),
      InventoryCheckCardOld(inventoryCheck: tempInvCheck2),
      InventoryCheckCardOld(inventoryCheck: tempInvCheck3),
    ];
    List<InventoryCheckCardOld> temporaryInvCheckRequestCards = [
      InventoryCheckCardOld(
        inventoryCheckRequest: tempInvCheckReq1,
      ),
    ];
    List<InventoryCheckCard> tempInvCheckCards = [
      InventoryCheckCard(
        inventoryCheck: newTempInvCheck,
      ),
    ];

    if (inventoryCheckRequests == null) {
      getInventoryCheckRequests();
    }

    if (inventoryCheckRequests != null && inventoryCheckRequestCards == null) {
      createInventoryCheckRequestCards();
    }

    return Scaffold(
      appBar: CustomAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          // Replace this delay with the code to be executed during refresh
          // and return a Future when code finishs execution.
          return refreshData();
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Your properties",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 15.0),
                properties != null
                    ? PropertyCards(
                        numberOfCards: 2,
                        propertiesArg: properties,
                      )
                    : SizedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SimpleButton(
                      onPressedFunction: navigateToPropertiesPage,
                      buttonLabel: "View all properties",
                    )
                  ],
                ),
                const SizedBox(height: 15.0),
                const Text(
                  "Recent inventory checks",
                  style: TextStyle(fontSize: 17),
                ),
                const SizedBox(height: 15.0),
                inventoryCheckCards != null && inventoryCheckCards!.isNotEmpty
                    ? SizedBox(
                        height: 180,
                        child: ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: inventoryCheckCards!.length,
                          itemBuilder: (BuildContext context, int index) =>
                              inventoryCheckCards![index],
                        ),
                      )
                    : Text("You have no recent inventory checks"),
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
                const SizedBox(height: 15.0),
                const Text(
                  "Inventory check requests",
                  style: TextStyle(fontSize: 17),
                ),
                const SizedBox(height: 15.0),
                inventoryCheckRequestCards != null
                    ? SizedBox(
                        height: 180,
                        child: ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: inventoryCheckRequestCards!.length,
                          itemBuilder: (BuildContext context, int index) =>
                              inventoryCheckRequestCards![index],
                        ),
                      )
                    : SizedBox(
                        height: 20,
                        child: Text("You have no inventory check requests"),
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SimpleButton(
                      onPressedFunction: () {
                        log("view more inventory check requests");
                      },
                      buttonLabel: "View more",
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> refreshData() async {
    await clearStates();
    // getInventoryCheckRequests();
    // getInventoryChecks();
    // createInventoryCheckCards();
    // // createInventoryCheckRequestCards();
    // setPropertyCards();
  }

  void getInventoryCheckRequests() async {
    List<InventoryCheckRequest> icrs = [];
    await DbService.getLandlordInventoryCheckRequests(
            FireAuth.getCurrentUser()!.uid)
        .then((value) => {
              if (value != null)
                {
                  for (QueryDocumentSnapshot<InventoryCheckRequest> icr
                      in value)
                    {
                      if (icr.data().checkDate != null &&
                          icr.data().clerkEmail != null &&
                          icr.data().propertyId != null &&
                          icr.data().type != null &&
                          icr.data().complete != null &&
                          icr.data().complete == false)
                        {icrs.add(icr.data())}
                    }
                }
            });

    setState(() {
      inventoryCheckRequests = icrs;
    });
  }

  void createInventoryCheckRequestCards() {
    List<InventoryCheckCardOld> icc = [];
    for (InventoryCheckRequest icr in inventoryCheckRequests!) {
      icc.add(InventoryCheckCardOld(
        inventoryCheckRequest: icr,
      ));
    }

    if (icc.isNotEmpty) {
      setState(() {
        inventoryCheckRequestCards = icc;
      });
    }
  }

  Future<void> getInventoryChecks() async {
    List<QueryDocumentSnapshot<InventoryCheck>> inventoryCheckQueryDocuments =
        [];
    await DbService.getInventoryChecks(FireAuth.getCurrentUser()!.uid)
        .then((value) {
      inventoryCheckQueryDocuments = value ?? [];
    });

    List<InventoryCheck> tempInventoryChecks = [];
    for (var i = 0; i < inventoryCheckQueryDocuments.length; i++) {
      tempInventoryChecks.add(inventoryCheckQueryDocuments[i].data());
    }

    setState(() {
      inventoryChecks = tempInventoryChecks;
    });
  }

  void createInventoryCheckCards() {
    List<InventoryCheckCard> invCheckCards = [];

    if (inventoryChecks != null) {
      for (InventoryCheck invCheck in inventoryChecks!) {
        invCheckCards.add(InventoryCheckCard(inventoryCheck: invCheck));
      }
    }

    setState(() {
      inventoryCheckCards = invCheckCards;
    });
  }

  Future<void> clearStates() async {
    setState(() {
      properties = null;
      inventoryChecks = null;
      inventoryCheckRequests = null;
      inventoryCheckCards = null;
      inventoryCheckRequestCards = null;
      pCards = null;
    });
  }

  Future<void> setPropertyCards() async {
    PropertyCards tempPropertyCards = PropertyCards(
      numberOfCards: 2,
      propertiesArg: properties,
    );

    setState(() {
      pCards = tempPropertyCards;
    });
  }

  void getProperties() async {
    List<Property> tempProperties = [];
    List<QueryDocumentSnapshot<Property>> propertyQueryDocuments = [];

    await DbService.getOwnedProperties(FireAuth.getCurrentUser()!.uid)
        .then((value) => propertyQueryDocuments = value ?? []);

    for (QueryDocumentSnapshot<Property> d in propertyQueryDocuments) {
      tempProperties.add(d.data());
    }

    setState(() {
      properties = tempProperties;
    });
  }
}
