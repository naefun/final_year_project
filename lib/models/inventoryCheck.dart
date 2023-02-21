import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_flutter_app/services/dbService.dart';

class InventoryCheck {
  String? id;
  String? propertyId;
  bool? complete;
  int? type;
  String? clerkEmail;
  String? checkCompletedDate;

  InventoryCheck(
      {this.id,
      this.propertyId,
      this.complete,
      this.type,
      this.clerkEmail,
      this.checkCompletedDate});

  factory InventoryCheck.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return InventoryCheck(
      id: data?['id'],
      propertyId: data?['propertyId'],
      complete: data?['complete'],
      type: data?['type'],
      clerkEmail: data?['clerkEmail'],
      checkCompletedDate: data?['checkCompletedDate'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (propertyId != null) "propertyId": propertyId,
      if (complete != null) "complete": complete,
      if (type != null) "type": type,
      if (clerkEmail != null) "clerkEmail": clerkEmail,
      if (checkCompletedDate != null) "checkCompletedDate": checkCompletedDate,
    };
  }

  static CollectionReference<InventoryCheck> getDocumentReference() {
    FirebaseFirestore db = DbService.getDbInstance();

    final CollectionReference<InventoryCheck> ref =
        db.collection("inventory_checks").withConverter(
              fromFirestore: InventoryCheck.fromFirestore,
              toFirestore:
                  (InventoryCheck inventoryCheck, _) =>
                      inventoryCheck.toFirestore(),
            );

    return ref;
  }
}
