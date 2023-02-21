import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:test_flutter_app/models/inventoryCheckInputArea.dart';
import 'package:test_flutter_app/services/dbService.dart';
import 'package:test_flutter_app/utilities/inventory_check_linked_list.dart';
import 'package:uuid/uuid.dart';

typedef void IntCallback(int val);

class InventoryCheckFormInput extends StatefulWidget {
  InventoryCheckFormInput(
      {Key? key,
      required this.parentSectionId,
      required this.inventoryCheckId,
      required this.inputAreaPosition,
      this.inputTitle,
      required this.checkboxCallback,
      required this.inputHasBeenUpdatedCallback,
      this.canUpdateInputs})
      : super(key: key);

  String parentSectionId;
  String inventoryCheckId;
  int inputAreaPosition;
  String? inputTitle;
  final IntCallback checkboxCallback;
  final IntCallback inputHasBeenUpdatedCallback;
  // TODO add callback to pass back an integer when this has finished updating linked structure
  bool? canUpdateInputs;

  @override
  _InventoryCheckFormInputState createState() =>
      _InventoryCheckFormInputState();
}

// TODO add similar mechanism that is in the section class to know when and how to update the linked structure
class _InventoryCheckFormInputState extends State<InventoryCheckFormInput> {
  bool inputComplete = false;
  bool showTitleEdit = true;
  bool delete = false;
  String id = Uuid().v4();
  String? inputTitle;
  bool titleEditable = true;
  final _inputTitleController = TextEditingController();
  final _inputTitleFocus = FocusNode();
  final _inputDetailsController = TextEditingController();
  final _inputDetailsFocus = FocusNode();
  bool? canUpdateInputs;

  @override
  Widget build(BuildContext context) {
    if (inputTitle == null) {
      inputTitle = widget.inputTitle != null ? widget.inputTitle! : "";
      if (widget.inputTitle != null && widget.inputTitle!.isNotEmpty) {
        showTitleEdit = false;
        titleEditable = false;
      } else {
        showTitleEdit = true;
      }
    }
    if (!delete) {
      InventoryCheckLinkedList.addInputField(widget.parentSectionId, id);
    }
    if (canUpdateInputs != null && canUpdateInputs == true) {
      log("updating inputs for input: $id");
      setState(() {
        canUpdateInputs = false;
      });
    }

    return GestureDetector(
      onHorizontalDragStart: (details) => log("Swipe start"),
      onHorizontalDragUpdate: (details) {
        log("Swiping: " + details.globalPosition.dx.toString());
      },
      onHorizontalDragEnd: (details) => log("Swiped"),
      onTap: () {
        _inputTitleFocus.unfocus();
        _inputDetailsFocus.unfocus();
      },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Visibility(
              visible: !titleEditable,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(inputTitle!.isEmpty ? "Input title" : "$inputTitle:"),
                  showTitleEdit == false
                      ? SizedBox()
                      : IconButton(
                          onPressed: () {
                            setState(() {
                              titleEditable = !titleEditable;
                            });
                          },
                          icon: Icon(Icons.edit))
                ],
              ),
            ),
            Visibility(
              visible: titleEditable,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      // onChanged: (value) {
                      //   setState(() {
                      //     inputTitle = value;
                      //   });
                      // },
                      controller: _inputTitleController,
                      focusNode: _inputTitleFocus,
                      // validator: (value) => Validator.(
                      //   password: value,
                      // ),
                      decoration: InputDecoration(
                        hintText: "Input title (e.g. Front door)",
                        errorBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          inputTitle = _inputTitleController.text;
                          titleEditable = !titleEditable;
                        });
                      },
                      icon: Icon(Icons.check)),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          titleEditable = !titleEditable;
                        });
                      },
                      icon: Icon(Icons.close))
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    maxLines: 20,
                    minLines: 1,
                    controller: _inputDetailsController,
                    focusNode: _inputDetailsFocus,
                    // validator: (value) => Validator.(
                    //   password: value,
                    // ),
                    decoration: InputDecoration(
                      hintText: "Provide details here",
                      errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
                Checkbox(
                    value: inputComplete,
                    onChanged: (value) {
                      if (value == true) {
                        widget.checkboxCallback(1);
                      } else {
                        widget.checkboxCallback(-1);
                      }
                      setState(() {
                        inputComplete = value!;
                      });
                    })
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
                      (canUpdateInputs == null || canUpdateInputs == false)) {
                    canUpdateInputs = next;
                    updateInputs();
                  } else if (next == false &&
                      canUpdateInputs != null &&
                      canUpdateInputs == true) {
                    canUpdateInputs = next;
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void updateInputs() {
    log("updated input: $id");

    InventoryCheckInputArea inventoryCheckInputArea = InventoryCheckInputArea(
        id: id,
        inventoryCheckId: widget.inventoryCheckId,
        sectionId: widget.parentSectionId,
        title: inputTitle,
        details: _inputDetailsController.text,
        inputPosition: widget.inputAreaPosition,
        inputComplete: inputComplete);
    DbService.submitInventoryCheckInputArea(inventoryCheckInputArea);
    setState(() {
      canUpdateInputs = false;
    });
    // InventoryCheckLinkedList.printSingleSectionDetails(id);
  }
}
