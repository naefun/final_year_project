import 'package:flutter/material.dart';
import 'package:test_flutter_app/widgets/propertyCard.dart';

class PropertyCards extends StatelessWidget {
  PropertyCards({ Key? key }) : super(key: key);

  List<PropertyCard> propertyCards = TemporaryHelper.getPropertyCards(2);

  @override
  Widget build(BuildContext context){
    return Column(
      children: propertyCards
    );
  }
}

class TemporaryHelper{
  static List<PropertyCard> getPropertyCards(int numberOfCards){
    List<PropertyCard> propertyCards = [];
    for (var i = 0; i < numberOfCards; i++) {
      propertyCards.add(const PropertyCard());
    }

    return propertyCards;
  }
}