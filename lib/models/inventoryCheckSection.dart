import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_flutter_app/services/dbService.dart';

class InventoryCheckSection {
  String? id;
  String? inventoryCheckId;
  String? title;
  bool? essentialSection;
  int? sectionPosition;

  InventoryCheckSection(
      {this.id,
      this.inventoryCheckId,
      this.title,
      this.essentialSection,
      this.sectionPosition});

  factory InventoryCheckSection.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return InventoryCheckSection(
      id: data?['id'],
      inventoryCheckId: data?['inventoryCheckId'],
      title: data?['title'],
      essentialSection: data?['essentialSection'],
      sectionPosition: data?['sectionPosition'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (inventoryCheckId != null) "inventoryCheckId": inventoryCheckId,
      if (title != null) "title": title,
      if (essentialSection != null) "essentialSection": essentialSection,
      if (sectionPosition != null) "sectionPosition": sectionPosition,
    };
  }

  static CollectionReference<InventoryCheckSection> getDocumentReference() {
    FirebaseFirestore db = DbService.getDbInstance();

    final CollectionReference<InventoryCheckSection> ref =
        db.collection("inventory_check_sections").withConverter(
              fromFirestore: InventoryCheckSection.fromFirestore,
              toFirestore: (InventoryCheckSection inventoryCheckSections, _) =>
                  inventoryCheckSections.toFirestore(),
            );

    return ref;
  }
}
