import 'package:flutter/material.dart';
import 'package:flutterapp/constants/strings.dart';
import 'package:flutterapp/models/logs.dart';
import 'package:flutterapp/resources/local_db/repository/log_repository.dart';
import 'package:flutterapp/screens/chatscreens/widgets/cached_image.dart';
import 'package:flutterapp/screens/pageviews/chats/widgets/quiet_box.dart';
import 'package:flutterapp/utils/universal_variables.dart';
import 'package:flutterapp/utils/utilities.dart';
import 'package:flutterapp/widgets/custom_tile.dart';
import 'package:flutterapp/widgets/quiet_box.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class LogListContainer extends StatefulWidget {
  @override
  _LogListContainerState createState() => _LogListContainerState();
}

class _LogListContainerState extends State<LogListContainer> {
  getIcon(String callStatus) {
    Icon _icon;
    double _iconSize = 15;

    switch (callStatus) {
      case CALL_STATUS_DIALLED:
        _icon = Icon(
          Icons.call_made,
          size: _iconSize,
          color: Colors.green,
        );
        break;

      case CALL_STATUS_MISSED:
        _icon = Icon(
          Icons.call_missed,
          color: Colors.red,
          size: _iconSize,
        );
        break;

      default:
        _icon = Icon(
          Icons.call_received,
          size: _iconSize,
          color: Colors.grey,
        );
        break;
    }

    return Container(
      margin: EdgeInsets.only(right: 5),
      child: _icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: LogRepository.getLogs(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width /0.8,
                    height: MediaQuery.of(context).size.height / 20,
                    child: Shimmer.fromColors(
                      baseColor: UniversalVariables.gradientColorStart.withOpacity(0.05),
                      highlightColor: UniversalVariables.separatorColor,
                      child: Container(
                        color: UniversalVariables.separatorColor,
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width / 0.8,
                    height: MediaQuery.of(context).size.height / 20,
                    child: Shimmer.fromColors(
                      baseColor: UniversalVariables.gradientColorStart.withOpacity(0.05),
                      highlightColor: UniversalVariables.separatorColor,
                      child: Container(
                        color: UniversalVariables.separatorColor,
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width / 0.8,
                    height: MediaQuery.of(context).size.height /20,
                    child: Shimmer.fromColors(
                      baseColor: UniversalVariables.gradientColorStart.withOpacity(0.05),
                      highlightColor: UniversalVariables.separatorColor,
                      child: Container(
                        color: UniversalVariables.separatorColor,
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width / 0.8,
                    height: MediaQuery.of(context).size.height / 20,
                    child: Shimmer.fromColors(
                      baseColor: UniversalVariables.gradientColorStart.withOpacity(0.05),
                      highlightColor: UniversalVariables.separatorColor,
                      child: Container(
                        color: UniversalVariables.separatorColor,
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width / 0.8,
                    height: MediaQuery.of(context).size.height / 20,
                    child: Shimmer.fromColors(
                      baseColor: UniversalVariables.gradientColorStart.withOpacity(0.05),
                      highlightColor: UniversalVariables.separatorColor,
                      child: Container(
                        color: UniversalVariables.separatorColor,
                      ),
                    )),
              ],
            ),
          ));
        }

        if (snapshot.hasData) {
          List<dynamic> logList = snapshot.data;

          if (logList.isNotEmpty) {
            return ListView.builder(
              itemCount: logList.length,
              itemBuilder: (context, i) {
                Log _log = logList[i];
                bool hasDialled = _log.callStatus == CALL_STATUS_DIALLED;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTile(
                    leading: CachedImage(
                      hasDialled ? _log.receiverPic : _log.callerPic,
                      isRound: true,
                      radius: 45,
                    ),
                    mini: false,
                    onLongPress: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30.0))),
                        backgroundColor: UniversalVariables.separatorColor,
                        title: Text("Delete this Log?",
                        style: GoogleFonts.raleway(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20
                        ),),
                        content:
                        Text("Are you sure you wish to delete this log?",
                        style: GoogleFonts.raleway(
                            color: Colors.white,
                            //fontWeight: FontWeight.w700,
                            fontSize: 15
                        ),),
                        actions: [
                          FlatButton(
                            child: Text("YES",
                            style: TextStyle(
                              color: Colors.white
                            ),),
                            onPressed: () async {
                              Navigator.maybePop(context);
                              await LogRepository.deleteLogs(i);
                              if (mounted) {
                                setState(() {});
                              }
                            },
                          ),
                          FlatButton(
                            child: Text("NO",
                              style: TextStyle(
                                  color: Colors.white
                              ),),
                            onPressed: () => Navigator.maybePop(context),
                          ),
                        ],
                      ),
                    ),
                    title: Text(
                      hasDialled ? _log.receiverName : _log.callerName,
                      style: GoogleFonts.raleway(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15
                      ),
                    ),
                    icon: getIcon(_log.callStatus),
                    subtitle: Text(
                      Utils.formatDateString(_log.timestamp),
                      style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 13
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return QuietBox(
            heading: "This is where all your call logs are listed",
            subtitle: "Calling people all over the world with just one click",
          );
        }

        return QuietBox(
          heading: "This is where all your call logs are listed",
          subtitle: "Calling people all over the world with just one click",
        );
      },
    );
  }
}