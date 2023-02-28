import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:test_flutter_app/models/inventoryCheckOld.dart';
import 'package:test_flutter_app/models/inventoryCheckRequest.dart';
import 'package:test_flutter_app/models/property.dart';
import 'package:test_flutter_app/models/user.dart';
import 'package:test_flutter_app/pages/inventoryCheckRequestFormPage.dart';
import 'package:test_flutter_app/services/dbService.dart';
import 'package:test_flutter_app/services/fireAuth.dart';
import 'package:test_flutter_app/utilities/date_utilities.dart';
import 'package:test_flutter_app/utilities/global_values.dart';

class InventoryCheckCardOld extends StatefulWidget {
  InventoryCheckOld? inventoryCheck;

  InventoryCheckRequest? inventoryCheckRequest;
  InventoryCheckCardOld(
      {Key? key, this.inventoryCheck, this.inventoryCheckRequest})
      : super(key: key);

  @override
  _InventoryCheckCardOldState createState() => _InventoryCheckCardOldState();
}

class _InventoryCheckCardOldState extends State<InventoryCheckCardOld> {
  Color checkInCardAccentColour = const Color(0xFF579A56);
  Color checkOutCardAccentColour = const Color(0xFFE76E6E);
  Color inventoryCheckRequestCardAccentColour = const Color(0xFFEFA73A);
  Color cardAccentColour = const Color(0xFFFFFFFF);
  String? clerkName;
  bool? checkIn;
  String? propertyAddress;
  bool completedInventoryCheck = true;
  User? clerk;

  // in the case that a completed inventory check is passed
  int? commentsSize;
  int? daysSinceCheck;

  // in the case that an inventory check request is passed
  String inventoryCheckRequestMessage = "Inventory check request";
  int? daysUntilCheck;
  Property? icrProperty;

  @override
  Widget build(BuildContext context) {
    if (clerk == null) getClerkUserViaEmail();

    if (widget.inventoryCheck != null) {
      propertyAddress = widget.inventoryCheck!.propertyAddress;
      clerkName = widget.inventoryCheck!.clerkName;
      commentsSize = widget.inventoryCheck!.comments != null
          ? widget.inventoryCheck!.comments!.length
          : null;
      checkIn = widget.inventoryCheck!.checkIn;
      cardAccentColour = checkIn != null && checkIn == true
          ? checkInCardAccentColour
          : checkOutCardAccentColour;
      if (widget.inventoryCheck!.dateCompleted != null &&
          DateUtilities.validDate(widget.inventoryCheck!.dateCompleted!)) {
        int? dateCheck = DateUtilities.dateStringToDaysRemaining(
            DateTime.now(), widget.inventoryCheck!.dateCompleted!);
        daysSinceCheck = dateCheck != null ? dateCheck * -1 : null;
        if (daysSinceCheck != null) log(daysSinceCheck.toString());
      }
    } else if (widget.inventoryCheckRequest != null) {
      DbService.getLandlordInventoryCheckRequests(
          FireAuth.getCurrentUser()!.uid);
      completedInventoryCheck = false;
      clerkName = widget.inventoryCheckRequest!.clerkEmail;
      commentsSize = 0;
      cardAccentColour = inventoryCheckRequestCardAccentColour;
      checkIn = widget.inventoryCheckRequest!.type == 1 ? true : false;
      if (widget.inventoryCheckRequest!.checkDate != null &&
          DateUtilities.validDate(widget.inventoryCheckRequest!.checkDate!)) {
        int? dateCheck = DateUtilities.dateStringToDaysRemaining(
            DateTime.now(), widget.inventoryCheckRequest!.checkDate!);
        daysUntilCheck = dateCheck;
        if (daysUntilCheck != null) log(daysUntilCheck.toString());
      }
      if (propertyAddress == null &&
          widget.inventoryCheckRequest!.propertyId != null) {
        getPropertyAddress(widget.inventoryCheckRequest!.propertyId!);
      }
      if (icrProperty == null &&
          widget.inventoryCheckRequest!.propertyId != null) {
        getProperty(widget.inventoryCheckRequest!.propertyId!);
      }
    }

    return GestureDetector(
      onTap: () {
        if (widget.inventoryCheck == null &&
            widget.inventoryCheckRequest != null) {
          PersistentNavBarNavigator.pushNewScreen(context,
              screen: InventoryCheckRequestFormPage(
                inventoryCheckRequest: widget.inventoryCheckRequest!,
                tenantId: icrProperty!.tenantId,
                landlordId: icrProperty!.ownerId!,
                address: propertyAddress,
                daysUntilInventoryCheck: daysUntilCheck,
                property: icrProperty!,
              ));
        }
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
                        bottom: BorderSide(color: cardAccentColour, width: 7))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        propertyAddress != null
                            ? propertyAddress!
                            : "No address given",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Image(
                            image: AssetImage(commentsSize != null &&
                                    commentsSize! > 0
                                ? IconPaths.commentWithNotificationIconPath.path
                                : IconPaths.commentIconPath.path),
                            width: 28,
                            height: 28,
                          ),
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
                                        : daysUntilCheck != null
                                            ? (daysUntilCheck! < -99
                                                ? "99+"
                                                : daysUntilCheck! < 0
                                                    ? (daysUntilCheck! * -1)
                                                        .toString()
                                                    : daysUntilCheck!
                                                        .toString())
                                            : "N/A",
                                    style: const TextStyle(fontSize: 25)),
                                daysUntilCheck != null
                                    ? daysUntilCheck! < 0
                                        ? Expanded(
                                            child: Text(
                                                (daysUntilCheck != 1)
                                                    ? " days overdue"
                                                    : " day overdue",
                                                overflow: TextOverflow.visible),
                                          )
                                        : Text((daysUntilCheck != 1)
                                            ? " days to go"
                                            : " day to go")
                                    : Text((daysSinceCheck != null &&
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
                          Expanded(
                              child: Text(
                            clerk != null
                                ? " ${clerk!.firstName!} ${clerk!.lastName!}"
                                : " John doe",
                            overflow: TextOverflow.fade,
                          ))
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

  void getPropertyAddress(String propertyId) async {
    String address = "";

    await DbService.getProperty(propertyId).then((value) => {
          if (value != null)
            {
              address += value.data().addressHouseNameOrNumber != null
                  ? value.data().addressHouseNameOrNumber!
                  : "",
              address += value.data().addressRoadName != null
                  ? " ${value.data().addressRoadName!}"
                  : "",
              address += value.data().addressCity != null
                  ? ", ${value.data().addressCity!}"
                  : "",
              address += value.data().addressPostcode != null
                  ? ", ${value.data().addressPostcode!}"
                  : ""
            }
        });

    if (address.isNotEmpty) {
      setState(() {
        propertyAddress = address;
      });
    }
  }

  void getProperty(String propertyId) async {
    Property? property;

    await DbService.getProperty(propertyId).then((value) => {
          if (value != null) {property = value.data()}
        });

    if (property != null) {
      setState(() {
        icrProperty = property;
      });
    }
  }

  void getClerkUserViaEmail() {
    if (clerkName != null) {
      DbService.getUserDocumentFromEmail(clerkName!).then((value) {
        setState(() {
          clerk = value ?? User(firstName: "John", lastName: "Doe");
        });
      });
    }
  }
}
