import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutterapp/models/quizAttempted.dart';
import 'package:flutterapp/models/quizQuestions.dart';
import 'package:flutterapp/models/quizzes.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/resources/firebase_methods.dart';
import 'package:flutterapp/screens/home_screen.dart';
import 'package:flutterapp/screens/quizscreens/scoring_screen.dart';
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
  QuizAttempted quizAttempted = QuizAttempted();

  //Variables for option selection.
  bool option1Selected = false;
  bool option2Selected = false;
  bool option3Selected = false;
  bool option4Selected = false;

  PageController pageController = PageController(initialPage: 0);

  //Below is for timer.
  CountdownTimerController timeController;
  int endTime;
  int duration;

  double userMarks = 0.0;
  int correctAnswers = 0;
  int incorrectAnswers = 0;
  int unattempted = 0;

  @override
  void initState() {
    super.initState();
    answerList = List.filled(widget.quiz.noOfQuestions, null);
    option1Selected = false;
    option2Selected = false;
    option3Selected = false;
    option4Selected = false;
    duration = (widget.quiz.duration * 60);
    endTime = DateTime.now().millisecondsSinceEpoch +
        (1000 * (widget.quiz.duration * 60));
    quizAttempted.startedOn = Timestamp.now();
    timeController = CountdownTimerController(
      endTime: endTime,
      onEnd: onTimerEnd,
    );
  }

  @override
  void dispose() {
    timeController.dispose();
    super.dispose();
  }

  void onTimerEnd() {
    for (int i = 0; i < widget.quiz.noOfQuestions; i++) {
      if (answerList[i] == null) {
        unattempted++;
      }
    }
    onQuizEnd();
  }

  void onQuizEnd() {
    FirebaseMethods()
        .updateUserTotalMarks(widget.user, userMarks)
        .then((value) {
      print(value);

      quizAttempted.answered = answerList;
      quizAttempted.correct = correctAnswers;
      quizAttempted.incorrect = incorrectAnswers;
      quizAttempted.scoredMarks = userMarks;
      quizAttempted.unattempted = unattempted;
      FirebaseMethods()
          .addQuizAnswered(widget.quiz, quizAttempted, widget.user)
          .then((value) {
        print('Answers Stored');
      });

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              Scoringscreen(userMarks, widget.quiz.maxMarks)));
    });
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
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${quiz.quizName} Quiz',
                        style: GoogleFonts.raleway(
                          color: Colors.white70,
                          fontSize: 21,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        height: 25,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xFF3F4768), width: 3),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: CountdownTimer(
                          endTime: endTime,
                          controller: timeController,
                          onEnd: onTimerEnd,
                          widgetBuilder: (context, remainingTime) {
                            return Stack(
                              children: [
                                LayoutBuilder(
                                  builder: (context, constraints) => Container(
                                    width: size.width *
                                        (remainingTime == null
                                            ? 0
                                            : ((((remainingTime.min == null
                                                            ? 0.0
                                                            : remainingTime
                                                                .min) *
                                                        60) +
                                                    (remainingTime.sec == null
                                                        ? 0.0
                                                        : remainingTime.sec)) /
                                                duration)),
                                    decoration: BoxDecoration(
                                      color: remainingTime == null
                                          ? Colors.red
                                          : (((((remainingTime.min == null
                                                                  ? 0.0
                                                                  : remainingTime
                                                                      .min) *
                                                              60) +
                                                          (remainingTime.sec ==
                                                                  null
                                                              ? 0.0
                                                              : remainingTime
                                                                  .sec)) /
                                                      duration) >
                                                  0.6
                                              ? Colors.green
                                              : ((((remainingTime.min == null
                                                                      ? 0.0
                                                                      : remainingTime
                                                                          .min) *
                                                                  60) +
                                                              (remainingTime
                                                                          .sec ==
                                                                      null
                                                                  ? 0.0
                                                                  : remainingTime
                                                                      .sec)) /
                                                          duration) >
                                                      0.2
                                                  ? Colors.orange
                                                  : Colors.red),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          " ${remainingTime == null ? '00' : (remainingTime.min == null ? '00' : remainingTime.min)}:${remainingTime == null ? '00' : (remainingTime.sec == null ? '00' : remainingTime.sec)} min",
                                          style: GoogleFonts.raleway(
                                            color: Colors.white,
                                          ),
                                        ),
                                        WebsafeSvg.asset(
                                            "assets/icons/clock.svg"),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
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
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.documents.length,
                          controller: pageController,
                          onPageChanged: (index) {
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
                                    SizedBox(height: size.height / 25),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                              double eachQuestionPoint =
                                                  quiz.maxMarks /
                                                      quiz.noOfQuestions;

                                              if (answerList[_questionNo - 1] ==
                                                      null ||
                                                  answerList[_questionNo - 1] ==
                                                      '') {
                                                unattempted++;
                                              } else if (answerList[
                                                      _questionNo - 1] ==
                                                  question.correctOption) {
                                                userMarks = userMarks +
                                                    eachQuestionPoint;
                                                correctAnswers++;
                                              } else {
                                                incorrectAnswers++;
                                              }

                                              print(userMarks);

                                              if (_questionNo ==
                                                  quiz.noOfQuestions) {
                                                onQuizEnd();
                                                timeController.dispose();
                                              } else {
                                                pageController.animateToPage(
                                                  index + 1,
                                                  duration: Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.easeIn,
                                                );
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
