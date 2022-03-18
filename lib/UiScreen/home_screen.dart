import 'dart:math';
import 'package:snow_remover/components/product_card.dart';
import 'package:snow_remover/constant.dart' as constant;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:snow_remover/utility.dart' as utility;
import 'package:snow_remover/models/product_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showFilter = false;
  String dropdownValue = 'Available';
  String searchValue = "";
  Future<List<ProductModel>> fetchProductsFromDatabase() async {
    try {
      Map<String, dynamic> singleElem;
      CollectionReference _products =
          FirebaseFirestore.instance.collection('products');
      QuerySnapshot querySnapshot = await _products.get();
      List<ProductModel> apiData = querySnapshot.docs.map((e) {
        singleElem = e.data() as Map<String, dynamic>;
        singleElem["image_url"] = singleElem["main_image"];
        singleElem["_id"] = e.reference.id.toString();
        ProductModel temp = ProductModel(
            singleElem["brand"],
            singleElem["name"],
            singleElem["description"],
            singleElem["main_image"],
            singleElem["price_numerical"],
            singleElem["self_id"],
            singleElem["type"],
            singleElem["stock_unit"],
            singleElem["video_url"],
            singleElem["image_url"],
            singleElem["_id"]);
        return temp;
      }).toList();
      return apiData;
    } catch (e) {
      print("caught error" + e.toString());
      rethrow;
    }
  }

  void keyboardDebounce(String value) async {
    await Future.delayed(Duration(milliseconds: 1500), () {
      setState(() {
        searchValue = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductModel>>(
      future: fetchProductsFromDatabase(),
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
        print("did it run twice" + snapshot.connectionState.toString());
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
                snapshot.data?.map((e) {
                  if (e.name.contains(searchValue)) {
                    myProducts.add(e);
                  }
                });
              } else {
                myProducts = snapshot.data ?? [];
              }
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    floating: true,
                    pinned: true,
                    snap: false,
                    centerTitle: false,
                    title: const Text("Shop Tools"),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.tune),
                        onPressed: () {
                          setState(() {
                            showFilter = !showFilter;
                          });
                        },
                      ),
                    ],
                    bottom: AppBar(
                        title: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          width: double.infinity,
                          height: 40,
                          child: Center(
                            child: TextField(
                              textAlign: TextAlign.center,
                              onChanged: (query) {
                                keyboardDebounce(query);
                              },
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
                    )),
                  ),
                  if (showFilter)
                    SliverPadding(
                      padding: const EdgeInsets.all(20),
                      sliver: SliverToBoxAdapter(
                        child: InputDecorator(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
                          child: StatefulBuilder(builder: (context, setState) {
                            return Container(
                              height: 20,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: dropdownValue,
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.black),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValue = newValue!;
                                    });
                                  },
                                  items: constant.filterOptions
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
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
                    ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 18),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 20, 
                              crossAxisSpacing: 20,
                              childAspectRatio: 1),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Card(
                              color: Colors.blue,
                              child: Container(
                                alignment: Alignment.center,
                                child: ProductCard(
                                  brand: myProducts[index].brand,
                                  cardImage: myProducts[index].imageURL,
                                  heading: myProducts[index].name,
                                  id: myProducts[index].id,
                                  price: myProducts[index].priceNumerical,
                                  subHeading:
                                      myProducts[index].selfId.toString(),
                                  supportingText: myProducts[index].description,
                                ),
                              ));
                        },
                        childCount: myProducts.length,
                      ),
                    ),
                  ),
                ],
              );
            }
        }
      },
    );
  }
}
