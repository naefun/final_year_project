import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageService {
  static final FirebaseStorage storage = FirebaseStorage.instance;

  static Future<Uint8List?> getPropertyImage(String imageName) async {
    Reference storageRef = storage.ref();
    Uint8List? imageData;
    log("getting image");
    Reference propertyImageRef =
        storageRef!.child("property_images/$imageName");
    log(propertyImageRef.fullPath);
    await propertyImageRef.getData(1000000).then((value) => imageData = value!);
    return imageData;
  }

  static Future<void> putPropertyImage(File image, String imageName) async {
    Reference storageRef = storage.ref();
    log("uploading image");
    Reference propertyImagesRef =
        storageRef!.child("property_images/$imageName");
    await propertyImagesRef.putFile(image);
  }
}
