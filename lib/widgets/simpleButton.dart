import 'dart:developer';

import 'package:flutter/material.dart';

class SimpleButton extends StatelessWidget {
const SimpleButton({super.key, required this.onPressedFunction });

final Function onPressedFunction;

  @override
  Widget build(BuildContext context){
    return  TextButton(
              child: const Text(
                "View more",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () => {log("View more pressed"), onPressedFunction()},
              style: TextButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  foregroundColor: Colors.white),
            );
  }
}