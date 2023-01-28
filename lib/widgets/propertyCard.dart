import 'dart:developer';

import 'package:flutter/material.dart';

class PropertyCard extends StatelessWidget {
  const PropertyCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log("created propertycard");
    return Column(
      children: [
        Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Container(
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Image(
                  image: AssetImage('assets/placeholderImages/house.jpg'),
                  height: 100,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'data',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        'data',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                )
              ]),
            ))
      ],
    );
  }
}
