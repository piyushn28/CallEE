import 'package:flutter/material.dart';
import 'package:flutterapp/models/quizzes.dart';
import 'package:flutterapp/resources/firebase_methods.dart';
import 'package:flutterapp/screens/home_screen.dart';
import 'package:flutterapp/screens/leaderboard/leaderboardUI.dart';
import 'package:flutterapp/screens/quizscreens/createQuestions_screen.dart';
import 'package:flutterapp/utils/universal_variables.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_string/random_string.dart';

class Scoringscreen extends StatefulWidget {
  final int maxMarks;
  final double userMarks;

  Scoringscreen(this.userMarks, this.maxMarks);

  @override
  _ScoringscreenState createState() => _ScoringscreenState();
}

class _ScoringscreenState extends State<Scoringscreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()),
                              (route) => false);
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: FittedBox(
                              child: IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                  size: size.width / 13,
                                ),
                                onPressed: () => Navigator.of(context)
                                    .pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => HomeScreen()),
                                        (route) => false),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height / 40),
                  Container(
                      width: MediaQuery.of(context).size.width / 1.4,
                      height: size.height / 3.8,
                      child: Image.asset(
                        "assets/stuteach/award.png",
                        fit: BoxFit.contain,
                      )),
                  SizedBox(height: size.height / 30),
                  Center(
                    child: Text(
                      "Congratulations",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.raleway(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height / 40),
                  Center(
                    child: Text(
                      "You have completed the quiz.But the fun is not over!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.raleway(
                        color: Colors.grey,
                        fontSize: 18.0,
                        //fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Check out your rank on leaderboard",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.raleway(
                        color: Colors.grey,
                        fontSize: 18.0,
                        //fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height / 40),
                  Center(
                    child: Text(
                      "YOUR SCORE",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.raleway(
                        letterSpacing: 2.2,
                        color: Colors.grey,
                        fontSize: 18.0,
                        //fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height / 50),
                  Center(
                    child: FittedBox(
                      child: Container(
                        width: size.width / 1.1,
                        child: Center(
                          child: RichText(
                            text: TextSpan(
                                text: widget.userMarks.toString(),
                                style: GoogleFonts.raleway(
                                  color: Colors.deepPurple,
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                  //fontWeight: FontWeight.w400,
                                ),
                                children: [
                                  TextSpan(
                                    text: '/${widget.maxMarks.toString()}',
                                    style: GoogleFonts.raleway(
                                      color: Colors.white,
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height / 20),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LeaderboardUI()));
                    },
                    child: new Container(
                      width: size.width / 1.4,
                      height: size.height / 13,
                      decoration: new BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        //    border: new Border.all(color: Colors.white, width: 2.0),
                        borderRadius: new BorderRadius.circular(50.0),
                      ),
                      child: new Center(
                        child: new Text(
                          'Leaderboard',
                          style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height / 50),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                          (route) => false);
                    },
                    child: new Container(
                      width: size.width / 1.4,
                      height: size.height / 13,
                      decoration: new BoxDecoration(
                        color: Colors.transparent,
                        //    border: new Border.all(color: Colors.white, width: 2.0),
                        borderRadius: new BorderRadius.circular(50.0),
                      ),
                      child: new Center(
                        child: new Text(
                          'Home',
                          style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
