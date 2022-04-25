import 'package:flutter/material.dart';

getInputDecoration(String hintText) => InputDecoration(
  hintText: hintText,
  fillColor: Colors.white,
  filled: true,
  enabledBorder: const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0)
  ),
  focusedBorder: const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 2.0)
  ),
);
