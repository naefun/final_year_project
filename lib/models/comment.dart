import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_flutter_app/services/dbService.dart';

class Comment {
  final String? id;
  final String? userId;
  final String? inventoryCheckId;
  final String? commentContent;
  final String? timestamp;
  final String? subsectionId;

  Comment({this.id, this.userId, this.inventoryCheckId, this.commentContent, this.timestamp, this.subsectionId});

  factory Comment.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Comment(
      id: data?['id'],
      userId: data?['userId'],
      inventoryCheckId: data?['inventoryCheckId'],
      commentContent: data?['commentContent'],
      timestamp: data?['timestamp'],
      subsectionId: data?['subsectionId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (userId != null) "userId": userId,
      if (inventoryCheckId != null) "inventoryCheckId": inventoryCheckId,
      if (commentContent != null) "commentContent": commentContent,
      if (timestamp != null) "timestamp": timestamp,
      if (subsectionId != null) "subsectionId": subsectionId,
    };
  }

  static CollectionReference<Comment> getDocumentReference(){
    FirebaseFirestore db = DbService.getDbInstance();

    final CollectionReference<Comment> ref = db.collection("comments").withConverter(
      fromFirestore: Comment.fromFirestore,
      toFirestore: (Comment comment, _) => comment.toFirestore(),
    );

    return ref;
  }
}
