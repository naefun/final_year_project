import 'dart:developer';

import 'package:flutter/material.dart';

class SimpleButton extends StatelessWidget {
SimpleButton({super.key, required this.onPressedFunction, required this.buttonLabel, this.secondaryButton });

final Function onPressedFunction;
final String buttonLabel;
bool? secondaryButton;
Color primaryColor = Colors.lightBlue;
Color secondaryColor = Colors.white;

  @override
  Widget build(BuildContext context){
    return  TextButton(
              onPressed: () => {onPressedFunction()},
              style: TextButton.styleFrom(
                  side: secondaryButton!=null&&secondaryButton==true?BorderSide(color: primaryColor, strokeAlign: BorderSide.strokeAlignInside, width: 2):null,
                  backgroundColor: secondaryButton!=null&&secondaryButton==true?secondaryColor:primaryColor,
                  foregroundColor: secondaryButton!=null&&secondaryButton==true?primaryColor:secondaryColor),
              child: Text(
                buttonLabel,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
  }
}