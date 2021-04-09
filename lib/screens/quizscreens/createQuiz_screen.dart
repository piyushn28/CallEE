import 'package:flutter/material.dart';
import 'package:flutterapp/models/quizzes.dart';
import 'package:flutterapp/resources/firebase_methods.dart';
import 'package:flutterapp/screens/quizscreens/createQuestions_screen.dart';
import 'package:flutterapp/utils/universal_variables.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_string/random_string.dart';

class CreateQuiz extends StatefulWidget {
  @override
  _CreateQuizState createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyy = GlobalKey<FormState>();
  String quizUID;
  int _page = 1;
  int _yearValue;
  String _branchValue;
  String _batchValue;
  var quizNameController = TextEditingController();
  var subjectController = TextEditingController();
  var noOfQuestionsController = TextEditingController();
  var maxMarksController = TextEditingController();
  var durationController = TextEditingController();
  var startTimeController = TextEditingController();
  var extraMessageController = TextEditingController();

  final _quizNameKey = GlobalKey<FormState>();

  @override
  void dispose() {
    quizNameController.dispose();
    subjectController.dispose();
    noOfQuestionsController.dispose();
    maxMarksController.dispose();
    durationController.dispose();
    startTimeController.dispose();
    extraMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // height: size.height/2.8,
    //   width: size.width/1.1,
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      /* appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.orange),
       //   onPressed: () => Navigator.of(context).pop(),
        ),
        // title: Text("Sample"),
        centerTitle: true,
        title: Text('Create Quiz'),
      ), */
      /*  appBar: AppBar(
        backgroundColor: UniversalVariables.blackColor,

        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.orange),
          //   onPressed: () => Navigator.of(context).pop(),
        ),
      ),  */
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(12.0),
              child: Column(
                children: [
                  SizedBox(height: size.height / 40),
                  Row(
                    children: [
                      SizedBox(
                        width: size.width / 42,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 0, right: 0, top: size.width / 35, bottom: 0),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                UniversalVariables.gradientColorStart,
                                UniversalVariables.gradientColorEnd
                              ]),
                              color: Colors.deepPurple,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: FittedBox(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back_ios_rounded,
                                    color: Colors.white,
                                    size: size.width / 15,
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  /*  new InkWell(
                    onTap: () => print('hello'),
                    child: new Container(
                      width: 44.0,
                      height: 44.0,
                      decoration: new BoxDecoration(
                        color: Colors.deepPurple,
                        border: new Border.all(color: Colors.deepPurple, width: 2.0),
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      child: new Center(
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                          // onPressed: () => Navigator.of(context).pop(),
                        ),
                       // child: new Text('Click Me', style: new TextStyle(fontSize: 18.0, color: Colors.white),),),
                    ),
                  ),
                  ), */
                  SizedBox(height: size.height / 40),
                  SizedBox(height: size.height / 40),
                  FittedBox(
                    child: Container(
                      width: size.width / 1.1,
                      child: RichText(
                        text: TextSpan(
                            style: GoogleFonts.raleway(
                              color: Colors.white,
                              fontSize: 26.0,
                              //fontWeight: FontWeight.w400,
                            ),
                            children: [
                              TextSpan(
                                text: 'Create a Quiz that engages students! ',
                                style: GoogleFonts.raleway(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height / 25),
                  Visibility(
                    visible: _page == 1,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          /*   Padding(
                            padding: EdgeInsets.all(10),
                            child: Container(
                              decoration: BoxDecoration(
                              //  color: Colors.grey,
                                color: UniversalVariables.separatorColor,
                                borderRadius: new BorderRadius.circular(20.0),
                                border: Border.all(
                                    color: Colors.deepPurple,// set border color
                                    width: 1.0),
                              ),
                             // child: Padding(
                               // padding: EdgeInsets.only(left: 2, right: 2, top: 2),
                                child: TextFormField(
                                  textCapitalization: TextCapitalization.words,
                                  controller: quizNameController,
                                  style: GoogleFonts.raleway(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white70),
                                  cursorColor: Colors.deepPurple,
                                  validator: (String value){
                                    if(value.isEmpty) {
                                      return "Please enter Quiz Name";
                                    }
                                    else
                                    {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                      filled: true,
                                     // fillColor: Color(0xFF17151B),
                                     // color: UniversalVariables.separatorColor,
                                      fillColor: UniversalVariables.separatorColor,
                                      labelText: 'Quiz Name',
                                      labelStyle: GoogleFonts.raleway(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white70),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.deepPurple))
                                  ),
                                ),

                            ),
                          ), */
                          TextFormField(
                            textCapitalization: TextCapitalization.words,
                            controller: quizNameController,
                            style: GoogleFonts.raleway(
                                fontWeight: FontWeight.w500,
                                color: Colors.white70),
                            cursorColor: Colors.deepPurple,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "Please enter Quiz Name";
                              } else {
                                return null;
                              }
                            },
                            /* validator: (String value) {
                              if (value.isEmpty) {
                                return "Please enter Quiz Name";
                              } else {
                                return null;
                              }
                            }, */
                            decoration: InputDecoration(
                              labelText: "Quiz Name",
                              filled: true,
                              fillColor: Colors.transparent,
                              labelStyle: GoogleFonts.raleway(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.deepPurple,
                                  width: 3.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.deepPurple,
                                  width: 3.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height / 40),
                          TextFormField(
                            textCapitalization: TextCapitalization.characters,
                            controller: subjectController,
                            style: GoogleFonts.raleway(
                                fontWeight: FontWeight.w500,
                                color: Colors.white70),
                            cursorColor: Colors.deepPurple,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "Please enter Quiz Subject";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              labelText: "Quiz Subject",
                              filled: true,
                              fillColor: Colors.transparent,
                              labelStyle: GoogleFonts.raleway(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.deepPurple,
                                  width: 3.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.deepPurple,
                                  width: 3.0,
                                ),
                              ),
                            ),
                            /*
                             InputDecoration(
                                filled: true,
                                fillColor: Color(0xFF17151B),
                                labelText: 'Quiz Subject',
                                labelStyle: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white70),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.deepPurple))
                            ),*/
                          ),
                          // height: size.height/2.8,
                          //   width: size.width/1.1,
                          SizedBox(height: size.height / 40),
                          DropdownButtonFormField(
                            /*onChanged: (value) {
                              setState(() {
                                _yearValue = value;
                              });
                            }, */
                            onChanged: (value) =>
                                setState(() => _yearValue = value),
                            validator: (value) =>
                                value == null ? 'Field required' : null,
                            items: <DropdownMenuItem>[
                              DropdownMenuItem(
                                child: Text('1st Year'),
                                value: 1,
                              ),
                              DropdownMenuItem(
                                child: Text('2nd Year'),
                                value: 2,
                              ),
                              DropdownMenuItem(
                                child: Text('3rd Year'),
                                value: 3,
                              ),
                              DropdownMenuItem(
                                child: Text('Final Year'),
                                value: 4,
                              ),
                            ],
                            style: GoogleFonts.raleway(
                                fontWeight: FontWeight.w500,
                                color: Colors.white70),
                            dropdownColor: Color(0xFF17151B),
                            focusColor: Colors.deepPurple,
                            decoration: InputDecoration(
                              labelText: "Year",
                              filled: true,
                              fillColor: Colors.transparent,
                              labelStyle: GoogleFonts.raleway(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.deepPurple,
                                  width: 3.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.deepPurple,
                                  width: 3.0,
                                ),
                              ),
                            ),
                            /* decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xFF17151B),
                              labelText: 'Year',
                              labelStyle: GoogleFonts.raleway(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70),
                            ), */
                          ),
                          SizedBox(height: 15),
                          DropdownButtonFormField(
                            /*  onChanged: (value) {
                              setState(() {
                                _branchValue = value;
                              }
                              );
                            }, */
                            onChanged: (value) =>
                                setState(() => _branchValue = value),
                            validator: (value) =>
                                value == null ? 'Field required' : null,
                            items: <DropdownMenuItem>[
                              DropdownMenuItem(
                                child: Text('ECE'),
                                value: 'ECE',
                              ),
                              DropdownMenuItem(
                                child: Text('CSE'),
                                value: 'CSE',
                              ),
                              DropdownMenuItem(
                                child: Text('IT'),
                                value: 'IT',
                              ),
                              DropdownMenuItem(
                                child: Text('EE'),
                                value: 'EE',
                              ),
                              DropdownMenuItem(
                                child: Text('ME'),
                                value: 'ME',
                              ),
                              DropdownMenuItem(
                                child: Text('CE'),
                                value: 'CE',
                              ),
                              DropdownMenuItem(
                                child: Text('PIE'),
                                value: 'PIE',
                              ),
                              DropdownMenuItem(
                                child: Text('BIOTECH'),
                                value: 'BIOTECH',
                              ),
                            ],
                            style: GoogleFonts.raleway(
                                fontWeight: FontWeight.w500,
                                color: Colors.white70),
                            dropdownColor: Color(0xFF17151B),
                            /* decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xFF17151B),
                              labelText: 'Branch',
                              labelStyle: GoogleFonts.raleway(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70),
                            ), */
                            decoration: InputDecoration(
                              labelText: "Branch",
                              filled: true,
                              fillColor: Colors.transparent,
                              labelStyle: GoogleFonts.raleway(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.deepPurple,
                                  width: 3.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.deepPurple,
                                  width: 3.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15.0),
                          //TODO: Function to select multiple batches.
                          DropdownButtonFormField(
                            /*onChanged: (value) {
                              setState(() {
                                _batchValue = value;
                              });
                            }, */
                            onChanged: (value) =>
                                setState(() => _batchValue = value),
                            validator: (value) =>
                                value == null ? 'Field required' : null,
                            items: <DropdownMenuItem>[
                              DropdownMenuItem(
                                child: Text('1'),
                                value: '1',
                              ),
                              DropdownMenuItem(
                                child: Text('2'),
                                value: '2',
                              ),
                              DropdownMenuItem(
                                child: Text('3'),
                                value: '3',
                              ),
                              DropdownMenuItem(
                                child: Text('4'),
                                value: '4',
                              ),
                            ],
                            style: GoogleFonts.raleway(
                                fontWeight: FontWeight.w500,
                                color: Colors.white70),
                            dropdownColor: Color(0xFF17151B),
                            /* decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xFF17151B),
                              labelText: 'Batch',
                              labelStyle: GoogleFonts.raleway(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70),
                            ), */
                            decoration: InputDecoration(
                              labelText: "Batch",
                              filled: true,
                              fillColor: Colors.transparent,
                              labelStyle: GoogleFonts.raleway(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.deepPurple,
                                  width: 3.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.deepPurple,
                                  width: 3.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height / 40),
                          SizedBox(height: size.height / 40),
                          SizedBox(height: size.height / 40),
                          /*  Padding(
                            padding: EdgeInsets.fromLTRB(size.width / 1.5, 50, 0, 0),
                            child: Container(
                              height: 40,
                              width: 40,
                              child: Image.asset(
                                "assets/stuteach/top3.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(size.width / 1.3, 90, 0, 0),
                            child: Container(
                              height: 50,
                              width: 50,
                              child: Image.asset(
                                "assets/stuteach/top2.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ), */
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _page == 2,
                    child: Form(
                      key: _formKeyy,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            key: _quizNameKey,
                            // validator: (value) {
                            //   if (value == null || value.isEmpty) {
                            //     return 'Please enter some text';
                            //   }
                            //   return null;
                            // },
                            controller: noOfQuestionsController,
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.raleway(
                                fontWeight: FontWeight.w500,
                                color: Colors.white70),
                            cursorColor: Colors.deepPurple,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "Please enter Question no.";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              labelText: "Number Of Questions",
                              filled: true,
                              fillColor: Colors.transparent,
                              labelStyle: GoogleFonts.raleway(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.deepPurple,
                                  width: 3.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.deepPurple,
                                  width: 3.0,
                                ),
                              ),
                            ),
                            /* decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xFF17151B),
                                labelText: 'Number Of Questions',
                                labelStyle: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white70),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.deepPurple)
                                )
                            ), */
                          ),
                          SizedBox(height: size.height / 40),
                          TextFormField(
                            controller: maxMarksController,
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.raleway(
                                fontWeight: FontWeight.w500,
                                color: Colors.white70),
                            cursorColor: Colors.deepPurple,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "Please enter max marks";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              labelText: "Maximum Marks",
                              filled: true,
                              fillColor: Colors.transparent,
                              labelStyle: GoogleFonts.raleway(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.deepPurple,
                                  width: 3.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.deepPurple,
                                  width: 3.0,
                                ),
                              ),
                            ),
                            /* decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xFF17151B),
                                labelText: 'Maximum Marks',
                                labelStyle: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white70),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.deepPurple)
                                )
                            ),*/
                          ),
                          SizedBox(height: size.height / 40),
                          TextFormField(
                            controller: durationController,
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.raleway(
                                fontWeight: FontWeight.w500,
                                color: Colors.white70),
                            cursorColor: Colors.deepPurple,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "Please enter duration of quiz";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              labelText: "Duration Of Quiz (in minutes)",
                              filled: true,
                              fillColor: Colors.transparent,
                              labelStyle: GoogleFonts.raleway(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.deepPurple,
                                  width: 3.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.deepPurple,
                                  width: 3.0,
                                ),
                              ),
                            ),
                            /* decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xFF17151B),
                                labelText: 'Duration Of Quiz (in minutes)',
                                labelStyle: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white70),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.deepPurple)
                                )
                            ), */
                          ),
                          SizedBox(height: size.height / 40),
                          //TODO: To change this to date and time picker.
                          TextFormField(
                            controller: startTimeController,
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.raleway(
                                fontWeight: FontWeight.w500,
                                color: Colors.white70),
                            cursorColor: Colors.deepPurple,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "Please enter start time";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              labelText: "Quiz start time",
                              filled: true,
                              fillColor: Colors.transparent,
                              labelStyle: GoogleFonts.raleway(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.deepPurple,
                                  width: 3.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.deepPurple,
                                  width: 3.0,
                                ),
                              ),
                            ),
                            /* decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xFF17151B),
                                labelText: 'Quiz start time',
                                labelStyle: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white70),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.deepPurple)
                                )
                            ), */
                          ),
                          SizedBox(height: size.height / 40),
                          //TODO: To change this to date and time picker.
                          TextFormField(
                            controller: extraMessageController,
                            style: GoogleFonts.raleway(
                                fontWeight: FontWeight.w500,
                                color: Colors.white70),
                            cursorColor: Colors.deepPurple,
                            decoration: InputDecoration(
                              labelText:
                                  "Quiz message like topic or chapter name.",
                              filled: true,
                              fillColor: Colors.transparent,
                              labelStyle: GoogleFonts.raleway(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.deepPurple,
                                  width: 3.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.deepPurple,
                                  width: 3.0,
                                ),
                              ),
                            ),
                            /*  decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xFF17151B),
                                labelText:
                                    'Quiz message like topic or chapter name.',
                                labelStyle: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white70),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.deepPurple)
                                )
                            ), */
                          ),
                          SizedBox(height: size.height / 40),
                          SizedBox(height: size.height / 40),
                          SizedBox(height: size.height / 40),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _page == 1,
                    child: InkWell(
                      onTap: () {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            _page = 2;
                          });
                        }
                      },
                      child: new Container(
                        width: size.width / 2.6,
                        height: size.height / 13,
                        decoration: new BoxDecoration(
                          color: Colors.deepPurpleAccent,
                          //    border: new Border.all(color: Colors.white, width: 2.0),
                          borderRadius: new BorderRadius.circular(50.0),
                        ),
                        child: new Center(
                          child: new Text(
                            'Next',
                            style: new TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28.0,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    /*   child: Container(
                        width: 180.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          //  color: Colors.grey,
                          color: UniversalVariables.separatorColor,
                          borderRadius: new BorderRadius.circular(20.0),
                          border: Border.all(
                              color: Colors.deepPurple,// set border color
                              width: 1.0),
                        ),
                        child: RaisedButton(
                          onPressed: () {
                            if(_formKey.currentState.validate()) {
                              setState(() {
                                _page = 2;
                              });
                            }
                          },
                          color: Colors.deepPurpleAccent[100],
                          child: Text(
                            "Next",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ), */
                    /*  child: TextButton(
                      onPressed: () {
                        //TODO: Next Page or something to ask for extra details of quiz.
                        setState(() {});
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            _page = 2;
                          });
                        }
                        /*     setState(() {
                     if(_formKey.currentState.validate()) {
                      _page = 2;
                       }
                        });  */
                      },
                      child: Text(
                        '>',
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ),  */
                  ),
                  Visibility(
                    visible: _page == 2,
                    child: InkWell(
                      onTap: () {
                        if (_formKeyy.currentState.validate()) {
                          quizUID = randomAlphaNumeric(20);
                          Quizzes quiz = Quizzes(
                            attemptedBy: [],
                            batch: this._batchValue,
                            branch: this._branchValue,
                            duration: int.parse(durationController.text),
                            extraMessage: extraMessageController.text,
                            maxMarks: int.parse(maxMarksController.text),
                            noOfQuestions:
                                int.parse(noOfQuestionsController.text),
                            quizName: quizNameController.text,
                            quizUID: quizUID,
                            subject: subjectController.text,
                            year: _yearValue,
                          );
                          //TODO: add toast here.
                          FirebaseMethods()
                              .addQuiz(quiz)
                              .then((value) => print('Quiz added.'));
                          createQuestionsList =
                              List.filled(quiz.noOfQuestions, null);

                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return CreateQuestions(quiz);
                          }));
                        }
                      },
                      child: new Container(
                        width: size.width / 2.6,
                        height: size.height / 13,
                        decoration: new BoxDecoration(
                          gradient: LinearGradient(colors: [
                            UniversalVariables.gradientColorStart,
                            UniversalVariables.gradientColorEnd
                          ]),
                          color: Colors.deepPurple,
                          //    border: new Border.all(color: Colors.white, width: 2.0),
                          borderRadius: new BorderRadius.circular(50.0),
                        ),
                        child: new Center(
                          child: new Text(
                            'Submit',
                            style: GoogleFonts.raleway(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    /*  child: TextButton(
                      //TODO: add StartTime.

                      onPressed: () {
                        if (_formKeyy.currentState.validate()) {
                          quizUID = randomAlphaNumeric(20);
                          Quizzes quiz = Quizzes(
                            batch: this._batchValue,
                            branch: this._branchValue,
                            duration: int.parse(durationController.text),
                            extraMessage: extraMessageController.text,
                            maxMarks: int.parse(maxMarksController.text),
                            noOfQuestions:
                                int.parse(noOfQuestionsController.text),
                            quizName: quizNameController.text,
                            quizUID: quizUID,
                            subject: subjectController.text,
                            year: _yearValue,
                          );
                          //TODO: add toast here.
                          FirebaseMethods()
                              .addQuiz(quiz)
                              .then((value) => print('Quiz added.'));
                          createQuestionsList =
                              List.filled(quiz.noOfQuestions, null);

                          print(createQuestionsList);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return CreateQuestions(quiz);
                          }));
                        }
                      },
                      //TODO: Ask Discard or continue when pressed back.
                      child: Text('Submit'),
                    ), */
                  ),
                  SizedBox(
                    height: size.height / 15,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
