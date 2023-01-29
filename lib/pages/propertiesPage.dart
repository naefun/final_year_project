import 'package:flutter/material.dart';
import 'package:test_flutter_app/widgets/propertyCard.dart';
import 'package:test_flutter_app/widgets/propertyCards.dart';

class PropertiesPage extends StatelessWidget {
  const PropertiesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<PropertyCard> propertyCards = TemporaryHelper.getPropertyCards(50);

    return Container(
      color: Colors.white,
      child: Column(
      children: [
        Expanded(
          child: ListView.builder(
          itemCount: propertyCards.length,
          itemBuilder: (context, index) => propertyCards.elementAt(index)
        ))
      ],
    ),
    );
    
  }
}
