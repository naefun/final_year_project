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
  List<Property>? propertiesArg;
  PropertyCards({super.key, this.numberOfCards = 0, this.propertiesArg});

  @override
  _PropertyCardsState createState() => _PropertyCardsState();
}

class _PropertyCardsState extends State<PropertyCards> {
  List<Property> properties = [];

  @override
  Widget build(BuildContext context) {
    if(widget.propertiesArg!=null){
      properties=widget.propertiesArg!;
    } else if(properties.isEmpty){
      getPropertyData(FireAuth.getCurrentUser()!.uid);
    }
    log("Properties retrieved: ${properties.length.toString()}");

    return Column(children: properties.isNotEmpty ? PropertyCardHelper.getPropertyCards(widget.numberOfCards == 0 ? properties.length : widget.numberOfCards, properties)!:[Text("data")]);
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

class PropertyCardHelper {
  // static List<PropertyCard> getPropertyCards(int numberOfCards) {
  //   List<PropertyCard> propertyCards = [];
  //   for (var i = 0; i < numberOfCards; i++) {
  //     propertyCards.add(PropertyCard());
  //   }

  //   return propertyCards;
  // }

    static List<PropertyCard>? getPropertyCards(int numberOfCards, List<Property> propertyData) {
    if(propertyData.isEmpty){
      return null;
    }
    List<PropertyCard> propertyCards = [];
    for (var i = 0; i < numberOfCards; i++) {
      if(propertyData.isEmpty){
        log("properties is empty");
        propertyCards.add(PropertyCard());
      }else{
        if(i >= propertyData.length){break;}
        propertyCards.add(PropertyCard(propertyData: propertyData[i],));
      }
    }

    return propertyCards;
  }
}
