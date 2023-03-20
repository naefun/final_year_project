import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_flutter_app/services/dbService.dart';

class Tenancy {
  final String? id;
  final String? tenantEmail;
  final String? propertyId;
  final String? startDate;
  final String? endDate;

  Tenancy({
    this.id,
    this.tenantEmail,
    this.propertyId,
    this.startDate,
    this.endDate,
  });

  factory Tenancy.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Tenancy(
      id: data?['id'],
      tenantEmail: data?['tenantEmail'],
      propertyId: data?['propertyId'],
      startDate: data?['startDate'],
      endDate: data?['endDate'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (tenantEmail != null) "tenantEmail": tenantEmail,
      if (propertyId != null) "propertyId": propertyId,
      if (startDate != null) "startDate": startDate,
      if (endDate != null) "endDate": endDate,
    };
  }

  static CollectionReference<Tenancy> getDocumentReference() {
    FirebaseFirestore db = DbService.getDbInstance();

    final CollectionReference<Tenancy> ref =
        db.collection("tenancies").withConverter(
              fromFirestore: Tenancy.fromFirestore,
              toFirestore: (Tenancy tenancy, _) => tenancy.toFirestore(),
            );

    return ref;
  }

  String getFormatedStartAndEndDates(){
    DateTime? start = DateTime.tryParse(startDate!);
    DateTime? end = DateTime.tryParse(endDate!);

    return "${start!.day}/${start.month}/${start.year} - ${end!.day}/${end.month}/${end.year}";
  }
}
