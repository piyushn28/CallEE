import 'dart:io';
import 'dart:math';
import 'package:flutterapp/enums/user_state.dart';
import 'package:image/image.dart' as Im;
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class Utils {
  static String getUsername(String email) {
    return "live:${email.split("@")[0]}";
  }

  // ignore: missing_return
  static String getPostPicture(String tag){
    if(tag=='Time'){
      return "https://firebasestorage.googleapis.com/v0/b/callie-626d8.appspot.com/o/categories_images%2Ftime.jpg?alt=media&token=e79eab44-47f3-4d18-a575-d9839e1cd94d";
    }else if(tag=='Motivation'){
      return "https://firebasestorage.googleapis.com/v0/b/callie-626d8.appspot.com/o/categories_images%2Fmotivation.jpg?alt=media&token=1e2480df-3ff1-429d-9954-e19a2ff1820e";
    }else if(tag=='Work'){
      return "https://firebasestorage.googleapis.com/v0/b/callie-626d8.appspot.com/o/categories_images%2Fwork.jpg?alt=media&token=45760477-160a-43b9-aa65-d33541edb1fe";
    }else if(tag=='Music'){
      return "https://firebasestorage.googleapis.com/v0/b/callie-626d8.appspot.com/o/categories_images%2Fmusic.jpg?alt=media&token=38225d7e-b5f1-4ff1-85e1-573495f107c0";
    }else if(tag=='Goals'){
      return "https://firebasestorage.googleapis.com/v0/b/callie-626d8.appspot.com/o/categories_images%2Fgoals.jpg?alt=media&token=bcede161-d98d-4790-8d07-ec2596946992";
    }else if(tag=='Books'){
      return "https://firebasestorage.googleapis.com/v0/b/callie-626d8.appspot.com/o/categories_images%2Fbooks.jpg?alt=media&token=654ab387-19b8-4b5c-a8ff-dffb4e8f80e1";
    }else if(tag=='Life'){
      return "https://firebasestorage.googleapis.com/v0/b/callie-626d8.appspot.com/o/categories_images%2Flife.jpg?alt=media&token=6f65c1d1-639a-4c93-8859-9aba4e683d1b";
    }else if(tag=='Learning'){
      return "https://firebasestorage.googleapis.com/v0/b/callie-626d8.appspot.com/o/categories_images%2Flearning.jpg?alt=media&token=5364e39c-4745-4e6e-ab94-89620d740ed5";
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
