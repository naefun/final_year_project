import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:test_flutter_app/models/inventoryCheck.dart';
import 'package:test_flutter_app/utilities/date_utilities.dart';
import 'package:test_flutter_app/utilities/global_values.dart';

class InventoryCheckCard extends StatefulWidget {
  InventoryCheckCard({Key? key, this.inventoryCheck}) : super(key: key);

  InventoryCheck? inventoryCheck;

  @override
  _InventoryCheckCardState createState() => _InventoryCheckCardState();
}

class _InventoryCheckCardState extends State<InventoryCheckCard> {
  String? propertyAddress;
  int? commentsSize;
  int? daysSinceCheck;
  String? clerkName;
  bool? checkIn;

  @override
  Widget build(BuildContext context) {
    if(widget.inventoryCheck != null){
      propertyAddress = widget.inventoryCheck!.propertyAddress;
      clerkName = widget.inventoryCheck!.clerkName;
      commentsSize = widget.inventoryCheck!.comments!=null?widget.inventoryCheck!.comments!.length:null;
      checkIn = widget.inventoryCheck!.checkIn;
      if(widget.inventoryCheck!.dateCompleted != null && DateUtilities.validDate(widget.inventoryCheck!.dateCompleted!)){
        int? dateCheck = DateUtilities.dateStringToDaysRemaining(DateTime.now(), widget.inventoryCheck!.dateCompleted!);
        daysSinceCheck = dateCheck!=null?dateCheck*-1:null;
        if(daysSinceCheck!=null)log(daysSinceCheck.toString());
      }
    }

    return SizedBox(
      width: 170,
      height: 20,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          //set border radius more than 50% of height and width to make circle
        ),
        child: ClipPath(
          clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4))),
          child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: checkIn != null && checkIn! == true ? Color(0xFF579A56):Color(0xFFE76E6E), width: 7))),
              child: Column(
                children: [
                  Text(
                    propertyAddress!=null?propertyAddress!:"15 Kelsall croft, Birmingham",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Image(
                        image: AssetImage(
                            commentsSize!=null&&commentsSize! > 0? IconPaths.commentWithNotificationIconPath.path: IconPaths.commentIconPath.path),
                            width: 28,
                            height: 28,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            commentsSize!=null?commentsSize!.toString():"0",
                            style: TextStyle(fontSize: 25),
                          ),
                          Text(commentsSize!=null&&commentsSize!=1?" comments":" comment")
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      ImageIcon(
                        AssetImage(
                            checkIn!=null && checkIn! ==true? IconPaths.checkInIconPath.path : IconPaths.checkOutIconPath.path),
                            size: 28,
                        color: Color(0xFF636363),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(daysSinceCheck!=null?daysSinceCheck!.toString():"5", style: TextStyle(fontSize: 25)),
                          Text((daysSinceCheck!=null&&daysSinceCheck!=1)?" days ago":" day ago"),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ImageIcon(
                        AssetImage(IconPaths.clerkIconPath.path),
                            size: 28,
                        color: Color(0xFF636363),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(clerkName!=null?clerkName!:" James Connor")
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }
}
