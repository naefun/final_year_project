import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:test_flutter_app/models/inventoryCheckRequest.dart';
import 'package:test_flutter_app/models/property.dart';
import 'package:test_flutter_app/services/dbService.dart';
import 'package:test_flutter_app/services/validator.dart';
import 'package:uuid/uuid.dart';

class RequestInventoryCheckDialog extends StatefulWidget {
  RequestInventoryCheckDialog({super.key, this.property});

  Property? property;

  @override
  State<RequestInventoryCheckDialog> createState() =>
      _RequestInventoryCheckDialogState();
}

class _RequestInventoryCheckDialogState
    extends State<RequestInventoryCheckDialog> {
  final _requestInventoryCheckFormKey = GlobalKey<FormState>();
  int _selectedType = 1;
  final _emailTextController = TextEditingController();
  final _dateTextController = TextEditingController();
  late DateTime _selectedDate;
  final _focusEmail = FocusNode();
  final _focusDate = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    log(widget.property != null && widget.property!.propertyId != null
        ? "property id: ${widget.property!.propertyId}"
        : "no property id");

    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusDate.unfocus();
      },
      child: Dialog(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                  color: Color(0xFF489EED),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4))),
              width: double.infinity,
              child: const Text(
                'Request an inventory check',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                  key: _requestInventoryCheckFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Type",
                        style: TextStyle(fontSize: 18),
                      ),
                      Row(
                        children: [
                          Radio(
                            value: 1,
                            groupValue: _selectedType,
                            onChanged: (value) {
                              setState(() {
                                _selectedType = value!;
                              });
                            },
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text("Check-in"),
                          const SizedBox(
                            width: 50,
                          ),
                          Radio(
                            value: 2,
                            groupValue: _selectedType,
                            onChanged: (value) {
                              setState(() {
                                _selectedType = value!;
                              });
                            },
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text("Check-out"),
                        ],
                      ),
                      TextFormField(
                        controller: _emailTextController,
                        focusNode: _focusEmail,
                        validator: (value) => Validator.validateEmail(
                          email: value,
                        ),
                        decoration: InputDecoration(
                          hintText: "Clerk email",
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _dateTextController,
                        onTap: () async {
                          DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(
                                  DateTime.now().year + 10,
                                  DateTime.now().month < 12
                                      ? DateTime.now().month + 1
                                      : 0,
                                  0));
                          
                          if(selectedDate!=null) {
                            setState(() {
                            _selectedDate=selectedDate;
                            _dateTextController.text = "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                          });
                          }
                        },
                        
                        readOnly: true,
                        decoration: InputDecoration(
                            labelText: "Select inventory check date",
                            icon: Icon(Icons.calendar_today)),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white, elevation: 4),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Color(0xFF489EED)),
                            ),
                          ),
                          const SizedBox(width: 15),
                          ElevatedButton(
                            onPressed: () async {
                              if (_requestInventoryCheckFormKey.currentState!
                                  .validate()) {
                                log("Attempting to make inventory check request");
                                String? propertyId;
                                if (widget.property != null &&
                                    widget.property!.propertyId != null) {
                                  propertyId = widget.property!.propertyId;
                                  InventoryCheckRequest icr =
                                      InventoryCheckRequest(
                                          id: Uuid().v4(),
                                          type: _selectedType,
                                          clerkEmail: _emailTextController.text,
                                          date: _selectedDate.toString(),
                                          propertyId: propertyId,
                                          complete: false);
                                  DbService.createInventoryCheckRequestDocument(
                                      icr);
                                  Navigator.pop(context);
                                  // createInventoryCheckRequestDocument
                                } else {
                                  log("Couldnt make request");
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF489EED),
                                elevation: 4),
                            child: const Text('Submit'),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
