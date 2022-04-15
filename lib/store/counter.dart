import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class Counter with ChangeNotifier, DiagnosticableTreeMixin {
  FirebaseAuth auth = FirebaseAuth.instance;
  int _count = 0;

  int get count => _count;
  Counter() {
    init();
  }

  void init() {
    User? users = auth.currentUser;
    String? uid = users?.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('cart')
        .get()
        .then((value) {
      _count = value.size;
    });
    notifyListeners();
  }

  void increment(int incrementBy) {
    _count += incrementBy;
    notifyListeners();
  }

  void decrement(int decrementBy) {
    _count -= decrementBy;
    notifyListeners();
  }

  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('count', count));
  }
}
