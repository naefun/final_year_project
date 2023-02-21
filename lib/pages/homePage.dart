import 'dart:developer';

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
import 'package:test_flutter_app/widgets/propertyCards.dart';
import 'package:test_flutter_app/widgets/simpleButton.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<InventoryCheckRequest>? inventoryCheckRequests;
  List<InventoryCheckCard>? inventoryCheckRequestCards;
  bool reloadData = false;
  PropertyCards pCards = PropertyCards(
    numberOfCards: 2,
  );

  void navigateToPropertiesPage() {
    log("Navigating to properties page");

    PersistentNavBarNavigator.pushNewScreen(context,
        screen: const PropertiesPage());
  }

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
    List<InventoryCheckCard> temporaryCards = [
      InventoryCheckCard(
        inventoryCheck: tempInvCheck,
      ),
      InventoryCheckCard(inventoryCheck: tempInvCheck2),
      InventoryCheckCard(inventoryCheck: tempInvCheck3),
    ];
    List<InventoryCheckCard> temporaryInvCheckRequestCards = [
      InventoryCheckCard(
        inventoryCheckRequest: tempInvCheckReq1,
      ),
      // InventoryCheckCard(
      //   inventoryCheckRequest: tempInvCheckReq2,
      // ),
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
                pCards,
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
                        height: 180,
                        child: ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: temporaryInvCheckRequestCards.length,
                          itemBuilder: (BuildContext context, int index) =>
                              temporaryInvCheckRequestCards[index],
                        ),
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
                StoreConnector<bool, String>(
                    converter: (store) => store.state.toString(),
                    builder: (context, viewModel) {
                      return Text(viewModel, style: TextStyle(fontSize: 24));
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> refreshData() async {
    setState(() {
      pCards = PropertyCards(
        numberOfCards: 2,
      );
    });
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
                          icr.data().type != null)
                        {
                          log("creating icr"),
                          icrs.add(InventoryCheckRequest(
                              checkDate: icr.data().checkDate,
                              clerkEmail: icr.data().clerkEmail,
                              propertyId: icr.data().propertyId,
                              type: icr.data().type))
                        }
                    }
                }
            });

    if (icrs.isNotEmpty) {
      setState(() {
        inventoryCheckRequests = icrs;
      });
    }
  }

  void createInventoryCheckRequestCards() {
    List<InventoryCheckCard> icc = [];
    for (InventoryCheckRequest icr in inventoryCheckRequests!) {
      icc.add(InventoryCheckCard(
        inventoryCheckRequest: icr,
      ));
    }

    if (icc.isNotEmpty) {
      setState(() {
        inventoryCheckRequestCards = icc;
      });
    }
  }
}
