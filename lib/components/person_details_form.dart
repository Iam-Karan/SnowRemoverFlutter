import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snow_remover/constant.dart' as constant;
import 'package:snow_remover/models/Person.dart';
import 'package:snow_remover/models/product_model.dart';
import 'package:snow_remover/validaiton_extension.dart';
import 'custom_form_field.dart';

class PersonDetailsForm extends StatefulWidget {
  final Function resetImage;
  final Function postData;
  const PersonDetailsForm(
      {Key? key, required this.resetImage, required this.postData})
      : super(key: key);

  @override
  State<PersonDetailsForm> createState() => _PersonDetailsFormState();
}

class _PersonDetailsFormState extends State<PersonDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  String name = "";
  String description = "";
  int age = 0;
  String mainImage = "";
  double priceNumerical = 0;
  int orders_completed = 0;
  int personId = 0;
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
            keypad: false,
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
            hintText: 'Orders completed',
            onSaved: (String value) {
              orders_completed = int.parse(value);
            },
            keypad: false,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'\d'),
              )
            ],
            validator: (val) {
              if (!val!.isNotEmpty) return 'Orders completed cannot be empty';
              if (!val.numbersOnly) {
                return 'Orders completed can be numbers only';
              }
            },
          ),
          CustomFormField(
            onSaved: (String value) {
              priceNumerical = double.parse(value);
            },
            keypad: true,
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
              personId = int.parse(value);
            },
            keypad: false,
            hintText: 'person ID',
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'\d'),
              )
            ],
            validator: (val) {
              if (!val!.isNotEmpty) return 'person ID cannot be empty';
              if (!val.numbersOnly) return 'person ID can be numbers only';
            },
          ),
          CustomFormField(
            onSaved: (String value) {
              age = int.parse(value);
            },
            keypad: true,
            hintText: 'age',
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'\d'),
              )
            ],
            validator: (val) {
              if (!val!.isNotEmpty) return 'age cannot be empty';
              if (!val.numbersOnly) return 'age can be numbers only';
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
                  // _formKey.currentState!.validate();
                  reset();
                }
              },
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
        ],
      ),
    );
  }

  void reset() {
    _formKey.currentState!.reset();
  }

  person formToModel() {
    return person(priceNumerical, age, description, personId.toString(),
        mainImage, name, personId, false, orders_completed);
  }
}
