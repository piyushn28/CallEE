import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutterapp/models/quizzes.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/resources/firebase_methods.dart';
import 'package:flutterapp/screens/Dashboard/dashboard_constant.dart';
import 'package:flutterapp/screens/Dashboard/subject_name.dart';
import 'package:flutterapp/screens/quizscreens/answers_scoring_screen.dart';
import 'package:flutterapp/screens/quizscreens/playQuiz_screen.dart';
import 'package:flutterapp/utils/universal_variables.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryCard extends StatelessWidget {
  final String svgSrc;
  final String title;
  final Function press;
  final Quizzes quiz;
  final User user;

  const CategoryCard({
    Key key,
    @required this.quiz,
    this.user,
    this.svgSrc,
    this.title,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        print('ghusa');
        if (quiz.createdBy == user.uid) {
          //TODO: open other page for created by user. Show toast for now.
          print('quiz is created by you only.');
        } else if (quiz.attemptedBy.contains(user.uid)) {
          print('You have already attempted the quiz.');
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AnswerScreen(this.user, this.quiz),
            ),
          );
        } else {
          FirebaseMethods()
              .updateQuizAttemptedBy(user, quiz)
              .then((value) => print(value));
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PlayQuiz(user, quiz),
            ),
          );
        }
      },
      child: Container(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, size.width / 23, 0, 0),
              child: Transform.rotate(
                angle: -3.141592653589 / (size.width / 20),
                child: Container(
                  height: size.width / 18,
                  width: size.width / 3.6,
                  decoration: BoxDecoration(
                      color: UniversalVariables.blueColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        //TODO: Reduce size if text is large.
                        quiz != null ? '#${quiz.subject}' : 'No Subject',
                        style: GoogleFonts.raleway(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(size.width / 25, 0, 0, 0),
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFFFFFF).withOpacity(0.3),
                      UniversalVariables.separatorColor.withOpacity(0.3),
                      UniversalVariables.senderColor.withOpacity(0.3)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15.0),
                  color: UniversalVariables.separatorColor.withOpacity(0.5),
                ),
                width: size.width / 2,
                height: size.height / 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${quiz.startTime.toDate().day} ${UniversalVariables.months[quiz.startTime.toDate().month]}, ${quiz.startTime.toDate().hour}:${quiz.startTime.toDate().minute}',
                      style: GoogleFonts.montserrat(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '${quiz.quizName}',
                      style: GoogleFonts.raleway(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '${quiz.branch}-${quiz.batch} | ${quiz.maxMarks} marks',
                      style: GoogleFonts.montserrat(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          quiz.createdBy.contains(user.uid)
                              ? '🕒 ${quiz.attemptedBy.length - 1} Attempted'
                              : quiz.attemptedBy.contains(user.uid)
                                  ? 'Attempted'
                                  : '🕒 ${quiz.duration} mintues',
                          style: GoogleFonts.montserrat(
                            color: quiz.createdBy.contains(user.uid)
                                ? Colors.grey
                                : quiz.attemptedBy.contains(user.uid)
                                    ? Colors.green
                                    : Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.play_arrow,
                            color: UniversalVariables.blueColor,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
