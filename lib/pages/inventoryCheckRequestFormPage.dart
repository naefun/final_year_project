import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:test_flutter_app/models/inventoryCheck.dart';
import 'package:test_flutter_app/models/tenancy.dart';
import 'package:test_flutter_app/store/actions.dart' as ReduxActions;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:test_flutter_app/models/inventoryCheckRequest.dart';
import 'package:test_flutter_app/models/property.dart';
import 'package:test_flutter_app/services/cloudStorageService.dart';
import 'package:test_flutter_app/services/dbService.dart';
import 'package:test_flutter_app/utilities/inventory_check_contents_builder.dart';
import 'package:test_flutter_app/utilities/inventory_check_linked_list.dart';
import 'package:test_flutter_app/utilities/pageNavigator.dart';
import 'package:test_flutter_app/utilities/snackbarUtility.dart';
import 'package:test_flutter_app/widgets/customAppBar.dart';
import 'package:test_flutter_app/widgets/inventoryCheckFormSection.dart';
import 'package:test_flutter_app/widgets/propertyImageAndInfo.dart';
import 'package:uuid/uuid.dart';

import '../models/user.dart';

class InventoryCheckRequestFormPage extends StatefulWidget {
  InventoryCheckRequestFormPage(
      {Key? key,
      required this.inventoryCheckRequest,
      this.tenantEmail,
      this.landlordId,
      this.address,
      this.daysUntilInventoryCheck,
      required this.property})
      : super(key: key);
  InventoryCheckRequest inventoryCheckRequest;
  String? tenantEmail;
  String? landlordId;
  String? address;
  int? daysUntilInventoryCheck;
  Property property;

  @override
  _InventoryCheckRequestFormPageState createState() =>
      _InventoryCheckRequestFormPageState();
}

class _InventoryCheckRequestFormPageState
    extends State<InventoryCheckRequestFormPage> {
  List<InventoryCheckFormSection>? essentialInformationSections;
  List<InventoryCheckFormSection>? optionalInformationSections;
  InventoryCheckRequest? inventoryCheckRequest;
  String? tenantEmail;
  String? landlordId;
  String? address;
  int? daysUntilInventoryCheck;
  Property? property;

  Uint8List? propertyImage;
  User? landlordDetails;
  User? tenantDetails;

  List<Tenancy>? inventoryCheckRequestTenants;

  bool sectionsAdded = false;
  bool updateInventoryCheckLinkedList = false;
  int numberOfSectionsPopulated = 0;
  bool inventoryCheckSubmitted = false;
  int sectionPosition = 0;
  bool? canSubmitInventoryCheck;

  String inventoryCheckId = Uuid().v4();

  int essentialSectionCount = 0;
  int optionalSectionCount = 0;

  @override
  Widget build(BuildContext context) {
    inventoryCheckRequest = widget.inventoryCheckRequest;
    tenantEmail = widget.tenantEmail;
    landlordId = widget.landlordId;
    address = widget.address;
    daysUntilInventoryCheck = widget.daysUntilInventoryCheck;
    property = widget.property;

    if (sectionsAdded == false && InventoryCheckLinkedList.getSize() > 0) {
      InventoryCheckLinkedList.clear();
    }

    optionalInformationSections ??= [createOptionalInventoryFormSection()];

    if (essentialInformationSections == null) {
      essentialInformationSections = prepopulateEssentialInformationSections();
      sectionsAdded = true;
    }

    if (inventoryCheckRequest == null ||
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

    if (property != null &&
        essentialInformationSections != null &&
        optionalInformationSections != null &&
        numberOfSectionsPopulated ==
            optionalInformationSections!.length +
                essentialInformationSections!.length &&
        inventoryCheckSubmitted == false) {
      log("all sections updated");
      DbService.submitCompleteInventoryCheck(
          InventoryCheckContentsBuilder.build(
              Uuid().v4(), property!.propertyId!, DateTime.now().toString()));
      setState(() {
        inventoryCheckSubmitted = true;
      });
    }

    if (inventoryCheckRequestTenants == null) getInventoryCheckRequestTenants();

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
                  propertyId: property!.propertyId!,
                  showCurrentTenants: false,
                ),
                SizedBox(height: 20),
                Text("This inventory check applies to the following tenants: "),
                inventoryCheckRequestTenants == null ||
                        inventoryCheckRequestTenants!.isEmpty
                    ? Text("No tenants selected")
                    : SizedBox(
                        height: 40,
                        child: ListView.builder(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: inventoryCheckRequestTenants!.length,
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
                                    Text(inventoryCheckRequestTenants![index]
                                        .tenantEmail!),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                SizedBox(height: 20),
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
                    getSections(optionalInformationSections!),
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
                                      tempInputSections =
                                      optionalInformationSections!;
                                  tempInputSections.add(
                                      createOptionalInventoryFormSection());
                                  optionalInformationSections =
                                      tempInputSections;
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFEDEDED)),
                        child: Text('Cancel',
                            style: TextStyle(color: Color(0xFF489EED))),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    SizedBox(
                      width: 20,
                    ),
                    StoreConnector<bool, VoidCallback>(converter: (store) {
                      return () => store.dispatch(ReduxActions.Actions.setTrue);
                    }, builder: (context, callback) {
                      return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF489EED)),
                          child: Text('Submit',
                              style: TextStyle(color: Color(0xFFEDEDED))),
                          onPressed: () {
                            callback();
                            SnackbarUtility.showSnackbar(context,
                                "Inventory check successfully created");

                            PageNavigator.navigateToHomePage(context);
                          });
                    }),
                  ],
                ),
                StoreConnector<bool, bool>(
                  converter: (store) => store.state,
                  builder: (context, viewModel) {
                    return SizedBox();
                  },
                  onWillChange: (previous, next) {
                    setState(() {
                      if (next == true &&
                          (canSubmitInventoryCheck == null ||
                              canSubmitInventoryCheck == false)) {
                        canSubmitInventoryCheck = next;
                        submitInventoryCheck();
                      } else if (next == false &&
                          canSubmitInventoryCheck != null &&
                          canSubmitInventoryCheck == true) {
                        canSubmitInventoryCheck = next;
                      }
                    });
                  },
                ),
                SizedBox(
                  height: 50,
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
    sections.add(createEssentialInventoryFormSection(
        const ["Clerk details", "Date carried out"],
        "Inventory check details"));

    sections.add(createEssentialInventoryFormSection(const [
      "Property particulars",
      "Overall condition",
      "Decorative order",
      "Instruction manuals"
    ], "Schedule of condition"));
    sections.add(createEssentialInventoryFormSection(const [
      "Overall general cleanliness",
      "Flooring",
      "Glazing",
      "Upholstory/Furniture",
      "Curtains/Blinds",
      "Lighting",
      "Electrical appliances",
      "Kitchen",
      "Bathroom/s"
    ], "Cleanliness schedule"));
    sections.add(createEssentialInventoryFormSection(
        const ["Smoke alarms", "Heat detector"], "Alarms"));
    sections.add(createEssentialInventoryFormSection(
        const ["Electric meter", "Water meter", "Gas meter"],
        "Meter readings"));
    sections.add(
        createEssentialInventoryFormSection(const ["Keys present"], "Keys"));
    return sections;
  }

  InventoryCheckFormSection createInventoryFormSection(
      int position,
      List<String>? inventoryCheckFormInputTitles,
      String? sectionTitle,
      bool? essentialSection) {
    return InventoryCheckFormSection(
      essentialSection: essentialSection,
      inventoryCheckFormInputTitles: inventoryCheckFormInputTitles,
      sectionTitle: sectionTitle,
      sectionPosition: position,
      inventoryCheckId: inventoryCheckId,
      updateSection: updateInventoryCheckLinkedList,
      sectionUpdatedCallback: (val) => setState(() {
        numberOfSectionsPopulated = numberOfSectionsPopulated + val;
      }),
    );
  }

  InventoryCheckFormSection createEssentialInventoryFormSection(
      List<String> inventoryCheckFormInputTitles, String sectionTitle) {
    int position = essentialSectionCount;
    setState(() {
      essentialSectionCount = essentialSectionCount + 1;
    });
    return createInventoryFormSection(
        position, inventoryCheckFormInputTitles, sectionTitle, true);
  }

  InventoryCheckFormSection createOptionalInventoryFormSection() {
    int position = optionalSectionCount;
    setState(() {
      optionalSectionCount = optionalSectionCount + 1;
    });
    return createInventoryFormSection(position, null, null, false);
  }

  void submitInventoryCheck() {
    InventoryCheck inventoryCheck = InventoryCheck(
        id: inventoryCheckId,
        propertyId: widget.property.propertyId,
        complete: true,
        type: inventoryCheckRequest!.type,
        clerkEmail: inventoryCheckRequest!.clerkEmail,
        date: DateTime.now().toString(),
        tenancyIds: getTenancyIds(),
        );

    DbService.submitInventoryCheck(inventoryCheck);
    DbService.setInventoryCheckRequestCompleted(inventoryCheckRequest!);
  }

  void getInventoryCheckRequestTenants() async {
    List<Tenancy> tempTenancies = [];
    if (widget.inventoryCheckRequest.tenancyIds != null) {
      await DbService.getSpecificTenancyDocuments(
              widget.inventoryCheckRequest.tenancyIds!)
          .then((value) {
        if (value != null) {
          for (QueryDocumentSnapshot<Tenancy> element in value) {
            tempTenancies.add(element.data());
          }
        }
      });
    }

    setState(() {
      inventoryCheckRequestTenants = tempTenancies;
    });
  }

  List<String> getTenancyIds(){
    List<String> ids = inventoryCheckRequestTenants!.map((e) => e.id!).toList();
    return ids;
  }
}
