import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_flutter_app/models/inventoryCheck.dart';
import 'package:test_flutter_app/models/inventoryCheckSection.dart';
import 'package:test_flutter_app/models/property.dart';
import 'package:test_flutter_app/models/tenancy.dart';
import 'package:test_flutter_app/models/user.dart';
import 'package:test_flutter_app/services/cloudStorageService.dart';
import 'package:test_flutter_app/services/dbService.dart';
import 'package:test_flutter_app/widgets/customAppBar.dart';
import 'package:test_flutter_app/widgets/inventoryCheckSectionArea.dart';
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
  List<InventoryCheckSectionArea>? essentialInventoryCheckSectionAreas;
  List<InventoryCheckSectionArea>? optionalInventoryCheckSectionAreas;
  Property? property;
  String? propertyAddress;
  Uint8List? propertyImage;
  User? landlordDetails;
  User? tenantDetails;
  bool canRenderPropertyImageAndInfo = false;
  List<Tenancy>? inventoryCheckTenants;

  @override
  Widget build(BuildContext context) {
    logInventoryCheckDetails();
    if (essentialInventoryCheckSections == null &&
        optionalInventoryCheckSections == null) getInventoryCheckSections();

    if (property == null) getProperty();
    if (property != null && propertyAddress == null) setPropertyAddress();
    if (property != null && propertyImage == null) getPropertyImage();
    if (property != null && landlordDetails == null) getLandlordDetails();
    if (property != null && property!.tenantId != null && tenantDetails == null)
      getTenantDetails();
    if (inventoryCheckTenants == null) getInventoryCheckTenants();
    allowPropertyImageAndInfoToRender();

    if (essentialInventoryCheckSections != null &&
        essentialInventoryCheckSections!.isNotEmpty &&
        inventoryCheckTenants!=null &&
        essentialInventoryCheckSectionAreas == null)
      createEssentialInventoryCheckSectionAreas();
    if (optionalInventoryCheckSections != null &&
        optionalInventoryCheckSections!.isNotEmpty &&
        inventoryCheckTenants!=null &&
        optionalInventoryCheckSectionAreas == null)
      createOptionalInventoryCheckSectionAreas();

    logDetails();

    return Scaffold(
      appBar: CustomAppBar(),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              canRenderPropertyImageAndInfo == false
                  ? SizedBox()
                  : PropertyImageAndInfo(
                      propertyAddress: propertyAddress,
                      propertyImage: propertyImage,
                      landlordDetails: landlordDetails,
                      tenantDetails: tenantDetails,
                      tenantEmail:
                          property != null && property!.tenantId != null
                              ? property!.tenantId
                              : null,
                      propertyId: property!.propertyId!,
                      showCurrentTenants: false,
                    ),
              SizedBox(
                height: 30,
              ),
              Text("This inventory check applies to the following tenants: "),
              inventoryCheckTenants == null || inventoryCheckTenants!.isEmpty
                  ? Text("No tenants selected")
                  : SizedBox(
                      height: 40,
                      child: ListView.builder(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: inventoryCheckTenants!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              // log(currentTenancies![index].startDate!);
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              padding: EdgeInsets.all(6),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 198, 227, 254),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(inventoryCheckTenants![index]
                                      .tenantEmail!),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              Text("Essential information"),
              SizedBox(height: 20),
              essentialInventoryCheckSectionAreas != null &&
                      essentialInventoryCheckSectionAreas!.isNotEmpty
                  ? ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: essentialInventoryCheckSectionAreas!.length,
                      itemBuilder: (BuildContext context, int index) =>
                          essentialInventoryCheckSectionAreas![index],
                    )
                  : SizedBox(),
              SizedBox(
                height: 30,
              ),
              Text("Aditional information"),
              SizedBox(height: 20),
              optionalInventoryCheckSectionAreas != null &&
                      optionalInventoryCheckSectionAreas!.isNotEmpty
                  ? ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: optionalInventoryCheckSectionAreas!.length,
                      itemBuilder: (BuildContext context, int index) =>
                          optionalInventoryCheckSectionAreas![index],
                    )
                  : SizedBox(),
              SizedBox(
                height: 30,
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
    log("Inventory check completed on: ${widget.inventoryCheck.date!}");
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
    }
    log("Set tenant details");
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
    if (property != null &&
        propertyAddress != null &&
        propertyImage != null &&
        landlordDetails != null) {
      setState(() {
        canRenderPropertyImageAndInfo = true;
      });
    }
  }

  void createEssentialInventoryCheckSectionAreas() {
    List<InventoryCheckSectionArea> inventoryCheckSectionAreas = [];

    for (InventoryCheckSection item in essentialInventoryCheckSections!) {
      inventoryCheckSectionAreas.add(InventoryCheckSectionArea(
        inventoryCheckSection: item,
        inventoryCheckTenants: inventoryCheckTenants,
      ));
    }

    setState(() {
      essentialInventoryCheckSectionAreas = inventoryCheckSectionAreas;
    });
  }

  void createOptionalInventoryCheckSectionAreas() {
    List<InventoryCheckSectionArea> inventoryCheckSectionAreas = [];

    for (InventoryCheckSection item in optionalInventoryCheckSections!) {
      inventoryCheckSectionAreas.add(InventoryCheckSectionArea(
        inventoryCheckSection: item,
        inventoryCheckTenants: inventoryCheckTenants,
      ));
    }

    setState(() {
      optionalInventoryCheckSectionAreas = inventoryCheckSectionAreas;
    });
  }

  void getInventoryCheckTenants() async {
    List<Tenancy> tempTenancies = [];
    if (widget.inventoryCheck.tenancyIds != null) {
      await DbService.getSpecificTenancyDocuments(
              widget.inventoryCheck.tenancyIds!)
          .then((value) {
        if (value != null) {
          for (QueryDocumentSnapshot<Tenancy> element in value) {
            tempTenancies.add(element.data());
          }
        }
      });
    }

    setState(() {
      inventoryCheckTenants = tempTenancies;
    });
  }
}
