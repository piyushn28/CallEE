import 'package:flutter/material.dart';
import 'package:flutterapp/utils/universal_variables.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../search_screen.dart';


class QuietBox extends StatelessWidget {
  final String heading;
  final String subtitle;

  QuietBox({
    @required this.heading,
    @required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          color: UniversalVariables.separatorColor,
          padding: EdgeInsets.symmetric(vertical: 35, horizontal: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                heading,
                textAlign: TextAlign.center,
                style: GoogleFonts.raleway(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 25
                ),
              ),
              SizedBox(height: 25),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.raleway(
                    letterSpacing: 1.2,
                    color: Colors.white,
                    //fontWeight: FontWeight.w700,
                    fontSize: 15
                ),
              ),
              SizedBox(height: 25),
              FlatButton(
                color: UniversalVariables.lightPurpleColor,
                child: Text("START SEARCHING",
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    color: Colors.white70),),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}