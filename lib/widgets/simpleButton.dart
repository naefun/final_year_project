import 'dart:developer';

import 'package:flutter/material.dart';

class SimpleButton extends StatelessWidget {
const SimpleButton({super.key, required this.onPressedFunction, required this.buttonLabel });

final Function onPressedFunction;
final String buttonLabel;

  @override
  Widget build(BuildContext context){
    return  TextButton(
              onPressed: () => {log("View more pressed"), onPressedFunction()},
              style: TextButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  foregroundColor: Colors.white),
              child: Text(
                buttonLabel,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
  }
}