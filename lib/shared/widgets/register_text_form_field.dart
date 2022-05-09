import 'package:flutter/material.dart';

class RegisterTextFromField extends StatelessWidget {
  const RegisterTextFromField({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.iconData,
    required this.onChanged,
    required this.onValidation,
    this.initValue
  }) : super(key: key);

  final String? initValue;
  final String labelText;
  final String hintText;
  final IconData? iconData;
  final Function onChanged;
  final Function onValidation;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initValue,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.greenAccent),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
        suffixIcon: Icon(iconData, color: Colors.greenAccent),
        suffixIconColor: Colors.tealAccent,
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(
                color: Colors.greenAccent,
                width: 1
            )
        ),
      ),
      onChanged: (val) => onChanged(val),
      validator: (val) => onValidation(val),
    );
  }
}
