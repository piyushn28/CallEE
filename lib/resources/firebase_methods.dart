import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterapp/constants/strings.dart';
import 'package:flutterapp/models/quizAttempted.dart';
import 'package:flutterapp/models/quizzes.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/provider/image_upload_provider.dart';
import 'package:flutterapp/resources/auth_methods.dart';
import 'package:flutterapp/utils/universal_variables.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutterapp/resources/chat_methods.dart';

class FirebaseMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final Firestore firestore = Firestore.instance;

  static final CollectionReference _userCollection =
      firestore.collection(USERS_COLLECTION);

  StorageReference _storageReference;

  User user = User();

  Future<List> updateQuizAttemptedBy(User user, Quizzes quiz) async {
    var docSnap = await Firestore.instance
        .collection('quizzes')
        .document(quiz.quizUID)
        .get();

    Map<String, dynamic> quizMap = docSnap.data;
    List newList = [];
    newList.addAll(quizMap['attemptedBy'].toList());
    newList.add(user.uid);
    quizMap['attemptedBy'] = newList;

    await Firestore.instance
        .collection('quizzes')
        .document(quiz.quizUID)
        .updateData(quizMap);

    return quizMap['attemptedBy'];
  }

  Future<dynamic> updateUserTotalMarks(User user, double gainedMarks) async {
    print('Updating users marks');
    var docSnap =
        await Firestore.instance.collection('users').document(user.uid).get();

    Map<String, dynamic> userMap = docSnap.data;
    userMap['totalMarks'] = userMap['totalMarks'] + gainedMarks;

    await Firestore.instance
        .collection('users')
        .document(user.uid)
        .updateData(userMap);

    return userMap['totalMarks'];
  }

  Future<void> addQuiz(Quizzes quiz) async {
    //TODO: Change timestamp now to store the asked time.
    quiz.startTime = Timestamp.now();
    User currentUser = await AuthMethods().getUserDetails();
    quiz.setCreatedBy(currentUser.uid);
    quiz.attemptedBy.add(currentUser.uid);
    try {
      firestore.collection('quizzes').document(quiz.quizUID).setData(
            quiz.toMap(quiz),
            merge: true,
          );
    } catch (e) {
      print(e.message);
    }
  }

  Future<bool> addQuizQuestions(Quizzes quiz) async {
    var batch = firestore.batch();

    for (int i = 1; i <= createQuestionsList.length; i++) {
      batch.setData(
        firestore
            .collection('quizzes')
            .document(quiz.quizUID)
            .collection('questions')
            .document(i.toString()),
        createQuestionsList[i - 1].toMap(createQuestionsList[i - 1]),
        merge: true,
      );
    }
    bool val;
    await batch.commit().then((value) {
      val = true;
    }).onError((error, stackTrace) {
      print(error.toString());
      val = false;
    });
    return val;
  }

  Future<void> addQuizAnswered(
      Quizzes quiz, QuizAttempted quizAttempted, User user) async {
    quizAttempted.maxMarks = quiz.maxMarks;
    quizAttempted.quizUID = quiz.quizUID;
    quizAttempted.submittedOn = Timestamp.now();
    quizAttempted.noOfQuestions = quiz.noOfQuestions;
    quizAttempted.remainingTime = ((quiz.duration * 60) -
            ((quizAttempted.submittedOn.millisecondsSinceEpoch -
                        quizAttempted.startedOn.millisecondsSinceEpoch) /
                    1000)
                .round())
        .abs();

    try {
      firestore
          .collection('users')
          .document(user.uid)
          .collection('quizAttempted')
          .document(quiz.quizUID)
          .setData(
            quizAttempted.toMap(quizAttempted),
            merge: true,
          );
    } catch (e) {
      print(e.message);
    }
  }

  Future<bool> authenticateUser(FirebaseUser user) async {
    QuerySnapshot result = await firestore
        .collection(USERS_COLLECTION)
        .where(EMAIL_FIELD, isEqualTo: user.email)
        .getDocuments();

    final List<DocumentSnapshot> docs = result.documents;

    return docs.length == 0 ? true : false;
  }

  Future<String> uploadImageToStorage(File imageFile) async {
    // mention try catch later on

    try {
      _storageReference = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}');
      StorageUploadTask storageUploadTask =
          _storageReference.putFile(imageFile);
      var url = await (await storageUploadTask.onComplete).ref.getDownloadURL();
      // print(url);
      return url;
    } catch (e) {
      return null;
    }
  }

  void uploadImage(File image, String receiverId, String senderId,
      ImageUploadProvider imageUploadProvider) async {
    // Set some loading value to db and show it to user
    imageUploadProvider.setToLoading();
    final ChatMethods chatMethods = ChatMethods();

    // Get url from the image bucket
    String url = await uploadImageToStorage(image);

    // Hide loading
    imageUploadProvider.setToIdle();

    chatMethods.setImageMsg(url, receiverId, senderId);
  }
}
