import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/provider/image_upload_provider.dart';
import 'package:flutterapp/provider/user_provider.dart';
import 'package:flutterapp/resources/auth_methods.dart';
import 'package:flutterapp/screens/dashboard/student_dashboard.dart';
import 'package:flutterapp/screens/home_screen.dart';
import 'package:flutterapp/screens/leaderboard/leader_board.dart';
import 'package:flutterapp/screens/login_screen.dart';
import 'package:flutterapp/screens/login_screen_temp.dart';
import 'package:flutterapp/screens/postscreens/add_post.dart';
import 'package:flutterapp/screens/quizscreens/answers_scoring_screen.dart';
import 'package:flutterapp/screens/quizscreens/createQuiz_screen.dart';
import 'package:flutterapp/screens/quizscreens/scoring_screen.dart';
import 'package:flutterapp/screens/search_screen.dart';
import 'package:flutterapp/screens/student_teacher_selection.dart';
import 'package:flutterapp/utils/universal_variables.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart' as gett;

void main() async {
  await GetStorage.init();
  //SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthMethods _authMethods = AuthMethods();
  Widget initialScreen = LoginScreenTemp();

  final userGoogleLogin = GetStorage();
  final userStudentTeacherSelected = GetStorage();

  String currPage = 'LoginPage';
  // currPage (initially): LoginPage

  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    /* SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
    ));*/
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    //SystemChrome.setEnabledSystemUIOverlays ([SystemUiOverlay.top]);
    userGoogleLogin.writeIfNull("isUserGoogleLogin", false);
    userStudentTeacherSelected.writeIfNull(
        "isUserStudentTeacherSelected", false);

    // Initial Check for opening the first page

    // If User, Google Logged & Filled Student Teacher Details
    if (userGoogleLogin.read("isUserGoogleLogin") &&
        userStudentTeacherSelected.read("isUserStudentTeacherSelected")) {
      currPage = 'HomeScreen';
    }
    //If User, Only Google Logged
    else if (userGoogleLogin.read("isUserGoogleLogin")) {
      currPage = 'StudentTeacherPage';
    }
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage("assets/Glogo.png"), context);
    //FirebaseUser currUser;
    //  Future<FirebaseUser> firebaseUser = _authMethods.getCurrentUser().then((value) => currUser=value);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ImageUploadProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        theme: ThemeData(
            canvasColor: UniversalVariables.blackColor,
            primarySwatch: Colors.deepPurple),
        darkTheme: ThemeData.from(
          colorScheme: ColorScheme.fromSwatch(
              //primaryColorDark: Colors.yellow,
              primarySwatch: Colors.deepPurple),
        ),
        routes: {
          '/search_screen': (context) => SearchScreen(),
          '/home_screen': (context) => HomeScreen(),
        },
        home: HomeScreen(),
        /* home: currPage == "LoginPage"
            ? LoginScreenTemp()
            : currPage == "HomeScreen"
                ? HomeScreen()
                : StudentTeacherPage(), */
      ),
    );
  }
}
