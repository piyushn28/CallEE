import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutterapp/screens/Dashboard/dashboard_constant.dart';
import 'package:flutterapp/screens/Dashboard/subject_name.dart';
import 'package:flutterapp/utils/universal_variables.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaderBoardCard extends StatelessWidget {
  final String svgSrc;
  final String title;
  final Function press;
  final String whichUser;
  const LeaderBoardCard({
    Key key,
    this.svgSrc,
    this.title,
    this.press,
    this.whichUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: press,
      child: Container(
        //margin: EdgeInsets.symmetric(vertical: 0.0),
        height: size.height / 4,
        width: size.width / 1.1,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Container(
                      width: size.width / 1.15,
                      height: size.height / 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22.0),
                        color: UniversalVariables.separatorColor,
                      ),
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      size.width / 25,
                                      size.width / 20,
                                      size.width / 20,
                                      size.width / 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FittedBox(
                                        child: Text(
                                          'Leaderboard',
                                          style: GoogleFonts.raleway(
                                            color: Colors.white,
                                            fontSize: 21,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.width / 50,
                                      ),
                                      FittedBox(
                                        child: Text(
                                          'Discover Overall\nranklist of all students!',
                                          style: GoogleFonts.raleway(
                                            color: Colors.white60,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: size.width / 30,
                                ),
                                Container(
                                    height: size.width / 3.5,
                                    width: size.width / 3,
                                    child: SvgPicture.asset(
                                      'assets/stuteach/leaderboard.svg',
                                      fit: BoxFit.contain,
                                    )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                0, 0, size.width / 22, size.width / 22),
                            child: Align(
                                alignment: Alignment.bottomRight,
                                child: whichUser == 'student'
                                    ? Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        height: size.width / 13,
                                        width: size.width / 3,
                                        child: Center(
                                          child: FittedBox(
                                            child: Text(
                                              'Know Your Rank',
                                              style: GoogleFonts.raleway(
                                                color: UniversalVariables
                                                    .lightPurpleColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(colors: [
                                              UniversalVariables
                                                  .gradientColorStart,
                                              UniversalVariables
                                                  .gradientColorEnd
                                            ]),
                                            color: UniversalVariables
                                                .lightPurpleColor,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        height: size.width / 13,
                                        width: size.width / 3,
                                        child: Center(
                                          child: FittedBox(
                                            child: Text(
                                              'Learn More',
                                              style: GoogleFonts.raleway(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
