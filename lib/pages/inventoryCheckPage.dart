import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:test_flutter_app/models/inventoryCheck.dart';
import 'package:test_flutter_app/models/inventoryCheckSection.dart';
import 'package:test_flutter_app/models/property.dart';
import 'package:test_flutter_app/models/user.dart';
import 'package:test_flutter_app/services/cloudStorageService.dart';
import 'package:test_flutter_app/services/dbService.dart';
import 'package:test_flutter_app/widgets/customAppBar.dart';
import 'package:test_flutter_app/widgets/propertyImageAndInfo.dart';

class InventoryCheckPage extends StatefulWidget {
  InventoryCheckPage({Key? key, required this.inventoryCheck})
      : super(key: key);

  InventoryCheck inventoryCheck;

  @override
  _InventoryCheckPageState createState() => _InventoryCheckPageState();
}

class _InventoryCheckPageState extends State<InventoryCheckPage> {
  List<InventoryCheckSection>? essentialInventoryCheckSections;
  List<InventoryCheckSection>? optionalInventoryCheckSections;
  Property? property;
  String? propertyAddress;
  Uint8List? propertyImage;
  User? landlordDetails;
  User? tenantDetails;
  bool canRenderPropertyImageAndInfo = false;

  @override
  Widget build(BuildContext context) {
    logInventoryCheckDetails();
    if (essentialInventoryCheckSections == null &&
        optionalInventoryCheckSections == null) getInventoryCheckSections();

    if (property == null) getProperty();
    if (property != null && propertyAddress == null) setPropertyAddress();
    if (property != null && propertyImage == null) getPropertyImage();
    if (property != null && landlordDetails == null) getLandlordDetails();
    if (property != null && tenantDetails == null) getTenantDetails();
    allowPropertyImageAndInfoToRender();

    logDetails();

    return Scaffold(
      appBar: CustomAppBar(),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              canRenderPropertyImageAndInfo==false? SizedBox(): PropertyImageAndInfo(
                propertyAddress: propertyAddress,
                propertyImage: propertyImage,
                landlordDetails: landlordDetails,
                tenantDetails: tenantDetails,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void logInventoryCheckDetails() {
    log("=" * 60);
    log("Inventory check id: ${widget.inventoryCheck.id!}");
    log("Inventory check complete: ${widget.inventoryCheck.complete!}");
    log("Inventory check completed on: ${widget.inventoryCheck.checkCompletedDate!}");
    log("Inventory check clerk email: ${widget.inventoryCheck.clerkEmail!}");
    log("Inventory check property id: ${widget.inventoryCheck.propertyId!}");
    log("Inventory check type: ${widget.inventoryCheck.type!}");
    log("=" * 60);
  }

  void getInventoryCheckSections() async {
    List<InventoryCheckSection> tempEssentialInventoryCheckSections = [];
    List<InventoryCheckSection> tempOptionalInventoryCheckSections = [];

    await DbService.getInventoryCheckSections(widget.inventoryCheck.id!)
        .then((value) => value?.forEach((element) {
              if (element.data().essentialSection == true) {
                tempEssentialInventoryCheckSections.add(element.data());
              } else {
                tempOptionalInventoryCheckSections.add(element.data());
              }
            }));

    if (tempEssentialInventoryCheckSections.isNotEmpty) {
      tempEssentialInventoryCheckSections
          .sort((a, b) => a.sectionPosition!.compareTo(b.sectionPosition!));
    }
    if (tempOptionalInventoryCheckSections.isNotEmpty) {
      tempOptionalInventoryCheckSections
          .sort((a, b) => a.sectionPosition!.compareTo(b.sectionPosition!));
    }

    setState(() {
      essentialInventoryCheckSections = tempEssentialInventoryCheckSections;
      optionalInventoryCheckSections = tempOptionalInventoryCheckSections;
    });

    log((tempEssentialInventoryCheckSections.length +
            tempOptionalInventoryCheckSections.length)
        .toString());
  }

  void logDetails() {
    if (essentialInventoryCheckSections != null &&
        essentialInventoryCheckSections!.isNotEmpty) {
      for (InventoryCheckSection element in essentialInventoryCheckSections!) {
        log("Section id: ${element.id!}");
        log("   Section position: ${element.sectionPosition!}");
        log("   Section is essential: ${element.essentialSection}");
      }
    }
    if (optionalInventoryCheckSections != null &&
        optionalInventoryCheckSections!.isNotEmpty) {
      for (InventoryCheckSection element in optionalInventoryCheckSections!) {
        log("Section id: ${element.id!}");
        log("   Section position: ${element.sectionPosition!}");
        log("   Section is essential: ${element.essentialSection}");
      }
    }
  }

  void getPropertyImage() async {
    Uint8List? image;

    try {
      image = await CloudStorageService.getPropertyImage(
          property!.propertyImageName!);
    } catch (e) {}
    if (image != null) {
      setState(() {
        propertyImage = image;
      });
    }
    log(image == null ? "no image" : "retrieved image");
  }

  void getLandlordDetails() async {
    User? tempLandlordDetails;

    await DbService.getUserDocument(property!.ownerId!).then((value) => {
          if (value != null) {tempLandlordDetails = value}
        });

    if (tempLandlordDetails != null) {
      setState(() {
        landlordDetails = tempLandlordDetails;
      });
    } else {
      setState(() {
        landlordDetails = User(
            userType: 1,
            firstName: "John",
            lastName: "Doe",
            email: "noemail@email.com");
      });
    }

    log("Inventory check page: Landlord first name: ${tempLandlordDetails!.firstName}");
  }

  void getTenantDetails() async {
    User? tempTenantDetails;

    try {
      await DbService.getUserDocument(property!.tenantId!).then((value) => {
            if (value != null) {tempTenantDetails = value}
          });
    } catch (e) {
      log("Could not get tenant details");
    }

    if (tempTenantDetails != null) {
      setState(() {
        tenantDetails = tempTenantDetails;
      });
    } else {
      setState(() {
        tenantDetails = User(userType: 2, firstName: "Jane", lastName: "Doe", email: "noemail@email.com");
      });
    }
  }

  void getProperty() async {
    Property? tempProperty;

    await DbService.getProperty(widget.inventoryCheck.propertyId!)
        .then((value) => tempProperty = value!.data());

    if (tempProperty == null) return;

    setState(() {
      property = tempProperty;
    });

    log("Inventory check page: Property id: ${tempProperty!.propertyId!}");
  }

  void setPropertyAddress() {
    String? tempPropertyAddress;

    tempPropertyAddress =
        "${property!.addressHouseNameOrNumber} ${property!.addressRoadName}, ${property!.addressCity}, ${property!.addressPostcode}";

    setState(() {
      propertyAddress = tempPropertyAddress;
    });

    log("Inventory check page: Property address: $tempPropertyAddress");
  }
  
  void allowPropertyImageAndInfoToRender() {




    if (property != null && propertyAddress != null && propertyImage != null && landlordDetails != null && tenantDetails != null) {
      setState(() {
      canRenderPropertyImageAndInfo = true;
    });
    }
  }
}
