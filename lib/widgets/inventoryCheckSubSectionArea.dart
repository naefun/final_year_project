import 'package:flutter/material.dart';
import 'package:test_flutter_app/models/inventoryCheckInputArea.dart';

class InventoryCheckSubSectionArea extends StatefulWidget {
  InventoryCheckSubSectionArea({Key? key, required this.inventoryCheckInputArea}) : super(key: key);

  InventoryCheckInputArea inventoryCheckInputArea;

  @override
  _InventoryCheckSubSectionAreaState createState() =>
      _InventoryCheckSubSectionAreaState();
}

class _InventoryCheckSubSectionAreaState
    extends State<InventoryCheckSubSectionArea> {

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Card(
          elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: ClipPath(
        clipper: ShapeBorderClipper(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            color: Color(0xFFCDCDCD),
            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.inventoryCheckInputArea.title!=null?widget.inventoryCheckInputArea.title!:""),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.comment),
                      iconSize: 20,
                      padding: EdgeInsets.all(0),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.add_comment),
                      iconSize: 20,
                      padding: EdgeInsets.all(0),
                    )
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Text(widget.inventoryCheckInputArea.details!=null?widget.inventoryCheckInputArea.details!:""),
          )
        ]),
      ),
    ));
  }
}
