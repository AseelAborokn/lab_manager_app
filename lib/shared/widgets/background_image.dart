///@nodoc
import 'package:flutter/material.dart';

BoxDecoration backGroundImage() {
  return const BoxDecoration(
      image: DecorationImage(
        image: AssetImage("lib/shared/assets/images/lab2modified.jpg"),
        fit: BoxFit.cover,
      )
  );
}
