import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/resources/auth_methods.dart';
import 'package:flutterapp/screens/student_teacher_selection.dart';
import 'package:flutterapp/utils/universal_variables.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'home_screen.dart';

class LoginScreenTemp extends StatefulWidget {
  @override
  _LoginScreenTempState createState() => new _LoginScreenTempState();
}

class _LoginScreenTempState extends State<LoginScreenTemp>
    with TickerProviderStateMixin {
  //GetX for GoogleLogin
  final userGoogleLogin = GetStorage();

  AnimationController _loginButtonController;
  var animationStatus = 0;
  @override
  void initState() {
    super.initState();
    _loginButtonController = new AnimationController(
        duration: new Duration(milliseconds: 3000), vsync: this);
  }

  @override
  void dispose() {
    _loginButtonController.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      await _loginButtonController.forward();
      await _loginButtonController.reverse();
    } on TickerCanceled {}
  }

  final AuthMethods _authMethods = AuthMethods();

  bool isLoginPressed = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    timeDilation = 0.4;
    return Scaffold(
        //resizeToAvoidBottomInset: ,
        backgroundColor: UniversalVariables.blackColor,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                        child: Text(
                          'Welcome',
                          style: GoogleFonts.raleway(
                              color: Colors.white,
                              fontSize: 50.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(252.0, 110.0, 0.0, 0.0),
                        child: Text(
                          '!',
                          style: GoogleFonts.merriweather(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurpleAccent,
                            fontSize: 50,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height / 2,
                ),
                Container(
                    padding:
                        EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 10.0),
                        loginButton(context),
                      ],
                    )),
                //Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(width: 5.0),
                    /*InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          //TODO: Remove this option of signUp also remove login and pass.
                          return SignupPage(null);
                        }));
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),*/
                  ],
                ),
                SizedBox(height: 10.0),
              ],
            ),
            isLoginPressed
                ? Container(
                    padding: EdgeInsets.all(40.0),
                    child: Center(child: CircularProgressIndicator()),
                    decoration: BoxDecoration(
                      color: Color(0xFF17151B).withOpacity(0.5),
                      //borderRadius: BorderRadius.circular(20.0),
                    ),
                  )
                : Container(),
          ],
        ));
  }

  Widget loginButton(BuildContext context) {
    return Container(
      height: 40,
      child: FlatButton(
        color: Color(0xFF17151B),
        //padding: EdgeInsets.all(35),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image.asset("assets/Glogo.png"),
              ),
            ),
            SizedBox(width: 3.0),
            Center(
              child: Text('Log in with Google',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                  )),
            )
          ],
        ),
        onPressed: () => performLogin(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  void performLogin(BuildContext context) {
    print("Trying to login...");
    setState(() {
      isLoginPressed = true;
    });
    _authMethods.signIn().then((FirebaseUser user) {
      //GetX
      userGoogleLogin.write("isUserGoogleLogin", true);

      if (user != null) {
        authenticateUser(user, context);
      } else {
        print("There was an error");
      }
    }).catchError((e) {
      setState(() {
        isLoginPressed = false;
      });
    });
  }

  void authenticateUser(FirebaseUser user, BuildContext context) {
    FirebaseUser fireuser;
    Future<FirebaseUser> firebaseUser =
        _authMethods.getCurrentUser().then((value) => fireuser = value);
    _authMethods.authenticateUser(user).then((isNewUser) {
      setState(() {
        isLoginPressed = false;
      });
      //TODO: Can reduce reads here.
      if (isNewUser) {
        _authMethods.addGoogleDataToDb(fireuser).then((value) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return StudentTeacherPage();
          }));
        });
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomeScreen();
        }));
      }
    }).catchError((e) => print(e.toString()));
  }
}
