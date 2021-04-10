import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/constants/year_constants.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/resources/auth_methods.dart';
import 'package:flutterapp/utils/universal_variables.dart';
import 'package:flutterapp/widgets/custom_tile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chatscreens/chat_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  AuthMethods _authMethods = AuthMethods();

  List<User> userList;
  String query = "";
  TextEditingController searchController = TextEditingController();
  int _currYear = 0;

  void choiceAction(String choice) {
    if (choice == Constants.all_year) {
      _currYear = 0;
    } else if (choice == Constants.first_year) {
      _currYear = 1;
    } else if (choice == Constants.second_year) {
      _currYear = 2;
    } else if (choice == Constants.third_third) {
      _currYear = 3;
    } else {
      _currYear = 4;
    }
  }

  @override
  void initState() {
    super.initState();
    _authMethods.getCurrentUser().then((FirebaseUser user) {
      _authMethods.fetchAllUsers(user).then((List<User> list) {
        setState(() {
          userList = list;
        });
      });
    });
  }

  searchAppBar(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(gradient: UniversalVariables.fabGradient),
      ),
      actions: [
        PopupMenuButton<String>(
          color: UniversalVariables.separatorColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          icon: Icon(
            Icons.sort,
            color: Colors.white,
          ),
          onSelected: choiceAction,
          offset: Offset(-1 * size.width / 10, size.height / 30),
          itemBuilder: (BuildContext context) {
            return Constants.choices.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.deepPurpleAccent,
                      size: 15,
                    ),
                    SizedBox(
                      width: size.width / 50,
                    ),
                    Text(
                      choice,
                      style: GoogleFonts.raleway(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Spacer(),
                    Constants.choices[_currYear] == choice
                        ? Icon(
                            Icons.done_outlined,
                            color: Colors.green,
                            size: 23,
                          )
                        : Container(),
                  ],
                ),
              );
            }).toList();
          },
        ),
      ],
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: TextField(
            controller: searchController,
            onChanged: (val) {
              setState(() {
                query = val;
              });
            },
            cursorColor: UniversalVariables.blackColor,
            autofocus: true,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 35,
            ),
            decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    WidgetsBinding.instance
                        .addPostFrameCallback((_) => searchController.clear());
                  },
                ),
                border: InputBorder.none,
                hintText: "Search",
                hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                  color: Color(0x88ffffff),
                )),
          ),
        ),
      ),
    );
  }

  buildSuggestions(String query) {
    final List<User> suggestionList = query.isEmpty
        ? []
        : userList.where((User user) {
            String _getUsername = user.username.toLowerCase();
            String _query = query.toLowerCase();
            String _getName = user.name.toLowerCase();
            bool matchesUsername = _getUsername.contains(_query);
            bool matchesName = _getName.contains(_query);

            return (matchesUsername || matchesName);

            // (User user) => (user.username.toLowerCase().contains(query.toLowerCase()) ||
            //     (user.name.toLowerCase().contains(query.toLowerCase()))),
          }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: ((context, index) {
        User searchedUser = User(
            uid: suggestionList[index].uid,
            profilePhoto: suggestionList[index].profilePhoto,
            name: suggestionList[index].name,
            username: suggestionList[index].username,
            year: suggestionList[index].year);

        return searchedUser.year == _currYear
            ? CustomTile(
                mini: false,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatScreen(
                                receiver: searchedUser,
                              )));
                },
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(searchedUser.profilePhoto),
                  backgroundColor: Colors.grey,
                ),
                title: Text(
                  searchedUser.username,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  searchedUser.name,
                  style: TextStyle(color: UniversalVariables.greyColor),
                ),
              )
            : _currYear == 0
                ? CustomTile(
                    mini: false,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                    receiver: searchedUser,
                                  )));
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(searchedUser.profilePhoto),
                      backgroundColor: Colors.grey,
                    ),
                    title: Text(
                      searchedUser.username,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      searchedUser.name,
                      style: TextStyle(color: UniversalVariables.greyColor),
                    ),
                  )
                : Container();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: searchAppBar(context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: buildSuggestions(query),
      ),
    );
  }
}


/* 
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
*/
/* 
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
*/
/* 
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
*/
/* 
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
*/
