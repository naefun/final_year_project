import 'package:flutter/material.dart';

class DateUtilities {
  static int? dateStringToDaysRemaining(DateTime dateFrom, String dateTo) {
    int? result;

    List<String> dateToSplit = dateTo.split("/");
    int? futureYear = int.tryParse(dateToSplit[2]);
    int? futureMonth = int.tryParse(dateToSplit[1]);
    int? futureDay = int.tryParse(dateToSplit[0]);

    if (futureYear == null ||
        futureMonth == null ||
        futureDay == null ||
        DateUtils.getDaysInMonth(futureYear, futureMonth) < futureDay ||
        futureDay <= 0 ||
        futureMonth <= 0 ||
        futureMonth > 12 ||
        futureYear <= 0) {
      return null;
    }

    DateTime futureDateTime = DateTime(futureYear, futureMonth, futureDay);

    result = (futureDateTime.difference(dateFrom).inHours / 24).round();

    return result;
  }

  static bool validDate(String date) {
    // date should be DD/MM/YYYY

    List<String> dateSplit = date.split("/");

    if (dateSplit.length != 3) return false;

    int? futureYear = int.tryParse(dateSplit[2]);
    int? futureMonth = int.tryParse(dateSplit[1]);
    int? futureDay = int.tryParse(dateSplit[0]);

    if (futureYear == null) return false;
    if (futureMonth == null || futureMonth > 12 || futureMonth <= 0)
      return false;
    if (futureDay == null || futureDay <= 0) return false;
    if (DateUtils.getDaysInMonth(futureYear, futureMonth) < futureDay)
      return false;

    return true;
  }

  static int? getDaysUntil(String date) {
    if (DateUtilities.validDate(date)) {
      int? dateCheck = dateStringToDaysRemaining(DateTime.now(), date);
      if (dateCheck != null) return dateCheck;
    }
  }
}
