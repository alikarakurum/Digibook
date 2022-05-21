import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digibook/constants.dart';
import 'package:digibook/models/activity_feed.dart';
import 'package:digibook/screens/home_screen.dart';
import 'package:digibook/widgets/progress.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  final ActivityFeed notification;
  NotificationsScreen({this.notification});
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<ActivityFeed> activityFeedsInList;

  @override
  void initState() {
    getActivityFeed();
    super.initState();
  }

  getActivityFeed() async {
    QuerySnapshot snapshot = await activityFeedRef
        .doc(currentUser.userID)
        .collection('feedItems')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .get();
    List<ActivityFeed> comingNotifications = snapshot.docs.map((doc) {
      Map<String, dynamic> docdata = doc.data();
      return ActivityFeed.fromDocument(docdata);
    }).toList();

    if (mounted) {
      setState(() {
        this.activityFeedsInList = comingNotifications;
      });
    }
  }

  makeCard(BuildContext context, ActivityFeed feed) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black,
      color: kLightColor,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.width * 0.01,
        horizontal: MediaQuery.of(context).size.width * 0.01,
      ),
      child: ListTile(
        leading: Icon(Icons.notification_important),
        title: Text(feed.type),
      ),
    );
  }

  buildNotificationsList(BuildContext context) {
    getActivityFeed();
    if (activityFeedsInList == null) {
      return circularProgress();
    } else if (activityFeedsInList.isEmpty) {
      return Center(
        child: Container(
          child: Text("NOTHING TO SEE"),
        ),
      );
    } else {
      return ListView.separated(
        itemBuilder: (context, index) {
          return makeCard(context, activityFeedsInList[index]);
        },
        separatorBuilder: (context, index) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.01,
            color: Colors.orange,
          );
        },
        itemCount: activityFeedsInList.length,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   bottomOpacity: 0,
        //   toolbarOpacity: 0,
        //   elevation: 0,
        //   centerTitle: true,
        //   title: Text(
        //     "NOTIFICATIONS",
        //     style: TextStyle(color: Colors.black),
        //   ),
        // ),
        body: Container(
          height: size.height,
          width: size.width,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                snap: true,
                floating: true,
                automaticallyImplyLeading: false,
                toolbarHeight: size.height * 0.03,
                expandedHeight: size.height * 0.3,
                collapsedHeight: size.height * 0.035,
                backgroundColor: Colors.orange[200],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    margin: EdgeInsets.all(size.height * 0.01),
                    decoration: BoxDecoration(
                        color: Colors.yellow[200],
                        borderRadius: BorderRadius.all(
                            Radius.circular(size.height * 0.02))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Your points are waiting to be collected\nHere you can collect your points with prize video\nAlso earn 30 minutes boost",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: size.height * 0.02,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print("YOU ARE COLLECTING YOUR POINTS");
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: size.height * 0.06,
                            width: size.width * 0.6,
                            decoration: BoxDecoration(
                                color: Colors.green[100],
                                borderRadius: BorderRadius.all(
                                    Radius.circular(size.height * 0.02))),
                            child: Text(
                              "Collect Earned Points",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: size.height * 0.02,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          // margin: EdgeInsets.all(size.height * 0.01),
                          alignment: Alignment.center,
                          height: size.height * 0.08,
                          width: size.width * 0.9,
                          decoration: BoxDecoration(
                              color: Colors.orange[200],
                              borderRadius: BorderRadius.all(
                                  Radius.circular(size.height * 0.02))),
                          child: Text(
                            "23 Minutes Left ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: size.height * 0.02,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.all(size.width * 0.02),
                  width: size.width * 0.96,
                  height: size.height * 0.8,
                  decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.all(
                          Radius.circular(size.height * 0.01))),
                  child: buildNotificationsList(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
