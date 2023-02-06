import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:test_flutter_app/utilities/global_values.dart';
import 'package:test_flutter_app/widgets/customAppBar.dart';
import 'package:test_flutter_app/widgets/wideInventoryCheckCard.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class PropertyPage extends StatefulWidget {
  const PropertyPage({Key? key}) : super(key: key);

  @override
  _PropertyPageState createState() => _PropertyPageState();
}

class _PropertyPageState extends State<PropertyPage> {
  SampleItem? selectedMenu;
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
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
                  child: const Image(
                      image: AssetImage("assets/placeholderImages/house.jpg"))),
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
                      const Text("John Crifton")
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
                      const Expanded(
                          child: Text(
                        "24 Valencia Croft, Birmingham, B35 7PH",
                        overflow: TextOverflow.visible,
                      ))
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 50.0),
              const Text(
                "Inventory checks",
                style: TextStyle(fontSize: 16),
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
}
