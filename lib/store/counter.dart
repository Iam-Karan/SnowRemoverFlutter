import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:snow_remover/models/cart_model.dart';

class Counter with ChangeNotifier, DiagnosticableTreeMixin {
  FirebaseAuth auth = FirebaseAuth.instance;
  int _count = 0;
  List<CartModel> cartItems = [];

  int get count => _count;
  Counter() {
    init();
  }
  void reset() {
    _count = 0;
    cartItems = [];
    notifyListeners();
  }

  Future<void> init() async {
    User? users = auth.currentUser;
    String? uid = users?.uid;
    QuerySnapshot cart = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('cart')
        .get();
    cartItems = cart.docs.map((e) {
      Map<String, dynamic> indiv = e.data() as Map<String, dynamic>;
      CartModel item = CartModel(
          hours: indiv["hours"],
          id: indiv["id"],
          image: indiv["image"],
          name: indiv["name"],
          price: indiv["price"],
          quantity: indiv["quantity"],
          type: indiv["type"]);
      return item;
    }).toList();
    if (cartItems.isEmpty) {
      _count = 0;
    } else {
      _count = cart.docs.map(
        (e) {
          Map<String, dynamic> singleElem = e.data() as Map<String, dynamic>;
          return singleElem['quantity'];
        },
      ).reduce((value, element) => value + element);
    }
    notifyListeners();
  }

  void increment(int incrementBy) {
    _count += incrementBy;
    notifyListeners();
  }

  void addItem(int incrementBy, CartModel item) {
    if (item.type.compareTo("personimages") == 0) {
      if (cartItems.any((element) => element.id.compareTo(item.id) == 0)) {
        CartModel match =
            cartItems.firstWhere((element) => element.id == item.id);
        match.hours = match.hours + incrementBy;
        return;
      } else {
        cartItems.add(item);
        _count += 1;
        notifyListeners();
        return;
      }
    } else {
      if (cartItems.any((element) => element.id.compareTo(item.id) == 0)) {
        CartModel match =
            cartItems.firstWhere((element) => element.id == item.id);
        match.quantity = match.quantity + incrementBy;
      } else {
        cartItems.add(item);
      }
    }
    _count += incrementBy;
    notifyListeners();
  }

  void removeItem(int decrementBy, String id, String type) {
    if (type.compareTo("personimages") == 0) {
      if (cartItems.any((element) => element.id.compareTo(id) == 0)) {
        CartModel match = cartItems.firstWhere((element) => element.id == id);
        match.hours = match.hours - decrementBy;
        return;
      }
    } else {
      if (cartItems.any((element) => element.id.compareTo(id) == 0)) {
        CartModel match = cartItems.firstWhere((element) => element.id == id);
        match.quantity = match.quantity - decrementBy;
      } else {
        return;
      }
    }
    _count -= decrementBy;
    notifyListeners();
  }

  void decrement(int decrementBy) {
    _count -= decrementBy;
    notifyListeners();
  }

  void deleteItem(String id, int quantity) {
    cartItems.removeWhere((element) => element.id.compareTo(id) == 0);
    _count -= quantity;
    notifyListeners();
  }

  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('count', count));
  }
}
