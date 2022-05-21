import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityFeed {
  final String username;
  final String userId;
  final String type; // 'like', 'follow', 'comment'
  final String mediaUrl;
  final String postId;
  final String userProfileImg;
  final String commentData;
  final Timestamp timestamp;

  ActivityFeed({
    this.username,
    this.userId,
    this.type,
    this.mediaUrl,
    this.postId,
    this.userProfileImg,
    this.commentData,
    this.timestamp,
  });

  factory ActivityFeed.fromDocument(Map<String, dynamic> docdata) {
    return ActivityFeed(
      username: docdata['username'],
      userId: docdata['userId'],
      type: docdata['type'],
      postId: docdata['postId'],
      userProfileImg: docdata['userProfileImg'],
      commentData: docdata['commentData'],
      timestamp: docdata['timestamp'],
      mediaUrl: docdata['mediaUrl'],
    );
  }
}
