import 'package:flutter/material.dart';
import 'package:test_flutter_app/models/user.dart';
import 'package:test_flutter_app/services/dbService.dart';

class UserUtilities {
  
  static Future<User?> getUserDocument(String userId) async{
    User? user;

    await DbService.getUserDocument(userId).then((value) => user=value);

    return user;
  }
}