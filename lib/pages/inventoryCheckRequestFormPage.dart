import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:test_flutter_app/models/inventoryCheckRequest.dart';
import 'package:test_flutter_app/models/property.dart';
import 'package:test_flutter_app/services/cloudStorageService.dart';
import 'package:test_flutter_app/services/dbService.dart';
import 'package:test_flutter_app/utilities/inventory_check_linked_list.dart';
import 'package:test_flutter_app/widgets/customAppBar.dart';
import 'package:test_flutter_app/widgets/inventoryCheckFormSection.dart';
import 'package:test_flutter_app/widgets/propertyImageAndInfo.dart';

import '../models/user.dart';

class InventoryCheckRequestFormPage extends StatefulWidget {
  InventoryCheckRequestFormPage(
      {Key? key,
      this.inventoryCheckRequest,
      this.tenantId,
      this.landlordId,
      this.address,
      this.daysUntilInventoryCheck,
      this.property})
      : super(key: key);
  InventoryCheckRequest? inventoryCheckRequest;
  String? tenantId;
  String? landlordId;
  String? address;
  int? daysUntilInventoryCheck;
  Property? property;

  @override
  _InventoryCheckRequestFormPageState createState() =>
      _InventoryCheckRequestFormPageState();
}

class _InventoryCheckRequestFormPageState
    extends State<InventoryCheckRequestFormPage> {
  List<InventoryCheckFormSection>? essentialInformationSections;
  List<InventoryCheckFormSection> inputSections = [InventoryCheckFormSection()];
  InventoryCheckRequest? inventoryCheckRequest;
  String? tenantId;
  String? landlordId;
  String? address;
  int? daysUntilInventoryCheck;
  Property? property;

  Uint8List? propertyImage;
  User? landlordDetails;
  User? tenantDetails;

  bool sectionsAdded = false;

  @override
  Widget build(BuildContext context) {
    inventoryCheckRequest = widget.inventoryCheckRequest;
    tenantId = widget.tenantId;
    landlordId = widget.landlordId;
    address = widget.address;
    daysUntilInventoryCheck = widget.daysUntilInventoryCheck;
    property = widget.property;

    if (sectionsAdded == false && InventoryCheckLinkedList.getSize() > 0) {
      InventoryCheckLinkedList.clear();
    }

    if (essentialInformationSections == null) {
      essentialInformationSections = prepopulateEssentialInformationSections();
      sectionsAdded = true;
    }

    if (inventoryCheckRequest == null ||
        tenantId == null ||
        landlordId == null ||
        address == null ||
        daysUntilInventoryCheck == null ||
        property == null) {
      Navigator.pop(context);
    }

    if (landlordId != null && landlordDetails == null) {
      getLandlordDetails(landlordId!);
    }
    if (property != null &&
        property!.propertyImageName != null &&
        propertyImage == null) {
      getPropertyImage(property!.propertyImageName!);
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: "Create inventory check",
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PropertyImageAndInfo(
                  propertyAddress: address,
                  propertyImage: propertyImage,
                  landlordDetails: landlordDetails,
                  tenantDetails: tenantDetails,
                ),
                const SizedBox(
                  height: 50,
                ),
                Form(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Essential information",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    getSections(essentialInformationSections!),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Rooms/Areas",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    getSections(inputSections),
                  ],
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: const Color(0xFF489EED),
                          ),
                          child: IconButton(
                              color: const Color(0xFFFFFFFF),
                              iconSize: 30,
                              padding: const EdgeInsets.all(0),
                              onPressed: () {
                                setState(() {
                                  List<InventoryCheckFormSection>
                                      tempInputSections = inputSections;
                                  tempInputSections
                                      .add(InventoryCheckFormSection());
                                  inputSections = tempInputSections;
                                  sectionsAdded = true;
                                });
                                log(InventoryCheckLinkedList.toStringS());
                              },
                              icon: const Icon(Icons.add)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text("Add room/area")
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
              ]),
        ),
      ),
    );
  }

  void getPropertyImage(String imageName) async {
    Uint8List? image;

    try {
      image = await CloudStorageService.getPropertyImage(imageName);
    } catch (e) {}
    if (image != null) {
      setState(() {
        propertyImage = image;
      });
    }
  }

  void getLandlordDetails(String landlordId) {
    User? tempLandlordDetails;

    DbService.getUserDocument(landlordId).then((value) => {
          if (value != null) {landlordDetails = value}
        });

    if (tempLandlordDetails != null) {
      setState(() {
        landlordDetails = tempLandlordDetails;
      });
    }
  }

  Widget getSections(List<InventoryCheckFormSection> inputSections) {
    return Column(children: [
      for (InventoryCheckFormSection inputSection in inputSections) inputSection
    ]);
  }

  List<InventoryCheckFormSection> prepopulateEssentialInformationSections() {
    List<InventoryCheckFormSection> sections = [];
    sections.add(InventoryCheckFormSection(
        sectionTitle: "Inventory check details",
        inventoryCheckFormInputTitles: const [
          "Clerk details",
          "Date carried out"
        ]));
    sections.add(InventoryCheckFormSection(
        sectionTitle: "Schedule of condition",
        inventoryCheckFormInputTitles: const [
          "Property particulars",
          "Overall condition",
          "Decorative order",
          "Instruction manuals"
        ]));
    sections.add(InventoryCheckFormSection(
        sectionTitle: "Cleanliness schedule",
        inventoryCheckFormInputTitles: const [
          "Overall general cleanliness",
          "Flooring",
          "Glazing",
          "Upholstory/Furniture",
          "Curtains/Blinds",
          "Lighting",
          "Electrical appliances",
          "Kitchen",
          "Bathroom/s"
        ]));
    sections.add(InventoryCheckFormSection(
        sectionTitle: "Alarms",
        inventoryCheckFormInputTitles: const [
          "Smoke alarms",
          "Heat detector",
        ]));
    sections.add(InventoryCheckFormSection(
        sectionTitle: "Meter readings",
        inventoryCheckFormInputTitles: const [
          "Electric meter",
          "Water meter",
          "Gas meter",
        ]));
    sections.add(InventoryCheckFormSection(
        sectionTitle: "Keys",
        inventoryCheckFormInputTitles: const [
          "Keys present",
        ]));
    return sections;
  }
}
