import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_flutter_app/services/dbService.dart';

class InventoryCheckInputArea {
  String? id;
  String? inventoryCheckId;
  String? sectionId;
  String? title;
  String? details;
  bool? inputComplete;
  int? inputPosition;

  InventoryCheckInputArea(
      {this.id,
      this.inventoryCheckId,
      this.sectionId,
      this.title,
      this.details,
      this.inputComplete,
      this.inputPosition});

  factory InventoryCheckInputArea.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return InventoryCheckInputArea(
      id: data?['id'],
      inventoryCheckId: data?['inventoryCheckId'],
      sectionId: data?['sectionId'],
      title: data?['title'],
      details: data?['title'],
      inputComplete: data?['inputComplete'],
      inputPosition: data?['inputPosition'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (inventoryCheckId != null) "inventoryCheckId": inventoryCheckId,
      if (sectionId != null) "sectionId": sectionId,
      if (title != null) "title": title,
      if (details != null) "details": details,
      if (inputComplete != null) "inputComplete": inputComplete,
      if (inputPosition != null) "inputPosition": inputPosition,
    };
  }

  static CollectionReference<InventoryCheckInputArea> getDocumentReference() {
    FirebaseFirestore db = DbService.getDbInstance();

    final CollectionReference<InventoryCheckInputArea> ref =
        db.collection("inventory_check_input_areas").withConverter(
              fromFirestore: InventoryCheckInputArea.fromFirestore,
              toFirestore:
                  (InventoryCheckInputArea inventoryCheckInputAreas, _) =>
                      inventoryCheckInputAreas.toFirestore(),
            );

    return ref;
  }
}
