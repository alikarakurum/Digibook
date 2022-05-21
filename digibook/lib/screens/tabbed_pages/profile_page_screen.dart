import 'package:digibook/screens/topic_content_pages/profile_post_flow.dart';
import 'package:flutter/material.dart';
import 'package:digibook/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digibook/screens/directed_pages/edit_profile_page.dart';
import 'package:digibook/widgets/progress.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:digibook/models/user_of_app.dart';
import 'package:digibook/screens/home_screen.dart';
import 'package:digibook/models/post.dart';

class Profile extends StatefulWidget {
  final String profileId;
  final UserOfApp currentUser;
  final String isComingFromSearch;

  Profile({this.profileId, this.currentUser, this.isComingFromSearch});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final String currentUserId = currentUser?.userID;
  bool isFollowing = false;
  bool isLoading = false;
  int postCount = 0;
  int followerCount = 0;
  int followingCount = 0;
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    getProfilePosts();
    getFollowers();
    getFollowing();
    checkIfFollowing();
  }

  checkIfFollowing() async {
    DocumentSnapshot doc = await followersRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .doc(currentUserId)
        .get();
    setState(() {
      isFollowing = doc.exists;
    });
  }

  getFollowers() async {
    QuerySnapshot snapshot = await followersRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .get();
    setState(() {
      followerCount = snapshot.docs.length;
    });
  }

  getFollowing() async {
    QuerySnapshot snapshot = await followingRef
        .doc(widget.profileId)
        .collection('userFollowing')
        .get();
    setState(() {
      followingCount = snapshot.docs.length;
    });
  }

  getProfilePosts() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await postsRef
        .doc(widget.profileId)
        .collection('userPosts')
        .orderBy('timestamp', descending: true)
        .get();
    setState(() {
      isLoading = false;
      postCount = snapshot.docs.length;

      posts = snapshot.docs.map((doc) {
        Map<String, dynamic> docdata = doc.data();
        Post.fromDocument(docdata);
      }).toList();
    });
  }

  editProfile() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditProfilePage(
                  currentUserId: FirebaseAuth.instance.currentUser.uid,
                )));
  }

  handleUnfollowUser() {
    setState(() {
      isFollowing = false;
    });
    // remove follower
    followersRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .doc(currentUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // remove following
    followingRef
        .doc(currentUserId)
        .collection('userFollowing')
        .doc(widget.profileId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // delete activity feed item for them
    activityFeedRef
        .doc(widget.profileId)
        .collection('feedItems')
        .doc(currentUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  handleFollowUser() {
    setState(() {
      isFollowing = true;
    });
    // Make auth user follower of THAT user (update THEIR followers collection)
    followersRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .doc(currentUserId)
        .set({});
    // Put THAT user on YOUR following collection (update your following collection)
    followingRef
        .doc(currentUserId)
        .collection('userFollowing')
        .doc(widget.profileId)
        .set({});
    // add activity feed item for that user to notify about new follower (us)
    activityFeedRef
        .doc(widget.profileId)
        .collection('feedItems')
        .doc(currentUserId)
        .set({
      "type": "follow",
      "ownerId": widget.profileId,
      "username": currentUser.username,
      "userId": currentUserId,
      "userProfileImg": currentUser.userProfilePhotoUrl,
      "timestamp": timestamp,
    });
  }

  buildCountRow(String label, int count, Size size) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            count.toString(),
            style: TextStyle(
                fontSize: size.height * 0.03, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: size.height * 0.005,
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey,
              fontSize: size.width * 0.04,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  buildButton(Size size, {String text, Function function}) {
    Icon icon;
    if (text == "Edit") {
      icon = Icon(Icons.edit, color: Colors.white);
    } else if (text == "Follow") {
      icon = Icon(Icons.add, color: Colors.white);
    } else if (text == "Unfollow") {
      icon = Icon(Icons.remove, color: Colors.white);
    }
    return Container(
      alignment: Alignment.centerRight,
      width: MediaQuery.of(context).size.width * 0.18,
      height: MediaQuery.of(context).size.height * 0.12,
      decoration: BoxDecoration(
          color: Colors.brown,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(size.height * 0.027),
            bottomRight: Radius.circular(size.height * 0.027),
          )),
      child: MaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: StadiumBorder(),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            child: icon,
            alignment: Alignment.center,
          ),
        ),
        onPressed: function,
      ),
    );
  }

  buildProfileButton(Size size) {
    bool isProfileOwner = currentUserId == widget.profileId;
    if (isProfileOwner) {
      return buildButton(
        size,
        text: "Edit",
        function: editProfile,
      );
    } else if (isFollowing) {
      return buildButton(
        size,
        text: "Unfollow",
        function: handleUnfollowUser,
      );
    } else if (!isFollowing) {
      return buildButton(
        size,
        text: "Follow",
        function: handleFollowUser,
      );
    }
  }

  buildProfileHeader(Size size) {
    return FutureBuilder(
        future: usersRef.doc(widget.currentUser.userID).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          Map<String, dynamic> docdata = snapshot.data.data();
          UserOfApp user = UserOfApp.fromDocument(docdata);
          return AnimatedContainer(
            duration: Duration(milliseconds: 80),
            width: size.width * 0.96,
            height: size.height * 0.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(size.width * 0.2),
                topLeft: Radius.circular(size.width * 0.2),
                bottomRight: Radius.circular(size.width * 0.07),
                topRight: Radius.circular(size.width * 0.07),
              ),
              color: Colors.brown[100],
            ),
            margin: EdgeInsets.symmetric(
                horizontal: size.width * 0.02, vertical: size.width * 0.01),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: size.width * 0.35,
                  margin: EdgeInsets.all(size.height * 0.01),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: kPrimaryLightColor,
                  ),
                  child: CircleAvatar(
                    radius: size.height * 0.1,
                    backgroundColor: Colors.grey,
                    backgroundImage:
                        NetworkImage(user.userProfilePhotoUrl) ?? null,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: size.width * 0.55,
                  margin: EdgeInsets.only(
                    top: size.height * 0.01,
                    bottom: size.height * 0.01,
                    right: size.height * 0.01,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(size.height * 0.03),
                    color: Colors.orange[100],
                  ),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: size.width * 0.52,
                        height: size.height * 0.05,
                        margin: EdgeInsets.all(size.width * 0.005),
                        child: Text(
                          user.username,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: size.height * 0.02),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: size.width * 0.53,
                        height: size.height * 0.12,
                        margin: EdgeInsets.symmetric(
                            horizontal: size.width * 0.002),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(size.height * 0.027),
                          color: Colors.orange[200],
                        ),
                        child: Row(
                          children: [
                            Container(
                                alignment: Alignment.center,
                                width: size.width * 0.34,
                                height: size.height * 0.12,
                                margin: EdgeInsets.all(size.width * 0.005),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    buildCountRow(
                                        "Looks", followingCount, size),
                                    buildCountRow(
                                        "Looked", followerCount, size),
                                  ],
                                )),
                            buildProfileButton(size),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: widget.isComingFromSearch == "yes"
            ? AppBar(
                leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.all(size.height * 0.005),
                    alignment: Alignment.center,
                    height: size.height * 0.04,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.brown,
                    ),
                    child: Icon(
                      Icons.arrow_left,
                      size: size.height * 0.035,
                      color: Colors.white,
                    ),
                  ),
                ),
                toolbarHeight: size.height * 0.05,
                toolbarOpacity: 1,
                bottomOpacity: 0,
                elevation: 0,
              )
            : AppBar(
                automaticallyImplyLeading: false,
                toolbarHeight: size.height * 0.05,
                toolbarOpacity: 0,
                bottomOpacity: 0,
                elevation: 0,
                title: Text(
                  "Your Profile",
                  style: TextStyle(
                      color: Colors.black, fontSize: size.height * 0.025),
                ),
              ),
        body: SingleChildScrollView(
          child: Container(
            height: size.height,
            width: size.width,
            child: Column(
              children: [
                buildProfileHeader(size),
                Expanded(
                  child: new ProfilePostFlow(
                    currentUser: widget.currentUser,
                    profileId: widget.profileId,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
