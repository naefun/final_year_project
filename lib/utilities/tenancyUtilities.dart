import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_flutter_app/models/tenancy.dart';
import 'package:test_flutter_app/services/dbService.dart';

class TenancyUtilities {
  static Future<List<Tenancy>> getCurrentTenancies(String propertyId) async {
    List<Tenancy> tempCurrentTenancies = [];
    await DbService.getTenancyDocuments(propertyId).then((value) {
      if (value != null) {
        for (QueryDocumentSnapshot<Tenancy> element in value) {
          DateTime? start = DateTime.tryParse(element.data().startDate!);
          DateTime? end = DateTime.tryParse(element.data().endDate!);
          if (start != null &&
              end != null &&
              start.isBefore(DateTime.now()) &&
              end.isAfter(DateTime.now())) {
            tempCurrentTenancies.add(element.data());
          }
        }
      }
    });

    if (tempCurrentTenancies.isNotEmpty) {
      tempCurrentTenancies.sort((a, b) => a.startDate!.compareTo(b.startDate!));
    }
    return tempCurrentTenancies;
  }

  static Future<List<Tenancy>> getTenantTenancies(
      String propertyId, String tenantEmail) async {
    List<Tenancy> tempTenancies = [];
    await DbService.getTenantsTenancyDocuments(propertyId, tenantEmail)
        .then((value) {
      if (value != null) {
        log("tenant tenancy length: ${value.length}");
        for (QueryDocumentSnapshot<Tenancy> element in value) {
          tempTenancies.add(element.data());
        }
      }
    });

    if (tempTenancies.isNotEmpty) {
      tempTenancies.sort((a, b) => a.startDate!.compareTo(b.startDate!));
    }
    return tempTenancies;
  }
}
