import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:test_flutter_app/utilities/global_values.dart';

import '../models/user.dart';

class PropertyImageAndInfo extends StatefulWidget {
  PropertyImageAndInfo(
      {Key? key,
      this.propertyImage,
      this.landlordDetails,
      this.tenantDetails,
      this.propertyAddress,
      this.tenantEmail})
      : super(key: key);
  Uint8List? propertyImage;
  User? landlordDetails;
  User? tenantDetails;
  String? propertyAddress;
  String? tenantEmail;

  @override
  _PropertyImageAndInfoState createState() => _PropertyImageAndInfoState();
}

class _PropertyImageAndInfoState extends State<PropertyImageAndInfo> {
  Uint8List? propertyImage;
  User? landlordDetails;
  User? tenantDetails;
  String? propertyAddress;

  @override
  Widget build(BuildContext context) {
    propertyImage = widget.propertyImage;
    landlordDetails = widget.landlordDetails;
    tenantDetails = widget.tenantDetails;
    propertyAddress = widget.propertyAddress;

    return Column(
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
                height: 300,
                decoration: propertyImage != null
                    ? BoxDecoration(
                        image: DecorationImage(
                            image: MemoryImage(propertyImage!),
                            fit: BoxFit.cover))
                    : const BoxDecoration(
                        image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/placeholderImages/house.jpg'),
                      )))),
        const SizedBox(height: 16.0),
        Wrap(
          spacing: 50,
          runSpacing: 10,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image(
                  image: AssetImage(IconPaths.tenantIconPath.path),
                  color: tenantDetails == null &&
                          (widget.tenantEmail == null ||
                              widget.tenantEmail!.isEmpty)
                      ? Color(0xFFE76E6E)
                      : Color(0xFF579A56),
                  width: 28,
                  height: 28,
                ),
                const SizedBox(width: 8.0),
                tenantDetails == null
                    ? Text(widget.tenantEmail != null &&
                            widget.tenantEmail!.isNotEmpty
                        ? widget.tenantEmail!
                        : "Vacant property")
                    : Text(
                        "${tenantDetails!.firstName} ${tenantDetails!.lastName}"),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image(
                  image: AssetImage(IconPaths.landlordIconPath.path),
                  width: 28,
                  height: 28,
                ),
                const SizedBox(width: 8.0),
                Text(landlordDetails != null
                    ? "${landlordDetails!.firstName!} ${landlordDetails!.lastName!}"
                    : "")
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image(
                  image: AssetImage(IconPaths.addressIconPath.path),
                  width: 28,
                  height: 28,
                ),
                const SizedBox(width: 8.0),
                Expanded(
                    child: Text(
                  propertyAddress!,
                  overflow: TextOverflow.visible,
                ))
              ],
            ),
          ],
        ),
      ],
    );
  }
}
