import 'package:digibook/models/user_of_app.dart';
import 'package:digibook/screens/topic_content_pages/argumentum_post_flow.dart';
import 'package:digibook/screens/topic_content_pages/championa_post_flow.dart';
import 'package:digibook/screens/topic_content_pages/question_post_flow.dart';
import 'package:digibook/screens/topic_content_pages/standart_post_flow.dart';
import 'package:flutter/material.dart';

class TopicPostFlow extends StatefulWidget {
  final String topicOfPage;
  final UserOfApp currentUser;

  TopicPostFlow({this.currentUser, this.topicOfPage});
  @override
  _TopicPostFlowState createState() => _TopicPostFlowState();
}

class _TopicPostFlowState extends State<TopicPostFlow> {
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
                automaticallyImplyLeading: false,
                title: const Text('Floating Nested SliverAppBar'),
                floating: true,
                expandedHeight: MediaQuery.of(context).size.height * 0.15,
                forceElevated: innerBoxIsScrolled,
              ),
            ];
          },
          body: Column(
            children: [
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(icon: Icon(Icons.directions_car)),
                  Tab(icon: Icon(Icons.directions_transit)),
                  Tab(icon: Icon(Icons.directions_bike)),
                  Tab(icon: Icon(Icons.directions_bike)),
                ],
              ),
              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    StandartPostFlow(
                      topicOfPage: widget.topicOfPage,
                      currentUser: widget.currentUser,
                    ),
                    QuestionPostFlow(
                      topicOfPage: widget.topicOfPage,
                      currentUser: widget.currentUser,
                    ),
                    ArgumentumPostFlow(
                      topicOfPage: widget.topicOfPage,
                      currentUser: widget.currentUser,
                    ),
                    ChampionaPostFlow(
                      topicOfPage: widget.topicOfPage,
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
