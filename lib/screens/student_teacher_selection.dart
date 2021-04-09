import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/provider/user_provider.dart';
import 'package:flutterapp/resources/auth_methods.dart';
import 'package:flutterapp/screens/home_screen.dart';
import 'package:flutterapp/utils/universal_variables.dart';
// import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class StudentTeacherPage extends StatefulWidget {
  //final FirebaseUser currentUser;
  // StudentTeacherPage(this.currentUser);

  @override
  _StudentTeacherPageState createState() => _StudentTeacherPageState();
}

class _StudentTeacherPageState extends State<StudentTeacherPage> {
  //GetX for user->Student/Teacher

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final userStudentTeacherSelected = GetStorage();

  //var regNoController = TextEditingController();
  var otherDescriptionController = TextEditingController();
  TextEditingController regNoController = new TextEditingController();
  String _occupationValue;
  int _yearValue;
  String _branchValue;
  int _batchValue;
  final AuthMethods _authMethods = AuthMethods();

  @override
  void dispose() {
    regNoController.dispose();
    otherDescriptionController.dispose();
    super.dispose();
  }

  _studentDetailFilling(FirebaseUser fuser) {
    Size size = MediaQuery.of(context).size;
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        elevation: 0,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: size.height / 1.1,
              decoration: BoxDecoration(
                color: UniversalVariables.blackColor,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(25.0),
                  topRight: const Radius.circular(25.0),
                ),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        children: <Widget>[
                          FlatButton(
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.maybePop(context),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "As Student",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.raleway(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ListView(
                          children: <Widget>[
                            TextFormField(
                              controller: regNoController,
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.raleway(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70),
                              cursorColor: Colors.deepPurple,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please enter Register Number";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xFF17151B),
                                  labelText: 'Registration Number',
                                  labelStyle: GoogleFonts.raleway(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white70),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.deepPurple))),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            DropdownButtonFormField(
                              onChanged: (value) {
                                setState(() {
                                  _yearValue = value;
                                });
                              },
                              items: <DropdownMenuItem>[
                                DropdownMenuItem(
                                  child: Text('Fresher'),
                                  value: 1,
                                ),
                                DropdownMenuItem(
                                  child: Text('Sophomore'),
                                  value: 2,
                                ),
                                DropdownMenuItem(
                                  child: Text('Junior'),
                                  value: 3,
                                ),
                                DropdownMenuItem(
                                  child: Text('Senior'),
                                  value: 4,
                                ),
                              ],
                              style: GoogleFonts.raleway(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70),
                              dropdownColor: Color(0xFF17151B),
                              focusColor: Colors.deepPurple,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xFF17151B),
                                labelText: 'Year',
                                labelStyle: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white70),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            DropdownButtonFormField(
                              onChanged: (value) {
                                setState(() {
                                  _branchValue = value;
                                });
                              },
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
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xFF17151B),
                                labelText: 'Branch',
                                labelStyle: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white70),
                              ),
                            ),
                            SizedBox(height: 15.0),
                            DropdownButtonFormField(
                              onChanged: (value) {
                                setState(() {
                                  _batchValue = value;
                                });
                              },
                              items: <DropdownMenuItem>[
                                DropdownMenuItem(
                                  child: Text('1'),
                                  value: 1,
                                ),
                                DropdownMenuItem(
                                  child: Text('2'),
                                  value: 2,
                                ),
                                DropdownMenuItem(
                                  child: Text('3'),
                                  value: 3,
                                ),
                                DropdownMenuItem(
                                  child: Text('4'),
                                  value: 4,
                                ),
                              ],
                              style: GoogleFonts.raleway(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70),
                              dropdownColor: Color(0xFF17151B),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xFF17151B),
                                labelText: 'Batch',
                                labelStyle: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white70),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // if(_formKey.currentState.validate()) {
                        print('signup tapped');
                        User user = User(
                          occupation: _occupationValue,
                          regNo: regNoController.text,
                          branch: _branchValue,
                          year: _yearValue,
                          batch: _batchValue,
                          otherDescription: otherDescriptionController.text,
                        );
                        _authMethods.addDataToDb(fuser, user).then((value) {
                          // userStudentTeacherSelected.write(
                          //     "isUserStudentTeacherSelected", true);
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(builder: (context) {
                            return HomeScreen();
                          }), (Route<dynamic> route) => false);
                        });
                      },
                      child: Container(
                          height: 50,
                          width: size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30)),
                            color: Colors.deepPurpleAccent,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  _teacherDetailFilling(FirebaseUser fuser) {
    Size size = MediaQuery.of(context).size;
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        elevation: 0,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: size.height / 1.1,
              decoration: BoxDecoration(
                color: UniversalVariables.blackColor,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(25.0),
                  topRight: const Radius.circular(25.0),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      children: <Widget>[
                        FlatButton(
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.maybePop(context),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "As Teacher",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.raleway(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ListView(
                        children: <Widget>[
                          DropdownButtonFormField(
                            onChanged: (value) {
                              setState(() {
                                _branchValue = value;
                              });
                            },
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
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xFF17151B),
                              labelText: 'Branch',
                              labelStyle: GoogleFonts.raleway(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            height: 120,
                            child: TextField(
                              //scrollController: _controller,
                              controller: otherDescriptionController,
                              expands: true,
                              autofocus: true,
                              autocorrect: false,
                              keyboardType: TextInputType.multiline,
                              style: GoogleFonts.raleway(
                                  letterSpacing: 1.2, color: Colors.white),
                              minLines: null,
                              maxLines: null,
                              cursorColor: Colors.deepPurple,
                              decoration: InputDecoration(
                                  //contentPadding: EdgeInsets.symmetric(
                                  //   vertical: 50.0, horizontal: 10.0),
                                  filled: true,
                                  fillColor: UniversalVariables.separatorColor,
                                  hintText: 'Description',
                                  hintStyle: GoogleFonts.raleway(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w500),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.deepPurple))),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print('signup tapped');
                      User user = User(
                        occupation: _occupationValue,
                        regNo: regNoController.text,
                        branch: _branchValue,
                        year: _yearValue,
                        batch: _batchValue,
                        otherDescription: otherDescriptionController.text,
                      );
                      _authMethods.addDataToDb(fuser, user).then((value) {
                        // userStudentTeacherSelected.write(
                        //     "isUserStudentTeacherSelected", true);
                        Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(builder: (context) {
                          return HomeScreen();
                        }), (Route<dynamic> route) => false);
                      });
                    },
                    child: Container(
                        height: 50,
                        width: size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
                          color: Colors.deepPurpleAccent,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        )),
                  ),
                ],
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser fireuser;
    Future<FirebaseUser> firebaseUser =
        _authMethods.getCurrentUser().then((value) => fireuser = value);
    Size size = MediaQuery.of(context).size;
    return new Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        //Gesture Detector = Click anywhere to remove keyboard and focus from textfield.
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            child: SingleChildScrollView(
              reverse: true,
              child: Stack(
                children: [
                  Container(
                      height: size.height / 2.8,
                      width: size.width / 1.8,
                      child: Image.asset(
                        "assets/stuteach/topleft.png",
                        fit: BoxFit.fill,
                      )),
                  Padding(
                    padding: EdgeInsets.fromLTRB(size.width / 1.5, 50, 0, 0),
                    child: Container(
                      height: 30,
                      width: 30,
                      child: Image.asset(
                        "assets/stuteach/top3.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(size.width / 1.3, 90, 0, 0),
                    child: Container(
                      height: 30,
                      width: 30,
                      child: Image.asset(
                        "assets/stuteach/top2.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height / 2,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        //padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: size.height / 5,
                            ),
                            Stack(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    height: size.height / 17,
                                    width: size.width / 1.5,
                                    decoration: BoxDecoration(
                                        color: Color(0xFF966CE0),
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20.0),
                                          bottomRight: Radius.circular(20.0),
                                        )),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "I'm using CallE...",
                                          style: GoogleFonts.raleway(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.end,
                                        ),
                                        SizedBox(
                                          width: 12,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      size.width / 1.6, 0, 0, 0),
                                  child: Container(
                                      height: 30,
                                      width: 30,
                                      child: Image.asset(
                                        "assets/stuteach/onMainLine.png",
                                        fit: BoxFit.contain,
                                      )),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () {
                                  _studentDetailFilling(fireuser);
                                },
                                child: Container(
                                  height: size.height / 4.5,
                                  width: size.width / 1.5,
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Color(0xFF898989)),
                                    borderRadius: BorderRadius.circular(22.0),
                                    color: UniversalVariables.separatorColor,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: size.height / 7,
                                        width: size.width / 3.5,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.4),
                                          //border: Border.all(color: Color(0xFF898989)),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: Center(
                                            child: Lottie.asset(
                                              'assets/student.json',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: size.width / 22,
                                      ),
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: size.height / 25,
                                          ),
                                          Container(
                                            height: size.height / 18,
                                            width: size.width / 4,
                                            child: FittedBox(
                                              child: Text('As Student',
                                                  style: GoogleFonts.montserrat(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ),
                                          ),
                                          Container(
                                            height: size.height / 10,
                                            width: size.width / 4,
                                            // color: Colors.white,
                                            child: Text(
                                                'Write about your problems,talk to seniors.',
                                                textAlign: TextAlign.start,
                                                style: GoogleFonts.montserrat(
                                                    color: Colors.white70,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () {
                                  _teacherDetailFilling(fireuser);
                                },
                                child: Container(
                                  height: size.height / 4.5,
                                  width: size.width / 1.5,
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Color(0xFF673AB7)),
                                    borderRadius: BorderRadius.circular(22.0),
                                    color: Color(0xFF966CE0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: size.height / 7,
                                        width: size.width / 3.5,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.4),
                                          //border: Border.all(color: Color(0xFF898989)),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: Center(
                                            child: Lottie.asset(
                                              'assets/teach.json',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: size.width / 22,
                                      ),
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: size.height / 25,
                                          ),
                                          Container(
                                            height: size.height / 18,
                                            width: size.width / 4,
                                            child: FittedBox(
                                              child: Text('As Teacher',
                                                  style: GoogleFonts.montserrat(
                                                      color: Color(0xFF300085),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ),
                                          ),
                                          Container(
                                            height: size.height / 10,
                                            width: size.width / 4,
                                            // color: Colors.white,
                                            child: Text(
                                                "Create and Manage Quizzes, Scoreboards",
                                                textAlign: TextAlign.start,
                                                style: GoogleFonts.montserrat(
                                                    color: Color(0xFF300085)
                                                        .withOpacity(0.8),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            /*Container(
                              height: 40.0,
                              child: Material(
                                borderRadius: BorderRadius.circular(10.0),
                                shadowColor: Colors.deepPurple,
                                color: Colors.deepPurple,
                                elevation: 7.0,
                                child: GestureDetector(
                                  //TODO: Insert values validator and progress bar.
                                  onTap: () {
                                    print('signup tapped');
                                    User user = User(
                                      occupation: _occupationValue,
                                      regNo: regNoController.text,
                                      branch: _branchValue,
                                      year: _yearValue,
                                      batch: _batchValue,
                                      otherDescription:
                                          otherDescriptionController.text,
                                    );
                                    _authMethods
                                        .addDataToDb(widget.currentUser, user)
                                        .then((value) {
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) {
                                        return HomeScreen();
                                      }));
                                    });
                                  },
                                  child: Center(
                                      child: Text('SIGN UP',
                                          style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                          ))),
                                ),
                              ),
                            ),*/
                          ],
                        ),
                      ),
                    ],
                  ),
                  /* Padding(
                    padding: EdgeInsets.fromLTRB(size.width/5, size.height / 1.18, 0, 0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        height: 30,
                        width: 30,
                        child: Image.asset(
                          "assets/stuteach/down1.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),*/
                  /*Padding(
                    padding: EdgeInsets.fromLTRB(0, size.height / 1.3, 0, 0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        // height: 30,
                        // width: 30,
                        child: Image.asset(
                          "assets/stuteach/bottomleft.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
