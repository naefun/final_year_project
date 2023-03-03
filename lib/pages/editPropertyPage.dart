import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:test_flutter_app/models/property.dart';
import 'package:test_flutter_app/services/dbService.dart';
import 'package:test_flutter_app/widgets/customAppBar.dart';
import 'package:test_flutter_app/widgets/simpleButton.dart';

class EditPropertyPage extends StatefulWidget {
  EditPropertyPage(
      {Key? key, required this.property, required this.propertyImage})
      : super(key: key);

  Property property;
  Uint8List propertyImage;

  @override
  _EditPropertyPageState createState() => _EditPropertyPageState();
}

class _EditPropertyPageState extends State<EditPropertyPage> {
  final _propertyNumberTextController = TextEditingController();
  final _propertyRoadNameTextController = TextEditingController();
  final _propertyCityTextController = TextEditingController();
  final _propertyPostcodeTextController = TextEditingController();
  final _propertyTenantTextController = TextEditingController();
  final _propertyNumberFocus = FocusNode();
  final _propertyRoadNameFocus = FocusNode();
  final _propertyCityFocus = FocusNode();
  final _propertyPostcodeFocus = FocusNode();
  final _propertyTenantFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    setInputFields();

    return Scaffold(
      appBar: CustomAppBar(
        title: "Edit property",
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                      height: 300,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: MemoryImage(widget.propertyImage),
                              fit: BoxFit.cover)))),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      focusNode: _propertyNumberFocus,
                      onTapOutside: (event) => _propertyNumberFocus.unfocus(),
                      controller: _propertyNumberTextController,
                      decoration: InputDecoration(
                        hintText: "House number/name",
                        errorBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    TextFormField(
                      focusNode: _propertyRoadNameFocus,
                      onTapOutside: (event) => _propertyRoadNameFocus.unfocus(),
                      controller: _propertyRoadNameTextController,
                      decoration: InputDecoration(
                        hintText: "Road name",
                        errorBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    TextFormField(
                      focusNode: _propertyCityFocus,
                      onTapOutside: (event) => _propertyCityFocus.unfocus(),
                      controller: _propertyCityTextController,
                      decoration: InputDecoration(
                        hintText: "City",
                        errorBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    TextFormField(
                      focusNode: _propertyPostcodeFocus,
                      onTapOutside: (event) => _propertyPostcodeFocus.unfocus(),
                      controller: _propertyPostcodeTextController,
                      decoration: InputDecoration(
                        hintText: "Postcode",
                        errorBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    TextFormField(
                      focusNode: _propertyTenantFocus,
                      onTapOutside: (event) => _propertyTenantFocus.unfocus(),
                      controller: _propertyTenantTextController,
                      decoration: InputDecoration(
                        hintText: "Tenant email",
                        errorBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SimpleButton(
                    onPressedFunction: () {
                      log("Cancelled");
                      Navigator.pop(context);
                    },
                    buttonLabel: "Cancel",
                    secondaryButton: true,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  SimpleButton(
                      onPressedFunction: () async {
                        await DbService.updateProperty(Property(
                            propertyId: widget.property.propertyId,
                            addressHouseNameOrNumber:
                                _propertyNumberTextController.text,
                            addressRoadName:
                                _propertyRoadNameTextController.text,
                            addressCity: _propertyCityTextController.text,
                            addressPostcode:
                                _propertyPostcodeTextController.text,
                            tenantId: _propertyTenantTextController.text));
                      },
                      buttonLabel: "Submit"),
                ],
              ),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setInputFields() {
    _propertyNumberTextController.text =
        widget.property.addressHouseNameOrNumber!;
    _propertyRoadNameTextController.text = widget.property.addressRoadName!;
    _propertyCityTextController.text = widget.property.addressCity!;
    _propertyPostcodeTextController.text = widget.property.addressPostcode!;
    _propertyTenantTextController.text =
        widget.property.tenantId != null ? widget.property.tenantId! : "";
  }
}
