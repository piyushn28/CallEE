import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home3 extends StatefulWidget {
  @override
  _Home3State createState() => _Home3State();
}

class _Home3State extends State<Home3> {
  TextEditingController phoneNumController = TextEditingController();
  TextEditingController smsManualLoginController = TextEditingController();
  String _smsVerificationCode;

  _verifyPhoneNumber(BuildContext context) async {
    String phoneNumber = "+91" + phoneNumController.text.toString();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 5),
        verificationCompleted: (authCredential) =>
            _verificationComplete(authCredential, context),
        verificationFailed: (authException) =>
            _verificationFailed(authException, context),
        codeAutoRetrievalTimeout: (verificationId) =>
            _codeAutoRetrievalTimeout(verificationId),
        // called when the SMS code is sent
        codeSent: (verificationId, [code]) =>
            _smsCodeSent(verificationId, [code]));
  }

  _verificationComplete(AuthCredential authCredential, BuildContext context) {
    FirebaseAuth.instance
        .signInWithCredential(authCredential)
        .then((authResult) {
      if (authResult.user != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AuthSuccessPage(authResult.user.uid.toString())));
      } else {
        print("Invalid code!");
      }
    });
  }

  _smsCodeSent(String verificationId, List<int> code) {
    // set the verification code so that we can use it to log the user in
    _smsVerificationCode = verificationId;
  }

  void _signInWithPhoneNumber(String smsCode) async {
    AuthCredential _authCredential = await PhoneAuthProvider.getCredential(
        verificationId: _smsVerificationCode, smsCode: smsCode);
    FirebaseAuth.instance
        .signInWithCredential(_authCredential)
        .then((authResult) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AuthSuccessPage(authResult.user.uid.toString())));
    }).catchError((error) {
      print(error.toString());
    });
  }

  _verificationFailed(AuthException authException, BuildContext context) {
    print(authException.message.toString());
  }

  _codeAutoRetrievalTimeout(String verificationId) {
    // set the verification code so that we can use it to log the user in
    _smsVerificationCode = verificationId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PhoneAuth'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: phoneNumController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Phone Number",
                    prefixText: "+91",
                    border: OutlineInputBorder()),
              ),
              FlatButton(
                child: Text(
                  "Send code",
                  style: TextStyle(color: Colors.white),
                ),
                color: Theme.of(context).primaryColor,
                onPressed: () => _verifyPhoneNumber(context),
              ),
              _smsVerificationCode != null ? TextField(
                controller: smsManualLoginController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Code",
                    border: OutlineInputBorder()),
              ) : Container(),
              _smsVerificationCode != null ? FlatButton(
                child: Text(
                  "Verify code",
                  style: TextStyle(color: Colors.white),
                ),
                color: Theme.of(context).primaryColor,
                onPressed: () => _signInWithPhoneNumber(smsManualLoginController.text),
              ) : Container(),
               //FlatButton
            ], // Widget
          ),
        ),
      ), //
    );
  }
}

class AuthSuccessPage extends StatelessWidget {
  final String userid;
  AuthSuccessPage(this.userid);

  signOutUser(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Phone Auth"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "user Id: $userid",
            ),
            RaisedButton(
              child: Text("Sign Out"),
              onPressed: () => signOutUser(context),
            )
          ],
        ),
      ),
    );
  }
}
