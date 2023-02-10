import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:test_flutter_app/models/property.dart';
import 'package:test_flutter_app/models/user.dart';
import 'package:test_flutter_app/services/cloudStorageService.dart';
import 'package:test_flutter_app/services/dbService.dart';
import 'package:test_flutter_app/utilities/global_values.dart';
import 'package:test_flutter_app/widgets/customAppBar.dart';
import 'package:test_flutter_app/widgets/requestInventoryCheckDialog.dart';
import 'package:test_flutter_app/widgets/simpleButton.dart';
import 'package:test_flutter_app/widgets/wideInventoryCheckCard.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

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

  SampleItem? selectedMenu;
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    widget.property != null ? property = widget.property! : null;

    if (property != null &&
        property!.propertyImageName != null &&
        propertyImage == null) {
      getPropertyImage(property!.propertyImageName!);
    }
    if(property!=null && property!.ownerId!=null && landlordDetails==null){
      getLandlordDetails(property!.ownerId!);
    }
    // if(property!=null && property!.tenantEmail!=null && tenantDetails==null){
    //   getTenantDetails(property!.tenantEmail!);
    // }

    return Scaffold(
      appBar: CustomAppBar(),
      body: Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                PopupMenuButton<SampleItem>(
                  padding: const EdgeInsets.all(0),
                  initialValue: selectedMenu,
                  // Callback that sets the selected popup menu item.
                  onSelected: (SampleItem item) {
                    setState(() {
                      selectedMenu = item;
                    });
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<SampleItem>>[
                    const PopupMenuItem<SampleItem>(
                      value: SampleItem.itemOne,
                      child: Text('Item 1'),
                    ),
                    const PopupMenuItem<SampleItem>(
                      value: SampleItem.itemTwo,
                      child: Text('Item 2'),
                    ),
                    const PopupMenuItem<SampleItem>(
                      value: SampleItem.itemThree,
                      child: Text('Item 3'),
                    ),
                  ],
                )
              ]),
              ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                height: 300,
                decoration: propertyImage != null
                    ? BoxDecoration(
                        image: DecorationImage(
                            image: MemoryImage(propertyImage!), fit: BoxFit.cover))
                    : const BoxDecoration(
                        image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/placeholderImages/house.jpg'),
                      )))),
              const SizedBox(height: 16.0),
              Wrap(
                spacing: 50,
                runSpacing: 10,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image(
                        image: AssetImage(IconPaths.tenantIconPath.path),
                        width: 28,
                        height: 28,
                      ),
                      const SizedBox(width: 8.0),
                      const Text("Carlos Bento")
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image(
                        image: AssetImage(IconPaths.landlordIconPath.path),
                        width: 28,
                        height: 28,
                      ),
                      const SizedBox(width: 8.0),
                      Text(landlordDetails!=null?"${landlordDetails!.firstName!} ${landlordDetails!.lastName!}":"")
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image(
                        image: AssetImage(IconPaths.addressIconPath.path),
                        width: 28,
                        height: 28,
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                          child: Text(
                        propertyAddress(),
                        overflow: TextOverflow.visible,
                      ))
                    ],
                  ),
                ],
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
                              RequestInventoryCheckDialog(property: property,)),
                      icon: Icon(Icons.add),
                      label: Text("Request"),
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

    if(tenantId == null){
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

  String propertyAddress(){
    if(property!=null && property!.addressHouseNameOrNumber!=null &&
    property!.addressRoadName!=null && property!.addressCity!=null &&
    property!.addressPostcode!=null){
      return("${property!.addressHouseNameOrNumber} ${property!.addressRoadName}, ${property!.addressCity}, ${property!.addressPostcode}");
    }

    return "No address given";
  }
}
