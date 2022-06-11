///@nodoc
import 'package:flutter/material.dart';

class ReadOnlyRegisterTextFromField extends StatelessWidget {
  const ReadOnlyRegisterTextFromField({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.iconData,
    this.initValue
  }) : super(key: key);

  final String? initValue;
  final String labelText;
  final String hintText;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initValue,
      readOnly: true,
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
    );
  }
}
