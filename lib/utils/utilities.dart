import 'dart:io';
import 'dart:math';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:flutterapp/enums/user_state.dart';
import 'package:image/image.dart' as Im;
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class Utils {
  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  static String getUsername(String email) {
    return "@${email.split("@")[0]}";
  }

  // ignore: missing_return
  static String getPostPicture(String tag) {
    if (tag == 'Academics') {
      return "https://firebasestorage.googleapis.com/v0/b/callie-626d8.appspot.com/o/ImgAssets%2FAcademics.jpg?alt=media&token=14736d6a-ed84-46b4-855b-850f561b7345";
    } else if (tag == 'Confessions') {
      return "https://firebasestorage.googleapis.com/v0/b/callie-626d8.appspot.com/o/ImgAssets%2FConfessions.jpg?alt=media&token=39078481-bdc0-44ee-ab29-692b5339553f";
    } else if (tag == 'Android') {
      return "https://firebasestorage.googleapis.com/v0/b/callie-626d8.appspot.com/o/ImgAssets%2FAndroid.jpg?alt=media&token=183cfce6-d2a8-4cdb-828f-75dac3b63975";
    } else if (tag == 'Machine Learning') {
      return "https://firebasestorage.googleapis.com/v0/b/callie-626d8.appspot.com/o/ImgAssets%2FMachine%20Learning.jpg?alt=media&token=9def3d81-60ed-4ac1-94f3-c3c2a0c34869";
    } else if (tag == 'React') {
      return "https://firebasestorage.googleapis.com/v0/b/callie-626d8.appspot.com/o/ImgAssets%2FReact.jpeg?alt=media&token=d5994d5e-5054-46fa-8537-eae2640c55f5";
    } else if (tag == 'Databases') {
      return "https://firebasestorage.googleapis.com/v0/b/callie-626d8.appspot.com/o/ImgAssets%2FDatabases.jpg?alt=media&token=515debc5-0565-45cd-a4d9-0853ca0d7a52";
    } else if (tag == 'Competitive Programming') {
      return "https://firebasestorage.googleapis.com/v0/b/callie-626d8.appspot.com/o/ImgAssets%2FCompetitive%20Programming.png?alt=media&token=309f6023-6b0b-43eb-927b-b32cbaaf98c6";
    } else if (tag == 'Others') {
      return "https://firebasestorage.googleapis.com/v0/b/callie-626d8.appspot.com/o/ImgAssets%2FOthers.jpg?alt=media&token=dbea9246-f541-44a0-b8e7-55285bc59501";
    }
  }

  static String getInitials(String name) {
    List<String> nameSplit = name.split(" ");
    String firstNameInitial = nameSplit[0][0];
    String lastNameInitial = nameSplit[1][0];
    return firstNameInitial + lastNameInitial;
  }

  static Future<File> pickImage({@required ImageSource source}) async {
    File selectedImage = await ImagePicker.pickImage(source: source);
    return compressImage(selectedImage);
  }

  static Future<File> compressImage(File imageToCompress) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;

    int random = Random().nextInt(1000);

    // read image
    Im.Image image = Im.decodeImage(imageToCompress.readAsBytesSync());
    // compress the image
    Im.copyResize(image, height: 500, width: 500);

    return new File('$path/img_$random.jpg')
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));
  }

  static int stateToNum(UserState userState) {
    switch (userState) {
      case UserState.Offline:
        return 0;

      case UserState.Online:
        return 1;

      default:
        return 2;
    }
  }

  static UserState numToState(int number) {
    switch (number) {
      case 0:
        return UserState.Offline;

      case 1:
        return UserState.Online;

      default:
        return UserState.Waiting;
    }
  }

  static String formatDateString(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    var formatter = DateFormat('dd/MM/yy');
    return formatter.format(dateTime);
  }
}
