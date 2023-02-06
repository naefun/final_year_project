import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
CustomAppBar({ Key? key, this.title }) : super(key: key);

String? title;

  @override
  Widget build(BuildContext context){
    return AppBar(
      title: Text(title!=null ? title!:"Inventory App"),
    );
  }
  
  @override
  Size get preferredSize => AppBar().preferredSize;
}