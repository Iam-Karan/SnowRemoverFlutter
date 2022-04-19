import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    Key? key,
    required this.hintText,
    this.inputFormatters,
    this.validator,
    required this.onSaved,
   required this.keypad,
  }) : super(key: key);
  final String hintText;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final Function onSaved;
  final bool keypad ;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(

      keyboardType: keypad ? TextInputType.number : TextInputType.streetAddress,
        onSaved: (newValue) => onSaved(newValue),
        inputFormatters: inputFormatters,
        validator: validator,
        // decoration: InputDecoration(hintText: hintText),
        decoration: InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(),
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 5))),
      ),
    );
  }
}

class FormBuilderValidators {
}
