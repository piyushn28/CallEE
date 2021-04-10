import 'package:cloud_firestore/cloud_firestore.dart';

class QuizAttempted {
  List<dynamic> answered;
  int correct;
  int incorrect;
  int maxMarks;
  Timestamp startedOn;
  String quizUID;
  int remainingTime;
  double scoredMarks;
  Timestamp submittedOn;
  int unattempted;
  int noOfQuestions;

  QuizAttempted({
    this.answered,
    this.correct,
    this.incorrect,
    this.maxMarks,
    this.startedOn,
    this.quizUID,
    this.remainingTime,
    this.scoredMarks,
    this.submittedOn,
    this.unattempted,
    this.noOfQuestions,
  });

  Map toMap(QuizAttempted quiz) {
    var data = Map<String, dynamic>();
    data['answered'] = quiz.answered;
    data['correct'] = quiz.correct;
    data['incorrect'] = quiz.incorrect;
    data['maxMarks'] = quiz.maxMarks;
    data['startedOn'] = quiz.startedOn;
    data['quizUID'] = quiz.quizUID;
    data['remainingTime'] = quiz.remainingTime;
    data['scoredMarks'] = quiz.scoredMarks;
    data['submittedOn'] = quiz.submittedOn;
    data['unattempted'] = quiz.unattempted;
    data['noOfQuestions'] = quiz.noOfQuestions;

    return data;
  }

  QuizAttempted.fromMap(Map<String, dynamic> mapData) {
    this.noOfQuestions = mapData['noOfQuestions'];
    this.answered = mapData['answered'];
    this.correct = mapData['correct'];
    this.incorrect = mapData['incorrect'];
    this.maxMarks = mapData['maxMarks'];
    this.startedOn = mapData['opened'];
    this.remainingTime = mapData['remainingTime'];
    this.scoredMarks = mapData['scoredMarks'];
    this.submittedOn = mapData['submittedOn'];
    this.quizUID = mapData['quizUID'];
    this.unattempted = mapData['unattempted'];
  }
}
