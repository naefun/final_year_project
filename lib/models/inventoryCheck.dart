import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_flutter_app/models/abstractInventoryCheck.dart';
import 'package:test_flutter_app/services/dbService.dart';


class InventoryCheck extends AbstractInventoryCheck{
  String? id;
  String? propertyId;
  bool? complete;
  int? type;
  String? clerkEmail;
  List<String>? tenancyIds;
  @override
  String? date;

  InventoryCheck(
      {this.id,
      this.propertyId,
      this.complete,
      this.type,
      this.clerkEmail,
      this.date,
      this.tenancyIds});

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
      date: data?['checkCompletedDate'],
      tenancyIds: data?['tenancyIds']==null?null:data!['tenancyIds'].cast<String>(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (propertyId != null) "propertyId": propertyId,
      if (complete != null) "complete": complete,
      if (type != null) "type": type,
      if (clerkEmail != null) "clerkEmail": clerkEmail,
      if (date != null) "checkCompletedDate": date,
      if (tenancyIds != null) "tenancyIds": tenancyIds,
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
