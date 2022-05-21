import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digibook/models/post.dart';
import 'package:digibook/models/user_of_app.dart';
import 'package:digibook/screens/home_screen.dart';
import 'package:digibook/widgets/progress.dart';
import 'package:flutter/material.dart';

class StandartPostFlow extends StatefulWidget {
  final String topicOfPage;
  final UserOfApp currentUser;
  final String isProfilePosts;
  final String isOwner;

  StandartPostFlow({
    this.topicOfPage,
    this.currentUser,
    this.isProfilePosts,
    this.isOwner,
  });

  @override
  _StandartPostFlowState createState() => _StandartPostFlowState();
}

class _StandartPostFlowState extends State<StandartPostFlow> {
  bool isHeaderClose = false;
  double lastOffset = 0;
  List<Post> standartPosts;

  bool isRequest = false;

  @override
  void initState() {
    super.initState();
  }

  getMorePosts(
    BuildContext context,
  ) async {
    if (!isRequest) {
      setState(() => isRequest = true);
      List<Post> newPosts = await buildProgresIndicator(); //returns empty list
      setState(() {
        standartPosts.addAll(newPosts);
        isRequest = false;
      });
    }
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
        this.standartPosts = takenPosts;
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
        this.standartPosts = posts;
      });
    }
  }

  getProfileContent(String type) async {
    QuerySnapshot snapshot = await postsRef
        .doc(widget.currentUser.userID)
        .collection('userPosts')
        .where("typeOfPost", isEqualTo: type)
        .limit(25)
        .get();
    List<Post> takenPosts = snapshot.docs.map((doc) {
      Map<String, dynamic> docdata = doc.data();
      return Post.fromDocument(docdata);
    }).toList();
    if (mounted) {
      setState(() {
        this.standartPosts = takenPosts;
      });
    }
  }

  buildTimeline(BuildContext context) {
    getTimeline("standartPost");
    if (standartPosts == null) {
      return circularProgress();
    } else if (standartPosts.isEmpty) {
      return Center(
        child: Container(
          child: Text("GONDERI YOK"),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: standartPosts.length + 1,
        itemBuilder: (context, index) {
          if (index == standartPosts.length) {
            return buildProgresIndicator();
          } else
            return ListTile();
        },
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
        physics: const AlwaysScrollableScrollPhysics(),
      );
    }
  }

  buildTopicContent(BuildContext context, String postTopic) {
    getTopicContent(postTopic, "standartPost");
    if (standartPosts == null) {
      return circularProgress();
    } else if (standartPosts.isEmpty) {
      return Center(
        child: Container(
          alignment: Alignment.center,
          child: Text("GONDERI YOK"),
        ),
      );
    } else {
      return FutureBuilder(
          future: getTopicContent(postTopic, "standartPost"),
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: standartPosts.length + 1,
              itemBuilder: (context, index) {
                if (index == standartPosts.length) {
                  return buildProgresIndicator();
                } else if (standartPosts[index].username != "anonym") {
                  return ListTile(
                    title: Text(standartPosts[index].postTitle),
                  );
                } else if (standartPosts[index].username == "anonym" &&
                    widget.isOwner == "yes") {
                  return ListTile(
                    title: Text(standartPosts[index].postTitle + "ANONYM"),
                  );
                }
                return null;
              },
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
              physics: const AlwaysScrollableScrollPhysics(),
            );
          });
    }
  }

  buildStandartPostCard(Post post, Size size, {String type}) {
    String title;
    if (type == "anonym") {
      title = post.postTitle + "anonym";
    } else {
      title = post.postTitle;
    }
    return Container(
        alignment: Alignment.center,
        height: size.height * 0.2,
        margin: EdgeInsets.all(size.height * 0.002),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(size.height * 0.02)),
          color: Colors.orange[100],
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: size.height * 0.07,
              margin: EdgeInsets.all(size.height * 0.001),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.all(Radius.circular(size.height * 0.02)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: size.height * 0.068,
                    margin: EdgeInsets.all(size.height * 0.001),
                    decoration: BoxDecoration(
                        color: Colors.orange, shape: BoxShape.circle),
                  ),
                  Text(
                    post.username,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: size.height * 0.02,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ///////////////////////////////////////BURADAN POST HEADER'A DEVAM EDİLECEK!!!!!!!!!!////////////
                ],
              ),
            )
          ],
        ));
  }

  buildProfileContent(BuildContext context, Size size) {
    getProfileContent("standartPost");
    if (standartPosts == null) {
      return circularProgress();
    } else if (standartPosts.isEmpty) {
      return Center(
        child: Container(
          alignment: Alignment.center,
          child: Text("GONDERI YOK"),
        ),
      );
    } else {
      return FutureBuilder(
          future: getProfileContent("standartPost"),
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: standartPosts.length + 1,
              itemBuilder: (context, index) {
                if (index == standartPosts.length) {
                  return buildProgresIndicator();
                } else if (standartPosts[index].username != "anonym") {
                  return buildStandartPostCard(standartPosts[index], size);
                } else if (standartPosts[index].username == "anonym" &&
                    widget.isOwner == "yes") {
                  return buildStandartPostCard(standartPosts[index], size,
                      type: "anonym");
                }
                return null;
              },
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
              physics: const AlwaysScrollableScrollPhysics(),
            );
          });
    }
  }

  buildProgresIndicator() {}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return widget.isProfilePosts == "profilePosts"
        ? buildProfileContent(context, size)
        : widget.topicOfPage == null || widget.topicOfPage == ""
            ? buildTimeline(context)
            : buildTopicContent(
                context,
                widget.topicOfPage,
              );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
