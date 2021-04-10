import 'dart:async';
import 'dart:ui';
import 'package:cache_image/cache_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutterapp/provider/user_provider.dart';
import 'package:flutterapp/screens/chatscreens/widgets/cached_image.dart';
import 'package:flutterapp/screens/pageviews/chats/widgets/user_circle.dart';
import 'package:flutterapp/screens/pageviews/profile/other_user_profile.dart';
import 'package:flutterapp/screens/postscreens/add_post.dart';
import 'package:flutterapp/screens/postscreens/open_post.dart';
import 'package:flutterapp/screens/postscreens/search_post.dart';
import 'package:flutterapp/utils/time.dart';
import 'package:flutterapp/utils/universal_variables.dart';
import 'package:flutterapp/utils/utilities.dart';
import 'package:flutterapp/widgets/skype_appbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:flutterapp/models/user.dart';
import 'package:intl/intl.dart';

class PostScreen extends StatefulWidget {
  final PageController pageController;

  const PostScreen({Key key, this.pageController}) : super(key: key);
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  final _controller = ScrollController();

  bool visiblePostTextField = false;
  Icon floatingicon = Icon(Icons.add);
  bool chipSelected = false;
  //TextEditingController titleController = new TextEditingController();
  //TextEditingController descriptionController = new TextEditingController();
  //TextEditingController captionController = TextEditingController();

  List<String> options = [
    "All",
    "Academics",
    "Confessions",
    "Android",
    "Machine Learning",
    "React",
    "Databases",
    "Competitive Programming",
    "Others"
  ];


  int _tag = 0;
  _buildChoiceList() {
    return ChipsChoice<int>.single(
      value: _tag,
      onChanged: (val) => setState(() {
        _tag = val;
        //print(val);
      }),
      choiceStyle: C2ChoiceStyle(
        color: Colors.deepPurple[600],
        brightness: Brightness.dark,
        margin: EdgeInsets.all(5),
        //showCheckmark: false,
      ),
      choiceActiveStyle: C2ChoiceStyle(
        color: Colors.green,
        brightness: Brightness.dark,
      ),
      choiceItems: C2Choice.listFrom<int, String>(
        source: options,
        value: (i, v) => i,
        label: (i, v) => v,
      ),
    );
  }

  String checkDate(String dateString) {
    //  example, dateString = "2020-01-26";

    DateTime checkedTime = DateTime.parse(dateString);
    DateTime currentTime = DateTime.now();

    if ((currentTime.year == checkedTime.year) &&
        (currentTime.month == checkedTime.month) &&
        (currentTime.day == checkedTime.day)) {
      return "TODAY";
    } else if ((currentTime.year == checkedTime.year) &&
        (currentTime.month == checkedTime.month)) {
      if ((currentTime.day - checkedTime.day) == 1) {
        return "YESTERDAY";
      } else if ((currentTime.day - checkedTime.day) == -1) {
        return "TOMORROW";
      } else {
        return dateString;
      }
    }
  }

  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {
        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }

    return time;
  }

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
        appBar: SkypeAppBar(
          title: Text(
            "Asked Questions",
            style: GoogleFonts.raleway(
                color: Colors.white, fontWeight: FontWeight.w600),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SearchPostScreen();
                }));
                //Navigator.pushNamed(context, "/search_screen");
              },
            ),
          ],
        ),
        floatingActionButton: AddPost(),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                //SizedBox(height: 10,),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildChoiceList(),
                    ],
                  ),
                ),

                Divider(
                  color: Colors.white.withOpacity(0.4),
                  thickness: 1,
                ),
                _tag == 0
                    ? StreamBuilder(
                        stream: Firestore.instance
                            .collection("posts")
                            .orderBy("time")
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.data == null) {
                            return Center(
                              child: CircularProgressIndicator(),
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

                          return ListView.builder(
                            cacheExtent: 9999999,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            padding: EdgeInsets.all(10),
                            itemCount: snapshot.data.documents.length,
                            reverse: true,
                            controller: _controller,
                            itemBuilder: (context, index) {
                              String shortDescription = snapshot
                                  .data.documents[index].data['description'];
                              int lastIdx = shortDescription.length;
                              Timestamp time =
                                  snapshot.data.documents[index].data['time'];
                              if (lastIdx > 35) {
                                shortDescription =
                                    shortDescription.substring(0, 33);
                              }
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          width: size.width,
                                          decoration: BoxDecoration(
                                            //color: UniversalVariables.separatorColor,
                                            color: UniversalVariables
                                                .separatorColor,
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Stack(
                                                children: [
                                                  Container(
                                                    height: size.height / 6,
                                                    width: size.width,
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  20.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  20.0),
                                                        ),
                                                        child:
                                                            CachedNetworkImage(
                                                          fadeInDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      10),
                                                          imageUrl: Utils
                                                              .getPostPicture(
                                                                  snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data['tags']),
                                                          fit: BoxFit.cover,
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              new Icon(
                                                            Icons.error,
                                                            color: Colors.white,
                                                          ),
                                                        )),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          user.uid !=
                                                                  snapshot
                                                                          .data
                                                                          .documents[
                                                                              index]
                                                                          .data[
                                                                      'postedByUserUid']
                                                              ? Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (_) {
                                                                  return OtherMainProfile(
                                                                    currUserUid: snapshot
                                                                        .data
                                                                        .documents[
                                                                            index]
                                                                        .data['postedByUserUid'],
                                                                    currUserName: snapshot
                                                                        .data
                                                                        .documents[
                                                                            index]
                                                                        .data['userName'],
                                                                    currUserImgUrl: snapshot
                                                                        .data
                                                                        .documents[
                                                                            index]
                                                                        .data['userAvatar'],
                                                                  );
                                                                }))
                                                              : widget
                                                                  .pageController
                                                                  .animateToPage(
                                                                  5,
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          300),
                                                                  curve: Curves
                                                                      .easeIn,
                                                                );
                                                        },
                                                        child: CachedImage(
                                                          snapshot
                                                              .data
                                                              .documents[index]
                                                              .data['userAvatar'],
                                                          isRound: true,
                                                          radius: 35,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        12, 12, 0, 0),
                                                child: Text(
                                                  "${snapshot.data.documents[index].data['title']}",
                                                  style: GoogleFonts.raleway(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ),
                                              ),
                                              //SizedBox(height: 10,),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        12, 8, 0, 0),
                                                child: Text(
                                                  "$shortDescription...",
                                                  style: GoogleFonts.raleway(
                                                      color: Colors.white70,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: Text(
                                                      Time.timeAgo(time),
                                                      style:
                                                          GoogleFonts.raleway(
                                                        color: Colors.white70
                                                            .withOpacity(0.4),
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      ),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                                      return OpenPost(
                                                                        postDocumentId: snapshot
                                                                            .data
                                                                            .documents[
                                                                        index]
                                                                            .data[
                                                                        'postDocId'],
                                                                        postImageLink:
                                                                        snapshot
                                                                            .data
                                                                            .documents[
                                                                        index]
                                                                            .data['tags'],
                                                                        postTitle: snapshot
                                                                            .data
                                                                            .documents[
                                                                        index]
                                                                            .data['title'],
                                                                        postDescription: snapshot
                                                                            .data
                                                                            .documents[
                                                                        index]
                                                                            .data[
                                                                        'description'],
                                                                        postPostedByUid: snapshot
                                                                            .data
                                                                            .documents[
                                                                        index]
                                                                            .data[
                                                                        'postedByUserUid'],
                                                                      );
                                                        }));
                                                      },
                                                      child: Container(
                                                        height:
                                                            size.height / 20,
                                                        width: size.width / 4,
                                                        decoration:
                                                            BoxDecoration(
                                                          //color: UniversalVariables.lightPurpleColor,
                                                          //color: Colors.redAccent,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    20.0),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    20.0),
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            'Read More',
                                                            style: GoogleFonts
                                                                .raleway(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: size.height / 55,
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      )
                    : StreamBuilder(
                        stream: Firestore.instance
                            .collection("posts")
                            .orderBy("time")
                            .where("tags", isEqualTo: options[_tag])
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.data == null) {
                            return Center(
                              child: CircularProgressIndicator(),
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

                          return ListView.builder(
                            cacheExtent: 9999999,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            padding: EdgeInsets.all(10),
                            itemCount: snapshot.data.documents.length,
                            reverse: true,
                            controller: _controller,
                            itemBuilder: (context, index) {
                              // print("ye length hai "+"${snapshot.data.documents.length}");

                              String shortDescription = snapshot
                                  .data.documents[index].data['description'];
                              Timestamp time =
                                  snapshot.data.documents[index].data['time'];
                              int lastIdx = shortDescription.length;
                              if (lastIdx > 35) {
                                shortDescription =
                                    shortDescription.substring(0, 33);
                              }
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          width: size.width,
                                          decoration: BoxDecoration(
                                            color: UniversalVariables
                                                .separatorColor,
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Stack(
                                                children: [
                                                  Container(
                                                    height: size.height / 6,
                                                    width: size.width,
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  20.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  20.0),
                                                        ),
                                                        child:
                                                            CachedNetworkImage(
                                                          fadeInDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      10),
                                                          imageUrl: Utils
                                                              .getPostPicture(
                                                                  snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data['tags']),
                                                          fit: BoxFit.cover,
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              new Icon(
                                                            Icons.error,
                                                            color: Colors.white,
                                                          ),
                                                        )),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          user.uid !=
                                                                  snapshot
                                                                          .data
                                                                          .documents[
                                                                              index]
                                                                          .data[
                                                                      'postedByUserUid']
                                                              ? Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (_) {
                                                                  return OtherMainProfile(
                                                                    currUserUid: snapshot
                                                                        .data
                                                                        .documents[
                                                                            index]
                                                                        .data['postedByUserUid'],
                                                                    currUserName: snapshot
                                                                        .data
                                                                        .documents[
                                                                            index]
                                                                        .data['userName'],
                                                                    currUserImgUrl: snapshot
                                                                        .data
                                                                        .documents[
                                                                            index]
                                                                        .data['userAvatar'],
                                                                  );
                                                                }))
                                                              : widget
                                                                  .pageController
                                                                  .animateToPage(
                                                                  5,
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          300),
                                                                  curve: Curves
                                                                      .easeIn,
                                                                );
                                                        },
                                                        child: CachedImage(
                                                          snapshot
                                                              .data
                                                              .documents[index]
                                                              .data['userAvatar'],
                                                          isRound: true,
                                                          radius: 35,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        12, 12, 0, 0),
                                                child: Text(
                                                  "${snapshot.data.documents[index].data['title']}",
                                                  style: GoogleFonts.raleway(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ),
                                              ),
                                              //SizedBox(height: 10,),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        12, 8, 0, 0),
                                                child: Text(
                                                  "$shortDescription...",
                                                  style: GoogleFonts.raleway(
                                                      color: Colors.white70,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),

                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: Text(
                                                      Time.timeAgo(time),
                                                      style:
                                                          GoogleFonts.raleway(
                                                        color: Colors.white70
                                                            .withOpacity(0.4),
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      ),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: GestureDetector(
                                                      onTap: () {

                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                                      return OpenPost(
                                                                        postDocumentId: snapshot
                                                                            .data
                                                                            .documents[
                                                                        index]
                                                                            .data[
                                                                        'postDocId'],
                                                                        postImageLink:
                                                                        snapshot
                                                                            .data
                                                                            .documents[
                                                                        index]
                                                                            .data['tags'],
                                                                        postTitle: snapshot
                                                                            .data
                                                                            .documents[
                                                                        index]
                                                                            .data['title'],
                                                                        postDescription: snapshot
                                                                            .data
                                                                            .documents[
                                                                        index]
                                                                            .data[
                                                                        'description'],
                                                                        postPostedByUid: snapshot
                                                                            .data
                                                                            .documents[
                                                                        index]
                                                                            .data[
                                                                        'postedByUserUid'],
                                                                      );
                                                        }));
                                                      },
                                                      child: Container(
                                                        height:
                                                            size.height / 20,
                                                        width: size.width / 4,
                                                        decoration:
                                                            BoxDecoration(
                                                          //color: UniversalVariables.lightPurpleColor,
                                                          //color: Colors.redAccent,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    20.0),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    20.0),
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            'Read More',
                                                            style: GoogleFonts
                                                                .raleway(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: size.height / 55,
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
