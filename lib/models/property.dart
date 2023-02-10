import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_flutter_app/services/dbService.dart';

class Property implements Comparable{
  final String? addressHouseNameOrNumber;
  final String? addressRoadName;
  final String? addressPostcode;
  final String? addressCity;
  final String? propertyImageName;
  final String? nextInventoryCheck;
  final String? ownerId;
  final String? tenantId;
  final String? propertyId;

  Property(
      {this.addressHouseNameOrNumber,
      this.addressRoadName,
      this.addressPostcode,
      this.addressCity,
      this.propertyImageName,
      this.nextInventoryCheck,
      this.ownerId,
      this.tenantId,
      this.propertyId
      });

  factory Property.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Property(
      addressHouseNameOrNumber: data?['addressHouseNameOrNumber'],
      addressRoadName: data?['addressRoadName'],
      addressPostcode: data?['addressPostcode'],
      addressCity: data?['addressCity'],
      propertyImageName: data?['propertyImageName'],
      nextInventoryCheck: data?['nextInventoryCheck'],
      ownerId: data?['ownerId'],
      tenantId: data?['tenantId'],
      propertyId: data?['propertyId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (addressHouseNameOrNumber != null) "addressHouseNameOrNumber": addressHouseNameOrNumber,
      if (addressRoadName != null) "addressRoadName": addressRoadName,
      if (addressPostcode != null) "addressPostcode": addressPostcode,
      if (addressCity != null) "addressCity": addressCity,
      if (propertyImageName != null) "propertyImageName": propertyImageName,
      if (nextInventoryCheck != null) "nextInventoryCheck": nextInventoryCheck,
      if (ownerId != null) "ownerId": ownerId,
      if (tenantId != null) "tenantId": tenantId,
      if (propertyId != null) "propertyId": propertyId,
    };
  }

  static CollectionReference<Property> getDocumentReference() {
    FirebaseFirestore db = DbService.getDbInstance();

    final CollectionReference<Property> ref =
        db.collection("properties").withConverter(
              fromFirestore: Property.fromFirestore,
              toFirestore: (Property property, _) => property.toFirestore(),
            );

    return ref;
  }

  static bool fieldsArentEmpty(Property property) {
    return property.addressHouseNameOrNumber != null &&
        property.addressRoadName != null &&
        property.addressPostcode != null &&
        property.addressCity != null &&
        property.ownerId != null &&
        property.propertyId != null;
  }
  
  @override
  int compareTo(other) {
    // TODO: implement compareTo
    Property? p = other;
    if(p == null){
      return 1;
    }

    if(addressHouseNameOrNumber!=p.addressHouseNameOrNumber!){
      return addressHouseNameOrNumber!.compareTo(p.addressHouseNameOrNumber!);
    }else if(addressRoadName!=p.addressRoadName){
      return addressRoadName!.compareTo(p.addressRoadName!);
    }else if(addressCity!=p.addressCity){
      return addressCity!.compareTo(p.addressCity!);
    }else if(addressPostcode!=p.addressPostcode){
      return addressPostcode!.compareTo(p.addressPostcode!);
    }else{
      return 0;
    }

  }
}
