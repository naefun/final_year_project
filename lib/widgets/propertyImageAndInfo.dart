import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_flutter_app/models/tenancy.dart';
import 'package:test_flutter_app/services/dbService.dart';
import 'package:test_flutter_app/services/fireAuth.dart';
import 'package:test_flutter_app/utilities/global_values.dart';
import 'package:test_flutter_app/utilities/tenancyUtilities.dart';
import 'package:test_flutter_app/utilities/user_utilities.dart';

import '../models/user.dart';

class PropertyImageAndInfo extends StatefulWidget {
  PropertyImageAndInfo({
    Key? key,
    this.propertyImage,
    this.landlordDetails,
    this.tenantDetails,
    this.propertyAddress,
    this.tenantEmail,
    required this.propertyId,
    this.showCurrentTenants,
  }) : super(key: key);
  Uint8List? propertyImage;
  User? landlordDetails;
  User? tenantDetails;
  String? propertyAddress;
  String? tenantEmail;
  String propertyId;
  bool? showCurrentTenants;

  @override
  _PropertyImageAndInfoState createState() => _PropertyImageAndInfoState();
}

class _PropertyImageAndInfoState extends State<PropertyImageAndInfo> {
  Uint8List? propertyImage;
  User? landlordDetails;
  User? tenantDetails;
  User? currentUser;
  String? propertyAddress;
  String? propertyId;
  List<Tenancy>? tenancies;
  bool showTenancyInformation = true;

  @override
  Widget build(BuildContext context) {
    propertyImage = widget.propertyImage;
    landlordDetails = widget.landlordDetails;
    tenantDetails = widget.tenantDetails;
    propertyAddress = widget.propertyAddress;
    propertyId = widget.propertyId;
    if (widget.showCurrentTenants != null) {
      setState(() {
        showTenancyInformation = widget.showCurrentTenants!;
      });
    }
    if (currentUser == null) {
      UserUtilities.getUserDocument(FireAuth.getCurrentUser()!.uid)
          .then((value) {
        if (value != null) {
          setState(() {
            currentUser = value;
          });
        }
      });
    }

    if (tenancies == null && propertyId != null) setTenancies();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                  color: tenancies == null || tenancies!.isEmpty
                      ? Color(0xFFE76E6E)
                      : Color(0xFF579A56),
                  width: 28,
                  height: 28,
                ),
                const SizedBox(width: 8.0),
                Text(tenancies == null || tenancies!.isEmpty
                    ? "Vacant property"
                    : "Occupied")
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
        SizedBox(height: 20),
        renderCurrentTenants(),
        renderCurrentUserTenancyDates()
      ],
    );
  }

  void setTenancies() {
    if (currentUser == null) return;

    switch (currentUser!.userType!) {
      case 1:
        setCurrentTenancies();
        break;
      case 2:
        setTenantTenancies();
        break;
    }
  }

  void setCurrentTenancies() async {
    List<Tenancy> tempTenancies =
        await TenancyUtilities.getCurrentTenancies(propertyId!);
    setState(() {
      tenancies = tempTenancies;
    });
  }

  void setTenantTenancies() async {
    List<Tenancy> tempTenancies = await TenancyUtilities.getTenantTenancies(
        propertyId!, FireAuth.getCurrentUser()!.email!);
    setState(() {
      tenancies = tempTenancies;
    });
  }

  Widget renderCurrentTenants() {
    return tenancies != null &&
            tenancies!.isNotEmpty &&
            showTenancyInformation == true &&
            currentUser != null &&
            currentUser!.userType! == 1
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                  tenancies!.length > 1 ? "Current tenants" : "Current tenant"),
              SizedBox(
                height: 40,
                child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: tenancies!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                          onTap: () {
                            // log(currentTenancies![index].startDate!);
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            padding: EdgeInsets.all(6),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 199, 199, 199),
                                borderRadius: BorderRadius.circular(4)),
                            child: Text(tenancies![index].tenantEmail!),
                          ));
                    }),
              ),
            ],
          )
        : SizedBox();
  }

  Widget renderCurrentUserTenancyDates() {
    return tenancies != null &&
            tenancies!.isNotEmpty &&
            showTenancyInformation &&
            currentUser != null &&
            currentUser!.userType! == 2
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                  "${tenancies!.length > 1 ? "Your tenancies" : "Your tenancy"} for this property"),
              SizedBox(
                height: 40,
                child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: tenancies!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                          onTap: () {
                            // log(currentTenancies![index].startDate!);
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            padding: EdgeInsets.all(6),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 199, 199, 199),
                                borderRadius: BorderRadius.circular(4)),
                            child: Text(tenancies![index].getFormatedStartAndEndDates()),
                          ));
                    }),
              ),
            ],
          )
        : SizedBox();
  }
}
