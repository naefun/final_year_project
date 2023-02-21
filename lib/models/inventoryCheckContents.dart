import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_flutter_app/services/dbService.dart';

class InventoryCheckContents {
  String? id;
  String? propertyId;
  String? dateCompleted;
  List<Map>? essentialSections;
  List<Map>? optionalSections;

  InventoryCheckContents(
      {this.id,
      this.propertyId,
      this.dateCompleted,
      this.essentialSections,
      this.optionalSections});

  factory InventoryCheckContents.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return InventoryCheckContents(
      id: data?['id'],
      propertyId: data?['propertyId'],
      dateCompleted: data?['dateCompleted'],
      essentialSections: data?['essentialSections'],
      optionalSections: data?['optionalSections'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (propertyId != null) "propertyId": propertyId,
      if (dateCompleted != null) "dateCompleted": dateCompleted,
      if (essentialSections != null) "essentialSections": essentialSections,
      if (optionalSections != null) "optionalSections": optionalSections,
    };
  }

  static CollectionReference<InventoryCheckContents> getDocumentReference() {
    FirebaseFirestore db = DbService.getDbInstance();

    final CollectionReference<InventoryCheckContents> ref =
        db.collection("inventory_check_contents").withConverter(
              fromFirestore: InventoryCheckContents.fromFirestore,
              toFirestore: (InventoryCheckContents inventoryCheckContents, _) =>
                  inventoryCheckContents.toFirestore(),
            );

    return ref;
  }

  void addSection(bool isEssential, String sectionTitle, String propertyId,
      String sectionId, List<Map> inputAreas) {
    essentialSections ??= [];
    optionalSections ??= [];
    if (isEssential) {
      essentialSections!.add({
        "section_title": sectionTitle,
        "section_position": essentialSections!.length + 1,
        "section_id": sectionId,
        "input_areas": inputAreas
      });
    } else {
      optionalSections!.add({
        "section_title": sectionTitle,
        "section_position": optionalSections!.length + 1,
        "section_id": sectionId,
        "input_areas": inputAreas
      });
    }
  }

  static Map buildInputArea(bool fieldComplete, String details, String title,
      int position, String parentSectionId) {
    return {
      "section_id": parentSectionId,
      "input_complete": fieldComplete,
      "input_details": details,
      "input_title": title,
      "position": position
    };
  }
}
