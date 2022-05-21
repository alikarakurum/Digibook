import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digibook/models/post.dart';
import 'package:digibook/models/user_of_app.dart';
import 'package:digibook/screens/home_screen.dart';
import 'package:digibook/widgets/progress.dart';
import 'package:flutter/material.dart';
import 'package:digibook/widgets/header.dart';
import 'package:digibook/constants.dart';
import 'package:digibook/screens/build_pages/user_search_page.dart';

class PostFlowContentPage extends StatefulWidget {
  final String topicOfPage;
  final UserOfApp currentUser;
  final String isProfilePosts;
  final String isOwner;
  PostFlowContentPage(
      {this.topicOfPage, this.currentUser, this.isProfilePosts, this.isOwner});

  @override
  _PostFlowContentPageState createState() => _PostFlowContentPageState();
}

class _PostFlowContentPageState extends State<PostFlowContentPage> {
  bool isHeaderClose = false;
  ScrollController scrollController;
  double lastOffset = 0;
  List<Post> posts;
  List<Post> profilePosts;
  List<String> followingList = [];
  bool isRequest = false;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();

    scrollController.addListener(() {
      print(scrollController.offset);
      if (scrollController.offset <= 0) {
        isHeaderClose = false;
      } else if (scrollController.offset >=
          scrollController.position.maxScrollExtent) {
        isHeaderClose = true;
      } else if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        getMorePosts(context);
      } else {
        isHeaderClose = scrollController.offset > lastOffset ? true : false;
      }

      setState(() {
        lastOffset = scrollController.offset;
      });
    });
  }

  getMorePosts(
    BuildContext context,
  ) async {
    if (!isRequest) {
      setState(() => isRequest = true);
      List<Post> newPosts = await getFollowing(); //returns empty list
      if (newPosts.isEmpty) {
        double edge = MediaQuery.of(context).size.height * 0.05;
        double offsetFromBottom = scrollController.position.maxScrollExtent -
            scrollController.position.pixels;
        if (offsetFromBottom < edge) {
          scrollController.animateTo(
              scrollController.offset - (edge - offsetFromBottom),
              duration: new Duration(milliseconds: 500),
              curve: Curves.easeOut);
        }
      }
      setState(() {
        posts.addAll(newPosts);
        isRequest = false;
      });
    }
  }

  getFollowing() async {
    QuerySnapshot snapshot = await followingRef
        .doc(widget.currentUser.userID)
        .collection('userFollowing')
        .get();
    setState(() {
      followingList = snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  getTimeline(String type) async {
    QuerySnapshot snapshot = await timelineRef
        .doc(widget.currentUser.userID)
        .collection('timelinePosts')
        .where("typeOfPost", isEqualTo: type)
        .limit(25)
        .get();
    List<Post> takenPosts = snapshot.docs.map((doc) {
      Map<String, dynamic> docdata = doc.data();
      Post.fromDocument(docdata);
    }).toList();
    if (mounted) {
      setState(() {
        this.posts = takenPosts;
      });
    }
  }

  getTopicContent(String postTopic, String type) async {
    QuerySnapshot snapshot =
        await postsRef.where("postTopic", isEqualTo: "[$type]").limit(25).get();
    List<Post> posts = snapshot.docs.map((doc) {
      Map<String, dynamic> docdata = doc.data();
      Post.fromDocument(docdata);
    }).toList();
    if (mounted) {
      setState(() {
        this.posts = posts;
      });
    }
  }

  getProfileContent(String type) async {
    QuerySnapshot snapshot = await postsRef
        .doc(widget.currentUser.userID)
        .collection('userPosts')
        .limit(25)
        .get();
    List<Post> takenPosts = snapshot.docs.map((doc) {
      Map<String, dynamic> docdata = doc.data();
      return Post.fromDocument(docdata);
    }).toList();
    if (mounted) {
      setState(() {
        this.profilePosts = takenPosts;
      });
    }
  }

  buildTimeline(BuildContext context, String typeOfPost) {
    getTimeline(typeOfPost);
    if (posts == null) {
      return circularProgress();
    } else if (posts.isEmpty) {
      return buildUsersToFollow();
    } else {
      return ListView.builder(
        itemCount: posts.length + 1,
        itemBuilder: (context, index) {
          if (index == posts.length) {
            return buildProgresIndicator();
          } else
            return ListTile();
        },
        controller: scrollController,
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
        physics: const AlwaysScrollableScrollPhysics(),
      );
    }
  }

  buildTopicContent(BuildContext context, String postTopic, String typeOfPost) {
    getTopicContent(postTopic, typeOfPost);
    if (posts == null) {
      return circularProgress();
    } else if (posts.isEmpty) {
      return buildUsersToFollow();
    } else {
      return ListView.builder(
        itemCount: posts.length + 1,
        itemBuilder: (context, index) {
          if (index == posts.length) {
            return buildProgresIndicator();
          } else
            return ListTile();
        },
        controller: scrollController,
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
        physics: const AlwaysScrollableScrollPhysics(),
      );
    }
  }

  buildProfileContent(BuildContext context, String typeOfPost) {
    getProfileContent(typeOfPost);
    if (profilePosts == null) {
      return circularProgress();
    } else if (profilePosts.isEmpty) {
      return buildUsersToFollow();
    } else {
      return FutureBuilder(
          future: getProfileContent(typeOfPost),
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: profilePosts.length + 1,
              itemBuilder: (context, index) {
                if (index == profilePosts.length) {
                  return buildProgresIndicator();
                } else if (profilePosts[index].username != "anonym") {
                  return ListTile(
                    title: Text(profilePosts[index].postTitle),
                  );
                } else if (profilePosts[index].username == "anonym" &&
                    widget.isOwner == "yes") {
                  return ListTile(
                    title: Text(profilePosts[index].postTitle + "ANONYM"),
                  );
                }
                return null;
              },
              controller: scrollController,
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
              physics: const AlwaysScrollableScrollPhysics(),
            );
          });
    }
  }

  buildProgresIndicator() {}

  buildAnimatedAppBar(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      height: isHeaderClose ? 0 : MediaQuery.of(context).size.height * 0.08,
      child: AppBar(
        automaticallyImplyLeading: false,
        elevation: 10,
        bottom: TabBar(
          indicatorColor: Colors.black,
          labelColor: kPrimaryColor,
          tabs: [
            Tab(icon: Icon(Icons.directions_car)),
            Tab(icon: Icon(Icons.directions_transit)),
            Tab(icon: Icon(Icons.directions_bike)),
            Tab(icon: Icon(Icons.directions_bike)),
          ],
        ),
      ),
    );
  }

  buildUsersToFollow() {
    return StreamBuilder(
      stream:
          usersRef.orderBy('timestamp', descending: true).limit(30).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<UserResult> userResults = [];
        snapshot.data.documents.forEach((doc) {
          UserOfApp user = UserOfApp.fromDocument(doc);
          final bool isAuthUser = currentUser.userID == user.userID;
          final bool isFollowingUser = followingList.contains(user.userID);
          // remove auth user from recommended list
          if (isAuthUser) {
            return;
          } else if (isFollowingUser) {
            return;
          } else {
            UserResult userResult = UserResult(user);
            userResults.add(userResult);
          }
        });
        return Container(
          color: Theme.of(context).accentColor.withOpacity(0.2),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.person_add,
                      color: Theme.of(context).primaryColor,
                      size: 30.0,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      "Users to Follow",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 30.0,
                      ),
                    ),
                  ],
                ),
              ),
              Column(children: userResults),
            ],
          ),
        );
      },
    );
  }

  buildTabbarViewer(BuildContext context) {
    return TabBarView(
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        widget.isProfilePosts == "profilePosts"
            ? buildProfileContent(context, "standartPost")
            : widget.topicOfPage == null || widget.topicOfPage == ""
                ? buildTimeline(context, "standartPost")
                : buildTopicContent(
                    context, widget.topicOfPage, "standartPost"),
        Icon(Icons.directions_transit),
        Icon(Icons.directions_bike),
        Icon(Icons.directions_bike),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: Scaffold(
        appBar: widget.topicOfPage == null || widget.topicOfPage == ""
            ? null
            : header(context, titleText: widget.topicOfPage),
        body: Container(
          child: Column(
            children: [
              buildAnimatedAppBar(context),
              Expanded(
                child: buildTabbarViewer(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }
}

// if (type == "standartPost") {
//       List<Post> posts = snapshot.docs.map((doc) {
//         Map<String, dynamic> docdata = doc.data();
//         Post.fromDocument(docdata);
//       }).toList();
//     } else if (type == "question") {
//       List<Post> posts = snapshot.docs.map((doc) {
//         Map<String, dynamic> docdata = doc.data();
//         Post.fromDocument(docdata);
//       }).toList();
//     } else if (type == "argumentum") {
//       List<Post> posts = snapshot.docs.map((doc) {
//         Map<String, dynamic> docdata = doc.data();
//         Post.fromDocument(docdata);
//       }).toList();
//     }
