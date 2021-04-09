class QuizQuestions {
  String answer;
  String correctOption;
  String imageLink;
  int noOfOptions;
  String option1;
  String option2;
  String option3;
  String option4;
  String question;
  String questionType;
  String questionUID;

  void setCorrectOptionsAndAnswer(
    QuizQuestions currentQuizQuestions,
    bool o1,
    bool o2, {
    bool o3: false,
    bool o4: false,
  }) {
    String correctOptions = '';
    String answers = '';
    if (o1) {
      correctOptions = correctOptions + '1';
      answers = answers + currentQuizQuestions.option1 + ' ';
    }
    if (o2) {
      correctOptions = correctOptions + '2';
      answers = answers + currentQuizQuestions.option2 + ' ';
    }
    if (o3) {
      correctOptions = correctOptions + '3';
      answers = answers + currentQuizQuestions.option3 + ' ';
    }
    if (o4) {
      correctOptions = correctOptions + '4';
      answers = answers + currentQuizQuestions.option4 + ' ';
    }
    this.correctOption = correctOptions;
    this.answer = answers;
  }

  QuizQuestions({
    this.answer,
    this.correctOption,
    this.imageLink,
    this.noOfOptions,
    this.option1: '',
    this.option2: '',
    this.option3: '',
    this.option4: '',
    this.question,
    this.questionType,
    this.questionUID,
  });

  Map toMap(QuizQuestions quizQuestions) {
    var data = Map<String, dynamic>();
    data['answer'] = quizQuestions.answer;
    data['correctOption'] = quizQuestions.correctOption;
    data['imageLink'] = quizQuestions.imageLink;
    data['noOfOptions'] = quizQuestions.noOfOptions;
    data['option1'] = quizQuestions.option1;
    data['option2'] = quizQuestions.option2;
    data['option3'] = quizQuestions.option3;
    data['option4'] = quizQuestions.option4;
    data['question'] = quizQuestions.question;
    data['questionType'] = quizQuestions.questionType;
    data['questionUID'] = quizQuestions.questionUID;
    return data;
  }

  QuizQuestions.fromMap(Map<String, dynamic> mapData) {
    this.answer = mapData['answer'];
    this.correctOption = mapData['correctOption'];
    this.imageLink = mapData['imageLink'];
    this.noOfOptions = mapData['noOfOptions'];
    this.option1 = mapData['option1'];
    this.option2 = mapData['option2'];
    this.option3 = mapData['option3'];
    this.option4 = mapData['option4'];
    this.question = mapData['question'];
    this.questionType = mapData['questionType'];
    this.questionUID = mapData['questionUID'];
  }
}
