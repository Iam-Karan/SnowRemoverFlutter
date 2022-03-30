import 'package:flutter/cupertino.dart';
import 'package:snow_remover/models/product_model.dart';


import 'package:firebase_storage/firebase_storage.dart' as fs;

import 'Person.dart';

// String generateImageUrl(String imageName) {
//   String storageKey = constant.storageKey;
//   return "https://firebasestorage.googleapis.com/v0/b/snowremovalapp-ac3d9.appspot.com/o/products%2F$imageName?alt=media&token=$storageKey";
// }

Future<String> generateImageUrl2(String imageName) async {
  fs.FirebaseStorage storage = fs.FirebaseStorage.instance;
  String downloadURL =
  await storage.ref('personimages/$imageName').getDownloadURL();
  return downloadURL;
}

List<person> applyFilter2(List<person> inputData, String type) {
  List<person> result = [];
  switch (type) {
    case 'Avilable':
      result = inputData.where((element) => element.age > 0).toList();
      break;
    case 'low to high':
      inputData.sort(((a, b) => a.Price.compareTo(b.Price)));
      result = inputData;
      break;
    case 'High to low':
      inputData.sort(((a, b) => b.Price.compareTo(a.Price)));
      result = inputData;
      break;
    default:
      throw ErrorDescription("Unkown filter");
  }
  return result;
}
