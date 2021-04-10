import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/screens/pageviews/chats/widgets/user_circle.dart';
import 'package:flutterapp/utils/universal_variables.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';

class AnswerUI extends StatelessWidget {
  final int index;
  const AnswerUI({Key key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: size.height / 1.4,
          width: size.width / 1.05,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.transparent,
          ),
          child: Column(
            children: <Widget>[
              SizedBox(height: size.height / 40),
              Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "  $index.",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    height: size.height / 24,
                    width: size.width / 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Center(
                      child: Text(
                        '+1',
                        style: GoogleFonts.raleway(
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height / 120),
              Expanded(
                child: Container(
                  height: size.height / 12,
                  width: size.width / 1.25,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.transparent,
                      width: 2,
                      // color: Color(0xff1F1D2B),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    color: Colors.transparent,
                    //  color: Colors.grey,
                  ),
                  child: AutoSizeText(
                    // yaha pr questions aa jaenge
                    "i am sumit ojha and i successfully fitted text using a package known as autosizetext which will increse or decrease the suze of text accordintg to question and what if i increase lines it will than d decreasewhich will increse or decrease the suze of text accordintg to question and what if i increase lines it will than d decrease fontsize of questions",
                    style: GoogleFonts.raleway(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                        color: Colors.white),
                    maxLines: 12,
                  ),
                ),
              ),
              SizedBox(height: size.height / 40),
              Container(
                height: size.height / 13.5,
                width: size.width / 1.3,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.deepPurple,
                    width: 2,
                    // color: Color(0xff1F1D2B),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: Colors.transparent,
                  //  color: Colors.grey,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      //   SizedBox(width: size.height/13.5,),
                      Padding(
                        padding: EdgeInsets.only(
                            left: size.width / 100,
                            right: 0,
                            top: size.width / 100,
                            bottom: 0),
                        child: Container(
                          height: size.height / 5,
                          width: size.width / 11,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Center(
                            child: Text(
                              'A',
                              style: GoogleFonts.raleway(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.0,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width / 100,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            "Sumit Ojha",
                            style: GoogleFonts.raleway(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height / 40),
              Container(
                height: size.height / 13.5,
                width: size.width / 1.3,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.deepPurple,
                    width: 2,
                    // color: Color(0xff1F1D2B),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: Colors.transparent,
                  //  color: Colors.grey,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      //   SizedBox(width: size.height/13.5,),
                      Padding(
                        padding: EdgeInsets.only(
                            left: size.width / 100,
                            right: 0,
                            top: size.width / 100,
                            bottom: 0),
                        child: Container(
                          height: size.height / 5,
                          width: size.width / 11,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Center(
                            child: Text(
                              'B',
                              style: GoogleFonts.raleway(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.0,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width / 100,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            "Sumit Ojha",
                            style: GoogleFonts.raleway(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height / 40),
              Container(
                height: size.height / 13.5,
                width: size.width / 1.3,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.deepPurple,
                    width: 2,
                    // color: Color(0xff1F1D2B),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: Colors.transparent,
                  //  color: Colors.grey,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      //   SizedBox(width: size.height/13.5,),
                      Padding(
                        padding: EdgeInsets.only(
                            left: size.width / 100,
                            right: 0,
                            top: size.width / 100,
                            bottom: 0),
                        child: Container(
                          height: size.height / 5,
                          width: size.width / 11,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Center(
                            child: Text(
                              'C',
                              style: GoogleFonts.raleway(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.0,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width / 100,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            "Sumit Ojha",
                            style: GoogleFonts.raleway(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height / 40),
              Container(
                height: size.height / 13.5,
                width: size.width / 1.3,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.deepPurple,
                    width: 2,
                    // color: Color(0xff1F1D2B),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: Colors.transparent,
                  //  color: Colors.grey,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      //   SizedBox(width: size.height/13.5,),
                      Padding(
                        padding: EdgeInsets.only(
                            left: size.width / 100,
                            right: 0,
                            top: size.width / 100,
                            bottom: 0),
                        child: Container(
                          height: size.height / 5,
                          width: size.width / 11,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Center(
                            child: Text(
                              'D',
                              style: GoogleFonts.raleway(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.0,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width / 100,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            "Sumit Ojha",
                            style: GoogleFonts.raleway(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height / 40),
            ],
          ),
        ),
      ],
    );
  }
}
