import 'package:flutter/material.dart';

class SnackbarUtility {
  static void showSnackbar(BuildContext context, String message) {
    Future.delayed(
        const Duration(),
        () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                message,
                textAlign: TextAlign.center,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.fromLTRB(40, 0, 40, 40),
            )));
  }
}
