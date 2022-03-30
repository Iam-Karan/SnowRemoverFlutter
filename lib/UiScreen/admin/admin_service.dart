import 'dart:async';
import 'package:snow_remover/components/admin_list_view.dart';
import 'package:snow_remover/constant.dart' as constant;
import 'package:flutter/material.dart';
import 'package:snow_remover/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snow_remover/utility.dart';

class AdminServiceScreen extends StatefulWidget {
  const AdminServiceScreen({Key? key}) : super(key: key);

  @override
  State<AdminServiceScreen> createState() => _AdminServiceScreenState();
}

class _AdminServiceScreenState extends State<AdminServiceScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Container(child: const Text("Admin handles services here"));
  }
}
