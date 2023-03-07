import 'package:flutter/material.dart';
import 'package:test_flutter_app/widgets/wideInventoryCheckCard.dart';

class DaysUntilOrSinceFormattedText extends StatefulWidget {
  DaysUntilOrSinceFormattedText(
      {Key? key,
      required this.daysUntilOrSince,
      required this.intendedToBeFuture})
      : super(key: key);

  int daysUntilOrSince;
  bool intendedToBeFuture;

  @override
  _DaysUntilOrSinceFormattedTextState createState() =>
      _DaysUntilOrSinceFormattedTextState();
}

class _DaysUntilOrSinceFormattedTextState
    extends State<DaysUntilOrSinceFormattedText> {
  int? daysUntilOrSince;
  bool? intendedToBeFuture;
  @override
  Widget build(BuildContext context) {
    daysUntilOrSince = widget.daysUntilOrSince;
    intendedToBeFuture = widget.intendedToBeFuture;
    String daysUntilOrSinceAsString = formatDays();
    String daysUntilOrSinceIndicator = formatDaysIndicator();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(daysUntilOrSinceAsString, style: const TextStyle(fontSize: 18)),
        Text(daysUntilOrSinceIndicator,
            style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,),
      ],
    );
  }

  String formatDays() {
    int tempDaysUntilOrSince = daysUntilOrSince!;

    if (tempDaysUntilOrSince < 0) {
      tempDaysUntilOrSince = tempDaysUntilOrSince * -1;
    }
    if (tempDaysUntilOrSince > 99) {
      return "99+";
    } else {
      return tempDaysUntilOrSince.toString();
    }
  }

  String formatDaysIndicator() {
    if (intendedToBeFuture! == true) {
      if (daysUntilOrSince! < 0) {
        return (daysUntilOrSince! * -1) != 1 ? " days overdue" : " day overdue";
      } else {
        return daysUntilOrSince! != 1 ? " days to go" : " day to go";
      }
    } else {
      return daysUntilOrSince! != 1 ? " days ago" : " day ago";
    }
  }
}
