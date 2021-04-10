import 'dart:ui';
import 'package:background_app_bar/background_app_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/provider/user_provider.dart';
import 'package:flutterapp/screens/chatscreens/widgets/cached_image.dart';
import 'package:flutterapp/utils/universal_variables.dart';
import 'package:flutterapp/utils/utilities.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:flutterapp/utils/time.dart';

class OpenPost extends StatefulWidget {
  final String postDocumentId;
  final String postImageLink; //  tag name
  final String postTitle;
  final String postDescription;
  final String postPostedByUid;
  const OpenPost(
      {Key key,
      this.postDocumentId,
      this.postImageLink,
      this.postTitle,
      this.postDescription,
      this.postPostedByUid})
      : super(key: key);

  @override
  _OpenPostState createState() => _OpenPostState();
}

class _OpenPostState extends State<OpenPost> {
  final _controller = ScrollController();
  GlobalKey itemKey;
  TextEditingController commentController = new TextEditingController();
  var year_name = {1: 'Fresher', 2: 'Sophomore', 3: 'Junior', 4: 'Senior'};
  ScrollController scrollController;
  final _bodyController = new ScrollController();
  List reportedIds = [];
  List likedByIds = [];
  Color _likeBtnColor = UniversalVariables.greyColor;
  bool _isLiked = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController captionController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> options = [
    "Academics",
    "Confessions",
    "Android",
    "Machine Learning",
    "React",
    "Databases",
    "Competitive Programming",
    "Others"
  ];
  Map mp = {
    "Academics": 0,
    "Confessions": 1,
    "Android": 2,
    "Machine Learning": 3,
    "React": 4,
    "Databases": 5,
    "Competitive Programming": 6,
    "Others": 7
  };

  int selectedIdx = 0;
  _createChips(BuildContext context, StateSetter setState) {
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

  @override
  void initState() {
    // TODO: implement initState
    itemKey = GlobalKey();
    scrollController = ScrollController();
    selectedIdx = mp[widget.postImageLink];
    titleController.text = widget.postTitle;
    descriptionController.text = widget.postDescription;

    super.initState();
  }

  _editOwnPost() {
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
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        children: <Widget>[
                          FlatButton(
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.maybePop(context),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Edit Post",
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
                                  hintText: "Title",
                                  hintStyle: GoogleFonts.raleway(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w500),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.deepPurple))),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              height: 120,
                              child: TextFormField(
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
                                    fillColor:
                                        UniversalVariables.separatorColor,
                                    hintText: "Description",
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
                                    borderRadius:
                                        new BorderRadius.circular(20.0),
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
                                          _createChips(context, setState)
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
                                // if(titleController.text.isNotEmpty && descriptionController.text.isNotEmpty){
                                if (_formKey.currentState.validate()) {
                                  try {
                                    Firestore.instance
                                        .collection("posts")
                                        .document(widget.postDocumentId)
                                        .setData({
                                      "title": titleController.text,
                                      "description": descriptionController.text,
                                      "time": DateTime.now(),
                                      'postDocId': widget.postDocumentId,
                                      "tags": options[selectedIdx],
                                      "userAvatar": user.profilePhoto,
                                      "userName": user.name,
                                      "postedByUserUid": user.uid,
                                    }, merge: true);
                                    titleController.clear();
                                    descriptionController.clear();
                                    selectedIdx = 0;
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

  _editPost2() {
    Size size = MediaQuery.of(context).size;
    return showModalBottomSheet(
        // isDismissible: false,
        isScrollControlled: true,
        context: context,
        elevation: 0,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            height: size.height / 4.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                UniversalVariables.blackColor,
                UniversalVariables.separatorColor,
              ]),
              color: UniversalVariables.blackColor,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(25.0),
                topRight: const Radius.circular(25.0),
              ),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: <Widget>[
                      FlatButton(
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        _editOwnPost();
                      },
                      borderRadius: BorderRadius.circular(20.0),
                      child: Ink(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              UniversalVariables.gradientColorStart,
                              UniversalVariables.gradientColorEnd
                            ]),
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Padding(
                            padding:  EdgeInsets.all(size.width/30),
                            child: Center(
                              child: Text(
                                'Edit Post',
                                style: GoogleFonts.raleway(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          height: size.height / 16,
                          width: size.width / 3,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Firestore.instance
                            .collection("posts")
                            .document(widget.postDocumentId)
                            .delete();
                          Navigator.pop(context);
                        Navigator.pop(context);

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            UniversalVariables.gradientColorStart,
                            UniversalVariables.gradientColorEnd
                          ]),
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(size.width/30),
                          child: Center(
                            child: Text(
                              'Delete Post',
                              style: GoogleFonts.raleway(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        height: size.height / 16,
                        width: size.width / 3,
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final User user = userProvider.getUser;

    Future<bool> onLikeButtonTapped(bool isLiked) async {
      if (!isLiked && !(likedByIds.contains(user.uid))) {
        likedByIds.add(user.uid);
        _likeBtnColor = Colors.red;
        isLiked = true;
      } else {
        if (likedByIds.contains(user.uid)) {
          likedByIds.remove(user.uid);
          _likeBtnColor = UniversalVariables.greyColor;
        }
        isLiked = false;
      }

      try {
        Firestore.instance
            .collection("posts")
            .document(widget.postDocumentId)
            .setData({
          "likedByIds": likedByIds,
        }, merge: true);
      } catch (e) {
        print(e);
      }

      return isLiked;
    }

    final _scaffoldKey = GlobalKey<ScaffoldState>();
    bool isCommentReported = false;
    Size size = MediaQuery.of(context).size;
    final controller = ScrollController();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: UniversalVariables.blackColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.height / 5),
        child: Stack(
          children: [
            CustomScrollView(
              physics: ScrollPhysics(),
              controller: controller,
              slivers: [
                SliverAppBar(
                  actions: [
                    widget.postPostedByUid == user.uid
                        ? IconButton(
                            icon: Icon(
                              Icons.arrow_drop_down_circle_outlined,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              _editPost2();
                            },
                          )
                        : Container(),
                    SizedBox(
                      width: size.width / 40,
                    ),
                  ],
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30))),
                  expandedHeight: size.height / 4,
                  floating: true,
                  pinned: false,
                  snap: false,
                  elevation: 0.0,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: BackgroundFlexibleSpaceBar(
                    centerTitle: false,
                    //titlePadding: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                    background: Container(
                      child: Stack(
                        children: [
                          Container(
                            width: size.width,
                            child: CachedNetworkImage(
                              imageUrl:
                                  Utils.getPostPicture(widget.postImageLink),
                              placeholder: (context, url) => Center(
                                  child: new CircularProgressIndicator()),
                              errorWidget: (context, url, error) => new Icon(
                                Icons.error,
                                color: Colors.white,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                            child: Container(
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                child: Container(
                  height: size.width / 10,
                  width: size.width / 10,
                  child: FittedBox(
                      child: StreamBuilder(
                    stream: Firestore.instance
                        .collection("posts")
                        .where('postDocId', isEqualTo: widget.postDocumentId)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.data == null) {
                        return Container();
                      }

                      var v=[];

                      for (int i = 0; i < snapshot.data.documents.length; i++) {
                        v = snapshot.data.documents[i].data['likedByIds'];
                      }
                      if(v.toList()==null){
                        v=[];
                      }
                      likedByIds = v.toList();

                      return LikeButton(
                          //isLiked: _isLiked,
                          onTap: onLikeButtonTapped,
                          likeBuilder: (bool isLiked) {
                            return Icon(
                              Icons.favorite,
                              color: likedByIds.contains(user.uid)
                                  ? Colors.red
                                  : Colors.white70,
                            );
                          });
                    },
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        key: itemKey,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              controller: scrollController,
              //physics: ScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  StreamBuilder(
                    stream: Firestore.instance
                        .collection("posts")
                        .where('postDocId', isEqualTo: widget.postDocumentId)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.data == null) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        padding: EdgeInsets.all(8),
                        itemCount: snapshot.data.documents.length,
                        reverse: true,
                        controller: _bodyController,
                        itemBuilder: (context, index) {
                          Timestamp time =
                              snapshot.data.documents[index].data['time'];

                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    FittedBox(
                                      child: Text(
                                        "${snapshot.data.documents[index].data['title']}",
                                        style: GoogleFonts.raleway(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      height: size.height / 27,
                                      width: size.width / 6,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                UniversalVariables.senderColor,
                                            blurRadius: 8.0,
                                          ),
                                        ],
                                        color: Colors.white.withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: FittedBox(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                              "#${(snapshot.data.documents[index].data['tags']).toString().toLowerCase()}",
                                              style: GoogleFonts.raleway(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    CachedImage(
                                      snapshot.data.documents[index]
                                          .data['userAvatar'],
                                      isRound: true,
                                      radius: size.width / 13,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "By ",
                                      style: GoogleFonts.raleway(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                    FittedBox(
                                      child: Text(
                                        "${snapshot.data.documents[index].data['userName']}",
                                        style: GoogleFonts.raleway(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    Spacer(),
                                    FittedBox(
                                      child: Text(
                                        Time.timeAgo(time),
                                        style: GoogleFonts.raleway(
                                            color:
                                                Colors.white70.withOpacity(0.3),
                                            fontWeight: FontWeight.w300,
                                            fontSize: 15),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Stack(
                                  children: [
                                    Container(
                                      width: size.width,
                                      /*decoration: BoxDecoration(
                                        color: UniversalVariables.separatorColor,
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),*/
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "${snapshot.data.documents[index].data['description']}",
                                            style: GoogleFonts.raleway(
                                                wordSpacing: 1,
                                                letterSpacing: 0.8,
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  StreamBuilder(
                      stream: Firestore.instance
                          .collection("posts")
                          .document(widget.postDocumentId)
                          .collection("comments")
                          .orderBy("time", descending: true)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.data == null) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(9, 0, 0, 0),
                              child: Text(
                                "Comments ",
                                style: GoogleFonts.raleway(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 9, 0),
                              child: Container(
                                color: Colors.white.withOpacity(0.3),
                                height: 1.2,
                                width: size.width / 1.6,
                              ),
                            ),
                          ],
                        );
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  StreamBuilder(
                    stream: Firestore.instance
                        .collection("posts")
                        .document(widget.postDocumentId)
                        .collection("comments")
                        .orderBy("time", descending: true)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.data == null) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        padding: EdgeInsets.all(8),
                        itemCount: snapshot.data.documents.length,
                        reverse: true,
                        controller: _controller,
                        itemBuilder: (context, index) {
                          var v = snapshot
                              .data.documents[index].data['reportedIds'];

                          return !(v.contains(user.uid))
                              ? Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CachedImage(
                                            snapshot.data.documents[index]
                                                .data['userAvatar'],
                                            isRound: true,
                                            radius: 50,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Material(
                                              color:
                                                  UniversalVariables.blackColor,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              child: InkWell(
                                                onLongPress: () {
                                                  if (user.name ==
                                                          snapshot
                                                                  .data
                                                                  .documents[index]
                                                                  .data[
                                                              'userName'] &&
                                                      user.uid ==
                                                          snapshot
                                                              .data
                                                              .documents[index]
                                                              .data['userUid']) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                        backgroundColor:
                                                            UniversalVariables
                                                                .separatorColor,
                                                        title: Text(
                                                          "Delete your comment?",
                                                          style: GoogleFonts
                                                              .raleway(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize: 18),
                                                        ),
                                                        actions: [
                                                          FlatButton(
                                                            child: Text(
                                                              "YES",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            onPressed: () {
                                                              Firestore.instance
                                                                  .collection(
                                                                      "posts")
                                                                  .document(widget
                                                                      .postDocumentId)
                                                                  .collection(
                                                                      "comments")
                                                                  .document(snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data['postCurrentCommentId'])
                                                                  .delete()
                                                                  .then((value) {
                                                                Navigator
                                                                    .maybePop(
                                                                        context);
                                                                _scaffoldKey
                                                                    .currentState
                                                                    .hideCurrentSnackBar();
                                                                _scaffoldKey
                                                                    .currentState
                                                                    .showSnackBar(
                                                                        SnackBar(
                                                                  content:
                                                                      Container(
                                                                    height:
                                                                        size.height /
                                                                            22,
                                                                    child: Text(
                                                                      "Comment Deleted!!",
                                                                      style: GoogleFonts.raleway(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                  ),
                                                                  duration:
                                                                      Duration(
                                                                    seconds: 2,
                                                                  ),
                                                                  backgroundColor:
                                                                      UniversalVariables
                                                                          .separatorColor,
                                                                ));
                                                              });
                                                            },
                                                          ),
                                                          FlatButton(
                                                            child: Text(
                                                              "NO",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            onPressed: () =>
                                                                Navigator
                                                                    .maybePop(
                                                                        context),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  } else {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                        backgroundColor:
                                                            UniversalVariables
                                                                .separatorColor,
                                                        title: Text(
                                                          "Report this comment!",
                                                          style: GoogleFonts
                                                              .raleway(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize: 18),
                                                        ),
                                                        actions: [
                                                          FlatButton(
                                                            child: Text(
                                                              "YES",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            onPressed: () {
                                                              try {
                                                                reportedIds =
                                                                    v.toList();
                                                                reportedIds.add(
                                                                    user.uid);
                                                                Firestore
                                                                    .instance
                                                                    .collection(
                                                                        "posts")
                                                                    .document(widget
                                                                        .postDocumentId)
                                                                    .collection(
                                                                        "comments")
                                                                    .document(snapshot
                                                                        .data
                                                                        .documents[
                                                                            index]
                                                                        .data['postCurrentCommentId'])
                                                                    .setData({
                                                                  "reportedIds":
                                                                      reportedIds,
                                                                }, merge: true);
                                                                Navigator.pop(
                                                                    context);
                                                                _scaffoldKey
                                                                    .currentState
                                                                    .hideCurrentSnackBar();
                                                                _scaffoldKey
                                                                    .currentState
                                                                    .showSnackBar(
                                                                        SnackBar(
                                                                  content:
                                                                      Container(
                                                                    height:
                                                                        size.height /
                                                                            22,
                                                                    child: Text(
                                                                      "Comment Reported!!",
                                                                      style: GoogleFonts.raleway(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                  ),
                                                                  duration:
                                                                      Duration(
                                                                    seconds: 2,
                                                                  ),
                                                                  backgroundColor:
                                                                      UniversalVariables
                                                                          .separatorColor,
                                                                ));
                                                              } catch (e) {
                                                                print(
                                                                    e.message);
                                                              }
                                                            },
                                                          ),
                                                          FlatButton(
                                                            child: Text(
                                                              "NO",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            onPressed: () =>
                                                                Navigator
                                                                    .maybePop(
                                                                        context),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: Ink(
                                                  decoration: BoxDecoration(
                                                    color: UniversalVariables
                                                        .separatorColor,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(20.0),
                                                      bottomLeft:
                                                          Radius.circular(20.0),
                                                      bottomRight:
                                                          Radius.circular(20.0),
                                                    ),
                                                  ),

                                                  //height: 50,
                                                  //width: 50,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SingleChildScrollView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "${snapshot.data.documents[index].data['userName']}",
                                                                style: GoogleFonts.raleway(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              StreamBuilder(
                                                                  stream: Firestore
                                                                      .instance
                                                                      .collection(
                                                                          "users")
                                                                      .where(
                                                                          'uid',
                                                                          isEqualTo: snapshot.data.documents[index].data[
                                                                              'userUid'])
                                                                      .snapshots(),
                                                                  builder: (context,
                                                                      AsyncSnapshot<
                                                                              QuerySnapshot>
                                                                          snapshot) {
                                                                    if (snapshot
                                                                            .data ==
                                                                        null) {
                                                                      return Container();
                                                                    }

                                                                    int yearNum = snapshot
                                                                        .data
                                                                        .documents[
                                                                            0]
                                                                        .data['year'];
                                                                    return Container(
                                                                      height:
                                                                          size.height /
                                                                              43,
                                                                      width:
                                                                          size.width /
                                                                              9,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .white
                                                                            .withOpacity(0.2),
                                                                        borderRadius:
                                                                            BorderRadius.circular(20),
                                                                      ),
                                                                      child:
                                                                          FittedBox(
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(5.0),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              "${year_name[yearNum]}",
                                                                              style: GoogleFonts.raleway(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  })
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          "${snapshot.data.documents[index].data['userComment']}",
                                                          style: GoogleFonts
                                                              .raleway(
                                                                  color: Colors
                                                                      .white60,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                )
                              : Container();
                        },
                      );
                    },
                  ),
                  SizedBox(
                    height: size.height / 5,
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                //margin: EdgeInsets.only(left: 16.0),
                decoration: BoxDecoration(
                  color: UniversalVariables.separatorColor,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  autofocus: false,
                  minLines: 1,
                  maxLines: 3,
                  //maxLength: 200,
                  style: GoogleFonts.raleway(
                    letterSpacing: 1.2,
                    color: Colors.white,
                  ),
                  controller: commentController,
                  decoration: InputDecoration(
                      counterStyle: TextStyle(
                        letterSpacing: 1.2,
                        color: Colors.white,
                      ),
                      labelStyle: GoogleFonts.raleway(
                        color: Colors.white,
                      ),
                      hintText: 'Leave your thoughts here...',
                      hintStyle: GoogleFonts.raleway(
                          fontSize: 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.w400),
                      filled: true,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 5,
                          width: 5,
                          decoration: BoxDecoration(
                            color: UniversalVariables.blackColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  Utils.getInitials(userProvider.getUser.name),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: UniversalVariables.lightPurpleColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      suffixIcon: IconButton(
                          icon: Icon(
                            Icons.send_sharp,
                            color: UniversalVariables.lightPurpleColor,
                          ),
                          onPressed: () {
                            String postCurrentCommentId =
                                randomAlphaNumeric(10);
                            if (commentController.text.isNotEmpty) {
                              try {
                                Firestore.instance
                                    .collection("posts")
                                    .document(widget.postDocumentId)
                                    .collection("comments")
                                    .document(postCurrentCommentId)
                                    .setData({
                                  "userComment": commentController.text,
                                  "time": DateTime.now(),
                                  'postCurrentCommentId': postCurrentCommentId,
                                  "userAvatar": user.profilePhoto,
                                  "userName": user.name,
                                  "userUid": user.uid,
                                  "reportedIds": [],
                                }, merge: true);
                                FocusScope.of(context).unfocus();
                                commentController.clear();
                                scrollController.animateTo(
                                  scrollController.position.maxScrollExtent,
                                  curve: Curves.easeOut,
                                  duration: const Duration(milliseconds: 1500),
                                );
                                //Navigator.pop(context);
                              } catch (e) {
                                print(e.message);
                              }
                            }
                          })),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
