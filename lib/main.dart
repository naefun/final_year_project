// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:test_flutter_app/pages/loginPage.dart';
import 'package:test_flutter_app/pages/propertiesPage.dart';
import 'package:test_flutter_app/services/AuthProvider.dart';
import 'package:test_flutter_app/services/AuthService.dart';
import 'package:test_flutter_app/store/reducer.dart';
import 'package:test_flutter_app/widgets/mainNavigation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final Store<bool> store = Store<bool>(reducer, initialState: false);
  runApp(MyApp(store));
}

class MyApp extends StatelessWidget {
  final Store<bool> store; 
  MyApp(this.store);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: Provider(
          auth: AuthService(),
          child: MaterialApp(
            title: 'Startup Name Generator',
            home: LoginPage(),
          )),
    );
  }
}


