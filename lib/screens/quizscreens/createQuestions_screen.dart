import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/models/quizQuestions.dart';
import 'package:flutterapp/models/quizzes.dart';
import 'package:flutterapp/resources/firebase_methods.dart';
import 'package:flutterapp/screens/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutterapp/utils/universal_variables.dart';

class CreateQuestions extends StatefulWidget {
  final Quizzes quiz;

  CreateQuestions(this.quiz);

  @override
  _CreateQuestionsState createState() => _CreateQuestionsState();
}

class _CreateQuestionsState extends State<CreateQuestions> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _questionNo = 1;

  //Variables for option selection.
  bool option1Selected = false;
  bool option2Selected = false;
  bool option3Selected = false;
  bool option4Selected = false;

  //Variable which determines wheter the textfields are editable or not.
  bool isReadOnly = false;

  PageController _pageController = PageController(initialPage: 0);
  var questionController = TextEditingController();
  var option1Controller = TextEditingController();
  var option2Controller = TextEditingController();
  var option3Controller = TextEditingController();
  var option4Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (createQuestionsList.isNotEmpty && createQuestionsList[0] != null) {
      isReadOnly = true;
      questionController.text = createQuestionsList[0].question;
      option1Controller.text = createQuestionsList[0].option1;
      option2Controller.text = createQuestionsList[0].option2;
      option3Controller.text = createQuestionsList[0].option3;
      option4Controller.text = createQuestionsList[0].option4;
    }
  }

  @override
  void dispose() {
    questionController.dispose();
    option1Controller.dispose();
    option2Controller.dispose();
    option3Controller.dispose();
    option4Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Quizzes quiz = widget.quiz;
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
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height / 15),
                      Text(
                        '${quiz.quizName} | ${quiz.subject} Quiz',
                        style: GoogleFonts.raleway(
                          color: Colors.white70,
                          fontSize: 21,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '${quiz.duration} mins | ${quiz.maxMarks} points',
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
                          Visibility(
                            visible:
                                createQuestionsList[_questionNo - 1] != null,
                            child: IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.deepPurple,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isReadOnly = false;
                                  });
                                }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      isReadOnly = false;
                      questionController.text = '';
                      option1Controller.text = '';
                      option2Controller.text = '';
                      option3Controller.text = '';
                      option4Controller.text = '';
                      option1Selected = false;
                      option2Selected = false;
                      option3Selected = false;
                      option4Selected = false;
                      if (createQuestionsList[index] != null) {
                        questionController.text =
                            createQuestionsList[index].question;
                        option1Controller.text =
                            createQuestionsList[index].option1;
                        option2Controller.text =
                            createQuestionsList[index].option2;
                        option3Controller.text =
                            createQuestionsList[index].option3;
                        option4Controller.text =
                            createQuestionsList[index].option4;

                        option1Selected = createQuestionsList[index]
                            .correctOption
                            .contains('1');
                        option2Selected = createQuestionsList[index]
                            .correctOption
                            .contains('2');
                        option3Selected = createQuestionsList[index]
                            .correctOption
                            .contains('3');
                        option4Selected = createQuestionsList[index]
                            .correctOption
                            .contains('4');

                        setState(() {
                          isReadOnly = true;
                        });
                      }
                      setState(() {
                        _questionNo = index + 1;
                      });
                    },
                    itemCount: quiz.noOfQuestions,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              TextFormField(
                                readOnly: isReadOnly,
                                controller: questionController,
                                maxLines: 10,
                                minLines: 1,
                                textCapitalization:
                                    TextCapitalization.sentences,
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
                                  labelText: 'Enter Question',
                                  labelStyle: GoogleFonts.raleway(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white70),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          UniversalVariables.lightPurpleColor,
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
                                  isReadOnly: isReadOnly,
                                  optionController: option1Controller,
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
                                  isReadOnly: isReadOnly,
                                  optionController: option2Controller,
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
                                  isReadOnly: isReadOnly,
                                  optionController: option3Controller,
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
                                  isReadOnly: isReadOnly,
                                  optionController: option4Controller,
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    width: size.width / 2.6,
                                    height: size.height / 13,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        UniversalVariables.gradientColorStart,
                                        UniversalVariables.gradientColorEnd
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
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.easeOut,
                                          );
                                        } else {
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    width: size.width / 2.6,
                                    height: size.height / 13,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        UniversalVariables.gradientColorStart,
                                        UniversalVariables.gradientColorEnd
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
                                          print('Select at least 1 option');
                                          return;
                                        } else if (option1Controller
                                                    .text.length ==
                                                0 ||
                                            option2Controller.text.length ==
                                                0 ||
                                            option3Controller.text.length ==
                                                0 ||
                                            option4Controller.text.length ==
                                                0 ||
                                            questionController.text.length ==
                                                0) {
                                          //TODO: Add toast to fill all details.
                                          print('Enter all details');
                                          return;
                                        } else {
                                          QuizQuestions quizQuestion =
                                              QuizQuestions(
                                            questionUID: _questionNo.toString(),
                                            noOfOptions: 4,
                                            questionType: 'MCQs',
                                            question: questionController.text,
                                            option1: option1Controller.text,
                                            option2: option2Controller.text,
                                            option3: option3Controller.text,
                                            option4: option4Controller.text,
                                          );
                                          quizQuestion
                                              .setCorrectOptionsAndAnswer(
                                            quizQuestion,
                                            option1Selected,
                                            option2Selected,
                                            o3: option3Selected,
                                            o4: option4Selected,
                                          );

                                          createQuestionsList[_questionNo - 1] =
                                              quizQuestion;
                                          print(createQuestionsList);

                                          if (_questionNo ==
                                              quiz.noOfQuestions) {
                                            for (int i = 0;
                                                i < quiz.noOfQuestions;
                                                i++) {
                                              if (createQuestionsList[i] ==
                                                  null) {
                                                //TODO: Show toast to fill details of all questions.
                                                //TODO: insert animation below.
                                                _pageController.jumpToPage(i);
                                                return;
                                              }
                                            }

                                            FirebaseMethods()
                                                .addQuizQuestions(quiz)
                                                .then((value) {
                                              print(value);
                                              if (value) {
                                                //TODO: Goes to home page again and showing toast 'Quiz created'.
                                                createQuestionsList =
                                                    List.filled(0, null);
                                                Navigator.of(context)
                                                    .pushAndRemoveUntil(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                HomeScreen()),
                                                        (route) => false);
                                              } else {
                                                //TODO: Show toast quiz not submitted, check internet conntection.
                                              }
                                            });
                                          } else {
                                            _pageController.animateToPage(
                                              index + 1,
                                              duration:
                                                  Duration(milliseconds: 500),
                                              curve: Curves.easeIn,
                                            );
                                          }
                                        }
                                      },
                                      child: Center(
                                        child: Text(
                                          _questionNo == quiz.noOfQuestions
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
                  ),
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
  bool isReadOnly,
  TextEditingController optionController,
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
              ? Colors.green
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
          readOnly: isReadOnly,
          controller: optionController,
          maxLines: 10,
          minLines: 1,
          textCapitalization: TextCapitalization.sentences,
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
                    ? Colors.green
                    : UniversalVariables.separatorColor,
                width: 3.0,
              ),
            ),
            filled: true,
            fillColor: Color(0xFF17151B),
            labelText: 'Enter Option $optionNo',
            labelStyle: GoogleFonts.raleway(
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
              borderSide: BorderSide(
                color: Colors.deepPurpleAccent,
                width: 3.0,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
