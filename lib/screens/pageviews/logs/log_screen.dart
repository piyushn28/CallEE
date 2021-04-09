import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/screens/callscreens/pickup/pickup_layout.dart';
import 'package:flutterapp/screens/pageviews/logs/widgets/floating_column.dart';
import 'package:flutterapp/screens/pageviews/logs/widgets/log_list_container.dart';
import 'package:flutterapp/utils/universal_variables.dart';
import 'package:flutterapp/widgets/skype_appbar.dart';
import 'package:google_fonts/google_fonts.dart';


class LogScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: UniversalVariables.blackColor,
          appBar: SkypeAppBar(
            title: Text(
              "Calls",
              style: GoogleFonts.raleway(
                  color: Colors.white, fontWeight: FontWeight.w600),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pushNamed(context, "/search_screen"),
              ),
            ],
          ),
          //floatingActionButton: FloatingColumn(),
          body: LogListContainer(),
        ),
      ),
    );
  }
}