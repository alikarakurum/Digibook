import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digibook/screens/show_posts/standart_post_full_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:digibook/models/post.dart';
import 'package:digibook/constants.dart';
import 'package:digibook/screens/home_screen.dart';

class StandartPostCard extends StatefulWidget {
  final Post currentPost;

  StandartPostCard(this.currentPost);

  @override
  _StandartPostCardState createState() => _StandartPostCardState();
}

class _StandartPostCardState extends State<StandartPostCard> {
  final String currentUserId = currentUser?.userID;
  bool showLiked;
  bool showDisliked;

  int getLikeCount(likes) {
    // if no likes, return 0
    if (likes == null) {
      return 0;
    }
    int count = 0;
    // if the key is explicitly set to true, add a like
    likes.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    return count;
  }

  int getDislikeCount(dislikes) {
    // if no likes, return 0
    if (dislikes == null) {
      return 0;
    }
    int count = 0;
    // if the key is explicitly set to true, add a like
    dislikes.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    return count;
  }

  addLikeToActivityFeed(bool isOwner) {
    // add a notification to the postOwner's activity feed only if comment made by OTHER user (to avoid getting notification for our own like)
    if (!isOwner) {
      activityFeedRef
          .doc(widget.currentPost.postsUserID)
          .collection("feedItems")
          .doc(widget.currentPost.postId)
          .set({
        "type": "like",
        "username": currentUser.username,
        "userId": currentUser.userID,
        "userProfileImg": currentUser.userProfilePhotoUrl,
        "postId": widget.currentPost.postId,
        "mediaUrl": widget.currentPost.postPhotoUrl,
        "timestamp": timestamp,
      });
    }
  }

  removeLikeFromActivityFeed(bool isOwner) {
    if (!isOwner) {
      activityFeedRef
          .doc(widget.currentPost.postsUserID)
          .collection("feedItems")
          .doc(widget.currentPost.postId)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    }
  }

  addDislikeToActivityFeed(bool isOwner) {
    // add a notification to the postOwner's activity feed only if comment made by OTHER user (to avoid getting notification for our own like)
    if (!isOwner) {
      activityFeedRef
          .doc(widget.currentPost.postsUserID)
          .collection("feedItems")
          .doc(widget.currentPost.postId)
          .set({
        "type": "dislike",
        "username": currentUser.username,
        "userId": currentUser.userID,
        "userProfileImg": currentUser.userProfilePhotoUrl,
        "postId": widget.currentPost.postId,
        "mediaUrl": widget.currentPost.postPhotoUrl,
        "timestamp": timestamp,
      });
    }
  }

  removeDislikeFromActivityFeed(bool isOwner) {
    if (!isOwner) {
      activityFeedRef
          .doc(widget.currentPost.postsUserID)
          .collection("feedItems")
          .doc(widget.currentPost.postId)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    }
  }

  handleLike(bool isOwner, bool _isLiked, bool _isDisliked, int likeCount,
      int dislikeCount) {
    if (_isLiked) {
      postsRef
          .doc(widget.currentPost.postsUserID)
          .collection('userPosts')
          .doc(widget.currentPost.postId)
          .update({'likes.$currentUserId': false});
      removeLikeFromActivityFeed(isOwner);
      setState(() {
        likeCount -= 1;
        showLiked = false;
        widget.currentPost.likes[currentUserId] = false;
      });
    } else if (!_isLiked) {
      if (_isDisliked) {
        postsRef
            .doc(widget.currentPost.postsUserID)
            .collection('userPosts')
            .doc(widget.currentPost.postId)
            .update({'dislikes.$currentUserId': false});
        removeDislikeFromActivityFeed(isOwner);
        setState(() {
          dislikeCount -= 1;
          showDisliked = false;
          widget.currentPost.dislikes[currentUserId] = false;
        });
      }
      postsRef
          .doc(widget.currentPost.postsUserID)
          .collection('userPosts')
          .doc(widget.currentPost.postId)
          .update({'likes.$currentUserId': true});
      addLikeToActivityFeed(isOwner);
      setState(() {
        likeCount += 1;
        _isLiked = true;
        widget.currentPost.likes[currentUserId] = true;
        showLiked = true;
      });
      Timer(Duration(milliseconds: 500), () {
        setState(() {
          showLiked = false;
        });
      });
    }
  }

  handleDislike(bool isOwner, bool _isLiked, bool _isDisliked, int likeCount,
      int dislikeCount) {
    if (_isLiked) {
      postsRef
          .doc(widget.currentPost.postsUserID)
          .collection('userPosts')
          .doc(widget.currentPost.postId)
          .update({'likes.$currentUserId': false});
      removeLikeFromActivityFeed(isOwner);
      setState(() {
        likeCount -= 1;
        showDisliked = false;
        _isLiked = false;
        _isDisliked = true;
        widget.currentPost.likes[currentUserId] = false;
        showLiked = false;
        showDisliked = true;
      });
      postsRef
          .doc(widget.currentPost.postsUserID)
          .collection('userPosts')
          .doc(widget.currentPost.postId)
          .update({'dislikes.$currentUserId': true});
      addDislikeToActivityFeed(isOwner);
    } else if (!_isLiked) {
      if (!_isDisliked) {
        postsRef
            .doc(widget.currentPost.postsUserID)
            .collection('userPosts')
            .doc(widget.currentPost.postId)
            .update({'dislikes.$currentUserId': true});
        addDislikeToActivityFeed(isOwner);
        setState(() {
          dislikeCount += 1;
          _isLiked = false;
          _isDisliked = true;
          widget.currentPost.likes[currentUserId] = true;
          showLiked = false;
          showDisliked = true;
        });
        Timer(Duration(milliseconds: 500), () {
          setState(() {
            showDisliked = false;
          });
        });
      } else if (_isDisliked) {
        postsRef
            .doc(widget.currentPost.postsUserID)
            .collection('userPosts')
            .doc(widget.currentPost.postId)
            .update({'dislikes.$currentUserId': false});
        removeDislikeFromActivityFeed(isOwner);
        setState(() {
          dislikeCount -= 1;
          showDisliked = false;
          widget.currentPost.dislikes[currentUserId] = false;
        });
      }
    }
  }

  buildLikeAndDislikeButtons(bool isOwner, bool _isLiked, bool _isDisliked,
      int likeCount, int dislikeCount) {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.06,
          height: MediaQuery.of(context).size.height * 0.06,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: kPrimaryLightColor,
              borderRadius: BorderRadius.circular(12)),
          child: MaterialButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: StadiumBorder(),
            child: Text(
              "L",
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.025,
                  fontFamily: "Calibri"),
            ),
            onPressed: () {
              handleLike(
                  isOwner, _isLiked, _isDisliked, likeCount, dislikeCount);
            },
          ),
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.03,
            height: MediaQuery.of(context).size.height * 0.08),
        Container(
          width: MediaQuery.of(context).size.width * 0.06,
          height: MediaQuery.of(context).size.height * 0.06,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: kPrimaryLightColor,
              borderRadius: BorderRadius.circular(12)),
          child: MaterialButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: StadiumBorder(),
            child: Text(
              "D",
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.025,
                  fontFamily: "Calibri"),
            ),
            onPressed: () {
              handleDislike(
                  isOwner, _isLiked, _isDisliked, likeCount, dislikeCount);
            },
          ),
        ),
      ],
    );
  }

  deletePost() async {
    // delete post itself
    postsRef
        .doc(widget.currentPost.postsUserID)
        .collection('userPosts')
        .doc(widget.currentPost.postId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // delete uploaded image for thep ost
    //storageRef.child("post_$widget.currentPost.postId.jpg").delete();
    // then delete all activity feed notifications
    QuerySnapshot activityFeedSnapshot = await activityFeedRef
        .doc(widget.currentPost.postsUserID)
        .collection("feedItems")
        .where('postId', isEqualTo: widget.currentPost.postId)
        .get();
    activityFeedSnapshot.docs.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // then delete all comments
    // QuerySnapshot commentsSnapshot = await commentsRef
    //     .doc(widget.currentPost.postId)
    //     .collection('comments')
    //     .get();
    // commentsSnapshot.docs.forEach((doc) {
    //   if (doc.exists) {
    //     doc.reference.delete();
    //   }
    // });
  }

  buildDeletePostButton() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.06,
      height: MediaQuery.of(context).size.height * 0.06,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: kPrimaryLightColor, borderRadius: BorderRadius.circular(12)),
      child: MaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: StadiumBorder(),
        child: Text(
          "DL",
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.025,
              fontFamily: "Calibri"),
        ),
        onPressed: () {
          deletePost();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool _isOwner = currentUserId == widget.currentPost.postsUserID;
    bool _isLiked = widget.currentPost.likes[currentUserId];
    bool _isDisliked = widget.currentPost.dislikes[currentUserId];
    int _likeCount = getLikeCount(widget.currentPost.likes);
    int _dislikeCount = getDislikeCount(widget.currentPost.dislikes);
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width * 0.96,
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
      child: Column(
        children: <Widget>[
          SizedBox(height: MediaQuery.of(context).size.height * 0.08),
          Container(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                //SPACER////////////////////////////////////
                SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                // PHOTOGRAPH FIELD ///////////////////////////
                Container(
                    child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            widget.currentPost.userProfilePhotoUrl))),
                //SPACER////////////////////////////////////
                SizedBox(height: MediaQuery.of(context).size.width * 0.08),
                // USERNAME FIELD ///////////////////////////
                Container(
                  child: Text(
                    widget.currentPost.username,
                    style: TextStyle(
                      fontFamily: "Calibri",
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                //SPACER////////////////////////////////////
                SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                buildLikeAndDislikeButtons(
                    _isOwner, _isLiked, _isDisliked, _likeCount, _dislikeCount),
                SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                widget.currentPost.postsUserID == currentUserId
                    ? buildDeletePostButton()
                    : SizedBox(width: MediaQuery.of(context).size.width * 0.06),
              ],
            ),
          ),
          //SPACER   -AFTER ROW's CONTAINER ////////////////////////////////////
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
              height: MediaQuery.of(context).size.height * 0.08),
          // LIST TILE FOR POST INFO
          ListTile(
            title: Text(widget.currentPost.postTitle),
            subtitle: Text(widget.currentPost.postContent[100]),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StandartPostFullPage(
                            postFromFlowPage: widget.currentPost,
                          )));
            },
          ),
          //SPACER////////////////////////////////////
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
              height: MediaQuery.of(context).size.height * 0.08),
        ],
      ),
    );
  }
}
