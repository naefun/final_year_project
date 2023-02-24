import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:test_flutter_app/models/inventoryCheckInputArea.dart';
import 'package:test_flutter_app/models/inventoryCheckSection.dart';
import 'package:test_flutter_app/services/dbService.dart';
import 'package:test_flutter_app/widgets/inventoryCheckSubSectionArea.dart';

class InventoryCheckSectionArea extends StatefulWidget {
  InventoryCheckSectionArea({Key? key, required this.inventoryCheckSection})
      : super(key: key);

  InventoryCheckSection inventoryCheckSection;

  @override
  _InventoryCheckSectionAreaState createState() =>
      _InventoryCheckSectionAreaState();
}

class _InventoryCheckSectionAreaState extends State<InventoryCheckSectionArea> {
  List<InventoryCheckInputArea>? inventoryCheckInputAreas;
  List<InventoryCheckSubSectionArea>? inventoryCheckSubsectionAreas;

  @override
  Widget build(BuildContext context) {

    if(inventoryCheckInputAreas==null) getInventoryCheckSubSections();
    if(inventoryCheckInputAreas!=null && inventoryCheckSubsectionAreas==null) createSubsectionAreas();

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.inventoryCheckSection.title!),
          SizedBox(
            height: 20,
          ),
          SizedBox(height: 20),
              inventoryCheckSubsectionAreas != null &&
                      inventoryCheckSubsectionAreas!.isNotEmpty
                  ? ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: inventoryCheckSubsectionAreas!.length,
                      itemBuilder: (BuildContext context, int index) =>
                          inventoryCheckSubsectionAreas![index],
                    )
                  : SizedBox(),
        ],
      ),
    );
  }

  void getInventoryCheckSubSections() async {
    List<InventoryCheckInputArea> tempInventoryCheckSubsections = [];

    await DbService.getInventoryCheckSubSections(
            widget.inventoryCheckSection.id!)
        .then((value) => value?.forEach((element) {
              tempInventoryCheckSubsections.add(element.data());
            }));

    if (tempInventoryCheckSubsections.isNotEmpty) {
      tempInventoryCheckSubsections
          .sort((a, b) => a.inputPosition!.compareTo(b.inputPosition!));
    }
    setState(() {
      inventoryCheckInputAreas = tempInventoryCheckSubsections;
    });

    log(tempInventoryCheckSubsections.length.toString());
  }

  void createSubsectionAreas() {
    List<InventoryCheckSubSectionArea> tempInventoryCheckSubsectionAreas = [];

    for (InventoryCheckInputArea item in inventoryCheckInputAreas!) {
      tempInventoryCheckSubsectionAreas.add(InventoryCheckSubSectionArea(
        inventoryCheckInputArea: item,
      ));
    }

    setState(() {
      inventoryCheckSubsectionAreas = tempInventoryCheckSubsectionAreas;
    });
  }
}
