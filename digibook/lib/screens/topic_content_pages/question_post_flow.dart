import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digibook/models/post.dart';
import 'package:digibook/models/user_of_app.dart';
import 'package:digibook/screens/home_screen.dart';
import 'package:digibook/widgets/progress.dart';
import 'package:flutter/material.dart';

class QuestionPostFlow extends StatefulWidget {
  final String topicOfPage;
  final UserOfApp currentUser;
  final String isProfilePosts;
  final String isOwner;

  QuestionPostFlow({
    this.topicOfPage,
    this.currentUser,
    this.isProfilePosts,
    this.isOwner,
  });

  @override
  _QuestionPostFlowState createState() => _QuestionPostFlowState();
}

class _QuestionPostFlowState extends State<QuestionPostFlow> {
  bool isHeaderClose = false;
  double lastOffset = 0;
  List<Post> questionPosts;

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
        questionPosts.addAll(newPosts);
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
        this.questionPosts = takenPosts;
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
        this.questionPosts = posts;
      });
    }
  }

  getProfileContent(String type) async {
    QuerySnapshot snapshot = await postsRef
        .doc(widget.currentUser.userID)
        .collection('userPosts')
        .where("typeOfPost", isEqualTo: "questionPost")
        .limit(25)
        .get();
    List<Post> takenPosts = snapshot.docs.map((doc) {
      Map<String, dynamic> docdata = doc.data();
      return Post.fromDocument(docdata);
    }).toList();
    if (mounted) {
      setState(() {
        this.questionPosts = takenPosts;
      });
    }
  }

  buildTimeline(BuildContext context) {
    getTimeline("questionPost");
    if (questionPosts == null) {
      return circularProgress();
    } else if (questionPosts.isEmpty) {
      return Center(
        child: Container(
          child: Text("GONDERI YOK"),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: questionPosts.length + 1,
        itemBuilder: (context, index) {
          if (index == questionPosts.length) {
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
    getTopicContent(postTopic, "questionPost");
    if (questionPosts == null) {
      return circularProgress();
    } else if (questionPosts.isEmpty) {
      return Center(
        child: Container(
          child: Text("GONDERI YOK"),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: questionPosts.length + 1,
        itemBuilder: (context, index) {
          if (index == questionPosts.length) {
            return buildProgresIndicator();
          } else
            return ListTile();
        },
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
        physics: const AlwaysScrollableScrollPhysics(),
      );
    }
  }

  buildProfileContent(BuildContext context) {
    getProfileContent("questionPost");
    if (questionPosts == null) {
      return circularProgress();
    } else if (questionPosts.isEmpty) {
      return Center(
        child: Container(
          alignment: Alignment.center,
          child: Text("GONDERI YOK"),
        ),
      );
    } else {
      return FutureBuilder(
          future: getProfileContent("questionPost"),
          builder: (context, snapshot) {
            return Container(
              child: ListView.builder(
                itemCount: questionPosts.length + 1,
                itemBuilder: (context, index) {
                  if (index == questionPosts.length) {
                    return buildProgresIndicator();
                  } else if (questionPosts[index].username != "anonym") {
                    return ListTile(
                      title: Text(questionPosts[index].postTitle),
                    );
                  } else if (questionPosts[index].username == "anonym" &&
                      widget.isOwner == "yes") {
                    return ListTile(
                      title: Text(questionPosts[index].postTitle + "ANONYM"),
                    );
                  }
                  return null;
                },
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                physics: const AlwaysScrollableScrollPhysics(),
              ),
            );
          });
    }
  }

  buildProgresIndicator() {}

  @override
  Widget build(BuildContext context) {
    return widget.isProfilePosts == "profilePosts"
        ? buildProfileContent(context)
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
