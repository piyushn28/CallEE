import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/models/quizAttempted.dart';
import 'package:flutterapp/models/quizQuestions.dart';
import 'package:flutterapp/models/quizzes.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/resources/firebase_methods.dart';
import 'package:flutterapp/screens/quizscreens/answer_question_ui.dart';
import 'package:flutterapp/screens/quizscreens/createQuestions_screen.dart';
import 'package:flutterapp/utils/universal_variables.dart';
import 'package:flutterapp/widgets/appbar.dart';
import 'package:flutterapp/widgets/skype_appbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:random_string/random_string.dart';

class AnswerScreen extends StatefulWidget {
  final Quizzes quiz;
  final User user;

  AnswerScreen(this.user, this.quiz);

  @override
  _AnswerScreenState createState() => _AnswerScreenState();
}

class _AnswerScreenState extends State<AnswerScreen> {
  QuizAttempted userAnswers;

  @override
  void initState() {
    super.initState();
    Firestore.instance
        .collection('users')
        .document(widget.user.uid)
        .collection('quizAttempted')
        .document(widget.quiz.quizUID)
        .get()
        .then((value) {
      userAnswers = QuizAttempted.fromMap(value.data);
      setState(() {});
    });
  }

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
            child: userAnswers == null
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : SingleChildScrollView(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.deepPurpleAccent,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Center(
                              child: FittedBox(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back_ios_rounded,
                                    color: Colors.white,
                                    size: size.width/13,
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: size.height/50),
                        Container(
                          child: Row(
                            children: [
                              Text(
                                "Report | ",
                                style: GoogleFonts.raleway(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35.0,
                                ),
                              ),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${widget.quiz.quizName}",
                                      style: GoogleFonts.raleway(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "${widget.quiz.branch}-${widget.quiz.batch} | ${widget.quiz.extraMessage}",
                                      style: GoogleFonts.raleway(
                                        color: Colors.amber,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                         SizedBox(
                           height: size.height/100,
                         ),
                         Divider(
                          height: 10,
                          thickness: 3,
                          color: UniversalVariables.separatorColor,
                        ),
                        SizedBox(height: 10),
                        FittedBox(
                          child: Container(
                            width: size.width / 1.1,
                            child: RichText(
                              text: TextSpan(
                                  text: 'Correct:',
                                  style: GoogleFonts.raleway(
                                    color: Colors.green,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: ' ${userAnswers.correct}',
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.width/80,
                        ),
                        FittedBox(
                          child: Container(
                            width: size.width / 1.1,
                            child: RichText(
                              text: TextSpan(
                                  text: 'Incorrect:',
                                  style: GoogleFonts.raleway(
                                    color: Colors.red,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    //fontWeight: FontWeight.w400,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: ' ${userAnswers.correct}',
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.width/80,
                        ),
                        FittedBox(
                          child: Container(
                            width: size.width / 1.1,
                            child: RichText(
                              text: TextSpan(
                                  text: 'Unattempted:',
                                  style: GoogleFonts.raleway(
                                    color: Colors.grey,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: ' ${userAnswers.unattempted}',
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                        SizedBox(height: size.height/20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Solutions",
                              style: GoogleFonts.raleway(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 28.0,
                              ),
                            ),
                            Text(
                              "${userAnswers.scoredMarks.round()}/${userAnswers.maxMarks}",
                              style: GoogleFonts.raleway(
                                color: Colors.amber,
                                fontSize: 28,
                              ),
                            ),
                          ],
                        ),
                         Divider(
                          height: 10,
                          thickness: 1,
                          color: UniversalVariables.separatorColor,
                        ),
                        StreamBuilder(
                            stream: Firestore.instance
                                .collection('quizzes')
                                .document(widget.quiz.quizUID)
                                .collection('questions')
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.data == null) {
                                //TODO:change this progress indicator
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

                              return ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (context, index) {
                                  Map<String, dynamic> questionMap =
                                      snapshot.data.documents[index].data;
                                  QuizQuestions question =
                                      QuizQuestions.fromMap(questionMap);

                                  return AnswerUI(
                                    index: index + 1,
                                    userAnswered:
                                        userAnswers.answered[index] == null
                                            ? ''
                                            : userAnswers.answered[index],
                                    questionMark: (userAnswers.maxMarks /
                                            userAnswers.noOfQuestions)
                                        .round(),
                                    question: question,
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return SizedBox(
                                    height: 15,
                                  );
                                },
                              );
                            }),
                        SizedBox(height: size.height / 50),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: new Container(
                            width: size.width / 2,
                            height: size.height / 15,
                            decoration: new BoxDecoration(
                              color: Colors.transparent,
                              border:
                                  Border.all(color: UniversalVariables.separatorColor, width: 2.0),
                              borderRadius: new BorderRadius.circular(50.0),
                            ),
                            child: new Center(
                              child: new Text(
                                'Home',
                                style: new TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: size.height / 50),
                      ],
                    ),
                  ),
          )),
    );
  }
}
