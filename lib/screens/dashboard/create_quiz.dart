import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutterapp/screens/Dashboard/dashboard_constant.dart';
import 'package:flutterapp/screens/Dashboard/subject_name.dart';
import 'package:flutterapp/utils/universal_variables.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateQuizCard extends StatelessWidget {
  final String svgSrc;
  final String title;
  final Function press;

  const CreateQuizCard({
    Key key,
    this.svgSrc,
    this.title,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.fromLTRB(size.width / 50,0,0,0),
      child: Container(
        //margin: EdgeInsets.symmetric(vertical: 0.0),
        height: size.height / 4,
        width: size.width/1.1,
        child: Padding(
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
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
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
                                    'Create Quiz!',
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
                                    'Make interesting quizzes\nfor students!',
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
                                'assets/stuteach/add_post.svg',
                                fit: BoxFit.contain,
                              )),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            0, 0, size.width / 22, size.width / 22),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      UniversalVariables.gradientColorStart,
                                        UniversalVariables.gradientColorEnd
                                    ]
                                ),
                                color: UniversalVariables.lightPurpleColor,
                                borderRadius:
                                BorderRadius.circular(15)),
                            height: size.width / 13,
                            width: size.width / 3,
                            child: Center(
                              child: FittedBox(
                                child: Text(
                                  'Create',
                                  style: GoogleFonts.raleway(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
