import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

Future<List<person>> applyFilter2(List<person> inputData, String type) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? users = auth.currentUser;
  String? uid = users?.uid;
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
    case 'Favorite':
      if (FirebaseAuth.instance.currentUser == null) {
        result = inputData;
        break;
      }
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      QuerySnapshot favList = await firebaseFirestore
          .collection("users")
          .doc(uid)
          .collection("favorite")
          .get();
      List<String> favIds = favList.docs.map((e) => e.reference.id).toList();
      result = inputData
          .where((element) => favIds.any((e) => e.compareTo(element.id) == 0))
          .toList();
      break;
    default:
      throw ErrorDescription("Unkown filter");
  }
  return result;
}
