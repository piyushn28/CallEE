import 'package:flutter/material.dart';
import 'package:flutterapp/models/contact.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/provider/user_provider.dart';
import 'package:flutterapp/resources/auth_methods.dart';
import 'package:flutterapp/resources/chat_methods.dart';
import 'package:flutterapp/screens/chatscreens/chat_screen.dart';
import 'package:flutterapp/screens/chatscreens/widgets/cached_image.dart';
import 'package:flutterapp/screens/chatscreens/widgets/online_dot_indicator.dart';
import 'package:flutterapp/utils/universal_variables.dart';
import 'package:flutterapp/widgets/custom_tile.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'last_message_container.dart';

class ContactView extends StatelessWidget {
  final Contact contact;
  final AuthMethods _authMethods = AuthMethods();

  ContactView(this.contact);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: _authMethods.getUserDetailsById(contact.uid),
      builder: (context, snapshot) {

        if(!snapshot.hasData){
          return SizedBox(
              width: MediaQuery.of(context).size.width /0.8,
              height: MediaQuery.of(context).size.height / 20,
              child: Shimmer.fromColors(
                baseColor: UniversalVariables.gradientColorStart.withOpacity(0.05),
                highlightColor: UniversalVariables.separatorColor,
                child: Container(
                  color: UniversalVariables.separatorColor,
                ),
              ));
        }

          User user = snapshot.data;
          return ViewLayout(
            contact: user,
          );


      },
    );
  }
}

class ViewLayout extends StatelessWidget {
  final User contact;
  final ChatMethods _chatMethods = ChatMethods();
  ViewLayout({@required this.contact});
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return CustomTile(
      mini: false,
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatScreen(
                    receiver: contact,
                  ))),
      title: Text(
        contact?.name ??
            '..', // you can also just directly write contact.name coz contact.name is never gonna be null
        // contact?.name is same as contact != null ? contact.name : null
        // ?? - null operator eg: contact.name ?? '..' is same as contact.name != null ? contact.name : '..'
        style: TextStyle(
          color: Colors.white,
          fontFamily: "Arial",
          fontSize: 19,
        ),
      ),
      subtitle: LastMessageContainer(
        stream: _chatMethods.fetchLastMessageBetween(
            senderId: userProvider.getUser.uid, receiverId: contact.uid),
      ),
      leading: Container(
        constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
        child: Stack(
          children: <Widget>[
            CachedImage(
              contact.profilePhoto,
              radius: 80,
              isRound: true,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: OnlineDotIndicator(
                uid: contact.uid,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
