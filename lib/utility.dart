import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:snow_remover/models/product_model.dart';
import '../models/Person.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'components/toast_message/ios_Style.dart';
import 'package:snow_remover/components/badge.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:snow_remover/models/Generate_Image_Url.dart';

import 'store/counter.dart';

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

Future<List<ProductModel>> applyFilter(
    List<ProductModel> inputData, String type) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? users = auth.currentUser;
  String? uid = users?.uid;
  List<ProductModel> result = [];
  switch (type) {
    case 'Available':
      result = inputData.where((element) => element.stockUnit > 0).toList();
      break;
    case 'Favourite':
      // result = inputData;
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

Future<List<person>> fetchPersonsFromDatabase(
    bool applyArchiveCon, String? searchValue, String sortValue) async {
  try {
    Map<String, dynamic> singleElem;
    CollectionReference _persons =
        FirebaseFirestore.instance.collection('person');
    QuerySnapshot querySnapshot;
    if (applyArchiveCon) {
      querySnapshot = await _persons.where('archive', isEqualTo: false).get();
    } else {
      querySnapshot = await _persons.get();
    }

    List<person> apiData = querySnapshot.docs.map((e) {
      singleElem = e.data() as Map<String, dynamic>;
      singleElem["imageurl"] = singleElem["imageurl"];
      singleElem["_id"] = e.reference.id;
      person temp = person(
          double.parse(singleElem["Price"]),
          singleElem["age"],
          singleElem["description"],
          singleElem["_id"],
          singleElem["imageurl"],
          singleElem["name"],
          singleElem["personId"],
          singleElem["archive"] ?? false,
          singleElem["completed_order"]);
      return temp;
    }).toList();
    if (searchValue != null) {
      apiData = apiData
          .where((element) =>
              element.name.toLowerCase().contains(searchValue.toLowerCase()))
          .toList();
    }
    if (sortValue != "nil") {
      apiData = await applyFilter2(apiData, sortValue);
    }
    return apiData;
  } catch (e) {
    print("caught error" + e.toString());
    rethrow;
  }
}

Future<void> uploadFile(File toUpload, String source, String filename) async {
  try {
    await firebase_storage.FirebaseStorage.instance
        .ref('$source/$filename')
        .putFile(toUpload);
  } on firebase_core.FirebaseException catch (e) {
    rethrow;
  }
}

List<Widget> getAction(BuildContext context) {
  return [
    MyBadge(
        child: InkWell(
          child: const Icon(
            Icons.shopping_cart,
            size: 35,
          ),
          onTap: () {
            Navigator.pushNamed(context, '/cartScreen');
          },
        ),
        value: '${context.watch<Counter>().count}',
        top: 10,
        right: 5)
  ];
}

String formattedDate(DateTime selected, String sep) {
  String day = selected.day < 10 ? '0${selected.day}' : '${selected.day}';
  String month =
      selected.month < 10 ? '0${selected.month}' : '${selected.month}';
  return '${selected.year}$sep$month$sep$day';
}

String formattedTime(TimeOfDay selectedTime) {
  String hour =
      selectedTime.hour < 10 ? '0${selectedTime.hour}' : '${selectedTime.hour}';
  String minute = selectedTime.minute < 10
      ? '0${selectedTime.minute}'
      : '${selectedTime.minute}';
  return '$hour:$minute';
}
