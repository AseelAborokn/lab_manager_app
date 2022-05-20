import 'package:flutter/material.dart';

BoxDecoration BackGroundImage() {
  return const BoxDecoration(
      image: DecorationImage(
        image: AssetImage("lib/shared/assets/images/lab2.jpg"),
        fit: BoxFit.cover,
      )
  );
}
