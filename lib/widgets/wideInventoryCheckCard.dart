import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:test_flutter_app/models/inventoryCheck.dart';
import 'package:test_flutter_app/models/inventoryCheckRequest.dart';
import 'package:test_flutter_app/models/property.dart';
import 'package:test_flutter_app/pages/inventoryCheckPage.dart';
import 'package:test_flutter_app/pages/inventoryCheckRequestFormPage.dart';
import 'package:test_flutter_app/services/dbService.dart';
import 'package:test_flutter_app/utilities/date_utilities.dart';
import 'package:test_flutter_app/utilities/global_values.dart';
import 'package:test_flutter_app/widgets/commentNotificationIcon.dart';
import 'package:test_flutter_app/widgets/daysUntilOrSinceFormattedText.dart';

class WideInventoryCheckCard extends StatefulWidget {
  WideInventoryCheckCard(
      {super.key, this.inventoryCheck, this.inventoryCheckRequest});

  InventoryCheck? inventoryCheck;
  InventoryCheckRequest? inventoryCheckRequest;

  @override
  State<WideInventoryCheckCard> createState() => _WideInventoryCheckCardState();
}

class _WideInventoryCheckCardState extends State<WideInventoryCheckCard> {
  bool? inventoryCheckIsRequest;
  Color? highlightColor;
  int? daysUntilOrSinceCheck;
  String? clerkName;
  int? numberOfComments;
  Property? inventoryCheckProperty;
  bool? isCheckIn;
  int? commentCount;

  bool gatheredInformation = false;
  @override
  Widget build(BuildContext context) {
    if (inventoryCheckIsRequest == null) checkInventoryCheckType();
    if (inventoryCheckIsRequest != null && gatheredInformation == false)
      populateInformation();

    return gatheredInformation == false
        ? const SizedBox()
        : GestureDetector(
            onTap: () {
              if (inventoryCheckIsRequest!) {
                if (inventoryCheckProperty == null) return;
                log("clicked inventory check request");
                navigateToInventoryCheckRequestPage();
              } else {
                log("clicked inventory check");
                navigateToInventoryCheckPage();
              }
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 5,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            left:
                                BorderSide(color: highlightColor!, width: 7))),
                    padding: const EdgeInsets.fromLTRB(8, 15, 8, 15),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                            child: Row(
                              children: [
                                Image(
                                  image: AssetImage(isCheckIn!
                                      ? IconPaths.checkInIconPath.path
                                      : IconPaths.checkOutIconPath.path),
                                  height: 28,
                                  width: 28,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: DaysUntilOrSinceFormattedText(
                                      daysUntilOrSince: daysUntilOrSinceCheck!,
                                      intendedToBeFuture:
                                          inventoryCheckIsRequest!),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: inventoryCheckIsRequest! ? 2 : 1,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                            child: Row(
                              children: [
                                Image(
                                  image:
                                      AssetImage(IconPaths.clerkIconPath.path),
                                  height: 28,
                                  width: 28,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                    child: Text(
                                  clerkName!,
                                  style: const TextStyle(fontSize: 12),
                                  overflow: TextOverflow.visible,
                                ))
                              ],
                            ),
                          ),
                        ),
                        widget.inventoryCheck == null
                            ? SizedBox()
                            : Expanded(
                                flex: 1,
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  child: Row(
                                    children: [
                                      CommenNotificationIcon(
                                          inventoryCheck:
                                              widget.inventoryCheck!),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(commentCount!.toString(),
                                              style: TextStyle(fontSize: 18)),
                                          Text(
                                            " comments",
                                            style: TextStyle(fontSize: 12),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ],
                    ),
                  )),
            ),
          );
  }

  void checkInventoryCheckType() {
    bool? tempInventoryCheckIsRequest;

    log("Checking inventory check type");

    if (widget.inventoryCheckRequest != null) {
      tempInventoryCheckIsRequest = true;
    } else if (widget.inventoryCheck != null) {
      tempInventoryCheckIsRequest = false;
    } else {
      return;
    }

    log("Inventory check is a request: $tempInventoryCheckIsRequest");

    setState(() {
      inventoryCheckIsRequest = tempInventoryCheckIsRequest;
    });
  }

  void populateInformation() {
    if (inventoryCheckIsRequest == true) {
      populateInformationAsInventoryCheckRequest();
    } else {
      populateInformationAsInventoryCheck();
    }
  }

  void populateInformationAsInventoryCheckRequest() async {
    Property? tempProperty;
    Color tempHighlightColor = const Color(0xFFEFA73A);
    int? tempDaysUntilOrSinceCheck =
        DateUtilities.getDaysUntil(widget.inventoryCheckRequest!.checkDate!);
    String? tempClerkName = widget.inventoryCheckRequest!.clerkEmail != null &&
            widget.inventoryCheckRequest!.clerkEmail!.isNotEmpty
        ? widget.inventoryCheckRequest!.clerkEmail!
        : "N/A";
    await DbService.getProperty(widget.inventoryCheckRequest!.propertyId!)
        .then((value) {
      if (value != null) tempProperty = value.data();
    });

    setState(() {
      inventoryCheckProperty = tempProperty;
      highlightColor = tempHighlightColor;
      if (tempDaysUntilOrSinceCheck != null)
        daysUntilOrSinceCheck = tempDaysUntilOrSinceCheck;
      clerkName = tempClerkName;
      gatheredInformation = true;
      if (widget.inventoryCheckRequest!.type! == 1) {
        isCheckIn = true;
      } else {
        isCheckIn = false;
      }
      ;
    });
  }

  void populateInformationAsInventoryCheck() async {
    Color checkInCardAccentColour = const Color(0xFF579A56);
    Color checkOutCardAccentColour = const Color(0xFFE76E6E);

    DateTime? date =
        DateTime.tryParse(widget.inventoryCheck!.checkCompletedDate!);

    int? tempDaysUntilOrSinceCheck =
        DateUtilities.getDaysUntil("${date!.day}/${date.month}/${date.year}");
    String? tempClerkName = widget.inventoryCheck!.clerkEmail != null &&
            widget.inventoryCheck!.clerkEmail!.isNotEmpty
        ? widget.inventoryCheck!.clerkEmail!
        : "N/A";
    int? tempCommentCount;
    await DbService.getCommentsForInventoryCheck(widget.inventoryCheck!.id!).then(
      (value) => tempCommentCount = value != null ? value.length : 0,
    );

    setState(() {
      highlightColor = widget.inventoryCheck!.type == 1
          ? checkInCardAccentColour
          : checkOutCardAccentColour;
      if (tempDaysUntilOrSinceCheck != null)
        daysUntilOrSinceCheck = tempDaysUntilOrSinceCheck;
      clerkName = tempClerkName;
      gatheredInformation = true;
      if (widget.inventoryCheck!.type! == 1) {
        isCheckIn = true;
      } else {
        isCheckIn = false;
      }
      commentCount=tempCommentCount;
    });
  }

  void navigateToInventoryCheckRequestPage() {
    PersistentNavBarNavigator.pushNewScreen(context,
        screen: InventoryCheckRequestFormPage(
          inventoryCheckRequest: widget.inventoryCheckRequest!,
          tenantId: inventoryCheckProperty!.tenantId!,
          landlordId: inventoryCheckProperty!.ownerId!,
          address: inventoryCheckProperty!.getPropertyAddress(),
          daysUntilInventoryCheck: daysUntilOrSinceCheck,
          property: inventoryCheckProperty!,
        ));
  }

  void navigateToInventoryCheckPage() {
    PersistentNavBarNavigator.pushNewScreen(context,
        screen: InventoryCheckPage(inventoryCheck: widget.inventoryCheck!));
  }
}
