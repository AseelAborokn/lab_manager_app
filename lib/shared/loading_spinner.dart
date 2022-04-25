import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingSpinner extends StatelessWidget {
  const LoadingSpinner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green.shade300,
      child: const Center(
        child: SpinKitSpinningLines(
          color: Colors.black,
          size: 50.0,
        ),
      ),
    );
  }
}
