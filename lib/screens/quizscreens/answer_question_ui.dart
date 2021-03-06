import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/models/quizAttempted.dart';
import 'package:flutterapp/models/quizQuestions.dart';
import 'package:flutterapp/screens/pageviews/chats/widgets/user_circle.dart';
import 'package:flutterapp/utils/universal_variables.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';

class AnswerUI extends StatelessWidget {
  final int index;
  final String userAnswered;
  final QuizQuestions question;
  final int questionMark;
  const AnswerUI(
      {Key key,
      this.index,
      this.userAnswered,
      this.question,
      this.questionMark})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool answeredCorrect = userAnswered == question.correctOption;

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: size.height / 1.4,
          width: size.width / 1.05,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.transparent,
          ),
          child: Column(
            children: <Widget>[
              SizedBox(height: size.height / 40),
              Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "$index.",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 22.0,
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: answeredCorrect ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Center(
                      child: Text(
                        answeredCorrect ? '+$questionMark' : '+0',
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              //SizedBox(height: size.height / 120),
              Expanded(
                flex: 2,
                child: Container(
                  width: size.width / 1.25,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.transparent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    color: Colors.transparent,
                  ),
                  child: AutoSizeText(
                    '${question.question}',
                    style: GoogleFonts.raleway(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                        color: Colors.white),
                    maxLines: 12,
                  ),
                ),
              ),
              Container(
                height: size.height/12,
                width: size.width / 1.3,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: question.correctOption.contains('1')
                        ? Colors.green
                        : userAnswered.contains('1')
                            ? Colors.red
                            : Colors.deepPurple,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: Colors.transparent,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[

                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: question.correctOption.contains('1')
                              ? Colors.green
                              : userAnswered.contains('1')
                                  ? Colors.red
                                  : Colors.deepPurple,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Center(
                          child: Text(
                            'A',
                            style: GoogleFonts.raleway(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width / 50,
                      ),
                      Text(
                        '${question.option1}',
                        style: GoogleFonts.raleway(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height / 40),
              Container(
                height: size.height/12,
                width: size.width / 1.3,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: question.correctOption.contains('2')
                        ? Colors.green
                        : userAnswered.contains('2')
                            ? Colors.red
                            : Colors.deepPurple,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: Colors.transparent,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: question.correctOption.contains('2')
                              ? Colors.green
                              : userAnswered.contains('2')
                                  ? Colors.red
                                  : Colors.deepPurple,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Center(
                          child: Text(
                            'B',
                            style: GoogleFonts.raleway(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width / 50,
                      ),
                      Text(
                        '${question.option2}',
                        style: GoogleFonts.raleway(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height / 40),
              Container(
                height: size.height/12,
                width: size.width / 1.3,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: question.correctOption.contains('3')
                        ? Colors.green
                        : userAnswered.contains('3')
                            ? Colors.red
                            : Colors.deepPurple,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: Colors.transparent,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: question.correctOption.contains('3')
                              ? Colors.green
                              : userAnswered.contains('3')
                                  ? Colors.red
                                  : Colors.deepPurple,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Center(
                          child: Text(
                            'C',
                            style: GoogleFonts.raleway(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width / 50,
                      ),
                      Text(
                        '${question.option3}',
                        style: GoogleFonts.raleway(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height / 40),
              Container(
                height: size.height/12,
                width: size.width / 1.3,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: question.correctOption.contains('4')
                        ? Colors.green
                        : userAnswered.contains('4')
                            ? Colors.red
                            : Colors.deepPurple,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: Colors.transparent,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: question.correctOption.contains('4')
                              ? Colors.green
                              : userAnswered.contains('4')
                                  ? Colors.red
                                  : Colors.deepPurple,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Center(
                          child: Text(
                            'D',
                            style: GoogleFonts.raleway(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width / 50,
                      ),
                      Text(
                        '${question.option4}',
                        style: GoogleFonts.raleway(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height / 40),
            ],
          ),
        ),
      ],
    );
  }
}
