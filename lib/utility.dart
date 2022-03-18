import 'package:flutter/cupertino.dart';
import 'package:snow_remover/models/product_model.dart';

import 'constant.dart' as constant;
import 'package:firebase_storage/firebase_storage.dart' as fs;

// String generateImageUrl(String imageName) {
//   String storageKey = constant.storageKey;
//   return "https://firebasestorage.googleapis.com/v0/b/snowremovalapp-ac3d9.appspot.com/o/products%2F$imageName?alt=media&token=$storageKey";
// }

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
