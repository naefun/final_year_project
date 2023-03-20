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
}