import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:test_flutter_app/models/tenancy.dart';
import 'package:test_flutter_app/utilities/themeColors.dart';

enum TenancyType {previous, current, future}

class TenancyCard extends StatefulWidget {
  TenancyCard({ Key? key, required this.tenancy, this.selected}) : super(key: key);

  Tenancy tenancy;
  bool? selected;

  @override
  _TenancyCardState createState() => _TenancyCardState();
}

class _TenancyCardState extends State<TenancyCard> {
  late TenancyType? tenancyType;
  late DateTime? startDate;
  late DateTime? endDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setTenancyType();
    setTenancyDates();
  }

  @override
  Widget build(BuildContext context) {

    printTenancyCardData();
    return Card(
      color: widget.selected!=null&&widget.selected==true?ThemeColors.mainBlue:Color(0xFFFFFFFF),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          Text(tenancyType!=null?"${tenancyType.toString().split(".")[1]} tenant":""),
          Text("Tenant: ${widget.tenancy.tenantEmail}"),
          Text(startDate!=null&&endDate!=null?"Tenancy dates: ${startDate!.day}/${startDate!.month}/${startDate!.year} - ${endDate!.day}/${endDate!.month}/${endDate!.year}":""),
        ],),
      ),
    );
  }
  
  void setTenancyType() {
    TenancyType? tempTenancyType;

    DateTime? start = DateTime.tryParse(widget.tenancy.startDate!);
    DateTime? end = DateTime.tryParse(widget.tenancy.endDate!);
    DateTime now = DateTime.now();

    if(start == null || end == null){

    }else if (start.isBefore(now) && end.isBefore(now)){
      tempTenancyType=TenancyType.previous;
    }else if (start.isBefore(now) && end.isAfter(now)){
      tempTenancyType=TenancyType.current;
    }else if (start.isAfter(now) && end.isAfter(now)){
      tempTenancyType=TenancyType.future;
    }

    setState(() {
      tenancyType=tempTenancyType;
    });
  }

  void printTenancyCardData(){
    log("=="*40);
    log("Tenancy card data - tenancy type: ${tenancyType!=null?tenancyType.toString():"Tenancy type not given"}");
    log("Tenancy card data - tenancy dates: ${widget.tenancy.startDate} - ${widget.tenancy.endDate}");
    log("Tenancy card data - tenancy tenant: ${widget.tenancy.tenantEmail}");
    log("=="*40);
  }
  
  void setTenancyDates() {
    DateTime? start = DateTime.tryParse(widget.tenancy.startDate!);
    DateTime? end = DateTime.tryParse(widget.tenancy.endDate!);

    if(start!=null && end!=null){
      setState(() {
        startDate=start;
        endDate=end;
      });
    }
  }
}