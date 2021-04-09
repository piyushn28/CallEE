import 'package:flutter/material.dart';
import 'package:flutterapp/models/quizQuestions.dart';

//This is a list used while creating quiz questions.
List<QuizQuestions> createQuestionsList = [];

class UniversalVariables {
  static final Color blueColor = Color(0xff2b9ed4);

  static final Color blackColor = Color(0xff1F1D2B);
  static final Color lightPurpleColor = Colors.deepPurple;
  static final Color separatorColor = Color(0xFF323544);
  static final Color highlightColor = Color(0xFF64dfdf);
  static final Color kPrimaryColor = Color(0xFF0C9869);
  static final Color kTextColor = Color(0xFF3C4046);
  static final Color kBackgroundColor = Color(0xFFF9F8FD);

  static final double kkDefaultPadding = 20.0;

  static final Color greyColor = Color(0xff8f8f8f);
  static final Color userCircleBackground = Color(0xff2b2b33);
  static final Color onlineDotColor = Color(0xff46dc64);

  static final Color gradientColorStart = Colors.deepPurpleAccent;
  static final Color gradientColorEnd = Colors.deepPurple;

  static final Color senderColor = Color(0xff2b343b);
  static final Color receiverColor = Color(0xff1e2225);

  static final Gradient fabGradient = LinearGradient(
      colors: [gradientColorStart, gradientColorEnd],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);


  LinearGradient kPrimaryGradient = LinearGradient(begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF46A0AE), Color(0xFF00FFCB)],);



  static final months = {
    1: 'January',
    2: 'February',
    3: 'March',
    4: 'April',
    5: 'May',
    6: 'June',
    7: 'July',
    8: 'August',
    9: 'September',
    10: 'October',
    11: 'November',
    12: 'December'
  };
}
