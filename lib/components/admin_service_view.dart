import 'package:flutter/material.dart';
import 'package:snow_remover/components/admin_service_card.dart';
import 'package:snow_remover/models/Person.dart';

/// List view for products on admin home screen
class AdminServiceView extends StatefulWidget {
  const AdminServiceView({Key? key, required this.listData}) : super(key: key);
  final List<person> listData;
  @override
  State<AdminServiceView> createState() => _AdminServiceViewState();
}

class _AdminServiceViewState extends State<AdminServiceView> {
  @override
  Widget build(BuildContext context) {
    final List<person> productData = widget.listData;
    int itemCount = widget.listData.length;
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 5,
      ),
      child: ListView.builder(
        itemBuilder: (context, index) => AdminServiceCard(
          cardImage: productData[index].imageurl,
          id: productData[index].id,
          price: productData[index].Price,
          name: productData[index].name,
          archiveStatus: productData[index].archiveStatus,
          dataRef: productData,
        ),
        itemCount: itemCount,
        padding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 5,
        ),
      ),
    ));
  }
}
