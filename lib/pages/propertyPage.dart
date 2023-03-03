import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:test_flutter_app/models/property.dart';
import 'package:test_flutter_app/models/user.dart';
import 'package:test_flutter_app/pages/editPropertyPage.dart';
import 'package:test_flutter_app/services/cloudStorageService.dart';
import 'package:test_flutter_app/services/dbService.dart';
import 'package:test_flutter_app/utilities/global_values.dart';
import 'package:test_flutter_app/widgets/customAppBar.dart';
import 'package:test_flutter_app/widgets/propertyImageAndInfo.dart';
import 'package:test_flutter_app/widgets/requestInventoryCheckDialog.dart';
import 'package:test_flutter_app/widgets/simpleButton.dart';
import 'package:test_flutter_app/widgets/wideInventoryCheckCard.dart';

enum MenuItem { edit, itemTwo, itemThree }

class PropertyPage extends StatefulWidget {
  PropertyPage({Key? key, this.property}) : super(key: key);

  Property? property;

  @override
  _PropertyPageState createState() => _PropertyPageState();
}

class _PropertyPageState extends State<PropertyPage> {
  Property? property;
  Uint8List? propertyImage;
  User? landlordDetails;
  User? tenantDetails;

  MenuItem? selectedMenu;
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    widget.property != null ? property = widget.property! : null;

    if (property != null &&
        property!.propertyImageName != null &&
        propertyImage == null) {
      getPropertyImage(property!.propertyImageName!);
    }
    if (property != null &&
        property!.ownerId != null &&
        landlordDetails == null) {
      getLandlordDetails(property!.ownerId!);
    }

    return Scaffold(
      appBar: CustomAppBar(),
      body: Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                PopupMenuButton<MenuItem>(
                  padding: const EdgeInsets.all(0),
                  initialValue: selectedMenu,
                  // Callback that sets the selected popup menu item.
                  onSelected: (MenuItem item) {
                    switch (item) {
                      case MenuItem.edit:
                        log("edit selected");
                        if (property != null && propertyImage != null) {
                          PersistentNavBarNavigator.pushNewScreen(context,
                              screen: EditPropertyPage(
                                  property: property!,
                                  propertyImage: propertyImage!));
                        }
                        break;
                      default:
                    }
                    setState(() {
                      selectedMenu = item;
                    });
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<MenuItem>>[
                    const PopupMenuItem<MenuItem>(
                      value: MenuItem.edit,
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem<MenuItem>(
                      value: MenuItem.itemTwo,
                      child: Text('Item 2'),
                    ),
                    const PopupMenuItem<MenuItem>(
                      value: MenuItem.itemThree,
                      child: Text('Item 3'),
                    ),
                  ],
                )
              ]),
              PropertyImageAndInfo(
                propertyImage: propertyImage,
                landlordDetails: landlordDetails,
                tenantDetails: tenantDetails,
                propertyAddress: propertyAddress(),
                tenantEmail: widget.property!.tenantId != null &&
                        widget.property!.tenantId!.isNotEmpty
                    ? widget.property!.tenantId!
                    : null,
              ),
              const SizedBox(height: 50.0),
              Flex(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                direction: Axis.horizontal,
                children: [
                  const Text(
                    "Inventory checks",
                    style: TextStyle(fontSize: 16),
                  ),
                  ElevatedButton.icon(
                      onPressed: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) =>
                              RequestInventoryCheckDialog(
                                property: property,
                              )),
                      icon: Icon(Icons.add),
                      label: Text("Request inventory check"),
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap))
                ],
              ),
              const SizedBox(height: 15.0),
              Container(
                height: 30,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(64, 0, 0, 0),
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: DropdownButton<String>(
                    style:
                        const TextStyle(fontSize: 15, color: Color(0xFF636363)),
                    underline: Container(
                      height: 0,
                    ),
                    hint: const Text("Sort"),
                    value: dropdownValue,
                    onChanged: (value) =>
                        {setState(() => dropdownValue = value!), log(value!)},
                    items: const [
                      DropdownMenuItem(
                        child: Text("Newest first"),
                        value: "1",
                      ),
                      DropdownMenuItem(
                        child: Text("Oldest first"),
                        value: "2",
                      )
                    ]),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 25,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Color(0xFF489EED),
                          borderRadius: BorderRadius.circular(100)),
                      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                      child: Row(
                        children: const [
                          Text(
                            "Check in",
                            style: TextStyle(color: Color(0xFFFFFFFF)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(100)),
                      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                      child: Row(
                        children: const [
                          Text(
                            "Check out",
                            style: TextStyle(color: Color(0xFF636363)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(100)),
                      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                      child: Row(
                        children: const [
                          Text(
                            "Requests",
                            style: TextStyle(color: Color(0xFF636363)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(100)),
                      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                      child: Row(
                        children: const [
                          Text(
                            "Has comments",
                            style: TextStyle(color: Color(0xFF636363)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(100)),
                      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                      child: Row(
                        children: const [
                          Text(
                            "Has no comments",
                            style: TextStyle(color: Color(0xFF636363)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                child: Column(children: [
                  WideInventoryCheckCard(),
                  WideInventoryCheckCard(),
                  WideInventoryCheckCard(),
                  WideInventoryCheckCard(),
                ]),
              )
            ]),
          )),
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

  Future<void> getLandlordDetails(String landlordId) async {
    User? landlord;

    try {
      landlord = await DbService.getUserDocument(landlordId);
    } catch (e) {}
    if (landlord != null) {
      setState(() {
        log("Landlord name: ${landlord!.firstName!}");
        landlordDetails = landlord;
      });
    }
  }

  Future<void> getTenantDetails(String tenantEmail) async {
    User? tenant;
    String? tenantId;

    //get tenant id by using email

    if (tenantId == null) {
      return;
    }

    try {
      tenant = await DbService.getUserDocument(tenantId);
    } catch (e) {}
    if (tenant != null) {
      setState(() {
        log("Landlord name: ${tenant!.firstName!}");
        tenantDetails = tenant;
      });
    }
  }

  String propertyAddress() {
    if (property != null &&
        property!.addressHouseNameOrNumber != null &&
        property!.addressRoadName != null &&
        property!.addressCity != null &&
        property!.addressPostcode != null) {
      return ("${property!.addressHouseNameOrNumber} ${property!.addressRoadName}, ${property!.addressCity}, ${property!.addressPostcode}");
    }

    return "No address given";
  }
}
