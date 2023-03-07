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
    User? currentUser;
    await DbService.getCommentsForInventoryCheck(inventoryCheckId)
        .then((value) => comments = value);
    await DbService.getUserDocument(FireAuth.getCurrentUser()!.uid)
        .then((value) => currentUser = value);

    bool newCommentsExist = false;

    if (comments != null && currentUser != null) {
      for (QueryDocumentSnapshot<Comment> element in comments!) {
        if ((currentUser!.userType == 1 &&
                element.data().seenByLandlord == false) ||
            (currentUser!.userType == 2 &&
                element.data().seenByTenant == false)) {
          newCommentsExist = true;
          break;
        }
      }
    }

    return newCommentsExist;
  }
}
