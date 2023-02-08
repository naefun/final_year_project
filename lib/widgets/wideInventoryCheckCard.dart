import 'package:flutter/material.dart';
import 'package:test_flutter_app/utilities/global_values.dart';

class WideInventoryCheckCard extends StatefulWidget {
  const WideInventoryCheckCard({
    super.key,
  });

  @override
  State<WideInventoryCheckCard> createState() => _WideInventoryCheckCardState();
}

class _WideInventoryCheckCardState extends State<WideInventoryCheckCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6))),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 5,
          child: Container(
            decoration: BoxDecoration(
                border: Border(
                    left: BorderSide(color: Color(0xFF579A56), width: 7))),
            padding: EdgeInsets.fromLTRB(8, 15, 8, 15),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image(
                          image: AssetImage(IconPaths.commentIconPath.path),
                          height: 28,
                          width: 28,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Column(
                          children: [
                            Text("0", style: TextStyle(fontSize: 18)),
                            Text(
                              " comments",
                              style: TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image(
                          image: AssetImage(IconPaths.checkInIconPath.path),
                          height: 28,
                          width: 28,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Column(
                          children: [
                            Text("5", style: TextStyle(fontSize: 18)),
                            Text(
                              " days ago",
                              style: TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image(
                          image: AssetImage(IconPaths.clerkIconPath.path),
                          height: 28,
                          width: 28,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                            child: Text(
                          "James Connor",
                          style: TextStyle(fontSize: 12),
                          overflow: TextOverflow.visible,
                        ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
