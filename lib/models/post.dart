import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String postDocId;
  String tags;
  Timestamp time;
  String title;
  String userAvatar;
  String userName;
  String description;
  List<dynamic> likedByIds;

  Post({
    this.postDocId,
    this.tags,
    this.time,
    this.title,
    this.userAvatar,
    this.userName,
    this.description,
    this.likedByIds
  });

  Map toMap(Post post) {
    var data = Map<String, dynamic>();
    data['postDocId'] = post.postDocId;
    data['tags'] = post.tags;
    data['time'] = post.time;
    data['title'] = post.title;
    data["userAvatar"] = post.userAvatar;
    data["userName"] = post.userName;
    data["description"] = post.description;
    data['likedByIds']=post.likedByIds;
    return data;
  }

  Post.fromMap(Map<String, dynamic> mapData) {
    this.postDocId = mapData['postDocId'];
    this.tags = mapData['tags'];
    this.time = mapData['time'];
    this.title = mapData['title'];
    this.userAvatar = mapData['userAvatar'];
    this.userName = mapData['userName'];
    this.description = mapData['description'];
    this.likedByIds = mapData['likedByIds'];
  }
}
