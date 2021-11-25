import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../shared/utils/constants.dart' as constants;

class Loading extends StatelessWidget {
  const Loading({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(
        child: SpinKitWanderingCubes(
          color: constants.Colors.mainColor,
          size: 100.0,
        ),
      ),
    );
  }
}