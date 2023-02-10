import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:test_flutter_app/models/inventoryCheck.dart';
import 'package:test_flutter_app/models/inventoryCheckRequest.dart';
import 'package:test_flutter_app/services/dbService.dart';
import 'package:test_flutter_app/services/fireAuth.dart';
import 'package:test_flutter_app/utilities/date_utilities.dart';
import 'package:test_flutter_app/utilities/global_values.dart';

class InventoryCheckCard extends StatefulWidget {
  InventoryCheck? inventoryCheck;

  InventoryCheckRequest? inventoryCheckRequest;
  InventoryCheckCard(
      {Key? key, this.inventoryCheck, this.inventoryCheckRequest})
      : super(key: key);

  @override
  _InventoryCheckCardState createState() => _InventoryCheckCardState();
}

class _InventoryCheckCardState extends State<InventoryCheckCard> {
  Color checkInCardAccentColour = const Color(0xFF579A56);
  Color checkOutCardAccentColour = const Color(0xFFE76E6E);
  Color inventoryCheckRequestCardAccentColour = const Color(0xFFEFA73A);
  Color cardAccentColour = const Color(0xFFFFFFFF);
  String? clerkName;
  bool? checkIn;
  String? propertyAddress;
  bool completedInventoryCheck = true;

  // in the case that a completed inventory check is passed
  int? commentsSize;
  int? daysSinceCheck;

  // in the case that an inventory check request is passed
  String inventoryCheckRequestMessage = "Inventory check request";
  int? daysUntilCheck;

  @override
  Widget build(BuildContext context) {
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
      DbService.getLandlordInventoryCheckRequests(FireAuth.getCurrentUser()!.uid);
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
      if(propertyAddress == null && widget.inventoryCheckRequest!.propertyId!=null) getPropertyAddress(widget.inventoryCheckRequest!.propertyId!);
    }

    return GestureDetector(
      onTap: (){log("card pressed");},
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
                                        : daysUntilCheck != null ? (daysUntilCheck! < -99 ? "99+" : daysUntilCheck! < 0 ? (daysUntilCheck!*-1).toString() : daysUntilCheck!.toString()) : "N/A",
                                    style: const TextStyle(fontSize: 25)),
                                daysUntilCheck != null
                                    ? daysUntilCheck! < 0 ?
                                    Expanded(
                                      child: Text((daysUntilCheck != 1)
                                          ? " days overdue"
                                          : " day overdue",
                                          overflow: TextOverflow.visible),
                                    ):
                                    
                                    Text((daysUntilCheck != 1)
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
  
  void getPropertyAddress(String propertyId) async {
    String address = "";

    await DbService.getProperty(propertyId).then((value) => {
      if(value!=null){
        address+=value.data().addressHouseNameOrNumber!=null?value.data().addressHouseNameOrNumber!:"",
        address+=value.data().addressRoadName!=null?" ${value.data().addressRoadName!}":"",
        address+=value.data().addressCity!=null?", ${value.data().addressCity!}":"",
        address+=value.data().addressPostcode!=null?", ${value.data().addressPostcode!}":""
      }
    });

    if(address.isNotEmpty){
      setState(() {
        propertyAddress=address;
      });
    }
  }
}
