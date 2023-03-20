import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_flutter_app/models/comment.dart';
import 'package:test_flutter_app/models/inventoryCheckInputArea.dart';
import 'package:test_flutter_app/models/tenancy.dart';
import 'package:test_flutter_app/services/dbService.dart';
import 'package:test_flutter_app/services/fireAuth.dart';
import 'package:test_flutter_app/widgets/subsectionCommentSection.dart';

class InventoryCheckSubSectionArea extends StatefulWidget {
  InventoryCheckSubSectionArea(
      {Key? key, required this.inventoryCheckInputArea, this.inventoryCheckTenants})
      : super(key: key);

  InventoryCheckInputArea inventoryCheckInputArea;
  List<Tenancy>? inventoryCheckTenants;

  @override
  _InventoryCheckSubSectionAreaState createState() =>
      _InventoryCheckSubSectionAreaState();
}

class _InventoryCheckSubSectionAreaState
    extends State<InventoryCheckSubSectionArea> {
  bool showComments = false;
  bool? newCommentsAvailable;
  int? numberOfComments;
  List<Comment>? subsectionComments;

  @override
  Widget build(BuildContext context) {
    if (subsectionComments == null) getSubsectionComments();
    if (subsectionComments != null && numberOfComments == null)
      setNumberOfComments();
    if (subsectionComments != null && newCommentsAvailable == null)
      setNewCommentsAvailable();

    return Container(
        child: Card(
      color: Color(0xFFEDEDED),
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
                Text(widget.inventoryCheckInputArea.title != null
                    ? widget.inventoryCheckInputArea.title!
                    : ""),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(numberOfComments != null
                        ? numberOfComments.toString()
                        : "0"),
                    IconButton(
                      onPressed: () {
                        toggleCommentsVisibility();
                      },
                      icon: Icon(
                        Icons.comment,
                        color: newCommentsAvailable != null &&
                                newCommentsAvailable == true
                            ? Color.fromARGB(255, 205, 83, 83)
                            : Color(0xFF636363),
                      ),
                      iconSize: 20,
                      padding: EdgeInsets.all(0),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Text(widget.inventoryCheckInputArea.details != null
                ? widget.inventoryCheckInputArea.details!
                : ""),
          ),
          showComments == false
              ? SizedBox()
              : SubsectionCommentSection(
                  inventoryCheckSubsectionId:
                      widget.inventoryCheckInputArea.id!,
                  inventoryCheckId:
                      widget.inventoryCheckInputArea.inventoryCheckId!,
                  inventoryCheckTenants: widget.inventoryCheckTenants,
                ),
        ]),
      ),
    ));
  }

  void toggleCommentsVisibility() {
    setState(() {
      showComments = !showComments;
    });
  }

  void setNumberOfComments() async {
    setState(() {
      numberOfComments =
          subsectionComments != null ? subsectionComments!.length : 0;
    });
  }

  void getSubsectionComments() async {
    List<QueryDocumentSnapshot<Comment>>? subsectionCommentsQueryDocSnap;
    List<Comment> tempSubsectionComments = [];

    await DbService.getCommentsForSubsection(widget.inventoryCheckInputArea.id!)
        .then((value) {
      subsectionCommentsQueryDocSnap = value ?? [];
    });

    if (subsectionCommentsQueryDocSnap != null) {
      for (QueryDocumentSnapshot<Comment> element
          in subsectionCommentsQueryDocSnap!) {
        tempSubsectionComments.add(element.data());
      }
    }

    setState(() {
      subsectionComments = tempSubsectionComments;
    });
  }

  void setNewCommentsAvailable() async {
    bool tempNewCommentsAvailable = false;

    for (Comment element in subsectionComments!) {
      if (element.seenByUsers!=null && !element.seenByUsers!.contains(FireAuth.getCurrentUser()!.uid)) {
        tempNewCommentsAvailable = true;
        break;
      }
    }

    setState(() {
      newCommentsAvailable = tempNewCommentsAvailable;
    });
  }
}
