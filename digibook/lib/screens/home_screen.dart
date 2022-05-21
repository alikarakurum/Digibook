import 'package:digibook/screens/tabbed_pages/create_post_screen.dart';
import 'package:digibook/screens/tabbed_pages/notifications_screen.dart';
import 'package:digibook/screens/tabbed_pages/profile_page_screen.dart';
import 'package:digibook/screens/topic_content_pages/timeline_post_flow.dart';
import 'package:flutter/material.dart';
import 'package:digibook/screens/tabbed_pages/search_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digibook/models/user_of_app.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

final usersRef = FirebaseFirestore.instance.collection('users');
final postsRef = FirebaseFirestore.instance.collection('posts');
final commentsRef = FirebaseFirestore.instance.collection('comments');
final activityFeedRef = FirebaseFirestore.instance.collection('feed');
final followersRef = FirebaseFirestore.instance.collection('followers');
final followingRef = FirebaseFirestore.instance.collection('following');
final timelineRef = FirebaseFirestore.instance.collection('timeline');
final firebase_storage.Reference storageRef =
    firebase_storage.FirebaseStorage.instance.ref();

var selectedTopic = "";
List<String> scrollTopics = <String>[
  "Genel",
  "İnsan",
  "Hayvan",
  "Sağlık",
  "Yemek",
  "Giyim",
  "Bakım",
  "İletişim",
  "İlişkiler",
  "Mizah",
  "Hayal",
  "Bilim",
  "Gelecek",
  "Gezi & Seyahat",
  "Teknoloji",
  "Araba",
  "Kozmetik",
  "Siyaset",
];

final DateTime timestamp = DateTime.now();
UserOfApp currentUser = UserOfApp();

class HomeScreen extends StatefulWidget {
  final UserOfApp curUser;

  const HomeScreen({
    Key key,
    this.curUser,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    currentUser = widget.curUser;
    _tabController = TabController(
      initialIndex: 0,
      vsync: this,
      length: 5,
    );
  }

  int _currentIndex;

  // List<Widget> _tabList = [
  //   Center(
  //     child: Text("AnaSayfadır"),
  //   ),
  //   Search(currentUser),
  //   PostCreateScreen(currentUser),
  //   Container(
  //     color: Colors.orange,
  //     child: Text("Bildirimler"),
  //   ),
  //   Profile(
  //     profileId: currentUser.userID,
  //   ),
  // ];

  TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: header(context, isAppTitle: true),
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: [
          TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [
              TimelinePostFlow(
                currentUser: widget.curUser,
              ),
              Search(currentUser),
              PostCreateScreen(currentUser),
              NotificationsScreen(),
              Profile(
                profileId: currentUser.userID,
                currentUser: currentUser,
              ),
            ],
          ),
          Positioned(
            child: buildBottomBar(context, size),
            bottom: size.height * 0.01,
          ),
        ],
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _tabController.index,
      //   backgroundColor: Colors.orange[100],
      //   unselectedItemColor: Colors.black,
      //   selectedItemColor: kPrimaryColor,
      //   onTap: (currrentIndex) {
      //     setState(() {
      //       _currentIndex = currrentIndex;
      //       _tabController.animateTo(_currentIndex);
      //     });
      //   },
      //   items: [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      //     BottomNavigationBarItem(icon: Icon(Icons.search), label: "Looking"),
      //     BottomNavigationBarItem(icon: Icon(Icons.edit), label: "Write"),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.notification_important), label: "Notifications"),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: "You"),
      //   ],
      // ),
    );
  }

  buildBottomBar(BuildContext context, Size size) {
    return Container(
      alignment: Alignment.center,
      height: size.height * 0.07,
      width: size.width,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size.width * 0.025),
            color: Colors.orange[200]),
        alignment: Alignment.center,
        margin: EdgeInsets.only(
            left: size.width * 0.03,
            right: size.width * 0.03,
            bottom: size.width * 0.004,
            top: size.width * 0.001),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = 0;
                  _tabController.animateTo(_currentIndex);
                });
              },
              child: Container(
                height: size.height * 0.06,

                alignment: Alignment.center,
                child: Icon(
                  Icons.emoji_people_outlined,
                  color: _currentIndex == 0 &&
                          _currentIndex != 1 &&
                          _currentIndex != 2
                      ? Colors.brown[400]
                      : Colors.white,
                  size: size.width * 0.07,
                ),
                //edit_location_outlined
                //filter_tilt_shift_outlined
                //language_rounded
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _currentIndex = 1;
                    _tabController.animateTo(_currentIndex);
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.search,
                    color: _currentIndex == 1 &&
                            _currentIndex != 0 &&
                            _currentIndex != 2 &&
                            _currentIndex != 3 &&
                            _currentIndex != 4
                        ? Colors.brown[400]
                        : Colors.white,
                    size: size.width * 0.07,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = 2;
                  _tabController.animateTo(_currentIndex);
                });
              },
              child: Container(
                height: size.height * 0.08,
                alignment: Alignment.center,
                child: Icon(
                  Icons.edit,
                  color: _currentIndex == 2 &&
                          _currentIndex != 0 &&
                          _currentIndex != 1 &&
                          _currentIndex != 3 &&
                          _currentIndex != 4
                      ? Colors.brown[400]
                      : Colors.white,
                  size: size.width * 0.07,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = 3;
                  _tabController.animateTo(_currentIndex);
                });
              },
              child: Container(
                height: size.height * 0.08,
                alignment: Alignment.center,
                child: Icon(
                  Icons.notification_important,
                  color: _currentIndex == 3 &&
                          _currentIndex != 0 &&
                          _currentIndex != 1 &&
                          _currentIndex != 2 &&
                          _currentIndex != 4
                      ? Colors.brown[400]
                      : Colors.white,
                  size: size.width * 0.07,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = 4;
                  _tabController.animateTo(_currentIndex);
                });
              },
              child: Container(
                height: size.height * 0.08,
                alignment: Alignment.center,
                child: Icon(
                  Icons.person,
                  color: _currentIndex == 4 &&
                          _currentIndex != 0 &&
                          _currentIndex != 1 &&
                          _currentIndex != 2 &&
                          _currentIndex != 3
                      ? Colors.brown[400]
                      : Colors.white,
                  size: size.width * 0.07,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
