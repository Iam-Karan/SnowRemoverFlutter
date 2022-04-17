import 'package:flutter/material.dart';

import 'package:snow_remover/models/Person.dart';

import 'PersonCard.dart';

class PersonGridView extends StatefulWidget {
  const PersonGridView({Key? key, required this.gridData}) : super(key: key);
  final List<person> gridData;

  @override
  State<PersonGridView> createState() => _PersonGridViewState();
}

class _PersonGridViewState extends State<PersonGridView> {
  @override
  Widget build(BuildContext context) {
    final List<person> gridData = widget.gridData;
    int itemCount = widget.gridData.length;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                personCard(
                    heading: gridData[index].description,
                    cardImage: gridData[index].imageurl,
                    name: gridData[index].name,
                    id: gridData[index].id,
                    price: gridData[index].Price);
          }),
    );
    // ));
  }
}
