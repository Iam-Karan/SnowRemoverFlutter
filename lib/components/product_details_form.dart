import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snow_remover/constant.dart' as constant;
import 'package:snow_remover/models/product_model.dart';
import 'package:snow_remover/validaiton_extension.dart';
import 'custom_form_field.dart';

class ProductDetailsForm extends StatefulWidget {
  final Function resetImage;
  final Function postData;
  const ProductDetailsForm(
      {Key? key, required this.resetImage, required this.postData})
      : super(key: key);

  @override
  State<ProductDetailsForm> createState() => _ProductDetailsFormState();
}

class _ProductDetailsFormState extends State<ProductDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  String brand = "";
  String name = "";
  String description = "";
  String mainImage = "";
  double priceNumerical = 0;
  int selfId = 0;
  String type = "";
  int stockUnit = 0;
  String videoURL = "";
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CustomFormField(
            hintText: 'Name',
            onSaved: (String value) {
              name = value;
            },
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r"[a-zA-Z]+|\s"),
              )
            ],
            validator: (val) {
              if (val!.isEmpty) return 'Name cannot be empty';
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: TextFormField(
              onSaved: (newValue) {
                description = newValue!;
              },
              validator: (val) {
                if (!val!.isNotEmpty) return 'Description cannot be empty';
              },
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 50.0),
                border: OutlineInputBorder(),
                labelText: 'Description',
              ),
            ),
          ),
          CustomFormField(
            hintText: 'Brand Name',
            onSaved: (String value) {
              brand = value;
            },
            validator: (val) {
              if (!val!.isNotEmpty) return 'Brand Name cannot be empty';
            },
          ),
          CustomFormField(
            onSaved: (String value) {
              priceNumerical = double.parse(value);
            },
            hintText: 'Price',
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'\d'),
              )
            ],
            validator: (val) {
              if (!val!.isNotEmpty) return 'Price cannot be empty';
              if (!val.numbersOnly) return 'Price can be numbers only';
            },
          ),
          CustomFormField(
            onSaved: (String value) {
              selfId = int.parse(value);
            },
            hintText: 'Self ID',
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'\d'),
              )
            ],
            validator: (val) {
              if (!val!.isNotEmpty) return 'Self ID cannot be empty';
              if (!val.numbersOnly) return 'Self ID can be numbers only';
            },
          ),
          CustomFormField(
            onSaved: (String value) {
              stockUnit = int.parse(value);
            },
            hintText: 'Stock Unit',
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'\d'),
              )
            ],
            validator: (val) {
              if (!val!.isNotEmpty) return 'Stock unit cannot be empty';
              if (!val.numbersOnly) return 'Stock unit can be numbers only';
            },
          ),
          CustomFormField(
            onSaved: (String value) {
              type = value;
            },
            hintText: 'Type',
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r"[a-zA-Z]+|\s"),
              )
            ],
            validator: (val) {
              if (!val!.isNotEmpty) return 'Self ID cannot be empty';
            },
          ),
          CustomFormField(
            onSaved: (String value) {
              videoURL = value;
            },
            hintText: 'Video URL',
            validator: (val) {
              if (!val!.validURL) return 'Please enter valid URL';
            },
          ),
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            child: InkWell(
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  await widget.postData(formToModel());
                  widget.resetImage();
                  _formKey.currentState!.validate();
                  reset();
                }
              },
              child: Container(
                width: screenWidth * 0.90,
                height: 40,
                color: constant.primaryColor,
                alignment: Alignment.center,
                child: const Text(
                  "Add Product",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void reset() {
    _formKey.currentState!.reset();
  }

  ProductModel formToModel() {
    return ProductModel(brand, name, description, mainImage, priceNumerical,
        selfId, type, stockUnit, videoURL, mainImage, selfId.toString(), false);
  }
}
