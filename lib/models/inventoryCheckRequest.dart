import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_flutter_app/services/dbService.dart';

class InventoryCheckRequest {
  final String? id;
  final int? type;
  final String? clerkEmail;
  final String? checkDate;
  final String? propertyId;
  final bool? complete;

  InventoryCheckRequest({this.id, this.type, this.clerkEmail, this.checkDate, this.propertyId, this.complete});

  factory InventoryCheckRequest.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return InventoryCheckRequest(
      id: data?['id'],
      type: data?['type'],
      clerkEmail: data?['clerkEmail'],
      checkDate: data?['checkDate'],
      propertyId: data?['propertyId'],
      complete: data?['complete'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (type != null) "type": type,
      if (clerkEmail != null) "clerkEmail": clerkEmail,
      if (checkDate != null) "checkDate": checkDate,
      if (propertyId != null) "propertyId": propertyId,
      if (complete != null) "complete": complete,
    };
  }

  static CollectionReference<InventoryCheckRequest> getDocumentReference(){
    FirebaseFirestore db = DbService.getDbInstance();

    final CollectionReference<InventoryCheckRequest> ref = db.collection("inventoryCheckRequests").withConverter(
      fromFirestore: InventoryCheckRequest.fromFirestore,
      toFirestore: (InventoryCheckRequest inventoryCheckRequest, _) => inventoryCheckRequest.toFirestore(),
    );

    return ref;
  }

  static bool fieldsArentEmpty(InventoryCheckRequest inventoryCheckRequest) {
        return
        inventoryCheckRequest.id != null &&
        inventoryCheckRequest.type != null &&
        inventoryCheckRequest.clerkEmail != null &&
        inventoryCheckRequest.clerkEmail!.isNotEmpty &&
        inventoryCheckRequest.checkDate != null &&
        inventoryCheckRequest.checkDate!.isNotEmpty &&
        inventoryCheckRequest.propertyId != null &&
        inventoryCheckRequest.propertyId!.isNotEmpty &&
        inventoryCheckRequest.complete != null;
  }
}
