// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:digibook/screens/directed_pages/edit_profile_page.dart';
// import 'package:digibook/widgets/progress.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:digibook/models/user_of_app.dart';
// import 'package:digibook/screens/home_screen.dart';
// import 'package:digibook/models/post.dart';

// class Profile extends StatefulWidget {
//   final String profileId;

//   Profile({this.profileId});

//   @override
//   _ProfileState createState() => _ProfileState();
// }

// class _ProfileState extends State<Profile> {
//   final String currentUserId = currentUser?.userID;
//   String postOrientation = "grid";
//   bool isFollowing = false;
//   bool isLoading = false;
//   int postCount = 0;
//   int followerCount = 0;
//   int followingCount = 0;
//   List<Post> posts = [];

//   @override
//   void initState() {
//     super.initState();
//     getProfilePosts();
//     getFollowers();
//     getFollowing();
//     checkIfFollowing();
//   }

//   checkIfFollowing() async {
//     DocumentSnapshot doc = await followersRef
//         .doc(widget.profileId)
//         .collection('userFollowers')
//         .doc(currentUserId)
//         .get();
//     setState(() {
//       isFollowing = doc.exists;
//     });
//   }

//   getFollowers() async {
//     QuerySnapshot snapshot = await followersRef
//         .doc(widget.profileId)
//         .collection('userFollowers')
//         .get();
//     setState(() {
//       followerCount = snapshot.docs.length;
//     });
//   }

//   getFollowing() async {
//     QuerySnapshot snapshot = await followingRef
//         .doc(widget.profileId)
//         .collection('userFollowing')
//         .get();
//     setState(() {
//       followingCount = snapshot.docs.length;
//     });
//   }

//   getProfilePosts() async {
//     setState(() {
//       isLoading = true;
//     });
//     QuerySnapshot snapshot = await postsRef
//         .doc(widget.profileId)
//         .collection('userPosts')
//         .orderBy('timestamp', descending: true)
//         .get();
//     setState(() {
//       isLoading = false;
//       postCount = snapshot.docs.length;

//       posts = snapshot.docs.map((doc) {
//         Map<String, dynamic> docdata = doc.data();
//         Post.fromDocument(docdata);
//       }).toList();
//     });
//   }

//   Column buildCountColumn(String label, int count) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         Text(
//           count.toString(),
//           style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
//         ),
//         Container(
//           margin: EdgeInsets.only(top: 4.0),
//           child: Text(
//             label,
//             style: TextStyle(
//               color: Colors.grey,
//               fontSize: 15.0,
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   editProfile() {
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => EditProfilePage(
//                   currentUserId: FirebaseAuth.instance.currentUser.uid,
//                 )));
//   }

//   Container buildButton({String text, Function function}) {
//     return Container(
//       padding: EdgeInsets.only(top: 2.0),
//       child: FlatButton(
//         onPressed: function,
//         child: Container(
//           width: 250.0,
//           height: 27.0,
//           child: Text(
//             text,
//             style: TextStyle(
//               color: isFollowing ? Colors.black : Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             color: isFollowing ? Colors.white : Colors.blue,
//             border: Border.all(
//               color: isFollowing ? Colors.grey : Colors.blue,
//             ),
//             borderRadius: BorderRadius.circular(5.0),
//           ),
//         ),
//       ),
//     );
//   }

//   buildProfileButton() {
//     // viewing your own profile - should show edit profile button
//     bool isProfileOwner = currentUserId == widget.profileId;
//     if (isProfileOwner) {
//       return buildButton(
//         text: "Edit Profile",
//         function: editProfile,
//       );
//     } else if (isFollowing) {
//       return buildButton(
//         text: "Unfollow",
//         function: handleUnfollowUser,
//       );
//     } else if (!isFollowing) {
//       return buildButton(
//         text: "Follow",
//         function: handleFollowUser,
//       );
//     }
//   }

//   handleUnfollowUser() {
//     setState(() {
//       isFollowing = false;
//     });
//     // remove follower
//     followersRef
//         .doc(widget.profileId)
//         .collection('userFollowers')
//         .doc(currentUserId)
//         .get()
//         .then((doc) {
//       if (doc.exists) {
//         doc.reference.delete();
//       }
//     });
//     // remove following
//     followingRef
//         .doc(currentUserId)
//         .collection('userFollowing')
//         .doc(widget.profileId)
//         .get()
//         .then((doc) {
//       if (doc.exists) {
//         doc.reference.delete();
//       }
//     });
//     // delete activity feed item for them
//     activityFeedRef
//         .doc(widget.profileId)
//         .collection('feedItems')
//         .doc(currentUserId)
//         .get()
//         .then((doc) {
//       if (doc.exists) {
//         doc.reference.delete();
//       }
//     });
//   }

//   handleFollowUser() {
//     setState(() {
//       isFollowing = true;
//     });
//     // Make auth user follower of THAT user (update THEIR followers collection)
//     followersRef
//         .doc(widget.profileId)
//         .collection('userFollowers')
//         .doc(currentUserId)
//         .set({});
//     // Put THAT user on YOUR following collection (update your following collection)
//     followingRef
//         .doc(currentUserId)
//         .collection('userFollowing')
//         .doc(widget.profileId)
//         .set({});
//     // add activity feed item for that user to notify about new follower (us)
//     activityFeedRef
//         .doc(widget.profileId)
//         .collection('feedItems')
//         .doc(currentUserId)
//         .set({
//       "type": "follow",
//       "ownerId": widget.profileId,
//       "username": currentUser.username,
//       "userId": currentUserId,
//       "userProfileImg": currentUser.userProfilePhotoUrl,
//       "timestamp": timestamp,
//     });
//   }

//   buildProfileHeader() {
//     return FutureBuilder(
//         future: usersRef.doc(widget.profileId).get(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return circularProgress();
//           }
//           Map<String, dynamic> docdata = snapshot.data.data();
//           UserOfApp user = UserOfApp.fromDocument(docdata);
//           return Container(
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             child: Column(
//               children: <Widget>[
//                 Container(),
//                 Container(
//                   alignment: Alignment.centerLeft,
//                   padding: EdgeInsets.only(top: 12.0),
//                   child: Text(
//                     user.username,
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16.0,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   alignment: Alignment.centerLeft,
//                   padding: EdgeInsets.only(top: 4.0),
//                   child: Text(
//                     user.displayName,
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   alignment: Alignment.centerLeft,
//                   padding: EdgeInsets.only(top: 2.0),
//                   child: Text(
//                     user.biography,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         });
//   }

//   buildProfilePosts() {
//     if (isLoading) {
//       return circularProgress();
//     } else if (posts.isEmpty) {
//       return Container(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               SizedBox(
//                 height: MediaQuery.of(context).size.height * 0.2,
//               ),
//               SvgPicture.asset('assets/icons/LOGO.svg', height: 160.0),
//               Padding(
//                 padding: EdgeInsets.only(top: 20.0),
//                 child: Text(
//                   "No Posts",
//                   style: TextStyle(
//                     color: Colors.redAccent,
//                     fontSize: 40.0,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView(
//         children: <Widget>[
//           buildProfileHeader(),
//           Divider(),
//           Divider(
//             height: 0.0,
//           ),
//           buildProfilePosts(),
//         ],
//       ),
//     );
//   }
// }

// // buildCountColumn("followers", followerCount),
// // buildCountColumn("following", followingCount),

// // buildProfileButton(),

// //  Row(
// //                   children: <Widget>[
// //                     Column(
// //                       children: <Widget>[
// //                         SizedBox(
// //                           height: MediaQuery.of(context).size.height * 0.03,
// //                         ),
// //                         Row(
// //                           mainAxisSize: MainAxisSize.max,
// //                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                           children: <Widget>[
// //                             buildCountColumn("posts", postCount),
// //                           ],
// //                         ),
// //                         Row(
// //                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                           children: <Widget>[],
// //                         ),
// //                       ],
// //                     ),
// //                     CircleAvatar(
// //                       radius: MediaQuery.of(context).size.height * 0.1,
// //                       backgroundColor: Colors.grey,
// //                       backgroundImage: NetworkImage(user.userProfilePhotoUrl),
// //                     ),
// //                   ],
// //                 ),
