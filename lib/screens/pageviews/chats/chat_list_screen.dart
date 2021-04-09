import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/models/contact.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/provider/user_provider.dart';
import 'package:flutterapp/resources/auth_methods.dart';
import 'package:flutterapp/resources/chat_methods.dart';
import 'package:flutterapp/screens/callscreens/pickup/pickup_layout.dart';
import 'package:flutterapp/screens/login_screen.dart';
import 'package:flutterapp/screens/pageviews/chats/widgets/quiet_box.dart';
import 'package:flutterapp/utils/universal_variables.dart';
import 'package:flutterapp/utils/utilities.dart';
import 'package:flutterapp/widgets/appbar.dart';
import 'package:flutterapp/widgets/custom_tile.dart';
import 'package:flutterapp/widgets/quiet_box.dart';
import 'package:flutterapp/widgets/skype_appbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'widgets/contact_view.dart';
import 'widgets/new_chat_button.dart';
import 'widgets/user_circle.dart';

class ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold:  AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: UniversalVariables.blackColor,
          appBar: SkypeAppBar(
            title: Text(
              "Chats",
              style: GoogleFonts.raleway(
                  color: Colors.white, fontWeight: FontWeight.w600),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, "/search_screen");
                },
              ),
            ],
          ),
          //floatingActionButton: NewChatButton(),
          body: ChatListContainer(),
        ),
      ),
    );
  }
}

class ChatListContainer extends StatelessWidget {
  final ChatMethods _chatMethods = ChatMethods();

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: _chatMethods.fetchContacts(
            userId: userProvider.getUser.uid,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var docList = snapshot.data.documents;

              if (docList.isEmpty) {
                return QuietBox(
                  heading: "This is where all the contacts are listed",
                  subtitle:
                      "Search for your friends and family to start calling or chatting with them",
                );
              }
              return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: docList.length,
                itemBuilder: (context, index) {
                  Contact contact = Contact.fromMap(docList[index].data);

                  return ContactView(contact);
                },
              );
            }

            return SizedBox(
                width: MediaQuery.of(context).size.width / 0.8,
                height: MediaQuery.of(context).size.height / 20,
                child: Shimmer.fromColors(
                  baseColor:
                      UniversalVariables.gradientColorStart.withOpacity(0.05),
                  highlightColor: UniversalVariables.separatorColor,
                  child: Container(
                    color: UniversalVariables.separatorColor,
                  ),
                ));
          }),
    );
  }
}
