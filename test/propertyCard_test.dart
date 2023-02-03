import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';
import 'package:test_flutter_app/utilities/date_utilities.dart';
import 'package:test_flutter_app/widgets/propertyCard.dart';

void main() {
  test("Date can be converted to days remaining", () {
    DateTime from = DateTime(2020, 10, 10);
    String to = "30/10/2020";

    expect(DateUtilities.dateStringToDaysRemaining(from, to), 20);
  });
}