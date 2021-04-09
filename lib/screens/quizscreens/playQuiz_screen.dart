import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/models/quizQuestions.dart';
import 'package:flutterapp/models/quizzes.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/resources/firebase_methods.dart';
import 'package:flutterapp/screens/home_screen.dart';
import 'package:flutterapp/screens/quizscreens/scoring_screen.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutterapp/utils/universal_variables.dart';
import 'package:lottie/lottie.dart';
import 'package:websafe_svg/websafe_svg.dart';

class PlayQuiz extends StatefulWidget {
  final User user;
  final Quizzes quiz;

  PlayQuiz(this.user, this.quiz);

  @override
  _PlayQuizState createState() => _PlayQuizState();
}

class _PlayQuizState extends State<PlayQuiz> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _questionNo = 1;
  List<String> answerList = [];

  //Variables for option selection.
  bool option1Selected = false;
  bool option2Selected = false;
  bool option3Selected = false;
  bool option4Selected = false;

  PageController _pageController = PageController(initialPage: 0);
  // var questionController = TextEditingController();
  // var option1Controller = TextEditingController();
  // var option2Controller = TextEditingController();
  // var option3Controller = TextEditingController();
  // var option4Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    answerList = List.filled(widget.quiz.noOfQuestions, null);
    option1Selected = false;
    option2Selected = false;
    option3Selected = false;
    option4Selected = false;
  }

  @override
  void dispose() {
    // questionController.dispose();
    // option1Controller.dispose();
    // option2Controller.dispose();
    // option3Controller.dispose();
    // option4Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Quizzes quiz = widget.quiz;
    User user = widget.user;
    Size size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SafeArea(
            child: Column(
              children: [
                //TODO: Adjust timer anywhere.
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height / 15),
                      Text(
                        '${quiz.quizName} Quiz',
                        style: GoogleFonts.raleway(
                          color: Colors.white70,
                          fontSize: 21,
                        ),
                      ),
                      // Priyansh is code ko dekh le ismein question controller laga dena baaki timer ka ui ho gaya
                      //controller se hi page change hoga time khatam hone pr
                      /* Container(
                      width: double.infinity,
                      height: 25,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF3F4768), width: 3),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: GetBuilder<questionController>(
                        init: _pageController(),
                        builder: (controller) {
                          return Stack(
                            children: [
                              LayoutBuilder(
                                builder: (context, constraints) => Container(
                                  // from 0 to 1 it takes 60s
                                  width: constraints.maxWidth * controller.animation.value,
                                  decoration: BoxDecoration(
                                    color: Colors.orangeAccent,
                                    // gradient: kPrimaryGradient,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(" ${(60- controller.animation.value * 60).round()} sec"),
                                      WebsafeSvg.asset("assets/icons/clock.svg"),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ), */
                      SizedBox(height: 5),
                      Text(
                        '${quiz.maxMarks} points',
                        style: GoogleFonts.raleway(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: size.width / 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Question $_questionNo/${quiz.noOfQuestions}',
                            style: GoogleFonts.raleway(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: StreamBuilder(
                      stream: Firestore.instance
                          .collection('quizzes')
                          .document(quiz.quizUID)
                          .collection('questions')
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.data == null) {
                          //Todo:change this progress indicator
                          return Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (snapshot.data.documents.length == 0) {
                          return Column(
                            children: [
                              SizedBox(
                                height: size.height / 7,
                              ),
                              Container(
                                height: size.height / 2.5,
                                width: size.width,
                                child: Center(
                                  child: Lottie.asset(
                                    'assets/tissue.json',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }

                        return PageView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.documents.length,
                          controller: _pageController,
                          onPageChanged: (index) {
                            // questionController = TextEditingController();
                            // option1Controller = TextEditingController();
                            // option2Controller = TextEditingController();
                            // option3Controller = TextEditingController();
                            // option4Controller = TextEditingController();
                            option1Selected = false;
                            option2Selected = false;
                            option3Selected = false;
                            option4Selected = false;
                            if (answerList[index] != null) {
                              option1Selected = answerList[index].contains('1');
                              option2Selected = answerList[index].contains('2');
                              option3Selected = answerList[index].contains('3');
                              option4Selected = answerList[index].contains('4');
                            }
                            setState(() {
                              _questionNo = index + 1;
                            });
                          },
                          itemBuilder: (context, index) {
                            Map<String, dynamic> questionMap =
                                snapshot.data.documents[index].data;
                            QuizQuestions question =
                                QuizQuestions.fromMap(questionMap);

                            return Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    TextFormField(
                                      readOnly: true,
                                      initialValue: question.question,
                                      // controller: questionController,
                                      maxLines: 10,
                                      minLines: 1,
                                      style: GoogleFonts.raleway(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                      cursorColor: Colors.deepPurple,
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.deepPurple,
                                            width: 2.0,
                                          ),
                                        ),
                                        labelText: 'Question',
                                        labelStyle: GoogleFonts.raleway(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white70),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: UniversalVariables
                                                .lightPurpleColor,
                                            width: 3.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: size.width / 15),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          option1Selected = !option1Selected;
                                        });
                                      },
                                      child: optionFormField(
                                        isOptionSelected: option1Selected,
                                        optionText: question.option1,
                                        // optionController: option1Controller,
                                        optionNo: 1,
                                        optionString: 'A',
                                      ),
                                    ),
                                    SizedBox(height: size.width / 22),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          option2Selected = !option2Selected;
                                        });
                                      },
                                      child: optionFormField(
                                        isOptionSelected: option2Selected,
                                        optionText: question.option2,
                                        // optionController: option2Controller,
                                        optionNo: 2,
                                        optionString: 'B',
                                      ),
                                    ),
                                    SizedBox(height: size.width / 22),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          option3Selected = !option3Selected;
                                        });
                                      },
                                      child: optionFormField(
                                        isOptionSelected: option3Selected,
                                        optionText: question.option3,
                                        // optionController: option3Controller,
                                        optionNo: 3,
                                        optionString: 'C',
                                      ),
                                    ),
                                    SizedBox(height: size.width / 22),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          option4Selected = !option4Selected;
                                        });
                                      },
                                      child: optionFormField(
                                        isOptionSelected: option4Selected,
                                        optionText: question.option4,
                                        // optionController: option4Controller,
                                        optionNo: 4,
                                        optionString: 'D',
                                      ),
                                    ),
                                    SizedBox(height: size.height / 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          width: size.width / 2.6,
                                          height: size.height / 13,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(colors: [
                                              UniversalVariables
                                                  .gradientColorStart,
                                              UniversalVariables
                                                  .gradientColorEnd
                                            ]),
                                            color: Colors.deepPurple,
                                            borderRadius:
                                                new BorderRadius.circular(50.0),
                                          ),
                                          child: TextButton(
                                            onPressed: () {
                                              if (_questionNo > 1) {
                                                _pageController.animateToPage(
                                                  index - 1,
                                                  duration: Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.easeOut,
                                                );
                                              } else {
                                                //TODO: Show that user is leaving the quiz.
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: Center(
                                              child: Text(
                                                'Back',
                                                style: GoogleFonts.raleway(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          width: size.width / 2.6,
                                          height: size.height / 13,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(colors: [
                                              UniversalVariables
                                                  .gradientColorStart,
                                              UniversalVariables
                                                  .gradientColorEnd
                                            ]),
                                            color: Colors.deepPurple,
                                            borderRadius:
                                                new BorderRadius.circular(50.0),
                                          ),
                                          child: TextButton(
                                            onPressed: () {
                                              if (!option1Selected &&
                                                  !option2Selected &&
                                                  !option3Selected &&
                                                  !option4Selected) {
                                                //TODO: Add Toast to select min 1 option.
                                                print(
                                                    'Select at least 1 option');
                                                return;
                                              } else {
                                                String options = '';
                                                if (option1Selected) {
                                                  options = options + '1';
                                                }
                                                if (option2Selected) {
                                                  options = options + '2';
                                                }
                                                if (option3Selected) {
                                                  options = options + '3';
                                                }
                                                if (option4Selected) {
                                                  options = options + '4';
                                                }
                                                answerList[_questionNo - 1] =
                                                    options;
                                                print(answerList);

                                                if (_questionNo ==
                                                    quiz.noOfQuestions) {
                                                  double eachQuestionPoint =
                                                      quiz.maxMarks /
                                                          quiz.noOfQuestions;
                                                  double userMarks = 0.0;
                                                  int correctAnswers = 0;
                                                  int incorrectAnswers = 0;
                                                  int unattempted = 0;
                                                  for (int i = 0;
                                                      i < quiz.noOfQuestions;
                                                      i++) {
                                                    if (answerList[i] == null) {
                                                      unattempted++;
                                                    } else if (answerList[i] ==
                                                        question
                                                            .correctOption) {
                                                      userMarks = userMarks +
                                                          eachQuestionPoint;
                                                      correctAnswers++;
                                                    } else {
                                                      incorrectAnswers++;
                                                    }
                                                  }
                                                  print(userMarks);

                                                  FirebaseMethods()
                                                      .updateUserTotalMarks(
                                                          user, userMarks)
                                                      .then((value) {
                                                    print(value);

                                                    //TODO: Goes to scoring screen.
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                Scoringscreen(
                                                                    userMarks,
                                                                    quiz.maxMarks)));
                                                  });
                                                } else {
                                                  _pageController.animateToPage(
                                                    index + 1,
                                                    duration: Duration(
                                                        milliseconds: 500),
                                                    curve: Curves.easeIn,
                                                  );
                                                }
                                              }
                                            },
                                            child: Center(
                                              child: Text(
                                                _questionNo ==
                                                        quiz.noOfQuestions
                                                    ? 'Submit'
                                                    : 'Save &\nContinue',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.raleway(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: size.height / 15,
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget optionFormField({
  @required bool isOptionSelected,
  @required String optionText,
  // TextEditingController optionController,
  int optionNo,
  String optionString,
}) {
  return Row(
    children: [
      Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isOptionSelected
              ? Colors.deepPurple
              : UniversalVariables.separatorColor,
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
        ),
        child: Center(
          child: Text(
            optionString,
            style: GoogleFonts.raleway(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
      SizedBox(width: 10),
      Expanded(
        child: TextFormField(
          readOnly: true,
          initialValue: optionText,
          // controller: optionController,
          maxLines: 10,
          minLines: 1,
          style: GoogleFonts.raleway(
              fontWeight: FontWeight.w600, color: Colors.white),
          cursorColor: Colors.deepPurple,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
              borderSide: BorderSide(
                color: isOptionSelected
                    ? Colors.deepPurple
                    : UniversalVariables.separatorColor,
                width: 3.0,
              ),
            ),
            filled: true,
            fillColor: Color(0xFF17151B),
            labelText: 'Option $optionNo',
            labelStyle: GoogleFonts.raleway(
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
              borderSide: BorderSide(
                color: UniversalVariables.separatorColor,
                width: 3.0,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
