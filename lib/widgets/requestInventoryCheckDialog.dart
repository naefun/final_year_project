import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_flutter_app/models/inventoryCheckRequest.dart';
import 'package:test_flutter_app/models/property.dart';
import 'package:test_flutter_app/models/tenancy.dart';
import 'package:test_flutter_app/services/dbService.dart';
import 'package:test_flutter_app/services/validator.dart';
import 'package:test_flutter_app/utilities/tenancyUtilities.dart';
import 'package:test_flutter_app/utilities/themeColors.dart';
import 'package:uuid/uuid.dart';

class RequestInventoryCheckDialog extends StatefulWidget {
  RequestInventoryCheckDialog({super.key, required this.property});

  Property property;

  @override
  State<RequestInventoryCheckDialog> createState() =>
      _RequestInventoryCheckDialogState();
}

class _RequestInventoryCheckDialogState
    extends State<RequestInventoryCheckDialog> {
  final _requestInventoryCheckFormKey = GlobalKey<FormState>();
  int _selectedType = 1;
  int _selectedTenantType = 1;
  List<Tenancy>? currentTenancies;
  List<Tenancy>? selectedTenants;
  List<Tenancy>? selectableTenants;
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
    log(widget.property != null && widget.property.propertyId != null
        ? "property id: ${widget.property.propertyId}"
        : "no property id");
    if (currentTenancies == null) getCurrentTenancies();
    if (selectedTenants == null &&
        currentTenancies != null &&
        currentTenancies!.isNotEmpty) setSelectedTenants(currentTenancies!);
    if (selectableTenants == null) getSelectableTenants();

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Request an inventory check',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  )
                ],
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
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(height: 10),
                      const Text(
                        "Choose whether this will be a check-in (prior to moving in) or check-out (after moving out) inventory check.",
                        style: TextStyle(fontSize: 11),
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
                            width: 25,
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
                      SizedBox(height: 15),
                      const Text(
                        "Tenant/s",
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(height: 10),
                      const Text(
                        "Choose the tenant/s that this inventory check applies to.",
                        style: TextStyle(fontSize: 11),
                      ),
                      Row(
                        children: [
                          Radio(
                            value: 1,
                            groupValue: _selectedTenantType,
                            onChanged: (value) {
                              setState(() {
                                _selectedTenantType = value!;
                                List<Tenancy> tempTenants = [];
                                tempTenants.addAll(currentTenancies!);
                                selectedTenants = tempTenants;
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
                          const Text("Current tenant/s"),
                          const SizedBox(
                            width: 25,
                          ),
                          Radio(
                            value: 2,
                            groupValue: _selectedTenantType,
                            onChanged: (value) {
                              setState(() {
                                _selectedTenantType = value!;
                                selectedTenants = [];
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
                          const Text("Custom"),
                        ],
                      ),
                      selectedTenants == null || selectedTenants!.isEmpty
                          ? Text("No tenants selected")
                          : SizedBox(
                              height: 40,
                              child: ListView.builder(
                                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: selectedTenants!.length,
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
                                          color: Color.fromARGB(
                                              255, 198, 227, 254),
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(selectedTenants![index]
                                              .tenantEmail!),
                                          _selectedTenantType == 2
                                              ? IconButton(
                                                  iconSize: 15,
                                                  constraints: BoxConstraints(),
                                                  padding: EdgeInsets.fromLTRB(
                                                      5, 0, 0, 0),
                                                  onPressed: () =>
                                                      deselectTenant(
                                                          selectedTenants![
                                                                  index]
                                                              .id!),
                                                  icon: Icon(
                                                      Icons.cancel_outlined))
                                              : SizedBox()
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                      _selectedTenantType != 2
                          ? SizedBox()
                          : selectableTenants == null ||
                                  selectableTenants!.isEmpty
                              ? Text("No tenants to choose from")
                              : SizedBox(
                                  height: 60,
                                  child: ListView.builder(
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: selectableTenants!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          if (tenantAlreadySelected(
                                                  selectableTenants![index]
                                                      .id!) ==
                                              false) {
                                            List<Tenancy> tempTenancies = [];
                                            tempTenancies
                                                .addAll(selectedTenants!);
                                            tempTenancies
                                                .add(selectableTenants![index]);
                                            setState(() {
                                              selectedTenants = tempTenancies;
                                            });
                                          }
                                        },
                                        child: Container(
                                          margin:
                                              EdgeInsets.fromLTRB(0, 0, 10, 0),
                                          padding: EdgeInsets.all(6),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: tenantAlreadySelected(
                                                      selectableTenants![index]
                                                          .id!)
                                                  ? Color.fromARGB(
                                                      255, 234, 234, 234)
                                                  : Color.fromARGB(
                                                      255, 199, 199, 199),
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                selectableTenants![index]
                                                    .tenantEmail!,
                                                style: TextStyle(
                                                    color:
                                                        tenantAlreadySelected(
                                                                selectableTenants![
                                                                        index]
                                                                    .id!)
                                                            ? Color.fromARGB(
                                                                255,
                                                                115,
                                                                115,
                                                                115)
                                                            : Color(
                                                                0xFF000000)),
                                              ),
                                              Text(
                                                  selectableTenants![index]
                                                      .getFormatedStartAndEndDates(),
                                                  style: TextStyle(
                                                      color: tenantAlreadySelected(
                                                              selectableTenants![
                                                                      index]
                                                                  .id!)
                                                          ? Color.fromARGB(255,
                                                              115, 115, 115)
                                                          : Color(0xFF000000)))
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
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

                          if (selectedDate != null) {
                            setState(() {
                              _selectedDate = selectedDate;
                              _dateTextController.text =
                                  "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                            });
                          }
                        },
                        readOnly: true,
                        decoration: const InputDecoration(
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
                                    widget.property.propertyId != null) {
                                  propertyId = widget.property.propertyId;
                                  InventoryCheckRequest icr =
                                      InventoryCheckRequest(
                                          id: const Uuid().v4(),
                                          type: _selectedType,
                                          clerkEmail: _emailTextController.text,
                                          date: _selectedDate.toString(),
                                          propertyId: propertyId,
                                          complete: false,
                                          tenancyIds: List.of(selectedTenants!.map((e) => e.id!)));
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

  void getCurrentTenancies() async {
    List<Tenancy> tempCurrentTenancies = [];
    await TenancyUtilities.getCurrentTenancies(widget.property.propertyId!)
        .then((value) => tempCurrentTenancies = value);
    setState(() {
      currentTenancies = tempCurrentTenancies;
    });
  }

  void setSelectedTenants(List<Tenancy> tenants) {
    setState(() {
      selectedTenants = tenants;
    });
  }

  void deselectTenant(String tenantId) {
    List<Tenancy> tempSelectedTenants = selectedTenants!;
    tempSelectedTenants.removeWhere((element) => element.id == tenantId);
    setState(() {
      selectedTenants = tempSelectedTenants;
    });

    log("Removing tenant: $tenantId");
  }

  void getSelectableTenants() async {
    List<Tenancy> tempTenancies = [];
    await DbService.getTenancyDocuments(widget.property.propertyId!)
        .then((value) {
      if (value != null) {
        for (QueryDocumentSnapshot<Tenancy> element in value) {
          DateTime? start = DateTime.tryParse(element.data().startDate!);
          DateTime? end = DateTime.tryParse(element.data().endDate!);
          DateTime now = DateTime.now();
          if (start == null || end == null) {
            continue;
          } else if ((start.isBefore(now) && end.isAfter(now)) ||
              (start.isAfter(now) && end.isAfter(start))) {
            tempTenancies.add(element.data());
          }
        }
      }
    });
    tempTenancies.sort((a, b) => a.startDate!.compareTo(b.startDate!));

    setState(() {
      selectableTenants = tempTenancies;
    });
  }

  bool tenantAlreadySelected(String tenancyId) {
    bool alreadySelected = false;
    for (Tenancy element in selectedTenants!) {
      if (element.id == tenancyId) {
        alreadySelected = true;
      }
    }

    return alreadySelected;
  }
}
