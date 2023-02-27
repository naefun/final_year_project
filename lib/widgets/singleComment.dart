import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:test_flutter_app/models/comment.dart';
import 'package:test_flutter_app/services/dbService.dart';

import '../models/user.dart';

class SingleComment extends StatefulWidget {
  SingleComment({Key? key, required this.comment}) : super(key: key);

  Comment comment;

  @override
  _SingleCommentState createState() => _SingleCommentState();
}

class _SingleCommentState extends State<SingleComment> {
  User? commentAuthor;
  DateTime? timestamp;

  @override
  Widget build(BuildContext context) {
    if (commentAuthor == null) getCommentAuthor();
    if(timestamp==null) setTimestamp();

    return Column(
      crossAxisAlignment: commentAuthor != null && commentAuthor!.userType! == 2
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment:
              commentAuthor != null && commentAuthor!.userType! == 2
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.end,
          children: [
            Text(
              timestamp!=null?"${timestamp!.day}/${timestamp!.month}/${timestamp!.year} - ${timestamp!.hour}:${timestamp!.minute}":"",
              style: TextStyle(fontSize: 12),
            )
          ],
        ),
        SizedBox(
          height: 6,
        ),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: commentAuthor != null && commentAuthor!.userType! == 2
                  ? Color(0xFFBBD8BA)
                  : Color(0xFFAAD0E5)),
          child: Text(widget.comment.commentContent!),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  void getCommentAuthor() async {
    User? user;

    await DbService.getUserDocument(widget.comment.userId!)
        .then((value) => user = value);

    setState(() {
      commentAuthor = user;
    });

    log(user!.firstName!);
  }
  
  void setTimestamp() {
    DateTime? tempTimestamp;

    tempTimestamp = DateTime.tryParse(widget.comment.timestamp!);

    if(tempTimestamp!=null){
      setState(() {
        timestamp=tempTimestamp;
      });
    }
  }
}
