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
