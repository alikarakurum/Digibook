import 'package:digibook/models/user_of_app.dart';
import 'package:digibook/screens/topic_content_pages/argumentum_post_flow.dart';
import 'package:digibook/screens/topic_content_pages/championa_post_flow.dart';
import 'package:digibook/screens/topic_content_pages/question_post_flow.dart';
import 'package:digibook/screens/topic_content_pages/standart_post_flow.dart';
import 'package:flutter/material.dart';

class TimelinePostFlow extends StatefulWidget {
  final UserOfApp currentUser;

  TimelinePostFlow({
    this.currentUser,
  });
  @override
  _TimelinePostFlowState createState() => _TimelinePostFlowState();
}

class _TimelinePostFlowState extends State<TimelinePostFlow> {
  TabController _tabController;
  ScrollController _scrollController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: DefaultTabController(
        length: 4,
        initialIndex: 0,
        child: NestedScrollView(
          controller: _scrollController,
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                centerTitle: true,
                title: Text("Posts"),
                backgroundColor: Colors.orange[200],
                automaticallyImplyLeading: false,
                floating: false,
                toolbarHeight: MediaQuery.of(context).size.height * 0.06,
                expandedHeight: MediaQuery.of(context).size.height * 0.12,
                forceElevated: innerBoxIsScrolled,
                bottom: TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(icon: Icon(Icons.directions_car)),
                    Tab(icon: Icon(Icons.directions_transit)),
                    Tab(icon: Icon(Icons.directions_bike)),
                    Tab(icon: Icon(Icons.directions_bike)),
                  ],
                ),
              ),
            ];
          },
          body: Column(
            children: [
              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    StandartPostFlow(
                      currentUser: widget.currentUser,
                    ),
                    QuestionPostFlow(
                      currentUser: widget.currentUser,
                    ),
                    ArgumentumPostFlow(
                      currentUser: widget.currentUser,
                    ),
                    ChampionaPostFlow(
                      currentUser: widget.currentUser,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
