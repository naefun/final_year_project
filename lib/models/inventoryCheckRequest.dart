import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_flutter_app/models/abstractInventoryCheck.dart';
import 'package:test_flutter_app/services/dbService.dart';

class InventoryCheckRequest extends AbstractInventoryCheck{
  final String? id;
  final int? type;
  final String? clerkEmail;
  final String? propertyId;
  final bool? complete;
  @override
  String? date;

  InventoryCheckRequest({this.id, this.type, this.clerkEmail, this.date, this.propertyId, this.complete});

  factory InventoryCheckRequest.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return InventoryCheckRequest(
      id: data?['id'],
      type: data?['type'],
      clerkEmail: data?['clerkEmail'],
      date: data?['checkDate'],
      propertyId: data?['propertyId'],
      complete: data?['complete'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (type != null) "type": type,
      if (clerkEmail != null) "clerkEmail": clerkEmail,
      if (date != null) "checkDate": date,
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
        inventoryCheckRequest.date != null &&
        inventoryCheckRequest.date!.isNotEmpty &&
        inventoryCheckRequest.propertyId != null &&
        inventoryCheckRequest.propertyId!.isNotEmpty &&
        inventoryCheckRequest.complete != null;
  }
}
