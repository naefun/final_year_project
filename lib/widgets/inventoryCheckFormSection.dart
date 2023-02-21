import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:test_flutter_app/models/inventoryCheckSection.dart';
import 'package:test_flutter_app/services/dbService.dart';
import 'package:test_flutter_app/services/validator.dart';
import 'package:test_flutter_app/utilities/inventory_check_linked_list.dart';
import 'package:test_flutter_app/widgets/inventoryCheckFormInput.dart';
import 'package:uuid/uuid.dart';

typedef void IntCallback(int val);

class InventoryCheckFormSection extends StatefulWidget {
  InventoryCheckFormSection(
      {Key? key,
      this.sectionTitle,
      this.inventoryCheckFormInputTitles,
      this.updateSection,
      this.essentialSection,
      required this.sectionPosition,
      required this.sectionUpdatedCallback,
      required this.inventoryCheckId})
      : super(key: key);

  String inventoryCheckId;
  String? sectionTitle;
  List<String>? inventoryCheckFormInputTitles;
  bool? updateSection;
  bool? essentialSection;
  int sectionPosition;
  // TODO callback function from form
  final IntCallback sectionUpdatedCallback;

  @override
  _InventoryCheckFormSectionState createState() =>
      _InventoryCheckFormSectionState();
}

class _InventoryCheckFormSectionState extends State<InventoryCheckFormSection> {
  String id = Uuid().v4();
  List<InventoryCheckFormInput>? inputArea;
  String? sectionTitle;
  bool showSection = false;
  final _sectionTitleController = TextEditingController();
  final _sectionTitleFocus = FocusNode();
  bool delete = false;
  int inputsComplete = 0;
  int inputsUpdated = 0;
  bool? updateSection;
  bool sectionUpdated = false;
  int? sectionPosition;
  int inputAreaCount = 0;
  // TODO add counter for populated input fields

  @override
  Widget build(BuildContext context) {
    sectionPosition = widget.sectionPosition;

    if (sectionTitle == null) {
      sectionTitle = widget.sectionTitle != null ? widget.sectionTitle! : "";
    }

    if (inputArea == null) {
      inputArea = [];
      if (widget.inventoryCheckFormInputTitles != null &&
          widget.inventoryCheckFormInputTitles!.isNotEmpty) {
        for (String title in widget.inventoryCheckFormInputTitles!) {
          inputArea!.add(createInventoryCheckInputArea(title));
        }
      } else {
        inputArea!.add(createInventoryCheckInputArea(null));
      }
    }
    if (!delete) {
      InventoryCheckLinkedList.addSection(id, widget.essentialSection ?? false);
    }

    if (updateSection != null && updateSection == true) {
      submitSectionToDb();
      setState(() {
        updateSection = false;
      });
    }

    // Future.delayed(Duration.zero, () {
    //   if (inputsUpdated == inputArea!.length && sectionUpdated==false) {
    //     log("all input areas updated for: $id");
    //     populateSectionFields();
    //   }
    // });
    // if(/* TODO the number of input fields that have completed updating == the total number of input fields within this section */){
    //   // TODO then call the callback passed through from the form with 1 + the number of input fields that have completed
    // }
    return Visibility(
      visible: !delete,
      child: GestureDetector(
        onTap: () {
          _sectionTitleFocus.unfocus();
        },
        child: Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              color: inputsComplete == inputArea!.length
                  ? Color(0xFF579A56)
                  : Color(0xFF636363),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    sectionTitle!.isEmpty ? "Room/area name" : sectionTitle!,
                    style: TextStyle(color: Colors.white),
                  ),
                  Row(
                    children: [
                      widget.sectionTitle != null &&
                              widget.sectionTitle!.isNotEmpty
                          ? SizedBox()
                          : IconButton(
                              onPressed: () {
                                InventoryCheckLinkedList.deleteSection(id);
                                setState(() {
                                  delete = !delete;
                                });
                              },
                              icon: Icon(Icons.delete)),
                      Text("${inputsComplete.toString()}/${inputArea!.length}"),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              showSection = !showSection;
                            });
                          },
                          icon: showSection == true
                              ? Icon(Icons.expand_more)
                              : Icon(Icons.chevron_left)),
                    ],
                  )
                ],
              ),
            ),
            Visibility(
              visible: showSection,
              maintainState: true,
              child: Column(
                children: [
                  widget.sectionTitle != null && widget.sectionTitle!.isNotEmpty
                      ? SizedBox()
                      : TextFormField(
                          onChanged: (value) {
                            setState(() {
                              sectionTitle = value;
                            });
                          },
                          controller: _sectionTitleController,
                          focusNode: _sectionTitleFocus,
                          // validator: (value) => Validator.(
                          //   password: value,
                          // ),
                          decoration: InputDecoration(
                            hintText: "Room/area name (e.g. Kitchen)",
                            errorBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                  getInputAreas(inputArea!),
                  Row(
                    children: [
                      widget.sectionTitle != null &&
                              widget.sectionTitle!.isNotEmpty
                          ? SizedBox()
                          : IconButton(
                              onPressed: () {
                                List<InventoryCheckFormInput> tempInputArea =
                                    inputArea!;
                                tempInputArea.add(createInventoryCheckInputArea(null));
                                setState(() {
                                  inputArea = tempInputArea;
                                });
                              },
                              icon: Icon(Icons.list)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            StoreConnector<bool, bool>(
              converter: (store) => store.state,
              builder: (context, viewModel) {
                return SizedBox();
              },
              onWillChange: (previous, next) {
                setState(() {
                  if (next == true &&
                      (updateSection == null || updateSection == false)) {
                    updateSection = next;
                  } else if (next == false &&
                      updateSection != null &&
                      updateSection == true) {
                    updateSection = next;
                  }
                });
              },
            ),
          ],
        )),
      ),
    );
  }

  Widget getInputAreas(List<InventoryCheckFormInput> inputAreas) {
    return Column(children: [
      for (InventoryCheckFormInput inputArea in inputAreas) inputArea
    ]);
  }

  Future<void> submitSectionToDb() async {
    log("submitting section: $id");

    InventoryCheckSection inventoryCheckSection = InventoryCheckSection(
        id: id,
        inventoryCheckId: widget.inventoryCheckId,
        title: sectionTitle,
        essentialSection: widget.essentialSection ?? false,
        sectionPosition: sectionPosition);

    DbService.submitInventoryCheckSection(inventoryCheckSection);
  }

  InventoryCheckFormInput createInventoryCheckInputArea(String? title) {
    int position = inputAreaCount;
    setState(() {
      inputAreaCount = inputAreaCount + 1;
    });
    return InventoryCheckFormInput(
      inputTitle: title,
      parentSectionId: id,
      checkboxCallback: (val) => setState(() {
        inputsComplete = inputsComplete + val;
      }),
      inputHasBeenUpdatedCallback: (val) => setState(() {
        inputsUpdated = inputsUpdated + val;
      }),
      inputAreaPosition: position,
      inventoryCheckId: widget.inventoryCheckId,
    );
  }
}
