import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

import '../models/Person.dart';
import '../models/Person.dart';
import '../models/personGridView.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({Key? key}) : super(key: key);

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  bool searchButtonPressed = false;

  Future<List<person>> fetchProductsFromDatabase() async {
    try {
      Map<String, dynamic> singleElem;
      CollectionReference _persons =
          FirebaseFirestore.instance.collection('person');
      QuerySnapshot querySnapshot = await _persons.get();
      List<person> apiData = querySnapshot.docs.map((e) {
        singleElem = e.data() as Map<String, dynamic>;
        singleElem["imageurl"] = singleElem["imageurl"];
        singleElem["_id"] = e.reference.id;
        person temp = person(
          singleElem["age"],
          singleElem["description"],
          singleElem["_id"],
          singleElem["imageurl"],
          singleElem["name"],
          singleElem["numberOfOrder"],
          singleElem["personId"],
        );
        return temp;
      }).toList();
      return apiData;
    } catch (e) {
      print("caught error" + e.toString());
      rethrow;
    }
  }

  var seachValue = "";

  @override
  Widget build(BuildContext context) {
    double Width = (MediaQuery.of(context).size.width);
    return Scaffold(
      appBar: AppBar(
        title: Text("Snow Removal"),
      ),
      // This is handled by the search bar itself.
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          searchButtonPressed == false
              ? buildFloatingSearchBar()
              : Positioned(
                  right: 5,
                  left: 5,
                  top: MediaQuery.of(context).size.height * 0.01,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text("Filter"),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(Width, 50),
                      onPrimary: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                  )),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.08,
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 1,
                width: MediaQuery.of(context).size.height * 1,
                child: Column(
                  children: <Widget>[
                    FutureBuilder<List<person>>(
                        future: fetchProductsFromDatabase(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<person>> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return const CircularProgressIndicator();
                            default:
                              if (snapshot.hasError) {
                                return Text(
                                  'Error t: ${snapshot.error}',
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                );
                              } else {
                                List<person> myProducts = [];
                                if (seachValue.isNotEmpty) {
                                  myProducts = snapshot.data!
                                      .where((element) => element.name
                                          .toLowerCase()
                                          .contains(seachValue.toLowerCase()))
                                      .toList();
                                } else {
                                  myProducts = snapshot.data ?? [];
                                }
                                // myProducts = applyFilter(myProducts, dropdownValue);
                                return PersonGridView(gridData: myProducts);
                              }
                          }
                        }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
        borderRadius: BorderRadius.circular(20),
        onSubmitted: (query) {
          setState(() {
            seachValue = query;
            searchButtonPressed = true;
          });
        },
        clearQueryOnClose: true,
        hint: 'Search...',
        scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
        transitionDuration: const Duration(milliseconds: 800),
        transitionCurve: Curves.easeInOut,
        physics: const BouncingScrollPhysics(),
        axisAlignment: isPortrait ? 0.0 : -1.0,
        openAxisAlignment: 0.0,
        width: isPortrait ? 600 : 500,
        debounceDelay: const Duration(milliseconds: 500),
        onQueryChanged: (query) {
          print(" i love u");
          // Call your model, bloc, controller here.
        },
        iconColor: Colors.blue,
        automaticallyImplyBackButton: true,

        // Specify a custom transition to be used for
        // animating between opened and closed stated.
        transition: CircularFloatingSearchBarTransition(),
        actions: [
          FloatingSearchBarAction(
            showIfOpened: false,
            child: CircularButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  searchButtonPressed = true;
                });
              },
            ),
          ),
          FloatingSearchBarAction.searchToClear(
            showIfClosed: false,
          ),
        ],
        builder: (context, transition) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Material(
                color: Colors.white,
                elevation: 4.0,
                child: Container(
                  height: 200,
                  color: Colors.red,
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(" Search Iteams"),
                      )
                    ],
                  ),
                )),
          );
        });
  }
}
