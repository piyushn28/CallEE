import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class topthree extends StatelessWidget {

  final bool large;
  final int index;

  const topthree({Key key,this.large=false,this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Size size = MediaQuery.of(context).size;
    var r = TextStyle(color: Colors.purpleAccent, fontSize: 34);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
            width: large? 40.0:30.0,
            height: large? 40.0:30.0,
          child: Stack(
          children: <Widget>[
          /*  Flexible(child: Container()),
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
            SizedBox(height: 10,), */
           /*
           ClipOval(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(4.0),
                child: ClipOval(
                  child: CircleAvatar(),
                ),
              ),
            ),*/
          /*  Align(
              alignment: Alignment(0.0,0.0),
              child: Container(
                width: 25.0,
                height: 25.0,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                // padding: EdgeInsets.all(8.0),
                child: Center(child: Text(
                  index==2?  "2" : index==3? "3" : "1",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),)),
              ),
            ) */
          ],
          )
        ),
       // Flexible(child: Container()),
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
         Text("Sumit Ojha",
           style: GoogleFonts.raleway(
             fontWeight: FontWeight.bold,
             color: Colors.white,
             fontSize: index==1? 24.0 : 18.0,
           ),
         ),
        Text("20 Points",
        style: GoogleFonts.raleway(
          color: Colors.white,
        ),
        ),
      ],
    );

  }

}