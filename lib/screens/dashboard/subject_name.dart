import 'package:flutter/material.dart';


class subjectname extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Container(
        height: 35,
        width: 120,
        decoration: BoxDecoration(
          color: Colors.lightBlueAccent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0),
            bottomRight: Radius.circular(8.0),
            bottomLeft: Radius.circular(8.0),
          ),
        ),
        child: Text(
          ' #physics ',
          overflow: TextOverflow.visible,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 24.0,
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 0, 0, 0),
            /* letterSpacing: 0.0, */
          ),
        )
    );
  }
}