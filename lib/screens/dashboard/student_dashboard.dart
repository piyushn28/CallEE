import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/models/quizzes.dart';
import 'package:flutterapp/provider/user_provider.dart';
import 'package:flutterapp/resources/auth_methods.dart';
import 'package:flutterapp/screens/chatscreens/widgets/cached_image.dart';
import 'package:flutterapp/screens/dashboard/leaderboard_container.dart';
import 'package:flutterapp/screens/dashboard/stuck_card.dart';
import 'package:flutterapp/screens/dashboard/subject_category.dart';
import 'package:flutterapp/screens/leaderboard/leader_board.dart';
import 'package:flutterapp/utils/universal_variables.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutterapp/utils/utilities.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'search_bar_dashboard.dart';

class StudentDashboard extends StatefulWidget {
  final PageController pageController;

  const StudentDashboard({Key key, this.pageController}) : super(key: key);

  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final _controller = ScrollController();
  var months = UniversalVariables.months;

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final User user = userProvider.getUser;
    Size size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(size.width / 15, size.width / 12,
                    size.width / 15, size.width / 26),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${DateTime.now().day} ${months[DateTime.now().month]}",
                              style: GoogleFonts.montserrat(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300),
                            ),
                            FittedBox(
                              child: Container(
                                width: size.width / 1.5,
                                child: RichText(
                                  text: TextSpan(
                                      style: GoogleFonts.raleway(
                                        color: Colors.white,
                                        fontSize: 26.0,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'Hi, ',
                                          style: GoogleFonts.raleway(
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '${user.name.split(' ')[0]}!',
                                          style: GoogleFonts.raleway(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      ]),
                                ),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.pageController.animateToPage(
                              5,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          },
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              height: size.width / 8,
                              width: size.width / 8,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: UniversalVariables.senderColor,
                                    blurRadius: 8.0,
                                  ),
                                ],
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Stack(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.center,
                                      child: CachedImage(
                                        user.profilePhoto,
                                        isRound: true,
                                        radius: size.width / 6,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        height: size.width / 40,
                                        width: size.width / 40,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [
                                            UniversalVariables.onlineDotColor,
                                            Colors.lightGreenAccent
                                          ]),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height / 20,
                    ),
                    SearchBar(),
                    SizedBox(
                      height: size.height / 20,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Quizzes",
                        style: GoogleFonts.raleway(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //TODO: Get data according to user's batch and branch
              StreamBuilder(
                stream: Firestore.instance
                    .collection('quizzes')
                    .orderBy('startTime', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data == null) {
                    //TODO:change this progress indicator
                    return Container(
                      height: size.width / 2,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (snapshot.data.documents.length == 0) {
                    return Column(
                      children: [
                        SizedBox(
                          height: size.height / 7,
                        ),
                        Container(
                          height: size.height / 2.5,
                          width: size.width,
                          child: Center(
                            child: Lottie.asset(
                              'assets/tissue.json',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  return Container(
                    height: MediaQuery.of(context).size.width / 2,
                    child: ListView.builder(
                      cacheExtent: 9999999,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: snapshot.data.documents.length,
                      controller: _controller,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> quizMap =
                            snapshot.data.documents[index].data;
                        Quizzes quiz = Quizzes.fromMap(quizMap);
                        return CategoryCard(
                          quiz: quiz,
                          user: user,
                        );
                      },
                    ),
                  );
                },
              ),
              SizedBox(
                height: size.height / 40,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                        onTap: () {
                          widget.pageController.animateToPage(
                            4,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        },
                        child: StuckCard()),
                    LeaderBoardCard(
                      whichUser: 'student',
                      press: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LeaderboardUI()));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
