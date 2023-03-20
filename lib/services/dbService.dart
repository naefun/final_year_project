import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_flutter_app/models/comment.dart';
import 'package:test_flutter_app/models/inventoryCheck.dart';
import 'package:test_flutter_app/models/inventoryCheckContents.dart';
import 'package:test_flutter_app/models/inventoryCheckInputArea.dart';
import 'package:test_flutter_app/models/inventoryCheckRequest.dart';
import 'package:test_flutter_app/models/inventoryCheckSection.dart';
import 'package:test_flutter_app/models/property.dart';
import 'package:test_flutter_app/models/tenancy.dart';
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

  static Future<User?> getUserDocumentFromEmail(String email) async {
    QuerySnapshot<User>? data;
    CollectionReference<User> ref = User.getDocumentReference();
    await ref.where("email", isEqualTo: email).get().then(
          (res) => {log("Successfully completed"), data = res},
          onError: (e) => log("Error completing: $e"),
        );
    return data != null && data!.docs.isNotEmpty
        ? data!.docs.first.data()
        : null;
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

  static Future<void> createComment(Comment comment) async {
    CollectionReference<Comment> ref = Comment.getDocumentReference();
    await ref.doc().set(comment);
    log("Comment document created");
  }

  static Future<List<QueryDocumentSnapshot<Comment>>?> getCommentsForSubsection(
      String subsectionId) async {
    QuerySnapshot<Comment>? data;
    CollectionReference<Comment> ref = Comment.getDocumentReference();
    await ref.where("subsectionId", isEqualTo: subsectionId).get().then(
          (res) => {log("Successfully retrieved comments"), data = res},
          onError: (e) => log("Error completing: $e"),
        );
    return data?.docs;
  }

  static Future<List<QueryDocumentSnapshot<Comment>>?>
      getCommentsForInventoryCheck(String inventoryCheckId) async {
    QuerySnapshot<Comment>? data;
    CollectionReference<Comment> ref = Comment.getDocumentReference();
    await ref.where("inventoryCheckId", isEqualTo: inventoryCheckId).get().then(
          (res) => {log("Successfully retrieved comments"), data = res},
          onError: (e) => log("Error completing: $e"),
        );
    return data?.docs;
  }

  static Future<Comment?> getComment(String commentId) async {
    Comment? data;
    await Comment.getDocumentReference()
        .where("id", isEqualTo: commentId)
        .get()
        .then(
          (res) => {
            log("Successfully retrieved comments"),
            data = res.docs.first.data()
          },
          onError: (e) => log("Error completing: $e"),
        );
    return data;
  }

  static Future<int> getNumberOfInventoryCheckComments(
      String inventoryCheckId) async {
    int data = 0;
    CollectionReference<Comment> ref = Comment.getDocumentReference();
    await ref.where("inventoryCheckId", isEqualTo: inventoryCheckId).get().then(
          (res) => {
            log("Successfully retrieved number of comments"),
            data = res.size
          },
          onError: (e) => log("Error completing: $e"),
        );
    return data;
  }

  static Future<void> createInventoryCheckRequestDocument(
      InventoryCheckRequest inventoryCheckRequest) async {
    if (!InventoryCheckRequest.fieldsArentEmpty(inventoryCheckRequest)) {
      log("fields are empty");
      return;
    }

    CollectionReference<InventoryCheckRequest> ref =
        InventoryCheckRequest.getDocumentReference();
    await ref.doc(inventoryCheckRequest.id).set(inventoryCheckRequest);
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

  static Future<List<QueryDocumentSnapshot<InventoryCheck>>?>
      getInventoryChecks(String ownerId) async {
    List<QueryDocumentSnapshot<Property>> properties = [];
    await getOwnedProperties(ownerId).then((value) => properties = value ?? []);

    if (properties.isEmpty) return null;

    List<String> propertyIds = [];

    for (int i = 0; i < properties.length; i++) {
      propertyIds.add(properties[i].data().propertyId!);
    }

    QuerySnapshot<InventoryCheck>? data;
    CollectionReference<InventoryCheck> ref =
        InventoryCheck.getDocumentReference();
    await ref.where("propertyId", whereIn: propertyIds).get().then(
          (res) => {
            log("Successfully completed for owner: $ownerId ${res.size}"),
            data = res
          },
          onError: (e) => log("Error completing: $e"),
        );
    return data?.docs;
  }

  static Future<List<QueryDocumentSnapshot<InventoryCheck>>?>
      getInventoryChecksForProperty(String propertyId) async {
    QuerySnapshot<InventoryCheck>? data;
    CollectionReference<InventoryCheck> ref =
        InventoryCheck.getDocumentReference();
    await ref.where("propertyId", isEqualTo: propertyId).get().then(
          (res) => {
            log("Successfully completed for property: $propertyId ${res.size}"),
            data = res
          },
          onError: (e) => log("Error completing: $e"),
        );
    return data?.docs;
  }

  static Future<List<QueryDocumentSnapshot<InventoryCheckSection>>?>
      getInventoryCheckSections(String inventoryCheckId) async {
    QuerySnapshot<InventoryCheckSection>? data;
    CollectionReference<InventoryCheckSection> ref =
        InventoryCheckSection.getDocumentReference();
    await ref.where("inventoryCheckId", isEqualTo: inventoryCheckId).get().then(
          (res) => {
            log("Successfully completed for inventory check: $inventoryCheckId ${res.size}"),
            data = res
          },
          onError: (e) => log("Error completing: $e"),
        );
    return data?.docs;
  }

  static Future<List<QueryDocumentSnapshot<InventoryCheckInputArea>>?>
      getInventoryCheckSubSections(String inventoryCheckSectionId) async {
    QuerySnapshot<InventoryCheckInputArea>? data;
    CollectionReference<InventoryCheckInputArea> ref =
        InventoryCheckInputArea.getDocumentReference();
    await ref.where("sectionId", isEqualTo: inventoryCheckSectionId).get().then(
          (res) => {
            log("Successfully completed for inventory check section: $inventoryCheckSectionId ${res.size}"),
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

    if (landlordPropertyIds.isEmpty) {
      return null;
    }
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

  static Future<void> setInventoryCheckRequestCompleted(
      InventoryCheckRequest inventoryCheckRequest) async {
    final ref =
        db.collection("inventoryCheckRequests").doc(inventoryCheckRequest.id);
    await ref.update({"complete": true});
  }

  static Future<void> setCommentAsSeen(int userType, String commentId) async {
    String commentDocumentId = "";

    await db
        .collection("comments")
        .where("id", isEqualTo: commentId)
        .get()
        .then((value) {
      commentDocumentId = value.docs.first.id;
    });

    if (userType == 1) {
      await db
          .collection("comments")
          .doc(commentDocumentId)
          .update({"seenByLandlord": true});
    } else if (userType == 2) {
      await db
          .collection("comments")
          .doc(commentDocumentId)
          .update({"seenByTenant": true});
    }
  }

  static Future<List<QueryDocumentSnapshot<InventoryCheckRequest>>>
      getInventoryCheckRequestsForProperty(String propertyId) async {
    final ref = InventoryCheckRequest.getDocumentReference();
    final data = await ref
        .where("propertyId", isEqualTo: propertyId)
        .where("complete", isEqualTo: false)
        .get();
    return data.docs;
  }

  static Future<void> updateProperty(Property property) async {
    final ref = Property.getDocumentReference().doc(property.propertyId);
    await ref.update({
      "addressHouseNameOrNumber": property.addressHouseNameOrNumber,
      "addressRoadName": property.addressRoadName,
      "addressCity": property.addressCity,
      "addressPostcode": property.addressPostcode,
      "tenantId": property.tenantId,
    });
  }

  static Future<void> deleteProperty(String propertyId) async {
    await Property.getDocumentReference().doc(propertyId).delete();
  }

  static Future<void> deleteInventoryCheckRequest(
      String inventoryCheckRequestId) async {
    await InventoryCheckRequest.getDocumentReference()
        .doc(inventoryCheckRequestId)
        .delete();
  }

  static Future<void> createTenancyDocument(Tenancy tenancy) async {
    await Tenancy.getDocumentReference().doc(tenancy.id).set(tenancy);
  }

  static Future<List<QueryDocumentSnapshot<Tenancy>>?> getTenancyDocuments(
      String propertyId) async {
    QuerySnapshot<Tenancy>? data;
    await Tenancy.getDocumentReference()
        .where("propertyId", isEqualTo: propertyId)
        .get()
        .then((value) => data = value);
    return data != null ? data!.docs : null;
  }

  static Future<List<QueryDocumentSnapshot<Tenancy>>?>
      getSpecificTenancyDocuments(List<String> tenancyIds) async {
    QuerySnapshot<Tenancy>? data;
    await Tenancy.getDocumentReference()
        .where("id", whereIn: tenancyIds)
        .get()
        .then((value) => data = value);
    return data != null ? data!.docs : null;
  }

  static Future<void> updateTenancyTerm(
      String tenancyId, String? start, String? end) async {
    Tenancy? tenancyToUpdate;
    Tenancy.getDocumentReference()
        .where("id", isEqualTo: tenancyId)
        .get()
        .then((value) {
      tenancyToUpdate = value.docs.first.data();
    });
    final ref = db.collection("tenancies").doc(tenancyId);
    await ref.update({
      "startDate": start != null ? start : tenancyToUpdate!.startDate,
      "endDate": end != null ? end : tenancyToUpdate!.endDate
    });
    log("Updated tenancy date/s");
  }

  static Future<void> updateCommentSeenBy(String uid, String commentId) async {
    String commentDocumentId = "";
    Comment? c;
    List<String> seenByUsers = [];

    await getComment(commentId).then((value) => {
          if (value != null) {c = value}
        });

    if (c == null) return;
    if (c!.seenByUsers != null) seenByUsers = c!.seenByUsers!;
    seenByUsers.add(uid);

    await db
        .collection("comments")
        .where("id", isEqualTo: commentId)
        .get()
        .then((value) {
      commentDocumentId = value.docs.first.id;
    });
    await db
        .collection("comments")
        .doc(commentDocumentId)
        .update({"seenByUsers": seenByUsers});
  }
}
