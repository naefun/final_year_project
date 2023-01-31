import 'dart:developer';
import 'dart:io';


import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageService{
  static final FirebaseStorage storage = FirebaseStorage.instance;

  void getPropertyImage(String imageId){

  }

  static Future<void> putPropertyImage(File image, String imageName) async {
    Reference storageRef = storage.ref();
    log("uploading image");
    Reference propertyImagesRef = storageRef!.child("property_images/$imageName");
    await propertyImagesRef.putFile(image);
  }
}