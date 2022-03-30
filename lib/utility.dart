import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:snow_remover/models/product_model.dart';

import 'components/toast_message/ios_Style.dart';
import 'constant.dart' as constant;
import 'package:firebase_storage/firebase_storage.dart' as fs;

// String generateImageUrl(String imageName) {
//   String storageKey = constant.storageKey;
//   return "https://firebasestorage.googleapis.com/v0/b/snowremovalapp-ac3d9.appspot.com/o/products%2F$imageName?alt=media&token=$storageKey";
// }
// final firebaseUser = FirebaseAuth.instance.currentUser!;
Future<String> generateImageUrl(String imageName) async {
  fs.FirebaseStorage storage = fs.FirebaseStorage.instance;
  String downloadURL =
      await storage.ref('products/$imageName').getDownloadURL();
  return downloadURL;
}

List<ProductModel> applyFilter(List<ProductModel> inputData, String type) {
  List<ProductModel> result = [];
  switch (type) {
    case 'Available':
      result = inputData.where((element) => element.stockUnit > 0).toList();
      break;
    case 'Favourite':
      result = inputData;
      break;
    case 'Price: Low to High':
      inputData.sort(((a, b) => a.priceNumerical.compareTo(b.priceNumerical)));
      result = inputData;
      break;
    case 'Price: High to Low':
      inputData.sort(((a, b) => b.priceNumerical.compareTo(a.priceNumerical)));
      result = inputData;
      break;
    default:
      throw ErrorDescription("Unkown filter");
  }
  return result;
}

Future<DocumentSnapshot?> fetchUser() async {
  User? user = FirebaseAuth.instance.currentUser;
  final uid = user?.uid;
  if (user != null) {
    CollectionReference _users = FirebaseFirestore.instance.collection("users");
    DocumentSnapshot ds = await _users.doc(uid).get();
    return ds;
  } else {
    return null;
  }
}

Future<bool> changeArchiveStatus(
    bool isArchived, String collection, String _id) async {
  var colRef = FirebaseFirestore.instance.collection(collection);
  var returnVal = await colRef
      .doc(_id)
      .set({'archive': isArchived}, SetOptions(merge: true))
      .then((value) => true)
      .catchError((onError) {
        print(onError);
        return false;
      });
  return returnVal;
}

void SignOut(BuildContext context) {
  FirebaseAuth.instance.signOut();
  showOverlay((context, t) {
    return Opacity(
      opacity: t,
      child: const IosStyleToast(label: "Logout successfully"),
    );
  });
  Navigator.pushReplacementNamed(context, '/bottom_nav');
}
