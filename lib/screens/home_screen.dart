import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/enums/user_state.dart';
import 'package:flutterapp/provider/user_provider.dart';
import 'package:flutterapp/resources/auth_methods.dart';
import 'package:flutterapp/resources/local_db/repository/log_repository.dart';
import 'package:flutterapp/screens/callscreens/pickup/pickup_layout.dart';
import 'package:flutterapp/screens/dashboard/student_dashboard.dart';
import 'package:flutterapp/screens/dashboard/teacher_dashboard.dart';
import 'package:flutterapp/screens/pageviews/logs/log_screen.dart';
import 'package:flutterapp/screens/pageviews/profile/main_profile.dart';
import 'package:flutterapp/screens/postscreens/post_screen.dart';
import 'package:flutterapp/utils/universal_variables.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

import 'pageviews/chats/chat_list_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  PageController pageController;
  int _page = 0;
  UserProvider userProvider;
  final userStudentTeacherSelected = GetStorage();
  final AuthMethods _authMethods = AuthMethods();
  // final LogRepository _logRepository = LogRepository(isHive: true);
  // final LogRepository _logRepository = LogRepository(isHive: false);

  int selectedIndex = 0;

  int activeIndex;

  void _onTap(int index) {
    setState((){
      activeIndex = index;
    });
  }

  var _bottomNavIndex = 0;


//default index of first screen
  AnimationController _animationController;
  Animation<double> animation;
  CurvedAnimation curve;



  final iconList = <IconData>[
    Icons.home_outlined,
    //  Icons.home_outlined,
    Icons.chat,
    Icons.call,
    Icons.post_add,
    Icons.person_rounded,
  ];

  @override
  void initState() {
    super.initState();
    userStudentTeacherSelected.write("isUserStudentTeacherSelected", true);
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.refreshUser();

      _authMethods.setUserState(
        userId: userProvider.getUser.uid,
        userState: UserState.Online,
      );

      LogRepository.init(
        isHive: true,
        dbName: userProvider.getUser.uid,
      );
    });

    WidgetsBinding.instance.addObserver(this);

    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    String currentUserId =
    (userProvider != null && userProvider.getUser != null)
        ? userProvider.getUser.uid
        : "";

    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        currentUserId != null
            ? _authMethods.setUserState(
            userId: currentUserId, userState: UserState.Online)
            : print("resume state");
        break;
      case AppLifecycleState.inactive:
        currentUserId != null
            ? _authMethods.setUserState(
            userId: currentUserId, userState: UserState.Offline)
            : print("inactive state");
        break;
      case AppLifecycleState.paused:
        currentUserId != null
            ? _authMethods.setUserState(
            userId: currentUserId, userState: UserState.Waiting)
            : print("paused state");
        break;
      case AppLifecycleState.detached:
        currentUserId != null
            ? _authMethods.setUserState(
            userId: currentUserId, userState: UserState.Offline)
            : print("detached state");
        break;
    }
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }



  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    double _labelFontSize = 10;

    return PickupLayout(
      scaffold: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: UniversalVariables.blackColor,
          body: PageView(
            children: <Widget>[
              StudentDashboard(
                pageController: pageController,
              ),
              //TeacherDashboard(pageController: pageController),
              ChatListScreen(),
              LogScreen(),
              PostScreen(
                pageController: pageController,
              ),
              MainProfile(),
            ],
            controller: pageController,
            onPageChanged: onPageChanged,
            //physics: NeverScrollableScrollPhysics(),
          ),
          /* bottomNavigationBar: CupertinoTabBar(
             backgroundColor: UniversalVariables.blackColor,
             items: <BottomNavigationBarItem>[
               BottomNavigationBarItem(
                 icon: Icon(Icons.home_outlined,
                     color: (_page == 0)
                         ? UniversalVariables.lightPurpleColor
                         : UniversalVariables.greyColor),
                 title: Text(
                   "StuHome",
                   style: TextStyle(
                       fontSize: _labelFontSize,
                       color: (_page == 0)
                           ? UniversalVariables.lightPurpleColor
                           : Colors.grey),
                 ),
               ),
               BottomNavigationBarItem(
                 icon: Icon(Icons.home_outlined,
                     color: (_page == 1)
                         ? UniversalVariables.lightPurpleColor
                         : UniversalVariables.greyColor),
                 title: Text(
                   "TeaHome",
                   style: TextStyle(
                       fontSize: _labelFontSize,
                       color: (_page == 1)
                           ? UniversalVariables.lightPurpleColor
                           : Colors.grey),
                 ),
               ),
               BottomNavigationBarItem(
                 icon: Icon(Icons.chat,
                     color: (_page == 2)
                         ? UniversalVariables.lightPurpleColor
                         : UniversalVariables.greyColor),
                 title: Text(
                   "Chats",
                   style: TextStyle(
                       fontSize: _labelFontSize,
                       color: (_page == 2)
                           ? UniversalVariables.lightPurpleColor
                           : Colors.grey),
                 ),
               ),
               BottomNavigationBarItem(
                 icon: Icon(Icons.call,
                     color: (_page == 3)
                         ? UniversalVariables.lightPurpleColor
                         : UniversalVariables.greyColor),
                 title: Text(
                   "Calls",
                   style: TextStyle(
                       fontSize: _labelFontSize,
                       color: (_page == 3)
                           ? UniversalVariables.lightPurpleColor
                           : Colors.grey),
                 ),
               ),
               BottomNavigationBarItem(
                 icon: Icon(Icons.post_add,
                     color: (_page == 4)
                         ? UniversalVariables.lightPurpleColor
                         : UniversalVariables.greyColor),
                 title: Text(
                   "Posts",
                   style: TextStyle(
                       fontSize: _labelFontSize,
                       color: (_page == 4)
                           ? UniversalVariables.lightPurpleColor
                           : Colors.grey),
                 ),
               ),
               BottomNavigationBarItem(
                 icon: Icon(Icons.person_rounded,
                     color: (_page == 5)
                         ? UniversalVariables.lightPurpleColor
                         : UniversalVariables.greyColor),
                 title: Text(
                   "Profile",
                   style: TextStyle(
                       fontSize: _labelFontSize,
                       color: (_page == 5)
                           ? UniversalVariables.lightPurpleColor
                           : Colors.grey),
                 ),
               ),
             ],
             onTap: navigationTapped,
             currentIndex: _page,
           ),*/
          bottomNavigationBar: AnimatedBottomNavigationBar(

            icons: iconList,
            inactiveColor: Colors.white,
            iconSize: 30,
            activeIndex: _page,
            elevation: 5,
            leftCornerRadius: 32,
            rightCornerRadius: 32,
            gapLocation: GapLocation.none,
            notchSmoothness: NotchSmoothness.smoothEdge,
            backgroundColor: UniversalVariables.separatorColor,
            activeColor: Colors.deepPurpleAccent,
            onTap: (index) {
              setState(() {
                _page = index;
                pageController.jumpToPage(_page);
              });

              },
            // animationCurve: Curves.easeInBack,
            // animationDuration: const Duration(milliseconds: 300),
          ),
        ),
      ),
    );
  }
}
