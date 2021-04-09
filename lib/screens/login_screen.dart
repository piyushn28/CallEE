import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/resources/auth_methods.dart';
import 'package:flutterapp/screens/home_screen.dart';
import 'package:flutterapp/utils/universal_variables.dart';
import 'package:shimmer/shimmer.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthMethods _authMethods = AuthMethods();

  bool isLoginPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      body: Stack(
        children: <Widget>[
          Center(child: loginButton(context)),
          isLoginPressed
              ? Center(
                  child: Container(
                    padding: EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(),
                    decoration: BoxDecoration(
                      color: UniversalVariables.blackColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget loginButton(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: UniversalVariables.gradientColorEnd,
      child: FlatButton(
        padding: EdgeInsets.all(35),
        child: Text(
          "LOGIN",
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
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
    _authMethods.authenticateUser(user).then((isNewUser) {
      setState(() {
        isLoginPressed = false;
      });
      if (isNewUser) {
        // _authMethods.addDataToDb(user).then((value) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomeScreen();
        }));
        // });
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomeScreen();
        }));
      }
    }).catchError((e) => print(e.toString()));
  }
}
