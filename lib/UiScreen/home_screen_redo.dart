import 'package:snow_remover/components/home_grid_view.dart';
import 'package:snow_remover/constant.dart' as constant;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snow_remover/utility.dart' as utility;
import 'package:snow_remover/models/product_model.dart';
import 'dart:async';

import 'package:snow_remover/utility.dart';

class HomeScreenTwo extends StatefulWidget {
  const HomeScreenTwo({Key? key}) : super(key: key);

  @override
  State<HomeScreenTwo> createState() => _HomeScreenTwoState();
}

class _HomeScreenTwoState extends State<HomeScreenTwo> {
  Timer? _debounce;
  bool showFilter = false;
  String dropdownValue = 'Price: Low to High';
  String searchValue = "";
  TextEditingController controller = TextEditingController();
  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        searchValue = query;
      });
    });
  }

  _onDropDownChanged(String? value) {
    setState(() {
      dropdownValue = value!;
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<List<ProductModel>> fetchProductsFromDatabase() async {
    try {
      Map<String, dynamic> singleElem;
      CollectionReference _products =
          FirebaseFirestore.instance.collection('products');
      QuerySnapshot querySnapshot =
          await _products.where('archive', isEqualTo: false).get();
      List<ProductModel> apiData = querySnapshot.docs.map((e) {
        singleElem = e.data() as Map<String, dynamic>;
        singleElem["image_url"] = singleElem["main_image"];
        singleElem["_id"] = e.reference.id.toString();
        ProductModel temp = ProductModel(
            singleElem["brand"],
            singleElem["name"],
            singleElem["description"],
            singleElem["main_image"],
            double.parse(singleElem["price_numerical"]),
            singleElem["self_id"],
            singleElem["type"],
            singleElem["stock_unit"],
            singleElem["video_url"],
            singleElem["image_url"],
            singleElem["_id"],
            singleElem["archive"] ?? false);
        return temp;
      }).toList();
      return apiData;
    } catch (e) {
      print("caught error" + e.toString());
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text("Shop tools"),
          ),
          actions: utility.getAction(context),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(55.0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    width: double.infinity,
                    height: 40,
                    child: Center(
                      child: TextField(
                        controller: controller,
                        textAlign: TextAlign.center,
                        onChanged: _onSearchChanged,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(50, 0, 0, 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: "Search for tools",
                          prefixIcon: const Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: InputDecorator(
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0))),
            child: StatefulBuilder(builder: (context, setState) {
              return Container(
                height: 18,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    onChanged: _onDropDownChanged,
                    items: constant.filterOptions
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              );
            }),
          ),
        ),
        FutureBuilder<List<ProductModel>>(
            future: fetchProductsFromDatabase(),
            builder: (BuildContext context,
                AsyncSnapshot<List<ProductModel>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const CircularProgressIndicator();
                default:
                  if (snapshot.hasError) {
                    return Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    );
                  } else {
                    List<ProductModel> myProducts = [];
                    if (searchValue.isNotEmpty) {
                      myProducts = snapshot.data!
                          .where((element) => element.brand
                              .toLowerCase()
                              .contains(searchValue.toLowerCase()))
                          .toList();
                    } else {
                      myProducts = snapshot.data ?? [];
                    }
                    myProducts = applyFilter(myProducts, dropdownValue);
                    return HomeScreenGridView(gridData: myProducts);
                  }
              }
            }),
      ]),
    );
  }
}
