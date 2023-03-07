import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:test_flutter_app/widgets/inventoryCheckHelpDialog.dart';

class InventoryCheckHelp extends StatefulWidget {
  const InventoryCheckHelp({Key? key}) : super(key: key);

  @override
  _InventoryCheckHelpState createState() => _InventoryCheckHelpState();
}

class _InventoryCheckHelpState extends State<InventoryCheckHelp> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => InventoryCheckHelpDialog()),
      icon: Icon(Icons.info_outline),
      iconSize: 17,
    );
  }
}
