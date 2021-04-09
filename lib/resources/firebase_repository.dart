import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterapp/models/message.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/provider/image_upload_provider.dart';
import 'package:flutterapp/resources/firebase_methods.dart';
import 'dart:io';

class FirebaseRepository {
  FirebaseMethods _firebaseMethods = FirebaseMethods();

  void uploadImage({
    @required File image,
    @required String receiverId,
    @required String senderId,
    @required ImageUploadProvider imageUploadProvider
  }) =>
      _firebaseMethods.uploadImage(image, receiverId, senderId, imageUploadProvider);
}
