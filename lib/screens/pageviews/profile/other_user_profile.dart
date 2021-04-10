import 'package:cached_network_image/cached_network_image.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/constants/strings.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/provider/user_provider.dart';
import 'package:flutterapp/screens/chatscreens/widgets/cached_image.dart';
import 'package:flutterapp/screens/postscreens/open_post.dart';
import 'package:flutterapp/utils/time.dart';
import 'package:flutterapp/utils/universal_variables.dart';
import 'package:flutterapp/utils/utilities.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

class OtherMainProfile extends StatefulWidget {
  final String currUserUid;
  final String currUserName;
  final String currUserImgUrl;

  const OtherMainProfile(
      {Key key, this.currUserUid, this.currUserImgUrl, this.currUserName})
      : super(key: key);

  @override
  _OtherMainProfileState createState() => _OtherMainProfileState();
}

class _OtherMainProfileState extends State<OtherMainProfile>
    with SingleTickerProviderStateMixin {
  //TabController _tabController;
  ScrollController _scrollViewController;
  @override
  void initState() {
    // _tabController = new TabController(length: 1, vsync: this);
    _scrollViewController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    //_tabController.dispose();
    _scrollViewController.dispose();
  }

  var year_name = {1: 'Fresher', 2: 'Sophomore', 3: 'Junior', 4: 'Senior'};
  final _controller = ScrollController();

  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController captionController = TextEditingController();

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
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final User user = userProvider.getUser;
    Size size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: DefaultTabController(
        length: 1,
        child: Scaffold(
          // bottomNavigationBar: ,
          body: NestedScrollView(
            controller: _scrollViewController,
            headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  leading: Row(
                    children: [
                      SizedBox(
                        width: size.width / 20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 0, right: 0, top: size.width / 25, bottom: 0),
                        child: InkWell(
                          onTap: (){
                            Navigator.pop(context);
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
                                    Icons.arrow_back_ios_rounded,
                                    color: Colors.white,
                                    size: size.width/13,
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
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  backwardsCompatibility: false,
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
                                padding: EdgeInsets.fromLTRB(
                                    0, size.height / 4, 0, 0),
                                child: CachedImage(
                                  widget.currUserImgUrl,
                                  isRound: true,
                                  radius: size.width / 6,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "${widget.currUserName}",
                                style: GoogleFonts.raleway(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              StreamBuilder(
                                  stream: Firestore.instance
                                      .collection("users")
                                      .where('uid',
                                          isEqualTo: widget.currUserUid)
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.data == null) {
                                      return Container();
                                    }

                                    int yearNum =
                                        snapshot.data.documents[0].data['year'];
                                    return Container(
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
                                              "${year_name[yearNum]}",
                                              style: GoogleFonts.raleway(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: Material(
              elevation: 0,
              color: UniversalVariables.blackColor,
              child: Column(
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
                      //controller: _tabController,
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
                                    .where("postedByUserUid",
                                        isEqualTo: widget.currUserUid)
                                    .orderBy("time", descending: true)
                                    .snapshots(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
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
                                      String shortDescription = snapshot.data
                                          .documents[index].data['description'];
                                      int lastIdx = shortDescription.length;
                                      Timestamp time = snapshot
                                          .data.documents[index].data['time'];
                                      if (lastIdx > 35) {
                                        shortDescription =
                                            shortDescription.substring(0, 33);
                                      }

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Stack(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  // print(user.name);
                                                  print(snapshot
                                                      .data
                                                      .documents[index]
                                                      .data['userName']);

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
                                                        color:
                                                            UniversalVariables
                                                                .senderColor
                                                                .withOpacity(
                                                                    0.8),
                                                        blurRadius: 4.0,
                                                      ),
                                                    ],
                                                    //color: UniversalVariables.separatorColor,
                                                    color: UniversalVariables
                                                        .separatorColor
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          Container(
                                                            height:
                                                                size.height /
                                                                    10,
                                                            width: size.width /
                                                                1.8,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        20.0),
                                                                topRight: Radius
                                                                    .circular(
                                                                        20.0),
                                                              ),
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl: Utils
                                                                    .getPostPicture(snapshot
                                                                        .data
                                                                        .documents[
                                                                            index]
                                                                        .data['tags']),
                                                                    fadeInDuration: Duration(
                                                                      milliseconds: 10,
                                                                    ),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    new Icon(
                                                                        Icons
                                                                        .error,color: Colors.white,),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                size.height /
                                                                    70,
                                                                size.height /
                                                                    70,
                                                                0,
                                                                0),
                                                        child: FittedBox(
                                                          child: Text(
                                                            "${snapshot.data.documents[index].data['title']}",
                                                            style: GoogleFonts
                                                                .raleway(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        15,
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
                                                            style: GoogleFonts
                                                                .raleway(
                                                              color: Colors
                                                                  .white70
                                                                  .withOpacity(
                                                                      0.4),
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
