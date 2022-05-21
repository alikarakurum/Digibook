// import 'package:digibook/screens/home_screen.dart';
// // import 'package:firebase_storage/firebase_storage.dart' as storage;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:digibook/models/post.dart';

// class HandleSocialEvent {
//   final Post currentPost;

//   HandleSocialEvent(this.currentPost);

//   handleLikePost() {
//     bool _isLiked = likes[currentPost.postsUserID] == true;

//     if (_isLiked) {
//       postsRef
//           .doc(ownerId)
//           .collection('userPosts')
//           .doc(postId)
//           .update({'likes.$currentUserId': false});
//       removeLikeFromActivityFeed();
//       setState(() {
//         likeCount -= 1;
//         isLiked = false;
//         likes[currentUserId] = false;
//       });
//     } else if (!_isLiked) {
//       postsRef
//           .doc(ownerId)
//           .collection('userPosts')
//           .doc(postId)
//           .update({'likes.$currentUserId': true});
//       addLikeToActivityFeed();
//       setState(() {
//         likeCount += 1;
//         isLiked = true;
//         likes[currentUserId] = true;
//         showHeart = true;
//       });
//       Timer(Duration(milliseconds: 500), () {
//         setState(() {
//           showHeart = false;
//         });
//       });
//     }
//   }

//   removeLikeFromActivityFeed() {
//     bool isNotPostOwner = currentUserId != ownerId;
//     if (isNotPostOwner) {
//       activityFeedRef
//           .doc(ownerId)
//           .collection("feedItems")
//           .doc(postId)
//           .get()
//           .then((doc) {
//         if (doc.exists) {
//           doc.reference.delete();
//         }
//       });
//     }
//   }

//   deletePost(String ownerId, String postId) async {
//     // delete post itself
//     postsRef.doc(ownerId).collection('userPosts').doc(postId).get().then((doc) {
//       if (doc.exists) {
//         doc.reference.delete();
//       }
//     });
//     // delete uploaded image for thep ost
//     storageRef.child("post_$postId.jpg").delete();
//     // then delete all activity feed notifications
//     QuerySnapshot activityFeedSnapshot = await activityFeedRef
//         .doc(ownerId)
//         .collection("feedItems")
//         .where('postId', isEqualTo: postId)
//         .get();
//     activityFeedSnapshot.docs.forEach((doc) {
//       if (doc.exists) {
//         doc.reference.delete();
//       }
//     });
//     // then delete all comments
//     QuerySnapshot commentsSnapshot =
//         await commentsRef.doc(postId).collection('comments').get();
//     commentsSnapshot.docs.forEach((doc) {
//       if (doc.exists) {
//         doc.reference.delete();
//       }
//     });
//   }
// }
