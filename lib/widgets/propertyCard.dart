import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:test_flutter_app/models/property.dart';
import 'package:test_flutter_app/services/cloudStorageService.dart';

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
    if (propertyData != null && propertyData!.propertyImageName != null)
      CloudStorageService.getPropertyImage(propertyData!.propertyImageName!);
      if (propertyData != null &&
        propertyData!.propertyImageName != null &&
        imageData==null) setPropertyImageUrl(propertyData!.propertyImageName!);
    return Column(
      children: [
        Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Container(
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                imageData != null ? Image(image: MemoryImage(imageData!), height: 100,) : Image(image: AssetImage('assets/placeholderImages/house.jpg'), height: 100,),

                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          propertyData != null
                              ? "${propertyData!.addressHouseNameOrNumber!} ${propertyData!.addressRoadName!}, \n${propertyData!.addressCity!}, ${propertyData!.addressPostcode!.toUpperCase()}"
                              : "No house number found",
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'data',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    )),
              ]),
            ))
      ],
    );
  }

  void setPropertyImageUrl(String imageName) async {
    Uint8List? url;
    url = await CloudStorageService.getPropertyImage(imageName);
    setState(() {
      imageData = url;
    });
  }
}
