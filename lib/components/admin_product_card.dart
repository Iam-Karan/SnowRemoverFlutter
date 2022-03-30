import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:snow_remover/models/product_model.dart';
import 'package:snow_remover/utility.dart' as utility;
import 'package:snow_remover/constant.dart' as constant;

class AdminProductCard extends StatefulWidget {
  final String id;
  final double price;
  final String brand;
  final String cardImage;
  final bool archiveStatus;
  final List<ProductModel> dataRef;
  const AdminProductCard(
      {Key? key,
      required this.cardImage,
      required this.id,
      required this.price,
      required this.brand,
      required this.archiveStatus,
      required this.dataRef})
      : super(key: key);

  @override
  State<AdminProductCard> createState() => _AdminProductCardState();
}

class _AdminProductCardState extends State<AdminProductCard> {
  bool archivalStatus = false;
  @override
  void initState() {
    // TODO: implement initState
    archivalStatus = widget.archiveStatus;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // archivalStatus = widget.archiveStatus;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return FutureBuilder<String>(
      builder: ((BuildContext context, AsyncSnapshot<String> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
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
              String? imageUrl = snapshot.data;
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                elevation: 5,
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    stops: const [
                      0.1,
                      0.4,
                      0.6,
                      0.9,
                    ],
                    colors: [
                      Colors.blue.shade300,
                      Colors.blue.shade400,
                      Colors.blue.shade600,
                      Colors.blue.shade700,
                    ],
                  )),
                  width: MediaQuery.of(context).size.width * 0.90,
                  height: MediaQuery.of(context).size.height * 0.18,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                          padding: const EdgeInsets.fromLTRB(5, 10, 0, 10),
                          child: CircleAvatar(
                            backgroundColor: Colors.blue.shade900,
                            radius: 75,
                            child: CircleAvatar(
                              radius: 55,
                              backgroundImage: NetworkImage(imageUrl!),
                            ),
                          )),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 10, 5, 5),
                                child: Text(
                                  widget.brand,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    fontSize: screenHeight > 550 ? 20 : 14,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 10, 5, 5),
                                child: Text(
                                  "   \$" + widget.price.toString(),
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      fontSize: screenHeight > 550 ? 18 : 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: InkWell(
                          child: Container(
                            height: screenHeight * 0.05,
                            width: screenWidth * 0.20,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(13),
                              color: archivalStatus
                                  ? Colors.green.shade400
                                  : Colors.red,
                            ),
                            child: Text(
                              archivalStatus ? "Unarchive" : "Archive",
                              style: const TextStyle(
                                  // fontSize: 20,
                                  color: Colors.white),
                            ),
                          ),
                          onTap: () async {
                            bool res = await utility.changeArchiveStatus(
                                !archivalStatus, "products", widget.id);
                            if (res) {
                              setState(() {
                                // archivalStatus = archivalStatus ? false : true;
                                archivalStatus = !archivalStatus;
                                Iterable<ProductModel> ref = widget.dataRef
                                    .where(
                                        (element) => element.id == widget.id);
                                ref.first.archiveStatus = archivalStatus;
                              });
                              print("new archival status is" +
                                  archivalStatus.toString());
                            } else {
                              toast(
                                  "There was some error in performing this operation");
                            }
                          },
                          splashColor: Colors.grey,
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
        }
      }),
      future: utility.generateImageUrl(widget.cardImage),
    );
  }
}
