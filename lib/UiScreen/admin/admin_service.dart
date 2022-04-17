import 'dart:async';
import 'package:snow_remover/components/admin_list_view.dart';
import 'package:snow_remover/components/admin_service_view.dart';
import 'package:snow_remover/constant.dart' as constant;
import 'package:flutter/material.dart';
import 'package:snow_remover/models/Person.dart';
import 'package:snow_remover/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snow_remover/models/Generate_Image_Url.dart';
import 'package:snow_remover/utility.dart' as utility;

class AdminServiceScreen extends StatefulWidget {
  const AdminServiceScreen({Key? key}) : super(key: key);

  @override
  State<AdminServiceScreen> createState() => _AdminServiceScreenState();
}

class _AdminServiceScreenState extends State<AdminServiceScreen> {
  Timer? _debounce;
  bool showFilter = false;
  String dropdownValue = 'low to high';
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text("Book services"),
          ),
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
                          hintText: "Search for services",
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
                    items: constant.adminServiceFOps
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
        Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            onTap: (() => Navigator.pushNamed(context, '/add_person')),
            child: Container(
              width: screenWidth * 0.90,
              height: 40,
              color: constant.primaryColor,
              alignment: Alignment.center,
              child: const Text(
                "Add Person",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        FutureBuilder<List<person>>(
            future: utility.fetchPersonsFromDatabase(false),
            builder:
                (BuildContext context, AsyncSnapshot<List<person>> snapshot) {
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
                    List<person> myProducts = [];
                    if (searchValue.isNotEmpty) {
                      myProducts = snapshot.data!
                          .where((element) => element.name
                              .toLowerCase()
                              .contains(searchValue.toLowerCase()))
                          .toList();
                    } else {
                      myProducts = snapshot.data ?? [];
                    }
                    myProducts = applyFilter2(myProducts, dropdownValue);
                    return AdminServiceView(listData: myProducts);
                  }
              }
            }),
      ]),
    );
  }
}
