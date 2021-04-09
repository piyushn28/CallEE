import 'package:flutter/material.dart';
import 'package:flutterapp/screens/pageviews/chats/widgets/user_circle.dart';
import 'package:flutterapp/utils/universal_variables.dart';
import 'package:google_fonts/google_fonts.dart';


class leaderboardprofile extends StatelessWidget{
  final int index;
  const leaderboardprofile({Key key,this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Size size = MediaQuery.of(context).size;
    // width: size.width,
    // height: size.height,
    var r = TextStyle(color: Colors.purpleAccent, fontSize: 34);
    return Row(
      children: [
        Container(
          alignment: Alignment.center,
          height: size.height/12,
          width: size.width/9,
          decoration: BoxDecoration(
            border: Border.all(
              color: UniversalVariables.blackColor,
              //   color: Color(0xff1F1D2B),
            ),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.transparent,
            //  color: Colors.white,
          ),
          child: Text("$index",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              //    color: Color(0xff1F1D2B),
              fontSize: 18.0,
            ),
          ),
        ),
        Container(
          height: size.height/13.5,
          width:  size.width - size.width/7.5,
          decoration: BoxDecoration(
            border: Border.all(
              color: UniversalVariables.separatorColor,
              // color: Color(0xff1F1D2B),
            ),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: UniversalVariables.separatorColor,
            //  color: Colors.grey,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                //   SizedBox(width: size.height/13.5,),
                Padding(
                  // padding: const EdgeInsets.only(left: 8.0),
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: CircleAvatar(),
                  //    child:   UserCircle(),
                ),
                SizedBox(width: size.width/25,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 12,),
                    Text("Sumit Ojha",
                      style: GoogleFonts.raleway(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                          color: Colors.white
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text("20 points",
                    style: GoogleFonts.raleway(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

}