import 'package:flutter/material.dart';
import 'package:flutterapp/models/quizzes.dart';
import 'package:flutterapp/resources/firebase_methods.dart';
import 'package:flutterapp/screens/quizscreens/answer_question_ui.dart';
import 'package:flutterapp/screens/quizscreens/createQuestions_screen.dart';
import 'package:flutterapp/utils/universal_variables.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_string/random_string.dart';

class answerscreen extends StatefulWidget {
  @override
  _answerscreenState createState() => _answerscreenState();
}

class _answerscreenState extends State<answerscreen> {
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
           // child: Container(
              padding: EdgeInsets.all(12.0),
              child: Column(
                children: [
                  SizedBox(height: size.height / 20),
                 /* Row(
                    children: [
                      SizedBox(
                        width: size.width / 20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: size.width / 1.4,
                            right: 0,
                            top: size.width / 35,
                            bottom: 0),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
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
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ), */
                  Align(
                    alignment: Alignment.centerLeft,
                      child: new Text("Report",
                        style: GoogleFonts.raleway(
                         // letterSpacing: 2.2,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 36.0,
                          //fontWeight: FontWeight.w400,
                        ),
                      )
                  ),
                  const Divider(
                    height: 10,
                    thickness: 1
                  ),
                  SizedBox(height: size.height / 40),
                  FittedBox(
                    child: Container(
                      width: size.width / 1.1,
                        child: RichText(
                          text: TextSpan(
                              text: 'Correct:',
                              style: GoogleFonts.raleway(
                                color: Colors.green,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                //fontWeight: FontWeight.w400,
                              ),
                              children: [
                                TextSpan(
                                  text: ' 10',
                                  style: GoogleFonts.raleway(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ),
                  FittedBox(
                    child: Container(
                      width: size.width / 1.1,
                        child: RichText(
                          text: TextSpan(
                              text: 'InCorrect:',
                              style: GoogleFonts.raleway(
                                color: Colors.red,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                //fontWeight: FontWeight.w400,
                              ),
                              children: [
                                TextSpan(
                                  text: ' 10',
                                  style: GoogleFonts.raleway(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ]),
                        ),
                    ),
                  ),
                  SizedBox(height: size.height / 20),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: new Text("Solutions",
                        style: GoogleFonts.raleway(
                          // letterSpacing: 2.2,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 36.0,
                          //fontWeight: FontWeight.w400,
                        ),
                      )
                  ),
                  const Divider(
                      height: 10,
                      thickness: 1
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: 5,
                    itemBuilder: (context,index) => answerui(
                      index: index +1,
                    ),
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 15,
                      );
                    },
                  ),
                  SizedBox(height: size.height / 50),
                  InkWell(
                    onTap: () {},
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
          )
      ),

        );

  }
}