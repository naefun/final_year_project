import 'package:flutter/material.dart';
import 'package:test_flutter_app/widgets/propertyCard.dart';

class PropertyCards extends StatelessWidget {
  PropertyCards({
    super.key,
    this.numberOfCards = 0
  });

  int numberOfCards;

  @override
  Widget build(BuildContext context){
    return Column(
      children: getPropertyCards(numberOfCards)
    );
  }

  List<PropertyCard> getPropertyCards(int numberOfCards){
    return TemporaryHelper.getPropertyCards(numberOfCards);
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