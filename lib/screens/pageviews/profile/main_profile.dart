import 'package:cached_network_image/cached_network_image.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/constants/strings.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/provider/user_provider.dart';
import 'package:flutterapp/screens/chatscreens/widgets/cached_image.dart';
import 'package:flutterapp/screens/pageviews/chats/widgets/user_details_container.dart';
import 'package:flutterapp/screens/postscreens/open_post.dart';
import 'package:flutterapp/utils/time.dart';
import 'package:flutterapp/utils/universal_variables.dart';
import 'package:flutterapp/utils/utilities.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

class MainProfile extends StatefulWidget {
  @override
  _MainProfileState createState() => _MainProfileState();
}

class _MainProfileState extends State<MainProfile>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  ScrollController _scrollViewController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    _scrollViewController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _scrollViewController.dispose();
  }

  var year_name = {1: 'Fresher', 2: 'Sophomore', 3: 'Junior', 4: 'Senior'};
  final _controller = ScrollController();

  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController captionController = TextEditingController();

  List<String> options = [
    "Time",
    "Motivation",
    "Work",
    "Music",
    "Goals",
    "Books",
    "Life",
    "Learning"
  ];
  Map mp = {
    "Time": 0,
    "Motivation": 1,
    "Work": 2,
    "Music": 3,
    "Goals": 4,
    "Books": 5,
    "Life": 6,
    "Learning": 7
  };
  //bool isselectedTag = false;
  int selectedIdx = 0;
  _createChips(BuildContext context, StateSetter setState, int tagNum) {
    return ChipsChoice<int>.single(
      wrapped: true,
      value: selectedIdx,
      onChanged: (val) => setState(() {
        selectedIdx = val;
        print(val);
      }),
      choiceStyle: C2ChoiceStyle(
        color: Colors.deepPurple,
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

  _editPost(int tagNum, String userId, String postDocId) {
    Size size = MediaQuery.of(context).size;
    return showModalBottomSheet(
      // isDismissible: false,
        isScrollControlled: true,
        context: context,
        elevation: 0,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                final UserProvider userProvider =
                Provider.of<UserProvider>(context);
                final User user = userProvider.getUser;

                return Container(
                  height: size.height / 1.1,
                  decoration: BoxDecoration(
                    color: UniversalVariables.blackColor,
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(25.0),
                      topRight: const Radius.circular(25.0),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            children: <Widget>[
                              WillPopScope(
                                onWillPop: () => (titleController.text.length != 0 ||
                                    descriptionController.text.length != 0)
                                    ? showDialog<bool>(
                                  context: context,
                                  builder: (c) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30.0))),
                                      backgroundColor:
                                      UniversalVariables.separatorColor,
                                      title: Text(
                                        'Save as draft?',
                                        style: GoogleFonts.raleway(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20),
                                      ),
                                      content: Text(
                                        'Drafts let you save your work, so you can edit it later',
                                        style: GoogleFonts.raleway(
                                            color: Colors.white,
                                            //fontWeight: FontWeight.w700,
                                            fontSize: 15),
                                      ),
                                      actions: [
                                        FlatButton(
                                          child: Text(
                                            'DISCARD',
                                            style:
                                            TextStyle(color: Colors.white),
                                          ),
                                          onPressed: () {
                                            titleController.clear();
                                            descriptionController.clear();
                                            Navigator.pop(c, true);
                                          },
                                        ),
                                        FlatButton(
                                          child: Text(
                                            'SAVE AS DRAFT',
                                            style:
                                            TextStyle(color: Colors.white),
                                          ),
                                          onPressed: () {
                                            //  String unpublishedDocID =
                                            // randomAlphaNumeric(10);
                                            if (titleController
                                                .text.isNotEmpty ||
                                                descriptionController
                                                    .text.isNotEmpty) {
                                              try {
                                                Firestore.instance
                                                    .collection(
                                                    USERS_COLLECTION)
                                                    .document(user.uid)
                                                    .collection("unpublished")
                                                    .document(postDocId)
                                                    .updateData({
                                                  "title": titleController.text,
                                                  "description":
                                                  descriptionController
                                                      .text,
                                                  "time": DateTime.now(),
                                                  'unpublishedDocID': postDocId,
                                                  "tags": options[selectedIdx],
                                                  "userAvatar":
                                                  user.profilePhoto,
                                                  "userName": user.name,
                                                  "postedByUserUid": user.uid,
                                                }).then((value) {
                                                  titleController.clear();
                                                  descriptionController.clear();
                                                  Navigator.pop(c, true);
                                                });
                                              } catch (e) {
                                                print(e.message);
                                              }
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                )
                                    : Future<bool>.value(true),
                                child: FlatButton(
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => Navigator.maybePop(context),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Unpublished",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.raleway(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: ListView(
                              children: <Widget>[
                                TextFormField(
                                  maxLength: 20,
                                  //scrollController: _controller,
                                  //expands: true,
                                  controller: titleController,
                                  autofocus: true,
                                  autocorrect: false,
                                  keyboardType: TextInputType.multiline,
                                  style: GoogleFonts.raleway(
                                      letterSpacing: 1.2, color: Colors.white),
                                  minLines: 1,
                                  maxLines: 2,
                                  cursorColor: Colors.deepPurple,
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return "Please enter title";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    //contentPadding: EdgeInsets.symmetric(
                                    //   vertical: 50.0, horizontal: 10.0),
                                      counterStyle: TextStyle(
                                          letterSpacing: 1.2,
                                          color: Colors.white,
                                          fontSize: 10),
                                      filled: true,
                                      fillColor: UniversalVariables.separatorColor,
                                      hintText: 'Title',
                                      hintStyle: GoogleFonts.raleway(
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w500),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Colors.deepPurple))),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  height: 120,
                                  child: TextFormField(
                                    //scrollController: _controller,
                                    controller: descriptionController,
                                    expands: true,
                                    autofocus: true,
                                    autocorrect: false,
                                    keyboardType: TextInputType.multiline,
                                    style: GoogleFonts.raleway(
                                        letterSpacing: 1.2, color: Colors.white),
                                    minLines: null,
                                    maxLines: null,
                                    cursorColor: Colors.deepPurple,
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return "Please enter Description";
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration(
                                      //contentPadding: EdgeInsets.symmetric(
                                      //   vertical: 50.0, horizontal: 10.0),
                                        filled: true,
                                        fillColor: UniversalVariables.separatorColor,
                                        hintText: 'Description',
                                        hintStyle: GoogleFonts.raleway(
                                            color: Colors.white70,
                                            fontWeight: FontWeight.w500),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.deepPurple))),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      height: size.height / 5,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        color: UniversalVariables.highlightColor,
                                        borderRadius: new BorderRadius.circular(20.0),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Tags",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.raleway(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: size.height / 5,
                                        width: size.width / 1.3,
                                        decoration: BoxDecoration(
                                          color: UniversalVariables.separatorColor,
                                          borderRadius: BorderRadius.circular(20.0),
                                        ),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Wrap(
                                            //spacing: 3.0,
                                            //runSpacing: 2.0,
                                            children: [
                                              _createChips(context, setState, tagNum)
                                            ],
                                          ),
                                        ),
                                        //width: size.width,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    String postDocID = randomAlphaNumeric(10);
                                    if (_formKey.currentState.validate()) {
                                      try {
                                        Firestore.instance
                                            .collection("posts")
                                            .document(postDocID)
                                            .setData({
                                          "title": titleController.text,
                                          "description": descriptionController.text,
                                          "time": DateTime.now(),
                                          'postDocId': postDocID,
                                          "tags": options[selectedIdx],
                                          "userAvatar": user.profilePhoto,
                                          "userName": user.name,
                                          "likedByIds": [],
                                          "postedByUserUid": user.uid,
                                        }, merge: true).then((value) {
                                          Firestore.instance
                                              .collection(USERS_COLLECTION)
                                              .document(userId)
                                              .collection("unpublished")
                                              .document(postDocId)
                                              .delete();
                                        });
                                        Navigator.pop(context);
                                      } catch (e) {
                                        print(e.message);
                                      }
                                    }
                                  },
                                  child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                        color: Colors.deepPurpleAccent,
                                      ),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        });
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
      child: NestedScrollView(
        controller: _scrollViewController,
        headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              actions: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: 0, right: 0, top: size.width / 25, bottom: 0),
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              backgroundColor: UniversalVariables.blackColor,
                              isScrollControlled: true,
                              builder: (context) => UserDetailsContainer());
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: FittedBox(
                              child: IconButton(
                                icon: Icon(
                                  Icons.settings,
                                  color: Colors.white,
                                  size: size.width / 13,
                                ),
                                //onPressed: () => _scaffoldKey.currentState.openDrawer(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width / 20,
                    ),
                  ],
                ),
                SizedBox(
                  height: size.width / 20,
                ),
              ],
              //title: Text("WhatsApp using Flutter"),
              floating: false,
              pinned: false,
              snap: false,
              backgroundColor: UniversalVariables.blackColor,
              expandedHeight: size.height / 2.2,
              leadingWidth: size.width,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                //centerTitle: true,
                background: Stack(
                  //alignment: Alignment.center,
                  children: [
                    Container(
                      height: size.height / 3.3,
                      color: Colors.white,
                      width: size.width,
                      child: Image.asset(
                        'assets/profile/cover.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Center(
                      child: Column(
                        children: [
                          Padding(
                            padding:
                            EdgeInsets.fromLTRB(0, size.height / 4, 0, 0),
                            child: CachedImage(
                              user.profilePhoto,
                              isRound: true,
                              radius: size.width / 6,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${user.name}",
                            style: GoogleFonts.raleway(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          (user.year).toString() != null
                              ? Container(
                            height: size.height / 29,
                            width: size.width / 6,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: FittedBox(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Center(
                                  child: Text(
                                    "${year_name[user.year]}",
                                    style: GoogleFonts.raleway(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ),
                          )
                              : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              /*bottom: PreferredSize(
                preferredSize: Size.fromHeight(size.height/1.8),
                child:
              )*/
            ),
          ];
        },
        body: Column(
          children: [
            SizedBox(
              height: size.width / 20,
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: UniversalVariables.lightPurpleColor.withOpacity(0.2),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TabBar(
                //indicatorColor: UniversalVariables.lightPurpleColor,
                isScrollable: true,
                controller: _tabController,
                tabs: [
                  Tab(
                    child: Text(
                      'Created Posts',
                      style: GoogleFonts.raleway(
                          color: Colors.white,
                          // fontSize: 20,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Unpublished',
                      style: GoogleFonts.raleway(
                          color: Colors.white,
                          // fontSize: 20,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        StreamBuilder(
                          stream: Firestore.instance
                              .collection("posts")
                              .where("postedByUserUid", isEqualTo: user.uid)
                              .orderBy("time", descending: true)
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

                            return GridView.builder(
                              cacheExtent: 9999999,
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 4),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              padding: EdgeInsets.all(size.height / 45),
                              itemCount: snapshot.data.documents.length,
                              //reverse: true,
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

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () {

                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                                      return OpenPost(
                                                        postDocumentId: snapshot
                                                            .data
                                                            .documents[index]
                                                            .data['postDocId'],
                                                        postImageLink: snapshot
                                                            .data
                                                            .documents[index]
                                                            .data['tags'],
                                                      );
                                                    }));
                                          },
                                          child: Container(
                                            width: size.width / 2,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: UniversalVariables
                                                      .senderColor
                                                      .withOpacity(0.8),
                                                  blurRadius: 4.0,
                                                ),
                                              ],
                                              //color: UniversalVariables.separatorColor,
                                              color: UniversalVariables
                                                  .separatorColor
                                                  .withOpacity(0.1),
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
                                                      height: size.height / 10,
                                                      width: size.width / 1.8,
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
                                                          fadeInDuration: Duration(
                                                            milliseconds: 10,
                                                          ),
                                                          imageUrl: Utils
                                                              .getPostPicture(
                                                              snapshot
                                                                  .data
                                                                  .documents[
                                                              index]
                                                                  .data['tags']),
                                                          errorWidget: (context,
                                                              url, error) =>
                                                          new Icon(
                                                            Icons.error,
                                                            color: Colors.white,),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      size.height / 70,
                                                      size.height / 70,
                                                      0,
                                                      0),
                                                  child: FittedBox(
                                                    child: Text(
                                                      "${snapshot.data.documents[index].data['title']}",
                                                      style:
                                                      GoogleFonts.raleway(
                                                          color:
                                                          Colors.white,
                                                          fontSize: 15,
                                                          fontWeight:
                                                          FontWeight
                                                              .w800),
                                                    ),
                                                  ),
                                                ),
                                                //SizedBox(height: 10,),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(
                                                      size.height / 60),
                                                  child: FittedBox(
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
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        StreamBuilder(
                          stream: Firestore.instance
                              .collection(USERS_COLLECTION)
                              .document(user.uid)
                              .collection("unpublished")
                              .orderBy("time", descending: true)
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

                            return GridView.builder(
                              cacheExtent: 9999999,
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 4),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              padding: EdgeInsets.all(size.height / 45),
                              itemCount: snapshot.data.documents.length,
                              //reverse: true,
                              controller: _controller,
                              itemBuilder: (context, index) {
                                Timestamp time =
                                snapshot.data.documents[index].data['time'];
                                String postDocId = snapshot.data
                                    .documents[index].data['unpublishedDocID'];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedIdx = mp[snapshot
                                                  .data
                                                  .documents[index]
                                                  .data['tags']];
                                              titleController.text = snapshot
                                                  .data
                                                  .documents[index]
                                                  .data['title'];
                                              descriptionController.text =
                                              snapshot.data.documents[index]
                                                  .data['description'];
                                            });

                                            _editPost(
                                                mp[snapshot
                                                    .data
                                                    .documents[index]
                                                    .data['tags']],
                                                user.uid,
                                                postDocId);
                                          },
                                          child: Container(
                                            width: size.width / 2,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: UniversalVariables
                                                      .senderColor
                                                      .withOpacity(0.8),
                                                  blurRadius: 4.0,
                                                ),
                                              ],
                                              //color: UniversalVariables.separatorColor,
                                              color: UniversalVariables
                                                  .separatorColor
                                                  .withOpacity(0.1),
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
                                                      height: size.height / 8,
                                                      width: size.width / 1.8,
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
                                                          imageUrl: Utils
                                                              .getPostPicture(
                                                              snapshot
                                                                  .data
                                                                  .documents[
                                                              index]
                                                                  .data['tags']),
                                                          fadeInDuration: Duration(
                                                              milliseconds: 10
                                                          ),
                                                          errorWidget: (context,
                                                              url, error) =>
                                                          new Icon(
                                                            Icons.error,
                                                            color: Colors.white,
                                                          ),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(
                                                      size.height / 60),
                                                  child: FittedBox(
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
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ],
                controller: _tabController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}