import 'package:flutter/material.dart';
import 'package:flutterapp/screens/leaderboard/leaderboard_profile.dart';
import 'package:flutterapp/screens/leaderboard/topthree.dart';
import 'package:flutterapp/utils/universal_variables.dart';
import 'package:google_fonts/google_fonts.dart';


class LeaderBoard extends StatefulWidget{
  @override

  _LeaderBoardState createState() => _LeaderBoardState();
}


class _LeaderBoardState extends State<LeaderBoard>{

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        body: Column(
          children: [
            Container(
              height: size.height/2.8,
              child: Stack(
                //   fit: StackFit.expand,
                children: <Widget>[
                  Container(
                    height: size.height/2.8,
                    decoration: BoxDecoration(
                      border: Border.all(
                        //                  color: Color(0xff1F1D2B),
                        color: UniversalVariables.blackColor,
                      ),
                      //   borderRadius: BorderRadius.all(Radius.circular(40)),
                      color: UniversalVariables.blackColor,
                    ),

                  ),
                  Align(
                    alignment: Alignment(-0.9,0.5),
                    child: topthree(
                      index: 2,
                    ),
                  ),
                  Align(
                      alignment: Alignment(0.0,0.0),
                      child: topthree(
                        large: true,
                        index: 1,
                      )
                  ),

                  Align(
                    alignment: Alignment(0.9,0.5),
                    child: topthree(
                      index: 3,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: UniversalVariables.lightPurpleColor.withOpacity(0.2),
            ),
            TabBar(
                indicatorWeight: 2.0,
                indicatorSize: TabBarIndicatorSize.label,
                // indicatorSize: TabB,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.deepPurple,
                tabs: <Widget>[
                  Tab(
                    child: Text(
                      "Current",
                      style: GoogleFonts.raleway(
                        fontSize: 16,
                        color: UniversalVariables.greyColor,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Overall",
                      style: GoogleFonts.raleway(
                        color: UniversalVariables.greyColor,
                        fontSize: 16,
                      ),
                    ),
                  )
                ]
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  Container(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: 30,
                      itemBuilder: (context,index) => leaderboardprofile(
                        index: index + 4,
                      ),
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 10,
                        );
                      },
                    ),
                  ),
                  Container(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: 50,
                      itemBuilder: (context,index) => leaderboardprofile(
                        index: index + 4,
                      ),
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 10,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}