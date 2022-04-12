import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snow_remover/components/custom_form_field.dart';
import 'package:snow_remover/models/cart_model.dart';
import 'package:snow_remover/constant.dart' as constant;

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  String address = "";
  String city = "";
  String zip = "";
  String province = "";
  String country = "";
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final currCart =
        ModalRoute.of(context)!.settings.arguments as List<CartModel>?;
    double total = 0;
    total = currCart!.fold(0, (sum, item) => sum + item.price);
    double tax = total * 0.13;
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(20),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Checkout",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Confirm Order",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      CustomFormField(
                        hintText: 'Address Line 1',
                        onSaved: (String value) {
                          address = value;
                        },
                        validator: (val) {
                          if (val!.isEmpty) return 'Address cannot be empty';
                        },
                      ),
                      CustomFormField(
                        hintText: 'City',
                        onSaved: (String value) {
                          city = value;
                        },
                        validator: (val) {
                          if (val!.isEmpty) return 'City cannot be empty';
                        },
                      ),
                      CustomFormField(
                        hintText: 'ZIP Code',
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(6),
                        ],
                        onSaved: (String value) {
                          zip = value;
                        },
                        validator: (val) {
                          if (val!.isEmpty) return 'ZIP CODE cannot be empty';
                        },
                      ),
                      CustomFormField(
                        hintText: 'Province',
                        onSaved: (String value) {
                          province = value;
                        },
                        validator: (val) {
                          if (val!.isEmpty) return 'Province cannot be empty';
                        },
                      ),
                      CustomFormField(
                        hintText: 'Country',
                        onSaved: (String value) {
                          country = value;
                        },
                        validator: (val) {
                          if (val!.isEmpty) return 'Country cannot be empty';
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: screenHeight * 0.30,
              width: screenWidth * 0.90,
              margin: const EdgeInsets.all(10),
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "SUMMARY",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      getCell("SUB-TOTAL", "\$" + total.toStringAsFixed(2)),
                      getCell("DELIVERY", "\$0"),
                      getCell("Taxes", "\$${tax.toStringAsFixed(2)}"),
                      const Divider(
                        color: Colors.black,
                        thickness: 4,
                      ),
                      getCell("Amount Payable",
                          "\$${(tax + total).toStringAsFixed(2)}"),
                    ],
                  )),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(223, 209, 207, 169),
                  borderRadius: BorderRadius.circular(12)),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              child: InkWell(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                  }
                },
                child: Container(
                  width: screenWidth * 0.90,
                  height: 40,
                  color: constant.primaryColor,
                  alignment: Alignment.center,
                  child: const Text(
                    "Order",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getCell(String heading, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(heading,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Text(value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}
