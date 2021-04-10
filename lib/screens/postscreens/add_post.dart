import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/constants/strings.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/provider/user_provider.dart';
import 'package:flutterapp/utils/universal_variables.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final _controller = ScrollController();
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

  //bool isselectedTag = false;
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

  _editPost() {
    Size size = MediaQuery.of(context).size;
    return showModalBottomSheet(
        // isDismissible: false,
        isScrollControlled: true,
        context: context,
        elevation: 0,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return WillPopScope(
            child: StatefulBuilder(
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
                            WillPopScope(
                              onWillPop: () => (titleController.text.length !=
                                          0 ||
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
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              onPressed: () {
                                                titleController.clear();
                                                descriptionController.clear();
                                                selectedIdx = 0;
                                                Navigator.pop(c, true);
                                              },
                                            ),
                                            FlatButton(
                                              child: Text(
                                                'SAVE AS DRAFT',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              onPressed: () {
                                                String unpublishedDocID =
                                                    randomAlphaNumeric(10);
                                                if (titleController
                                                        .text.isNotEmpty ||
                                                    descriptionController
                                                        .text.isNotEmpty) {
                                                  try {
                                                    Firestore.instance
                                                        .collection(
                                                            USERS_COLLECTION)
                                                        .document(user.uid)
                                                        .collection(
                                                            "unpublished")
                                                        .document(
                                                            unpublishedDocID)
                                                        .setData({
                                                      "title":
                                                          titleController.text,
                                                      "description":
                                                          descriptionController
                                                              .text,
                                                      "time": DateTime.now(),
                                                      'unpublishedDocID':
                                                          unpublishedDocID,
                                                      "tags":
                                                          options[selectedIdx],
                                                      "userAvatar":
                                                          user.profilePhoto,
                                                      "userName": user.name,
                                                      "postedByUserUid":
                                                          user.uid,
                                                    }).then((value) {
                                                      titleController.clear();
                                                      descriptionController
                                                          .clear();
                                                      selectedIdx = 0;
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
                                  "Add Question",
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
                                    fillColor:
                                        UniversalVariables.separatorColor,
                                    hintText: 'Title',
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
                                      fillColor:
                                          UniversalVariables.separatorColor,
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
                                        color:
                                            UniversalVariables.separatorColor,
                                        borderRadius:
                                            BorderRadius.circular(20.0),
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
                                  /*  if(_formKey.currentState.validate())
                                        {
                                          return;
                                        }
                                      else
                                        {
                                          print("unsuccess");
                                        } */
                                  String postDocID = randomAlphaNumeric(10);
                                  // if(titleController.text.isNotEmpty && descriptionController.text.isNotEmpty){
                                  if (_formKey.currentState.validate()) {
                                    try {
                                      Firestore.instance
                                          .collection("posts")
                                          .document(postDocID)
                                          .setData({
                                        "title": titleController.text,
                                        "description":
                                            descriptionController.text,
                                        "time": DateTime.now(),
                                        'postDocId': postDocID,
                                        "tags": options[selectedIdx],
                                        "userAvatar": user.profilePhoto,
                                        "userName": user.name,
                                        "likedByIds": [],
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
            }),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
      onPressed: () {
        _editPost();
      },
    );
  }
}
