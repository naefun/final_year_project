// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Startup Name Generator'),
            backgroundColor: Colors.green,
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: MainBody(),)
          ,
          bottomNavigationBar: const CustomBottomNavigation()),
    );
  }
}

class CustomBottomNavigation extends StatefulWidget {
  const CustomBottomNavigation({Key? key}) : super(key: key);

  @override
  _CustomBottomNavigationState createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: "Create"),
        BottomNavigationBarItem(
            icon: Icon(Icons.notifications), label: "Alerts"),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }
}

class MainBody extends StatelessWidget {
  MainBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const Image(
              image: AssetImage('assets/placeholderImages/house.jpg'),
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('data', style: TextStyle(fontSize: 18), textAlign: TextAlign.start,),
                  Text('data', style: TextStyle(fontSize: 14),),
                ],
              ),
            )
          ]),
        ))
      ]),
    );
  }
}
