import 'dart:math';

import 'package:flutter/material.dart';

class RequestInventoryCheckDialog extends StatefulWidget {
  const RequestInventoryCheckDialog({
    super.key,
  });

  @override
  State<RequestInventoryCheckDialog> createState() =>
      _RequestInventoryCheckDialogState();
}

class _RequestInventoryCheckDialogState
    extends State<RequestInventoryCheckDialog> {
  int? _selectedType;
  final _emailTextController = TextEditingController();
  final _dateTextController = TextEditingController();
  final _focusEmail = FocusNode();
  final _focusDate = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusDate.unfocus();
      },
      child: Dialog(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(12),
              child: Text(
                'Request an inventory check',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              decoration: BoxDecoration(
                  color: Color(0xFF489EED),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4))),
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Type",
                    style: TextStyle(fontSize: 18),
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 1,
                        groupValue: _selectedType,
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value;
                          });
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity(
                            horizontal: VisualDensity.minimumDensity),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Check-in"),
                      SizedBox(
                        width: 50,
                      ),
                      Radio(
                        value: 2,
                        groupValue: _selectedType,
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value;
                          });
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity(
                            horizontal: VisualDensity.minimumDensity),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Check-out"),
                    ],
                  ),
                  TextFormField(
                    controller: _emailTextController,
                    focusNode: _focusEmail,
                    // validator: (value) => {},
                    decoration: InputDecoration(
                      hintText: "Clerk email",
                      errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _dateTextController,
                    focusNode: _focusDate,
                    // validator: (value) => {},
                    decoration: InputDecoration(
                      hintText: "Inventory check date",
                      errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Color(0xFF489EED)),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, elevation: 4),
                      ),
                      const SizedBox(width: 15),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Submit'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF489EED), elevation: 4),
                      ),
                    ],
                  ),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}
