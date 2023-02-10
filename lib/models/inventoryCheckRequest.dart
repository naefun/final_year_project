import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_flutter_app/services/dbService.dart';

class InventoryCheckRequest {
  final int? type;
  final String? clerkEmail;
  final String? checkDate;
  final String? propertyId;

  InventoryCheckRequest({this.type, this.clerkEmail, this.checkDate, this.propertyId});

  factory InventoryCheckRequest.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return InventoryCheckRequest(
      type: data?['type'],
      clerkEmail: data?['clerkEmail'],
      checkDate: data?['checkDate'],
      propertyId: data?['propertyId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (type != null) "type": type,
      if (clerkEmail != null) "clerkEmail": clerkEmail,
      if (checkDate != null) "checkDate": checkDate,
      if (propertyId != null) "propertyId": propertyId,
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
        inventoryCheckRequest.type != null &&
        inventoryCheckRequest.clerkEmail != null &&
        inventoryCheckRequest.clerkEmail!.isNotEmpty &&
        inventoryCheckRequest.checkDate != null &&
        inventoryCheckRequest.checkDate!.isNotEmpty &&
        inventoryCheckRequest.propertyId != null &&
        inventoryCheckRequest.propertyId!.isNotEmpty;
  }
}
