import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_flutter_app/models/property.dart';
import 'package:test_flutter_app/models/user.dart';

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
    await ref.doc().set(property);
    log("property document created");
  }
}
