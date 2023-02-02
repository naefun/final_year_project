import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_flutter_app/models/property.dart';
import 'package:test_flutter_app/services/cloudStorageService.dart';
import 'package:test_flutter_app/services/dbService.dart';
import 'package:test_flutter_app/services/fireAuth.dart';
import 'package:test_flutter_app/widgets/propertyCard.dart';

class PropertyCards extends StatefulWidget {
  int numberOfCards;
  PropertyCards({super.key, this.numberOfCards = 0});

  @override
  _PropertyCardsState createState() => _PropertyCardsState();
}

class _PropertyCardsState extends State<PropertyCards> {
  List<Property> properties = [];

  @override
  Widget build(BuildContext context) {
    if(properties.isEmpty){
      getPropertyData(FireAuth.getCurrentUser()!.uid);
    }
    log("Properties retrieved: ${properties.length.toString()}");

    return Column(children: getPropertyCards(widget.numberOfCards));
  }

  List<PropertyCard> getPropertyCards(int numberOfCards) {
    List<PropertyCard> propertyCards = [];
    for (var i = 0; i < numberOfCards; i++) {
      if(properties.isEmpty){
        log("properties is not empty");
        propertyCards.add(PropertyCard());
      }else{
        if(i >= properties.length){break;}
        propertyCards.add(PropertyCard(propertyData: properties[i],));
      }
    }

    return propertyCards;
  }

  void getPropertyData(String userId) async {
    List<Property> propertiesToReturn = [];
    await DbService.getOwnedProperties(userId)
        .then((value) => value!.forEach((element) {
              propertiesToReturn.add(element.data());
            }));
    setState(() {
      properties = propertiesToReturn;
    });
  }
}

class TemporaryHelper {
  static List<PropertyCard> getPropertyCards(int numberOfCards) {
    List<PropertyCard> propertyCards = [];
    for (var i = 0; i < numberOfCards; i++) {
      propertyCards.add(PropertyCard());
    }

    return propertyCards;
  }
}
