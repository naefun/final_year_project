import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:test_flutter_app/models/inventoryCheck.dart';
import 'package:test_flutter_app/models/inventoryCheckRequest.dart';
import 'package:test_flutter_app/models/property.dart';
import 'package:test_flutter_app/pages/propertyPage.dart';
import 'package:test_flutter_app/services/cloudStorageService.dart';
import 'package:test_flutter_app/services/dbService.dart';
import 'package:test_flutter_app/utilities/date_utilities.dart';
import 'package:test_flutter_app/utilities/tenancyUtilities.dart';

class PropertyCard extends StatefulWidget {
  PropertyCard({Key? key, this.propertyData}) : super(key: key);
  Property? propertyData;

  @override
  _PropertyCardState createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  Uint8List? imageData;
  Property? propertyData;
  String? inventoryCheckDueDate;
  bool? propertyIsOccupied;

  @override
  Widget build(BuildContext context) {
    propertyData = widget.propertyData;
    if(propertyIsOccupied==null) checkPropertyOccupation();
    // log("created propertycard");
    log(propertyData != null
        ? "Property postcode: ${propertyData!.addressPostcode!}"
        : "created propertycard");
    log(imageData != null ? "image data retrieved" : "");
    if (propertyData != null &&
        propertyData!.propertyImageName != null &&
        imageData == null) {
      setPropertyImageUrl(propertyData!.propertyImageName!);
    }
    if(propertyData!=null && inventoryCheckDueDate==null) getInventoryCheckDueDate();
    return GestureDetector(
      onTap: () => {navigateToPropertyPage()},
      child: Card(
          margin: const EdgeInsets.only(bottom: 17),
          elevation: 5,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6))),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                height: 120,
                width: 150,
                decoration: imageData != null
                    ? BoxDecoration(
                        image: DecorationImage(
                            image: MemoryImage(imageData!), fit: BoxFit.cover))
                    : const BoxDecoration(
                        image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/placeholderImages/house.jpg'),
                      ))),
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          propertyData != null
                              ? "${propertyData!.addressHouseNameOrNumber!} ${propertyData!.addressRoadName!}, ${propertyData!.addressCity!}, ${propertyData!.addressPostcode!.toUpperCase()}"
                              : "No house number found",
                          style: const TextStyle(fontSize: 18),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            const Icon(Icons.add_home, color: Color(0xFF636363),),
                            const SizedBox(width: 10.0),
                            Text(inventoryCheckDueDate!=null?inventoryCheckDueDate!.split(" ")[0].replaceAll("-", "/"):"No check due"),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Card(
                          color: propertyIsOccupied != null && propertyIsOccupied == true
                              ? const Color(0xFF579A56)
                              : const Color(0xFFE76E6E),
                          elevation: 0,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: SizedBox(
                            width: 90,
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 2, bottom: 2),
                                child: Text(
                                  propertyIsOccupied != null && propertyIsOccupied == true
                                      ? "Occupied"
                                      : "Vacant",
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ))),
          ])),
    );
  }

  void setPropertyImageUrl(String imageName) async {
    Uint8List? url;

    try {
      url = await CloudStorageService.getPropertyImage(imageName);
    } catch (e) {}
    if (url != null) {
      setState(() {
        imageData = url;
      });
    }
  }

  void navigateToPropertyPage() {
    log("Navigating to properties page");

    PersistentNavBarNavigator.pushNewScreen(context,
        screen: PropertyPage(
          property: propertyData,
        ));
  }
  
  Future<void> getInventoryCheckDueDate() async {
    List<QueryDocumentSnapshot<InventoryCheckRequest>> docs = [];
    List<InventoryCheckRequest> icrs = [];

    await DbService.getInventoryCheckRequestsForProperty(propertyData!.propertyId!).then((value) => docs=value);

    for (QueryDocumentSnapshot<InventoryCheckRequest> element in docs) {
      icrs.add(element.data());
    }

    icrs.sort((a, b) => a.date!.compareTo(b.date!));

    if(icrs.isNotEmpty){
      setState(() {
        inventoryCheckDueDate=icrs[0].date;
      });
    }
  }

  void checkPropertyOccupation() async {
    bool occupied = false;
    await TenancyUtilities.getCurrentTenancies(propertyData!.propertyId!).then((value) => occupied=value.isNotEmpty);
    setState(() {
      propertyIsOccupied = occupied;
    });
  }
}
