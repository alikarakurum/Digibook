import 'package:digibook/models/user_of_app.dart';
import 'package:digibook/screens/home_screen.dart';
import 'package:digibook/screens/topic_content_pages/argumentum_post_flow.dart';
import 'package:digibook/screens/topic_content_pages/championa_post_flow.dart';
import 'package:digibook/screens/topic_content_pages/question_post_flow.dart';
import 'package:digibook/screens/topic_content_pages/standart_post_flow.dart';
import 'package:flutter/material.dart';

class ProfilePostFlow extends StatefulWidget {
  final UserOfApp currentUser;
  final String profileId;

  ProfilePostFlow({this.currentUser, this.profileId});
  @override
  _ProfilePostFlowState createState() => _ProfilePostFlowState();
}

class _ProfilePostFlowState extends State<ProfilePostFlow>
    with SingleTickerProviderStateMixin {
  final String currentUserId = currentUser?.userID;
  TabController _tabController;

  int _currentIndex;

  //index 0 = STANDART POST FLOW
  //index 1 = QUESTION POST FLOW
  //index 0 = ARGUMENTUM POST FLOW
  //index 0 = CHAMPIONA POST FLOW

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      vsync: this,
      length: 4,
    );
    _currentIndex = _tabController.index;
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          body: Container(
        height: size.height,
        width: size.width,
        child: DefaultTabController(
            length: 4,
            initialIndex: 0,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: size.height * 0.005,
                      left: size.height * 0.01,
                      right: size.height * 0.01),
                  width: size.width * 0.96,
                  height: size.height * 0.07,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withAlpha(100),
                          blurRadius: size.width * 0.01),
                    ],
                    borderRadius: BorderRadius.circular(size.width * 0.03),
                    color: Colors.orange[200],
                  ),
                  child: Row(
                    children: [
                      buildTap(size, 0),
                      buildTap(size, 1),
                      buildTap(size, 2),
                      buildTap(size, 3),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: size.width * 0.92,
                  height: size.height * 0.7,
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(size.width * 0.03),
                        bottomRight: Radius.circular(size.width * 0.03)),
                    color: Colors.orange[100],
                  ),
                  child: Container(
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children: [
                        StandartPostFlow(
                          currentUser: widget.currentUser,
                          isProfilePosts: "profilePosts",
                          isOwner:
                              currentUserId == widget.profileId ? "yes" : "no",
                        ),
                        QuestionPostFlow(
                          currentUser: widget.currentUser,
                          isProfilePosts: "profilePosts",
                          isOwner:
                              currentUserId == widget.profileId ? "yes" : "no",
                        ),
                        ArgumentumPostFlow(
                          currentUser: widget.currentUser,
                          isProfilePosts: "profilePosts",
                          isOwner:
                              currentUserId == widget.profileId ? "yes" : "no",
                        ),
                        ChampionaPostFlow(
                          currentUser: widget.currentUser,
                          isProfilePosts: "profilePosts",
                          isOwner:
                              currentUserId == widget.profileId ? "yes" : "no",
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )),
      )),
    );
  }

  buildTap(Size size, int type) {
    Icon icon;
    if (type == 0)
      icon = Icon(
        Icons.ac_unit,
        color: _currentIndex == 0 &&
                _currentIndex != 1 &&
                _currentIndex != 2 &&
                _currentIndex != 3
            ? Colors.white
            : Colors.brown,
      );
    else if (type == 1)
      icon = Icon(
        Icons.access_alarm,
        color: _currentIndex == 1 &&
                _currentIndex != 0 &&
                _currentIndex != 2 &&
                _currentIndex != 3
            ? Colors.white
            : Colors.brown,
      );
    else if (type == 2)
      icon = Icon(
        Icons.accessibility_new_rounded,
        color: _currentIndex == 2 &&
                _currentIndex != 0 &&
                _currentIndex != 1 &&
                _currentIndex != 3
            ? Colors.white
            : Colors.brown,
      );
    else if (type == 3)
      icon = Icon(
        Icons.zoom_out_outlined,
        color: _currentIndex == 3 &&
                _currentIndex != 0 &&
                _currentIndex != 1 &&
                _currentIndex != 2
            ? Colors.white
            : Colors.brown,
      );
    return Container(
      alignment: Alignment.center,
      height: size.height * 0.07,
      width: size.width * 0.24,
      child: MaterialButton(
        onPressed: () {
          if (type == 0) {
            setState(() {
              _currentIndex = 0;
              _tabController.animateTo(_currentIndex);
            });
          } else if (type == 1) {
            setState(() {
              _currentIndex = 1;
              _tabController.animateTo(_currentIndex);
            });
          } else if (type == 2) {
            setState(() {
              _currentIndex = 2;
              _tabController.animateTo(_currentIndex);
            });
          } else if (type == 3) {
            setState(() {
              _currentIndex = 3;
              _tabController.animateTo(_currentIndex);
            });
          }
        },
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Align(
          alignment: Alignment.center,
          child: icon,
        ),
      ),
    );
  }

  // buildNestedScroll() {
  //   return NestedScrollView(
  //     controller: _scrollController,
  //     floatHeaderSlivers: false,
  //     headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
  //       return <Widget>[
  //         SliverAppBar(
  //           primary: true,
  //           automaticallyImplyLeading: false,
  //           floating: true,
  //           expandedHeight: MediaQuery.of(context).size.height * 0.01,
  //           forceElevated: innerBoxIsScrolled,
  //           bottom: TabBar(
  //             controller: _tabController,
  //             tabs: [
  //               Tab(icon: Icon(Icons.directions_car)),
  //               Tab(icon: Icon(Icons.directions_transit)),
  //               Tab(icon: Icon(Icons.directions_bike)),
  //               Tab(icon: Icon(Icons.directions_bike)),
  //             ],
  //           ),
  //         ),
  //       ];
  //     },
  //     body: Column(
  //       children: [
  //         Expanded(
  //           child: TabBarView(
  //             physics: NeverScrollableScrollPhysics(),
  //             controller: _tabController,
  //             children: [
  //               StandartPostFlow(
  //                 currentUser: widget.currentUser,
  //                 isProfilePosts: "profilePosts",
  //                 isOwner: currentUserId == widget.profileId ? "yes" : "no",
  //               ),
  //               QuestionPostFlow(
  //                 currentUser: widget.currentUser,
  //                 isProfilePosts: "profilePosts",
  //                 isOwner: currentUserId == widget.profileId ? "yes" : "no",
  //               ),
  //               ArgumentumPostFlow(
  //                 currentUser: widget.currentUser,
  //                 isProfilePosts: "profilePosts",
  //                 isOwner: currentUserId == widget.profileId ? "yes" : "no",
  //               ),
  //               ChampionaPostFlow(
  //                 currentUser: widget.currentUser,
  //                 isProfilePosts: "profilePosts",
  //                 isOwner: currentUserId == widget.profileId ? "yes" : "no",
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
