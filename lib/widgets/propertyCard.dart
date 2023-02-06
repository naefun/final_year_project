import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:test_flutter_app/models/property.dart';
import 'package:test_flutter_app/pages/propertyPage.dart';
import 'package:test_flutter_app/services/cloudStorageService.dart';
import 'package:test_flutter_app/utilities/date_utilities.dart';

class PropertyCard extends StatefulWidget {
  PropertyCard({Key? key, this.propertyData}) : super(key: key);
  Property? propertyData;

  @override
  _PropertyCardState createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  Uint8List? imageData;
  Property? propertyData;

  @override
  Widget build(BuildContext context) {
    propertyData = widget.propertyData;
    // log("created propertycard");
    log(propertyData != null
        ? "Property postcode: ${propertyData!.addressPostcode!}"
        : "created propertycard");
    log(imageData != null ? "image data retrieved"! : "");
    if (propertyData != null && propertyData!.propertyImageName != null) {
      CloudStorageService.getPropertyImage(propertyData!.propertyImageName!);
    }
    if (propertyData != null &&
        propertyData!.propertyImageName != null &&
        imageData == null) {
      setPropertyImageUrl(propertyData!.propertyImageName!);
    }
    propertyData != null
        ? log(propertyData!.nextInventoryCheck!)
        : log("No property data");
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
                            const Icon(Icons.add_home),
                            const SizedBox(width: 10.0),
                            Text(propertyData != null &&
                                    propertyData!.nextInventoryCheck != null &&
                                    DateUtilities.validDate(
                                        propertyData!.nextInventoryCheck!)
                                ? "${DateUtilities.dateStringToDaysRemaining(DateTime.now(), propertyData!.nextInventoryCheck!).toString()} days to go"
                                : "No check pending"),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Card(
                          color: propertyData != null &&
                                  propertyData!.tenantId != null &&
                                  propertyData!.tenantId!.isNotEmpty
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
                                  propertyData != null &&
                                          propertyData!.tenantId != null &&
                                          propertyData!.tenantId!.isNotEmpty
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
    url = await CloudStorageService.getPropertyImage(imageName);
    setState(() {
      imageData = url;
    });
  }

  void navigateToPropertyPage() {
    log("Navigating to properties page");

    PersistentNavBarNavigator.pushNewScreen(context,
        screen: const PropertyPage());
  }
}
