import 'package:flutter/material.dart';
import 'package:flutterapp/screens/leaderboard/leader_board.dart';
import 'package:flutterapp/screens/pageviews/chats/widgets/user_circle.dart';
import 'package:flutterapp/utils/universal_variables.dart';
import 'package:google_fonts/google_fonts.dart';

class Leaderboardprofile extends StatelessWidget {
  final int index;
  final NameAndPoints userDetails;
  const Leaderboardprofile({Key key, this.index, this.userDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    var r = TextStyle(color: Colors.purpleAccent, fontSize: 34);
    return Row(
      children: [
        Container(
          alignment: Alignment.center,
          height: size.height / 12,
          width: size.width / 9,
          decoration: BoxDecoration(
            border: Border.all(
              color: UniversalVariables.blackColor,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.transparent,
          ),
          child: Text(
            "$index",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ),
        Container(
          height: size.height / 13.5,
          width: size.width - size.width / 7.5,
          decoration: BoxDecoration(
            border: Border.all(
              color: UniversalVariables.separatorColor,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: UniversalVariables.separatorColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: CircleAvatar(),
                ),
                SizedBox(
                  width: size.width / 25,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      '${userDetails == null ? 'Loading' : userDetails.name}',
                      style: GoogleFonts.raleway(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                          color: Colors.white),
                    ),
                  ],
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    "${userDetails == null ? '0' : userDetails.totalMarks} Points",
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
