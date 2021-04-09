import 'package:cloud_firestore/cloud_firestore.dart';

class Quizzes {
  String batch;
  String branch;
  String createdBy;
  int duration;
  Timestamp endTime;
  String extraMessage;
  int maxMarks;
  int noOfQuestions;
  String quizName;
  String quizUID;
  Timestamp solutionTime;
  Timestamp startTime;
  String subject;
  int year;
  List<dynamic> attemptedBy;

  Quizzes(
      {this.batch,
      this.branch,
      this.createdBy,
      this.duration,
      this.endTime,
      this.extraMessage,
      this.maxMarks,
      this.noOfQuestions,
      this.quizName,
      this.quizUID,
      this.solutionTime,
      this.startTime,
      this.subject,
      this.year,
      this.attemptedBy});

  void setCreatedBy(String createdByUID) {
    this.createdBy = createdByUID;
  }

  void setQuizUID(String quizUID) {
    this.quizUID = quizUID;
  }

  Map toMap(Quizzes quizzes) {
    var data = Map<String, dynamic>();
    data['batch'] = quizzes.batch;
    data['branch'] = quizzes.branch;
    data['createdBy'] = quizzes.createdBy;
    data['duration'] = quizzes.duration;
    data['endTime'] = quizzes.endTime;
    data['extraMessage'] = quizzes.extraMessage;
    data['maxMarks'] = quizzes.maxMarks;
    data['noOfQuestions'] = quizzes.noOfQuestions;
    data['quizName'] = quizzes.quizName;
    data['quizUID'] = quizzes.quizUID;
    data['solutionTime'] = quizzes.solutionTime;
    data['startTime'] = quizzes.startTime;
    data['subject'] = quizzes.subject;
    data['year'] = quizzes.year;
    data['attemptedBy'] = quizzes.attemptedBy;
    return data;
  }

  Quizzes.fromMap(Map<String, dynamic> mapData) {
    this.batch = mapData['batch'];
    this.branch = mapData['branch'];
    this.createdBy = mapData['createdBy'];
    this.duration = mapData['duration'];
    this.endTime = mapData['endTime'];
    this.extraMessage = mapData['extraMessage'];
    this.maxMarks = mapData['maxMarks'];
    this.noOfQuestions = mapData['noOfQuestions'];
    this.quizName = mapData['quizName'];
    this.quizUID = mapData['quizUID'];
    this.solutionTime = mapData['solutionTime'];
    this.startTime = mapData['startTime'];
    this.subject = mapData['subject'];
    this.year = mapData['year'];
    this.attemptedBy = mapData['attemptedBy'];
  }
}
