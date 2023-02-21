import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_flutter_app/models/inventoryCheck.dart';
import 'package:test_flutter_app/models/inventoryCheckContents.dart';
import 'package:test_flutter_app/models/inventoryCheckInputArea.dart';
import 'package:test_flutter_app/models/inventoryCheckRequest.dart';
import 'package:test_flutter_app/models/inventoryCheckSection.dart';
import 'package:test_flutter_app/models/property.dart';
import 'package:test_flutter_app/models/user.dart';
import 'package:test_flutter_app/utilities/inventory_check_contents_builder.dart';
import 'package:uuid/uuid.dart';

class DbService {
  static FirebaseFirestore db = FirebaseFirestore.instance;

  static FirebaseFirestore getDbInstance() {
    return db;
  }

  static Future<User?> getUserDocument(String userId) async {
    QuerySnapshot<User>? data;
    CollectionReference<User> ref = User.getDocumentReference();
    await ref.where("authId", isEqualTo: userId).get().then(
          (res) => {log("Successfully completed"), data = res},
          onError: (e) => log("Error completing: $e"),
        );
    return data?.docs.first.data();
  }

  static Future<void> createUserDocument(User user) async {
    if (!User.fieldsArentEmpty(user)) {
      log("fields are empty");
      return;
    }

    CollectionReference<User> ref = User.getDocumentReference();
    await ref.doc().set(user);
    log("user document created");
  }

  static Future<void> createPropertyDocument(Property property) async {
    if (!Property.fieldsArentEmpty(property)) {
      log("fields are empty");
      return;
    }

    CollectionReference<Property> ref = Property.getDocumentReference();
    await ref.doc(property.propertyId).set(property);
    log("property document created");
  }

  static Future<void> createInventoryCheckRequestDocument(
      InventoryCheckRequest inventoryCheckRequest) async {
    if (!InventoryCheckRequest.fieldsArentEmpty(inventoryCheckRequest)) {
      log("fields are empty");
      return;
    }

    CollectionReference<InventoryCheckRequest> ref =
        InventoryCheckRequest.getDocumentReference();
    await ref.doc().set(inventoryCheckRequest);
    log("property inventory check request document created");
  }

  static Future<void> submitInventoryCheckSection(
      InventoryCheckSection inventoryCheckSection) async {

    CollectionReference<InventoryCheckSection> ref =
        InventoryCheckSection.getDocumentReference();
    await ref.doc().set(inventoryCheckSection);
    log("property inventory check section document created");
  }

  static Future<void> submitInventoryCheckInputArea(
      InventoryCheckInputArea inventoryCheckInputArea) async {

    CollectionReference<InventoryCheckInputArea> ref =
        InventoryCheckInputArea.getDocumentReference();
    await ref.doc().set(inventoryCheckInputArea);
    log("property inventory check input area document created");
  }

  static Future<void> submitInventoryCheck(
      InventoryCheck inventoryCheck) async {

    CollectionReference<InventoryCheck> ref =
        InventoryCheck.getDocumentReference();
    await ref.doc().set(inventoryCheck);
    log("property inventory check document created");
  }

  static Future<List<QueryDocumentSnapshot<Property>>?> getOwnedProperties(
      String ownerId) async {
    log("getting owned properties");
    QuerySnapshot<Property>? data;
    CollectionReference<Property> ref = Property.getDocumentReference();
    await ref.where("ownerId", isEqualTo: ownerId).get().then(
          (res) => {
            log("Successfully completed for owner: $ownerId ${res.size}"),
            data = res
          },
          onError: (e) => log("Error completing: $e"),
        );
    return data?.docs;
  }

  static Future<QueryDocumentSnapshot<Property>?> getProperty(
      String propertyId) async {
    QuerySnapshot<Property>? data;
    CollectionReference<Property> ref = Property.getDocumentReference();
    await ref
        .where("propertyId", isEqualTo: propertyId)
        .get()
        .then((value) => data = value);
    return data!.docs.first;
  }

  static Future<List<QueryDocumentSnapshot<InventoryCheckRequest>>?>
      getLandlordInventoryCheckRequests(String landlordId) async {
    List<String> landlordPropertyIds = [];
    await getOwnedProperties(landlordId).then((value) => {
          if (value != null)
            {
              for (QueryDocumentSnapshot<Property> prop in value)
                {
                  if (prop.data().propertyId != null)
                    {
                      {landlordPropertyIds.add(prop.data().propertyId!)}
                    }
                }
            }
        });

    log(landlordPropertyIds.toString());

    QuerySnapshot<InventoryCheckRequest>? data;
    CollectionReference<InventoryCheckRequest> ref =
        InventoryCheckRequest.getDocumentReference();
    data = await ref.where("propertyId", whereIn: landlordPropertyIds).get();

    return data.docs;
  }

  static Future<void> submitCompleteInventoryCheck(
      InventoryCheckContents? icc) async {
    String id = "abc123";
    List<Map> essentialSections = [
      {
        "input_areas": [
          {
            "input_complete": true,
            "input_details": "Some details",
            "input_title": "Client details",
            "position": 1
          }
        ],
        "section_id": "section id",
        "section_position": 1,
        "section_title": "Inventory check details"
      }
    ];
    List<Map> optionalSections = [
      {
        "input_areas": [
          {
            "input_complete": false,
            "input_details": "Some details",
            "input_title": "Client details",
            "position": 1
          }
        ],
        "section_id": "section id",
        "section_position": 2,
        "section_title": "Bathroom"
      }
    ];

    final docData = {
      "essential_sections": essentialSections,
      "optional_sections": optionalSections,
      "id": "akjdbvv12",
    };

    FirebaseFirestore db = DbService.getDbInstance();

    if (icc != null) {
      CollectionReference<InventoryCheckContents> ref =
          InventoryCheckContents.getDocumentReference();
      await ref.doc(icc.id).set(icc);
    } else {
      await db.collection("inventory_check_contents").doc("test").set(docData);
    }
    log("Inventory check created");
  }
}
