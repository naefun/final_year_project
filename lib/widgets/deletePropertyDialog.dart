import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:test_flutter_app/models/inventoryCheckRequest.dart';
import 'package:test_flutter_app/models/property.dart';
import 'package:test_flutter_app/pages/homePage.dart';
import 'package:test_flutter_app/pages/loginPage.dart';
import 'package:test_flutter_app/services/dbService.dart';
import 'package:test_flutter_app/services/validator.dart';
import 'package:test_flutter_app/utilities/pageNavigator.dart';
import 'package:test_flutter_app/utilities/themeColors.dart';
import 'package:uuid/uuid.dart';

class DeletePropertyDialog extends StatefulWidget {
  DeletePropertyDialog({
    super.key,
    required this.property,
  });

  Property property;

  @override
  State<DeletePropertyDialog> createState() => _DeletePropertyDialogState();
}

class _DeletePropertyDialogState extends State<DeletePropertyDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
                color: ThemeColors.mainRed,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4), topRight: Radius.circular(4))),
            width: double.infinity,
            child: const Text(
              'Delete property',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          Container(
            padding: EdgeInsets.all(12),
            child: Text(
                "Are you sure that you would like to delete this property? This cannot be reverted."),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, elevation: 4),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: ThemeColors.mainRed),
                  ),
                ),
                const SizedBox(width: 15),
                ElevatedButton(
                  onPressed: () async {
                    await DbService.deleteProperty(widget.property.propertyId!)
                        .then((value) => PageNavigator.navigateToHomePage(context));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeColors.mainRed, elevation: 4),
                  child: const Text('Delete'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
