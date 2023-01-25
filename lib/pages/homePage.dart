import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:test_flutter_app/widgets/propertyCards.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text("Properties", style: TextStyle(fontSize: 20),),
        PropertyCards(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              child: const Text("View more", style: TextStyle(fontWeight: FontWeight.bold),),
              onPressed: () => {
                log("View more pressed")
                },
              style: TextButton.styleFrom(backgroundColor: Colors.lightBlue, foregroundColor: Colors.white),
            )
          ],
        )
      ],
    );
  }
}
