import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/models/post.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/resources/auth_methods.dart';
import 'package:flutterapp/resources/post_methods.dart';
import 'package:flutterapp/screens/chatscreens/widgets/cached_image.dart';
import 'package:flutterapp/utils/universal_variables.dart';
import 'package:flutterapp/utils/utilities.dart';
import 'package:flutterapp/widgets/custom_tile.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

import 'open_post.dart';

class SearchPostScreen extends StatefulWidget {
  @override
  _SearchPostScreenState createState() => _SearchPostScreenState();
}

class _SearchPostScreenState extends State<SearchPostScreen> {
  PostMethods _postMethods = PostMethods();

  List<Post> postList;
  String query = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _postMethods.fetchAllPosts().then((list) {
      setState(() {
        postList = list;
      });
    });
  }

  searchAppBar(BuildContext context) {
    return AppBar(
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
                if(val!=null){
                  query = val;
                }
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
    //print("yee ${postList.length}");

    final List<Post> suggestionList = query.isEmpty
        ? []
        : postList.where((Post post) {
            String _query = query.toLowerCase();
            print(_query);
            String _getTitle = post.title.toLowerCase();
            print(_getTitle);
            bool matchesTitle = _getTitle.contains(_query);

            return (matchesTitle);
          }).toList();

    return ListView.builder(
      shrinkWrap: true,
      itemCount: suggestionList.length,
      itemBuilder: ((context, index) {
        Post searchedPost = Post(
            postDocId: suggestionList[index].postDocId,
            userAvatar: suggestionList[index].userAvatar,
            title: suggestionList[index].title,
            userName: suggestionList[index].userName,
            tags: suggestionList[index].tags);

        return Column(
          children: [
            SizedBox(
              height: 5,
            ),
            CustomTile(
              mini: false,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return OpenPost(
                    postDocumentId:
                        searchedPost.postDocId,
                    postImageLink: searchedPost.tags,
                  );
                }));
              },
              leading:CachedImage(
                Utils.getPostPicture(searchedPost.tags),
                isRound: true,
                radius: MediaQuery.of(context).size.width / 8,
              ),
              title: Text(
                searchedPost.title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "${searchedPost.tags} • ${searchedPost.userName}",
                style: TextStyle(color: UniversalVariables.greyColor),
              ),
            ),
            SizedBox(
              height: 5,
            )
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
