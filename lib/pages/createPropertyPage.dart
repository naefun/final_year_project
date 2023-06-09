import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:test_flutter_app/models/property.dart';
import 'package:test_flutter_app/services/cloudStorageService.dart';
import 'package:test_flutter_app/services/dbService.dart';
import 'package:test_flutter_app/services/fireAuth.dart';
import 'package:test_flutter_app/utilities/pageNavigator.dart';
import 'package:test_flutter_app/widgets/customAppBar.dart';
import 'package:test_flutter_app/widgets/fileSelector.dart';
import 'package:uuid/uuid.dart';

class CreatePropertyPage extends StatefulWidget {
  const CreatePropertyPage({Key? key}) : super(key: key);

  @override
  _CreatePropertyPageState createState() => _CreatePropertyPageState();
}

class _CreatePropertyPageState extends State<CreatePropertyPage> {
  final _registerFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;
  File? selectedImage;

  void updateSelectedImage(File image) {
    setState(() {
      selectedImage = image;
    });
  }

  final _addressHouseNameOrNumberTextController = TextEditingController();
  final _addressRoadNameTextController = TextEditingController();
  final _addressPostcodeTextController = TextEditingController();
  final _addressCityTextController = TextEditingController();

  final _focusAddressHouseNameOrNumber = FocusNode();
  final _focusAddressRoadName = FocusNode();
  final _focusAddressPostcode = FocusNode();
  final _focusAddressCity = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusAddressHouseNameOrNumber.unfocus();
      },
      child: Scaffold(
        appBar: CustomAppBar(title: "Create property"),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: ListView(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _registerFormKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                          child: selectedImage != null
                              ? Image.file(selectedImage!)
                              : Text("No image selected")),
                      FileSelector(onImageSelected: (File image) {
                        updateSelectedImage(image);
                      }),
                      TextFormField(
                        controller: _addressHouseNameOrNumberTextController,
                        focusNode: _focusAddressHouseNameOrNumber,
                        validator: (value) => ((value == null || value.isEmpty)
                            ? "House name/number cannot be empty"
                            : null),
                        decoration: InputDecoration(
                          hintText: "House name or number",
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: _addressRoadNameTextController,
                        focusNode: _focusAddressRoadName,
                        validator: (value) => ((value == null || value.isEmpty)
                            ? "Road name cannot be empty"
                            : null),
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
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: _addressPostcodeTextController,
                        focusNode: _focusAddressPostcode,
                        validator: (value) => ((value == null || value.isEmpty)
                            ? "Postcode cannot be empty"
                            : null),
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
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: _addressCityTextController,
                        focusNode: _focusAddressCity,
                        validator: (value) => ((value == null || value.isEmpty)
                            ? "City cannot be empty"
                            : null),
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
                      SizedBox(height: 32.0),
                      _isProcessing
                          ? CircularProgressIndicator()
                          : Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (_registerFormKey.currentState!
                                          .validate()) {
                                        String _propertyImageName =
                                            selectedImage != null
                                                ? Uuid().v4()
                                                : "null";
                                        String propertyId = Uuid().v4();

                                        Property propertyDocument = Property(
                                            addressHouseNameOrNumber:
                                                _addressHouseNameOrNumberTextController
                                                    .text,
                                            addressRoadName:
                                                _addressRoadNameTextController
                                                    .text,
                                            addressPostcode:
                                                _addressPostcodeTextController
                                                    .text,
                                            addressCity:
                                                _addressCityTextController.text,
                                            propertyImageName:
                                                _propertyImageName,
                                            ownerId:
                                                FireAuth.getCurrentUser()!.uid,
                                            propertyId: propertyId);

                                        setState(() {
                                          _isProcessing = true;
                                        });

                                        log("This is where the property will be sent to the database");
                                        if (Property.fieldsArentEmpty(
                                                propertyDocument) &&
                                            selectedImage != null) {
                                          await DbService
                                              .createPropertyDocument(
                                                  propertyDocument);
                                          await CloudStorageService
                                              .putPropertyImage(selectedImage!,
                                                  _propertyImageName);

                                          PageNavigator.navigateToHomePage(
                                              context);
                                        }

                                        setState(() {
                                          _isProcessing = false;
                                        });
                                      }
                                    },
                                    child: Text(
                                      'Create property',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
