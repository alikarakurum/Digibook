import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digibook/screens/home_screen.dart';
import 'package:digibook/screens/topic_content_pages/topic_post_flow.dart';

import 'package:digibook/widgets/input_field_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:digibook/models/user_of_app.dart';
import 'package:digibook/models/post.dart';
import 'package:digibook/constants.dart';
import 'package:digibook/widgets/progress.dart';

class PostSearch extends StatefulWidget {
  final UserOfApp currentUser;
  PostSearch(this.currentUser);
  @override
  _PostSearchState createState() => _PostSearchState();
}

class _PostSearchState extends State<PostSearch> {
  TextEditingController topicSearchController = TextEditingController();
  Future<QuerySnapshot> topicSearchResultsFuture;

  @override
  void initState() {
    super.initState();
    topicSearchController.clear();
  }

  @override
  void dispose() {
    topicSearchController.dispose();
    super.dispose();
  }

  clearSearch() {
    topicSearchController.clear();
  }

  handleTopicSearch(String topicQuery) {
    try {
      Future<QuerySnapshot> topics =
          postsRef.where("postTitle", isGreaterThanOrEqualTo: topicQuery).get();
      setState(() {
        topicSearchResultsFuture = topics;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  searchForTopicInput(Size size) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.orange[100],
          borderRadius: BorderRadius.circular(size.height * 0.03)),
      height: size.height * 0.1,
      width: size.width * 0.96,
      margin: EdgeInsets.symmetric(
          horizontal: size.height * 0.02, vertical: size.height * 0.01),
      child: Padding(
        padding: EdgeInsets.all(size.height * 0.02),
        child: TextFormField(
          controller: topicSearchController,
          decoration: DecorationSpecific().textFieldStyle(
            hintText: "Look for a topic...",
            icon: Icon(
              Icons.topic,
              size: 28.0,
              color: Colors.brown[300],
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: clearSearch,
            ),
          ),
          onFieldSubmitted: (query) {
            handleTopicSearch(query);
          },
        ),
      ),
    );
  }

  buildTopicSearchResults(Size size) {
    return FutureBuilder(
      future: topicSearchResultsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return buildNoResultPage();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          List<TopicResult> topicSearchResults = [];
          snapshot.data.docs.forEach((doc) {
            Map<String, dynamic> docdata = doc.data();
            Post post = Post.fromDocument(docdata);
            TopicResult topicSearchResult = TopicResult(post);
            topicSearchResults.add(topicSearchResult);
          });
          return Container(
            height: size.height * 0.86,
            width: size.width * 0.96,
            margin: EdgeInsets.symmetric(
                horizontal: size.height * 0.02, vertical: size.height * 0.01),
            alignment: Alignment.center,
            child: ListView(
              children: topicSearchResults,
            ),
          );
        } else
          return circularProgress();
      },
    );
  }

  buildNoContent(Size size) {
    return Container(
      alignment: Alignment.center,
      height: size.height * 0.3,
      width: size.width * 0.6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            height: size.width * 0.06,
          ),
          SvgPicture.asset(
            'assets/icons/LOGO.svg',
            width: size.width * 0.2,
          ),
          SizedBox(
            height: size.width * 0.03,
          ),
          Text(
            "Find Users",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600,
              fontSize: size.width * 0.03,
            ),
          ),
        ],
      ),
    );
  }

  buildNoResultPage() {
    return Center(
      child: Container(
        alignment: Alignment.center,
        child: Text(
          "NO RESULT FOUND",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.05,
          ),
        ),
      ),
    );
  }

  navigateToTopicPage(String topicOfPage) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TopicPostFlow(
                  currentUser: widget.currentUser,
                  topicOfPage: topicOfPage,
                )));
  }

  buildTopicsGrid(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.5,
      child: GridView.count(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
        crossAxisCount: 2,
        scrollDirection: Axis.horizontal,
        crossAxisSpacing: MediaQuery.of(context).size.height * 0.01,
        mainAxisSpacing: MediaQuery.of(context).size.height * 0.01,
        children: List.generate(scrollTopics.length, (index) {
          return GestureDetector(
            onTap: () {
              navigateToTopicPage(scrollTopics[index]);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.orange[200],
              ),
              child: Center(
                child: Text(scrollTopics[index]),
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              searchForTopicInput(size),
              Container(
                margin: EdgeInsets.symmetric(vertical: size.height * 0.1),
                alignment: Alignment.center,
                child: topicSearchResultsFuture == null
                    ? buildTopicsGrid(context)
                    : buildTopicSearchResults(size),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TopicResult extends StatelessWidget {
  final Post post;

  TopicResult(this.post);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.7),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {},
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
              ),
              title: Text(
                post.username,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                post.postTitle,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Divider(
            height: 2.0,
            color: kLightColor,
          ),
        ],
      ),
    );
  }
}
