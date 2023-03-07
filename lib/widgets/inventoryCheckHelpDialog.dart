import 'package:flutter/material.dart';
import 'package:test_flutter_app/utilities/global_values.dart';
import 'package:test_flutter_app/utilities/themeColors.dart';

class InventoryCheckHelpDialog extends StatefulWidget {
  const InventoryCheckHelpDialog({Key? key}) : super(key: key);

  @override
  _InventoryCheckHelpDialogState createState() =>
      _InventoryCheckHelpDialogState();
}

class _InventoryCheckHelpDialogState extends State<InventoryCheckHelpDialog> {
  final double indicatorSize = 15;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(20),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: ThemeColors.mainBlue,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4))),
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Text(
                    "Inventory check key",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: indicatorSize,
                        width: indicatorSize,
                        decoration: BoxDecoration(
                            color: ThemeColors.mainGreen,
                            borderRadius: BorderRadius.circular(100)),
                      ),
                      Text(" = Completed inventory check (check-in)"),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        height: indicatorSize,
                        width: indicatorSize,
                        decoration: BoxDecoration(
                            color: ThemeColors.mainRed,
                            borderRadius: BorderRadius.circular(100)),
                      ),
                      Text(" = Completed inventory check (check-out)"),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        height: indicatorSize,
                        width: indicatorSize,
                        decoration: BoxDecoration(
                            color: ThemeColors.mainOrange,
                            borderRadius: BorderRadius.circular(100)),
                      ),
                      Text(" = Inventory check request"),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Image(
                        image: AssetImage(IconPaths.checkInIconPath.path),
                        height: 28,
                        width: 28,
                      ),
                      Text(" = Check-in"),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Image(
                        image: AssetImage(IconPaths.checkOutIconPath.path),
                        height: 28,
                        width: 28,
                      ),
                      Text(" = Check-out"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
