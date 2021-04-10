import 'package:flutter/material.dart';
import 'package:flutterapp/screens/leaderboard/leader_board.dart';
import 'package:google_fonts/google_fonts.dart';

class TopThree extends StatelessWidget {
  final bool large;
  final int index;
  final NameAndPoints userDetails;

  const TopThree({Key key, this.large = false, this.index, this.userDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var r = TextStyle(color: Colors.purpleAccent, fontSize: 34);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
            width: large ? 40.0 : 30.0,
            height: large ? 40.0 : 30.0,
            child: Stack(
              children: <Widget>[],
            )),
        index == 1
            ? Text("🥇", style: r)
            : index == 2
                ? Text(
                    "🥈",
                    style: r,
                  )
                : index == 3
                    ? Text(
                        "🥉",
                        style: r,
                      )
                    : Text(''),
        Text(
          '${userDetails == null ? 'Loading' : userDetails.name}',
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: index == 1 ? 24.0 : 18.0,
          ),
        ),
        Text(
          "${userDetails == null ? '0' : userDetails.totalMarks.toString()} Points",
          style: GoogleFonts.raleway(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
