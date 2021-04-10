import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/provider/user_provider.dart';
import 'package:flutterapp/screens/Dashboard/create_quiz.dart';
import 'package:flutterapp/screens/Dashboard/dashboard_constant.dart';
import 'package:flutterapp/screens/Dashboard/search_bar_dashboard.dart';
import 'package:flutterapp/screens/Dashboard/leaderboard_container.dart';
import 'package:flutterapp/screens/Dashboard/stuck_card.dart';
import 'package:flutterapp/screens/Dashboard/subject_category.dart';
import 'package:flutterapp/screens/leaderboard/leader_board.dart';
import 'package:flutterapp/utils/universal_variables.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutterapp/utils/utilities.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TeacherNoQuizDashboard extends StatefulWidget {
  @override
  _TeacherNoQuizDashboardState createState() => _TeacherNoQuizDashboardState();
}

class _TeacherNoQuizDashboardState extends State<TeacherNoQuizDashboard> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context)
        .size; //this gonna give us total height and with of our device
    return Scaffold(
      // bottomNavigationBar: BottomNavBar(),
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height,
            decoration: BoxDecoration(
              color: Colors.black,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      alignment: Alignment.center,
                      height: size.height / 20,
                      width: size.width / 20,
                      decoration: BoxDecoration(
                        //   color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset("assets/stuteach/sumitasd_ojha.png"),
                    ),
                  ),
                  Text(
                    "23 March",
                    style: GoogleFonts.raleway(
                        color: Colors.grey,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Hi,Sumit!",
                    style: GoogleFonts.raleway(
                      color: Colors.white,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SearchBar(),
                  SizedBox(
                    height: size.height / 70,
                  ),
                  SizedBox(
                    height: size.height / 70,
                  ),
                  SizedBox(
                    height: size.height / 70,
                  ),
                  SizedBox(
                    height: size.height / 70,
                  ),
                  SizedBox(
                    height: size.height / 70,
                  ),
                  SizedBox(
                    height: size.height / 70,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 0.0),
                    height: size.height / 4,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        Container(
                          width: size.width / 1.15,
                          child: CreateQuizCard(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height / 70,
                  ),
                  SizedBox(
                    height: size.height / 70,
                  ),
                  SizedBox(
                    height: size.height / 70,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 0.0),
                    height: size.height / 4,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        Container(
                          width: size.width / 1.15,
                          child: LeaderBoardCard(
                            press: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => LeaderboardUI()));
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
