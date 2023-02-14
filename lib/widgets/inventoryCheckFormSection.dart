import 'package:flutter/material.dart';
import 'package:test_flutter_app/services/validator.dart';
import 'package:test_flutter_app/utilities/inventory_check_linked_list.dart';
import 'package:test_flutter_app/widgets/inventoryCheckFormInput.dart';
import 'package:uuid/uuid.dart';

class InventoryCheckFormSection extends StatefulWidget {
  InventoryCheckFormSection({Key? key, this.sectionTitle, this.inventoryCheckFormInputTitles,}) : super(key: key);

  String? sectionTitle;
  List<String>? inventoryCheckFormInputTitles;

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

  @override
  Widget build(BuildContext context) {
    if(sectionTitle==null){
      sectionTitle = widget.sectionTitle!=null?widget.sectionTitle!:"";
    }

    if(inputArea == null){
      inputArea = [];
      if(widget.inventoryCheckFormInputTitles!=null && widget.inventoryCheckFormInputTitles!.isNotEmpty){
        for (String title in widget.inventoryCheckFormInputTitles!) {

          inputArea!.add(InventoryCheckFormInput(parentSectionId: id, inputTitle: title, checkboxCallback: (val) => setState(() {
            inputsComplete = inputsComplete + val;
          }),));
        }
      }else{
        inputArea!.add(InventoryCheckFormInput(parentSectionId: id, checkboxCallback: (val) => setState(() {
            inputsComplete = inputsComplete + val;
          })));
      }
    }
    if(!delete){
      InventoryCheckLinkedList.addSection(id);
    }
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
              color: inputsComplete==inputArea!.length ?Color(0xFF579A56):Color(0xFF636363),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    sectionTitle!.isEmpty ? "Room/area name" : sectionTitle!,
                    style: TextStyle(color: Colors.white),
                  ),
                  Row(
                    children: [
                      widget.sectionTitle!=null && widget.sectionTitle!.isNotEmpty? SizedBox(): IconButton(
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
                  widget.sectionTitle!=null && widget.sectionTitle!.isNotEmpty? SizedBox():TextFormField(
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
                      widget.sectionTitle!=null && widget.sectionTitle!.isNotEmpty? SizedBox():IconButton(
                          onPressed: () {
                            List<InventoryCheckFormInput> tempInputArea =
                                inputArea!;
                            tempInputArea.add(InventoryCheckFormInput(parentSectionId: id, checkboxCallback: (val) => setState(() {
            inputsComplete = inputsComplete + val;
          })));
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
            )
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
}
