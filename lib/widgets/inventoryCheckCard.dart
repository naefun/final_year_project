import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:test_flutter_app/models/comment.dart';
import 'package:test_flutter_app/models/inventoryCheck.dart';
import 'package:test_flutter_app/models/inventoryCheckOld.dart';
import 'package:test_flutter_app/models/inventoryCheckRequest.dart';
import 'package:test_flutter_app/models/property.dart';
import 'package:test_flutter_app/models/user.dart';
import 'package:test_flutter_app/pages/inventoryCheckPage.dart';
import 'package:test_flutter_app/pages/inventoryCheckRequestFormPage.dart';
import 'package:test_flutter_app/services/dbService.dart';
import 'package:test_flutter_app/services/fireAuth.dart';
import 'package:test_flutter_app/utilities/comment_utilities.dart';
import 'package:test_flutter_app/utilities/date_utilities.dart';
import 'package:test_flutter_app/utilities/global_values.dart';
import 'package:test_flutter_app/widgets/commentNotificationIcon.dart';

class InventoryCheckCard extends StatefulWidget {
  InventoryCheck inventoryCheck;

  InventoryCheckCard({Key? key, required this.inventoryCheck})
      : super(key: key);

  @override
  _InventoryCheckCardState createState() => _InventoryCheckCardState();
}

class _InventoryCheckCardState extends State<InventoryCheckCard> {
  Color checkInCardAccentColour = const Color(0xFF579A56);
  Color checkOutCardAccentColour = const Color(0xFFE76E6E);
  Color? cardAccentColour;
  String? clerkName;
  bool? checkIn;
  Property? property;
  int? commentsSize;
  int? daysSinceCheck;

  @override
  Widget build(BuildContext context) {
    if (commentsSize == null) getNumberOfComments();
    if (property == null) getProperty();
    if (checkIn == null) setInventoryCheckType();
    if (cardAccentColour == null) setCardAccentColor();
    if (daysSinceCheck == null) setDaysSinceCheck();
    if (clerkName == null) getClerkName();

    return GestureDetector(
      onTap: () {
        PersistentNavBarNavigator.pushNewScreen(context,
            screen: InventoryCheckPage(inventoryCheck: widget.inventoryCheck));
      },
      child: SizedBox(
        width: 170,
        height: 20,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            //set border radius more than 50% of height and width to make circle
          ),
          child: ClipPath(
            clipper: ShapeBorderClipper(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4))),
            child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(color: cardAccentColour!, width: 7))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        getPropertyAddress(),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          CommenNotificationIcon(inventoryCheck: widget.inventoryCheck),
                          const SizedBox(
                            width: 5,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                commentsSize != null
                                    ? commentsSize!.toString()
                                    : "0",
                                style: const TextStyle(fontSize: 25),
                              ),
                              Text(commentsSize != null && commentsSize != 1
                                  ? " comments"
                                  : " comment")
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          ImageIcon(
                            AssetImage(checkIn != null && checkIn! == true
                                ? IconPaths.checkInIconPath.path
                                : IconPaths.checkOutIconPath.path),
                            size: 28,
                            color: const Color(0xFF636363),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                    daysSinceCheck != null
                                        ? daysSinceCheck!.toString()
                                        : "N/A",
                                    style: const TextStyle(fontSize: 25)),
                                Text((daysSinceCheck != null &&
                                        daysSinceCheck != 1)
                                    ? " days ago"
                                    : " day ago"),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ImageIcon(
                            AssetImage(IconPaths.clerkIconPath.path),
                            size: 28,
                            color: const Color(0xFF636363),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(clerkName != null ? clerkName! : " James Connor")
                        ],
                      ),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }

  String getPropertyAddress() {
    if (property == null) return "no address given";

    String address = "";

    if (property != null) {
      address += property!.addressHouseNameOrNumber != null
          ? property!.addressHouseNameOrNumber!
          : "";
      address += property!.addressRoadName != null
          ? " ${property!.addressRoadName!}"
          : "";
      address +=
          property!.addressCity != null ? ", ${property!.addressCity!}" : "";
      address += property!.addressPostcode != null
          ? ", ${property!.addressPostcode!}"
          : "";
    }

    return address;
  }

  void getProperty() async {
    Property? tempProperty;

    await DbService.getProperty(widget.inventoryCheck.propertyId!)
        .then((value) => {
              if (value != null) {tempProperty = value.data()}
            });

    if (tempProperty != null) {
      setState(() {
        property = tempProperty;
      });
    }
  }

  Future<void> getNumberOfComments() async {
    await DbService.getNumberOfInventoryCheckComments(widget.inventoryCheck.id!)
        .then((value) {
      setState(() {
        commentsSize = value;
      });
    });
  }

  void setInventoryCheckType() {
    setState(() {
      checkIn = widget.inventoryCheck.type == 1 ? true : false;
    });
  }

  void setCardAccentColor() {
    setState(() {
      cardAccentColour = checkIn != null && checkIn == true
          ? checkInCardAccentColour
          : checkOutCardAccentColour;
    });
  }

  void setDaysSinceCheck() {
    if (widget.inventoryCheck.checkCompletedDate == null) return;
    List<String> yyyymmdd =
        widget.inventoryCheck.checkCompletedDate!.split(" ").first.split("-");
    String ddmmyyyy = "${yyyymmdd[2]}/${yyyymmdd[1]}/${yyyymmdd[0]}";

    if (DateUtilities.validDate(ddmmyyyy)) {
      int? dateCheck =
          DateUtilities.dateStringToDaysRemaining(DateTime.now(), ddmmyyyy);
      setState(() {
        daysSinceCheck = dateCheck != null ? dateCheck * -1 : null;
      });
      if (daysSinceCheck != null) log(daysSinceCheck.toString());
    }
  }

  void getClerkName() {
    if (widget.inventoryCheck.clerkEmail == null) return;
    DbService.getUserDocumentFromEmail(widget.inventoryCheck.clerkEmail!)
        .then((value) {
      setState(() {
        clerkName = "${value!.firstName} ${value.lastName}";
      });
    });
  }
}