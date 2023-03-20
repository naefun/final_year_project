import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_flutter_app/models/comment.dart';
import 'package:test_flutter_app/models/user.dart';
import 'package:test_flutter_app/services/dbService.dart';
import 'package:test_flutter_app/services/fireAuth.dart';

class CommentUtilities {
  static Future<bool> inventoryCheckHasNewComments(
      String inventoryCheckId) async {
    List<QueryDocumentSnapshot<Comment>>? comments;
    await DbService.getCommentsForInventoryCheck(inventoryCheckId)
        .then((value) => comments = value);

    bool newCommentsExist = false;

    if (comments != null) {
      for (QueryDocumentSnapshot<Comment> element in comments!) {
        if (element.data().seenByUsers!=null && !element.data().seenByUsers!.contains(FireAuth.getCurrentUser()!.uid)) {
          newCommentsExist = true;
          break;
        }
      }
    }

    

    return newCommentsExist;
  }
}
