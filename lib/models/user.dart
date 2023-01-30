import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_flutter_app/services/dbService.dart';

class User {
  final String? authId;
  final int? userType;
  final String? firstName;
  final String? lastName;

  // static final Map<String, int> userTypes = {"Landlord":1, "Tenant":2, "Clerk":3};
  static final List<List<String>> userTypes = [["Landlord", "1"], ["Tenant", "2"], ["Clerk", "3"]];

  User({this.authId, this.userType, this.firstName, this.lastName});

  factory User.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return User(
      authId: data?['authId'],
      userType: data?['userType'],
      firstName: data?['firstName'],
      lastName: data?['lastName'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (authId != null) "authId": authId,
      if (userType != null) "userType": userType,
      if (firstName != null) "firstName": firstName,
      if (lastName != null) "lastName": lastName,
    };
  }

  static CollectionReference<User> getDocumentReference(){
    FirebaseFirestore db = DbService.getDbInstance();

    final CollectionReference<User> ref = db.collection("users").withConverter(
      fromFirestore: User.fromFirestore,
      toFirestore: (User user, _) => user.toFirestore(),
    );

    return ref;
  }

  static bool fieldsArentEmpty(User user){
    return user.authId != null && user.firstName!=null && user.lastName!=null && user.userType!=null;
  }

  static List<List<String>> getUserTypes(){
    return userTypes;
  }
}
