import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_flutter_app/models/property.dart';
import 'package:test_flutter_app/services/dbService.dart';
import 'package:test_flutter_app/services/fireAuth.dart';
import 'package:test_flutter_app/widgets/customAppBar.dart';
import 'package:test_flutter_app/widgets/propertyCard.dart';
import 'package:test_flutter_app/widgets/propertyCards.dart';

class PropertiesPage extends StatefulWidget {
  const PropertiesPage({Key? key}) : super(key: key);

  @override
  _PropertiesPageState createState() => _PropertiesPageState();
}

class _PropertiesPageState extends State<PropertiesPage> {
  List<Property>? properties;
  List<PropertyCard>? propertyCards;
  @override
  Widget build(BuildContext context) {
    if (properties == null) getProperties();
    if (properties != null && propertyCards == null) propertyCards = PropertyCardHelper.getPropertyCards(properties!.length, properties!);
    return Scaffold(
      appBar: CustomAppBar(),
      body: Container(
        width: double.infinity,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              propertyCards != null && propertyCards!.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                          itemCount: propertyCards!.length,
                          itemBuilder: (context, index) =>
                              propertyCards!.elementAt(index)))
                  : const Text(
                      "No properties found",
                      style: TextStyle(fontSize: 25),
                    )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getProperties() async {
    List<Property> propertiesToReturn = [];
    await DbService.getOwnedProperties(FireAuth.getCurrentUser()!.uid)
        .then((value) => {
              if (value != null)
                {
                  for (QueryDocumentSnapshot<Property> prop in value)
                    {propertiesToReturn.add(prop.data())}
                }
            });
    setState(() {
      propertiesToReturn.sort();
      properties = propertiesToReturn;
    });
  }
}
