import 'package:flutter/material.dart';
import 'package:snow_remover/components/admin_product_card.dart';
import 'package:snow_remover/components/product_card.dart';
import 'package:snow_remover/models/product_model.dart';

/// List view for products on admin home screen
class AdminListView extends StatefulWidget {
  const AdminListView({Key? key, required this.listData}) : super(key: key);
  final List<ProductModel> listData;
  @override
  State<AdminListView> createState() => _AdminListViewState();
}

class _AdminListViewState extends State<AdminListView> {
  @override
  Widget build(BuildContext context) {
    final List<ProductModel> productData = widget.listData;
    int itemCount = widget.listData.length;
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 5,
      ),
      child: ListView.builder(
        itemBuilder: (context, index) => AdminProductCard(
          cardImage: productData[index].mainImage,
          id: productData[index].id,
          price: productData[index].priceNumerical,
          brand: productData[index].brand,
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
