import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/screens/leaderboard/leaderboard_profile.dart';
import 'package:flutterapp/screens/leaderboard/topthree.dart';
import 'package:flutterapp/utils/universal_variables.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaderboardUI extends StatefulWidget {
  @override
  _LeaderboardUIState createState() => _LeaderboardUIState();
}

class _LeaderboardUIState extends State<LeaderboardUI> {
  List<NameAndPoints> leaderboardList = <NameAndPoints>[].toList();

  @override
  void initState() {
    Firestore.instance
        .collection('users')
        .orderBy('totalMarks', descending: true)
        .where('totalMarks', isGreaterThan: 1.0)
        .getDocuments()
        .then((snapshot) {
      snapshot.documents.forEach((doc) {
        leaderboardList.add(NameAndPoints(
            name: doc.data['name'],
            uid: doc.data['uid'],
            totalMarksInDouble: doc.data['totalMarks'],
            avatarUrl: doc.data['profile_photo']));
      });
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //SizedBox(width: size.width/50),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      size.width / 25, size.width / 20, 0, 0),
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
            SizedBox(
              height: size.height / 20,
            ),
            Container(
              height: size.height / 5,
              child: Stack(
                children: <Widget>[
                  Container(
                    height: size.height / 2.8,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: UniversalVariables.blackColor,
                      ),
                      color: UniversalVariables.blackColor,
                    ),
                  ),
                  Align(
                    alignment: Alignment(-0.9, -0.5),
                    child: Stack(
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          color: Colors.redAccent,
                          child: CachedNetworkImage(
                            imageUrl: leaderboardList[1].avatarUrl,
                          ),
                        ),
                        TopThree(
                          index: 2,
                          userDetails: leaderboardList.length > 1
                              ? leaderboardList[1]
                              : null,
                        ),
                      ],
                    ),
                  ),
                  Align(
                      alignment: Alignment(0.0, -4.5),
                      child: TopThree(
                        large: true,
                        index: 1,
                        userDetails: leaderboardList.length > 0
                            ? leaderboardList[0]
                            : null,
                      )),
                  Align(
                    alignment: Alignment(0.9, -0.5),
                    child: TopThree(
                      index: 3,
                      userDetails: leaderboardList.length > 2
                          ? leaderboardList[2]
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: UniversalVariables.lightPurpleColor.withOpacity(0.2),
            ),
            TabBar(
                indicatorWeight: 2.0,
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.deepPurple,
                tabs: <Widget>[
                  Tab(
                    child: Text(
                      "     Current     ",
                      style: GoogleFonts.raleway(
                        fontSize: 16,
                        color: UniversalVariables.greyColor,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "     Overall     ",
                      style: GoogleFonts.raleway(
                        color: UniversalVariables.greyColor,
                        fontSize: 16,
                      ),
                    ),
                  )
                ]),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  Container(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: leaderboardList.length > 3
                          ? leaderboardList.length - 3
                          : 0,
                      itemBuilder: (context, index) => Leaderboardprofile(
                        index: index + 4,
                        userDetails: leaderboardList.length > 3
                            ? leaderboardList[index + 3]
                            : null,
                      ),
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 10,
                        );
                      },
                    ),
                  ),
                  Container(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: leaderboardList.length > 3
                          ? leaderboardList.length - 3
                          : 0,
                      itemBuilder: (context, index) => Leaderboardprofile(
                        index: index + 4,
                        userDetails: leaderboardList.length > 3
                            ? leaderboardList[index + 3]
                            : null,
                      ),
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 10,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NameAndPoints {
  String name;
  String uid;
  double totalMarksInDouble;
  int totalMarks;
  String avatarUrl;

  NameAndPoints(
      {this.name,
      this.uid,
      this.totalMarks,
      this.totalMarksInDouble,
      this.avatarUrl}) {
    this.totalMarks = this.totalMarksInDouble.round();
  }
}
