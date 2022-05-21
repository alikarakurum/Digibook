import 'package:digibook/models/user_of_app.dart';
import 'package:flutter/material.dart';
import 'package:digibook/screens/topic_content_pages/timeline_post_flow.dart';

class PostFlowScreen extends StatefulWidget {
  final UserOfApp currentUser;

  PostFlowScreen({
    Key key,
    this.currentUser,
  }) : super(key: key);

  // @override
  // void initState() {}

  @override
  _PostFlowScreenState createState() => _PostFlowScreenState();
}

class _PostFlowScreenState extends State<PostFlowScreen> {
  @override
  Widget build(BuildContext context) {
    return TimelinePostFlow(
      currentUser: widget.currentUser,
    );
  }
}
