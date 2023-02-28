import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_flutter_app/models/comment.dart';
import 'package:test_flutter_app/services/dbService.dart';
import 'package:test_flutter_app/services/fireAuth.dart';
import 'package:test_flutter_app/widgets/singleComment.dart';
import 'package:uuid/uuid.dart';

class SubsectionCommentSection extends StatefulWidget {
  SubsectionCommentSection({Key? key, required this.inventoryCheckSubsectionId, required this.inventoryCheckId})
      : super(key: key);

  String inventoryCheckSubsectionId;
  String inventoryCheckId;

  @override
  _SubsectionCommentSectionState createState() =>
      _SubsectionCommentSectionState();
}

class _SubsectionCommentSectionState extends State<SubsectionCommentSection> {
  List<Comment>? comments;
  List<SingleComment>? commentWidgets;

  final _focusCommentInput = FocusNode();
  final _controllerCommentInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (comments == null) getComments();
    if (comments != null && comments!.isNotEmpty && commentWidgets == null)
      createCommentWidgets();

    return Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        color: Color(0xFFFCFCFC),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFFBBD8BA)),
                ),
                Text("Carlos Bento - Tenant")
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFFAAD0E5)),
                ),
                Text("John Crifton - Landlord")
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Container(
              height: 200,
              child: commentWidgets != null && commentWidgets!.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: commentWidgets!.length,
                      itemBuilder: (BuildContext context, int index) =>
                          commentWidgets![index],
                    )
                  : SizedBox(),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Flexible(
                    child: TextField(
                        controller: _controllerCommentInput,
                        focusNode: _focusCommentInput,
                        onTapOutside: (event) => _focusCommentInput.unfocus(),
                        decoration: InputDecoration(
                            fillColor: Color(0xFFE6E6E6),
                            filled: true,
                            isDense: true,
                            contentPadding: EdgeInsets.all(8),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide.none)))),
                IconButton(
                  onPressed: () => submitComment(),
                  icon: Icon(Icons.send),
                )
              ],
            )
          ],
        ));
  }

  void submitComment() async {
    String message = _controllerCommentInput.text;

    Comment newComment = Comment(
        id: Uuid().v4(),
        userId: FireAuth.getCurrentUser()!.uid,
        inventoryCheckId: widget.inventoryCheckId,
        commentContent: message,
        timestamp: DateTime.now().toString(),
        subsectionId: widget.inventoryCheckSubsectionId);

    List<Comment> tempComments = comments!;
    tempComments.add(newComment);

    await DbService.createComment(newComment);

    await clearCommentWidgets();
    setState(() {
      comments = tempComments;
      _controllerCommentInput.text = "";
    });
  }

  void createCommentWidgets() {
    List<SingleComment> tempCommentWidgets =
        commentWidgets != null ? commentWidgets! : [];

    for (Comment element in comments!) {
      tempCommentWidgets.add(SingleComment(comment: element));
    }

    setState(() {
      commentWidgets = tempCommentWidgets;
    });
  }

  void getComments() async {
    List<QueryDocumentSnapshot<Comment>>? commentDocuments;
    List<Comment> tempComments = [];

    await DbService.getComments(widget.inventoryCheckSubsectionId)
        .then((value) => commentDocuments = value);

    if (commentDocuments != null && commentDocuments!.isNotEmpty) {
      for (QueryDocumentSnapshot<Comment> element in commentDocuments!) {
        tempComments.add(element.data());
      }
    }

    tempComments.sort((a, b) => DateTime.parse(a.timestamp!).compareTo(DateTime.parse(b.timestamp!)));

    setState(() {
      comments = tempComments;
    });
  }

  Future<void> clearCommentWidgets() async {
    setState(() {
      commentWidgets = null;
    });
  }
}
