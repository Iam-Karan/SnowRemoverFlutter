import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:snow_remover/models/Generate_Image_Url.dart';
import 'package:snow_remover/utility.dart' as utility;

import '../models/Person.dart';

import '../models/personGridView.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({Key? key}) : super(key: key);

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

Icon iconValue = Icon(Icons.arrow_downward);

class _ServiceScreenState extends State<ServiceScreen> {
  bool searchButtonPressed = false;
  String sortValue = "nil";

  var seachValue = "";

  // final filterButtonIteams = filterButton(iconValue: iconValue, sortValue: "nil",);
  // var finalSortValue;
  @override
  Widget build(BuildContext context) {
    //  finalSortValue = filterButtonIteams.sortValue;
    print(((MediaQuery.of(context).size.height * 1) - 2));
    double Width = (MediaQuery.of(context).size.width);
    return Scaffold(
      appBar: AppBar(
        //leading: Image.asset('assets/images/113324765-close-up-of-small-snowman-in-winter-with-snow-background.jpg',fit: BoxFit.fill,),
        elevation: 5,
        title: Text("Snow Removal"),
      ),
      // This is handled by the search bar itself.
      // resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            right: 25,
            left: 25,
            top: MediaQuery.of(context).size.height * 0.08,
            child: Container(
              // margin: EdgeInsets.all(10),
              child: floatBar(),
            ),
          ),
          productView(),
          buildFloatingSearchBar()
        ],
      ),
    );
  }

  Widget productView() {
    return Positioned(
      top: 120,
      child: SizedBox(
        height: ((MediaQuery.of(context).size.height * 1) - 280),
        width: MediaQuery.of(context).size.width * 1,
        child: FutureBuilder<List<person>>(
            future: utility.fetchPersonsFromDatabase(true),
            builder:
                (BuildContext context, AsyncSnapshot<List<person>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const CircularProgressIndicator();
                default:
                  if (snapshot.hasError) {
                    return Text(
                      'Error yes: ${snapshot.error}',
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
                    if (sortValue != "nil") {
                      myProducts = applyFilter2(myProducts, sortValue);
                    }
                    return PersonGridView(gridData: myProducts);
                  }
              }
            }),
      ),
    );
  }

  Future bottomBar() {
    return showModalBottomSheet(
      elevation: 15,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          // color: Colors.amber,
          child: Column(
            children: [
              Row(
                //crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                // mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ElevatedButton(
                    child: const Text('Close',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        iconValue = Icon(Icons.arrow_downward);
                        //ServiceScreen();
                      });
                    },
                  ),
                ],
              ),
              Divider(
                height: 1,
                color: Colors.black.withOpacity(0.3),
                indent: 10,
                endIndent: 10,
                thickness: 1,
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                margin: EdgeInsets.only(left: 15),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('Sort By:-',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black)),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      )),
                      onPressed: () {
                        setState(() {
                          sortValue = "low to high";
                        });
                      },
                      child: Text("Price: low to high",
                          style: TextStyle(fontSize: 16))),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      )),
                      onPressed: () {
                        setState(() {
                          sortValue = "High to low";
                        });
                      },
                      child: Text("Price: High to low",
                          style: TextStyle(fontSize: 16))),
                ],
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  )),
                  onPressed: () {
                    setState(() {
                      sortValue = "Avilable";
                      print(sortValue);
                    });
                  },
                  child: Text(
                    "Avilable",
                    style: TextStyle(fontSize: 16),
                  )),
            ],
          ),
        );
      },
    );
  }

  Widget floatBar() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ElevatedButton.icon(
        onPressed: () {
          setState(() {
            sortValue = "nil";
            //   searchButtonPressed = false;
            iconValue = Icon(Icons.arrow_upward);
          });
          bottomBar();
        },
        icon: iconValue,
        label: const Text(" Filter"),
        style: ElevatedButton.styleFrom(
          //elevation: 5,
          padding: EdgeInsets.all(5),
          // fixedSize: Size(Width, 50),
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
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
            if (seachValue.isNotEmpty) {
              searchButtonPressed = true;
            }
          });
        },
        clearQueryOnClose: false,
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
          setState(() {
            seachValue = query;
          });
        },
        iconColor: Colors.blue,
        automaticallyImplyBackButton: false,

        // Specify a custom transition to be used for
        // animating between opened and closed stated.
        transition: CircularFloatingSearchBarTransition(),
        actions: [
          FloatingSearchBarAction(
            showIfOpened: false,
            child: CircularButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                if (seachValue.isNotEmpty) {
                  setState(() {});
                }
              },
            ),
          ),
          FloatingSearchBarAction.searchToClear(
            showIfClosed: false,
          ),
        ],
        builder: (context, transition) {
          return Container();

          /*  ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Material(
                color: Colors.white,
                elevation: 4.0,
                child: Container(
                  height: 200,

                  child: Column(
                    children: [
                      ListTile(
                          //title: Text(" Search Iteams"),
                          )
                    ],
                  ),
                )),
          );*/
        });
  }
}
