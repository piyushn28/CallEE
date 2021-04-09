import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutterapp/utils/universal_variables.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        height: size.height/16,
        decoration: BoxDecoration(
           color: UniversalVariables.separatorColor,
          borderRadius: BorderRadius.circular(29.5),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(size.width/50,0,0,0),
          child: Center(
            child: TextFormField(
              style: GoogleFonts.raleway(
                letterSpacing: 1.2,
                color: Colors.white,
                fontSize: 18
              ),
              decoration: InputDecoration(
                  counterStyle: TextStyle(
                    letterSpacing: 1.2,
                    color: Colors.white,
                  ),
                  labelStyle: GoogleFonts.raleway(
                    color: Colors.white,
                  ),
                hintText: "Search Quiz",
                hintStyle: GoogleFonts.raleway(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 20.0,
               //   fontWeight: FontWeight.bold,
                ),
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search_sharp,
                  size: size.width/15,
                  color: Colors.white,
                )
              ),
            ),
          ),
        ),

    );
  }
}