import 'package:flutter/material.dart';
import 'package:snow_remover/components/product_card.dart';
import 'package:snow_remover/models/product_model.dart';

class HomeScreenGridView extends StatefulWidget {
  const HomeScreenGridView({Key? key, required this.gridData})
      : super(key: key);
  final List<ProductModel> gridData;

  @override
  State<HomeScreenGridView> createState() => _HomeScreenGridViewState();
}

class _HomeScreenGridViewState extends State<HomeScreenGridView> {
  @override
  Widget build(BuildContext context) {
    final List<ProductModel> gridData = widget.gridData;
    int itemCount = widget.gridData.length;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 1),
            itemCount: itemCount,
            itemBuilder: (BuildContext context, int index) {
              return /*Card(
              color: Colors.blue,
              child: Container(
                alignment: Alignment.center,
                child:*/
                  ProductCard(
                brand: gridData[index].brand,
                cardImage: gridData[index].imageURL,
                heading: gridData[index].name,
                id: gridData[index].id,
                price: gridData[index].priceNumerical,
                subHeading: gridData[index].selfId.toString(),
                supportingText: gridData[index].description,
              );
            }),
      ),
    );
    // ));
  }
}
