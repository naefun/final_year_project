import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_flutter_app/models/property.dart';
import 'package:test_flutter_app/models/tenancy.dart';
import 'package:test_flutter_app/models/user.dart';
import 'package:test_flutter_app/services/dbService.dart';
import 'package:test_flutter_app/utilities/snackbarUtility.dart';
import 'package:test_flutter_app/utilities/themeColors.dart';
import 'package:test_flutter_app/widgets/customAppBar.dart';
import 'package:test_flutter_app/widgets/tenancyCard.dart';
import 'package:uuid/uuid.dart';

class EditTenancyPage extends StatefulWidget {
  EditTenancyPage({Key? key, required this.property}) : super(key: key);

  Property property;

  @override
  _EditTenancyPageState createState() => _EditTenancyPageState();
}

class _EditTenancyPageState extends State<EditTenancyPage> {
  BuildContext? widgetContext;

  final _newTenantEmailController = TextEditingController();
  final _newTenancyStartDateController = TextEditingController();
  final _newTenancyEndDateController = TextEditingController();

  final _newTenantEmailFocusNode = FocusNode();
  final _newTenancyStartDateFocusNode = FocusNode();
  final _newTenancyEndDateFocusNode = FocusNode();

  DateTime? newTenancyStartDate;
  DateTime? newTenancyEndDate;

  final _updateTenancyStartDateController = TextEditingController();
  final _updateTenancyEndDateController = TextEditingController();

  final _updateTenantEmailFocusNode = FocusNode();
  final _updateTenancyStartDateFocusNode = FocusNode();
  final _updateTenancyEndDateFocusNode = FocusNode();

  DateTime? updateTenancyStartDate;
  DateTime? updateTenancyEndDate;

  bool propertyHasTenant = false;
  bool editTenancyEnabled = false;
  bool renderTenancyCreator = false;

  List<Tenancy>? tenancies;
  Tenancy? selectedTenancy;
  User? tenant;

  String? selectedTenancyId;

  @override
  initState() {
    super.initState();

    //getCurrentTenancy();

    if (propertyHasTenant == true && tenant == null) {
      getTenantUser();
    }

    getPropertyTenancies();
  }

  @override
  Widget build(BuildContext context) {
    if (widgetContext == null) {
      setState(() {
        widgetContext = context;
      });
    }
    if (tenancies == null) getPropertyTenancies();
    if (selectedTenancyId == null) {
      setState(() {
        selectedTenancy = null;
      });
    } else if (selectedTenancyId != null &&
        tenancies != null &&
        tenancies!.isNotEmpty) {
      setState(() {
        selectedTenancy =
            tenancies!.firstWhere((element) => element.id == selectedTenancyId);
      });
    }
    if (selectedTenancy != null) populateUpdateDates();
    if (selectedTenancy == null &&
        selectedTenancyId != null &&
        tenancies != null) {
      setState(() {
        selectedTenancy =
            tenancies!.firstWhere((element) => element.id == selectedTenancyId);
      });
    }
    if (renderTenancyCreator == false &&
        (newTenancyStartDate != null ||
            newTenancyEndDate != null ||
            _newTenantEmailController.text.isNotEmpty)) {
      clearTenancyCreatorFields();
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: "Tenancies",
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.property.getPropertyAddress()),
              SizedBox(
                height: 20,
              ),
              selectedTenancy == null
                  ? Text("Select a tenancy to edit")
                  : Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Tenant details"),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Name"),
                            Text(tenant != null &&
                                    tenant!.firstName != null &&
                                    tenant!.lastName != null
                                ? "${tenant!.firstName} ${tenant!.lastName}"
                                : selectedTenancy != null
                                    ? "${selectedTenancy!.tenantEmail}"
                                    : ""),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Tenancy term: "),
                            Row(
                              children: [
                                Text(updateTenancyStartDate != null &&
                                        updateTenancyEndDate != null
                                    ? "${updateTenancyStartDate!.day}/${updateTenancyStartDate!.month}/${updateTenancyStartDate!.year} - ${updateTenancyEndDate!.day}/${updateTenancyEndDate!.month}/${updateTenancyEndDate!.year}"
                                    : "Tenancy term data not found"),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: ThemeColors.mainBlue),
                                  child: IconButton(
                                    constraints: BoxConstraints(),
                                    padding: EdgeInsets.all(5),
                                    color: Color(0xFFFFFFFF),
                                    onPressed: () => showDateRangeSelector(
                                        updateTenancyMode: true),
                                    icon: Icon(Icons.edit),
                                    iconSize: 15,
                                  ),
                                )
                              ],
                            )
                          ]),
                    ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Text("Tenancies"),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: ThemeColors.mainBlue),
                    child: IconButton(
                      constraints: BoxConstraints(),
                      padding: EdgeInsets.all(5),
                      color: Color(0xFFFFFFFF),
                      onPressed: () {
                        setState(() {
                          renderTenancyCreator = !renderTenancyCreator;
                        });
                      },
                      icon: Icon(Icons.add),
                      iconSize: 15,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: renderTenancyCreator == true ? 10 : 0,
              ),
              renderTenancyCreator == true ? showTenancyCreator() : SizedBox(),
              SizedBox(
                height: 30,
              ),
              tenancies != null
                  ? ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: tenancies!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTenancyId =
                                  selectedTenancyId == tenancies![index].id
                                      ? null
                                      : tenancies![index].id;
                            });
                            log(tenancies![index].startDate!);
                          },
                          child: TenancyCard(
                              tenancy: tenancies![index],
                              selected: selectedTenancyId != null &&
                                      selectedTenancyId == tenancies![index].id
                                  ? true
                                  : false),
                        );
                      })
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  void getTenantUser() async {
    await DbService.getUserDocumentFromEmail(widget.property.tenantId!)
        .then((value) {
      if (value != null) {
        setState(() {
          tenant = value;
        });
      }
    });
  }

  void createNewTenancy() async {
    if (_newTenantEmailController.text.isEmpty ||
        newTenancyStartDate == null ||
        newTenancyEndDate == null) {
      SnackbarUtility.showSnackbar(widgetContext!, "Please fill in all fields");
      return;
    }

    Tenancy newTenancy = Tenancy(
        id: Uuid().v4(),
        tenantEmail: _newTenantEmailController.text,
        propertyId: widget.property.propertyId,
        startDate: newTenancyStartDate.toString(),
        endDate: newTenancyEndDate.toString());

    await DbService.createTenancyDocument(newTenancy);
    SnackbarUtility.showSnackbar(widgetContext!,
        "New tenancy created for: ${_newTenantEmailController.text}");
    setState(() {
      selectedTenancyId = null;
      tenancies = null;
      renderTenancyCreator = false;
    });
  }

  void showDateRangeSelector({bool? updateTenancyMode}) async {
    DateTime tempStartDate =
        updateTenancyMode == true ? updateTenancyStartDate! : DateTime.now();
    DateTime tempEndDate =
        updateTenancyMode == true ? updateTenancyEndDate! : DateTime.now();

    DateTimeRange? selectedDate = await showDateRangePicker(
        helpText: updateTenancyMode == null || updateTenancyMode == false
            ? "Select date"
            : "Update date",
        context: widgetContext!,
        initialDateRange: DateTimeRange(
            start: tempStartDate != null ? tempStartDate : DateTime.now(),
            end: tempEndDate != null ? tempEndDate : DateTime.now()),
        firstDate: tempStartDate != null ? tempStartDate : DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 10,
            DateTime.now().month < 12 ? DateTime.now().month + 1 : 0, 0));

    if (selectedDate == null || selectedDate.start == selectedDate.end) {
    } else if (updateTenancyMode == null || updateTenancyMode == false) {
      setState(() {
        newTenancyStartDate = selectedDate.start;
        newTenancyEndDate = selectedDate.end;
        _newTenancyStartDateController.text =
            "${selectedDate.start.day}/${selectedDate.start.month}/${selectedDate.start.year}";
        _newTenancyEndDateController.text =
            "${selectedDate.end.day}/${selectedDate.end.month}/${selectedDate.end.year}";
      });
      log("New tenancy dates: ");
      log(selectedDate.start.toString());
      log(selectedDate.end.toString());
    } else if (updateTenancyMode == true &&
        (selectedDate.start != updateTenancyStartDate &&
            selectedDate.end != updateTenancyEndDate)) {
      updateTenancyTerm(selectedDate.start, selectedDate.end);
      setState(() {
        updateTenancyStartDate = selectedDate.start;
        updateTenancyEndDate = selectedDate.end;
        _updateTenancyStartDateController.text =
            "${selectedDate.start.day}/${selectedDate.start.month}/${selectedDate.start.year}";
        _updateTenancyEndDateController.text =
            "${selectedDate.end.day}/${selectedDate.end.month}/${selectedDate.end.year}";
        tenancies = null;
        selectedTenancy = null;
      });
      SnackbarUtility.showSnackbar(widgetContext!, "Tenancy term date updated");
    }
  }

  void updateTenancyTerm(DateTime start, DateTime end) async {
    await DbService.updateTenancyTerm(
        selectedTenancy!.id!, start.toString(), end.toString());
  }

  void getPropertyTenancies() async {
    List<Tenancy> tempTenancies = [];

    await DbService.getTenancyDocuments(widget.property.propertyId!)
        .then((value) {
      if (value != null) {
        for (QueryDocumentSnapshot<Tenancy> element in value) {
          tempTenancies.add(element.data());
          log("${element.data().startDate!} - ${element.data().endDate!}");
        }
      }
    });

    tempTenancies.sort((a, b) => b.startDate!.compareTo(a.startDate!));

    setState(() {
      tenancies = tempTenancies;
    });
  }

  Widget showTenancyCreator() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 232, 232, 232),
          borderRadius: BorderRadius.circular(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Add tenancy"),
          TextField(
            focusNode: _newTenantEmailFocusNode,
            onTapOutside: (event) => _newTenantEmailFocusNode.unfocus(),
            controller: _newTenantEmailController,
            decoration: InputDecoration(helperText: "Tenant email"),
          ),
          SizedBox(
            height: 20,
          ),
          Text("Tenancy term"),
          Row(
            children: [
              Expanded(
                child: TextField(
                    focusNode: _newTenancyStartDateFocusNode,
                    onTapOutside: (event) =>
                        _newTenancyStartDateFocusNode.unfocus(),
                    controller: _newTenancyStartDateController,
                    readOnly: true,
                    decoration: InputDecoration(helperText: "Move in date"),
                    onTap: () => showDateRangeSelector()),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Text("-"),
              ),
              Expanded(
                child: TextField(
                    focusNode: _newTenancyEndDateFocusNode,
                    onTapOutside: (event) =>
                        _newTenancyEndDateFocusNode.unfocus(),
                    controller: _newTenancyEndDateController,
                    readOnly: true,
                    decoration: InputDecoration(helperText: "Move out date"),
                    onTap: () => showDateRangeSelector()),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          ButtonBar(
            children: [
              ElevatedButton(
                  onPressed: () {
                    createNewTenancy();
                  },
                  child: Text("Create tenancy"))
            ],
          )
        ],
      ),
    );
  }

  void populateUpdateDates() {
    setState(() {
      updateTenancyStartDate = DateTime.tryParse(selectedTenancy!.startDate!);
      updateTenancyEndDate = DateTime.tryParse(selectedTenancy!.endDate!);
    });
  }

  void clearTenancyCreatorFields() {
    log("Cleared tenancy creator fields");
    setState(() {
      newTenancyStartDate = DateTime.now();
      newTenancyEndDate = DateTime.now();
      _newTenancyStartDateController.text = "";
      _newTenancyEndDateController.text = "";
      _newTenantEmailController.text = "";
    });
  }
}
