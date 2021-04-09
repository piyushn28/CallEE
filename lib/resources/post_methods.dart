import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/models/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostMethods{
  static final Firestore firestore = Firestore.instance;

  Future<List<Post>> fetchAllPosts() async {
    List<Post> postList = List<Post>();

    QuerySnapshot querySnapshot =
    await firestore.collection("posts").getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      //print(querySnapshot.documents[i].data);
      postList.add(Post.fromMap(querySnapshot.documents[i].data));
    }
    return postList;
  }


}