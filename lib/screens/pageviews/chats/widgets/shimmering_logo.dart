import 'package:flutter/material.dart';

class ShimmeringLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.width/7.5,
      width: size.width/7.5,
      child: Image.asset('assets/applogo.png'),
    );
  }
}