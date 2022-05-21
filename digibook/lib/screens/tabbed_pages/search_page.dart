import 'package:flutter/material.dart';
import 'package:digibook/models/user_of_app.dart';
import 'package:digibook/screens/build_pages/user_search_page.dart';
import 'package:digibook/screens/build_pages/post_search_page.dart';

class Search extends StatefulWidget {
  final UserOfApp currentUser;

  Search(this.currentUser);
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search>
    with AutomaticKeepAliveClientMixin<Search> {
  String searchType = "userSearch";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    FloatingActionButton myFAB = FloatingActionButton(
      elevation: 8,
      child: searchType == "userSearch"
          ? Icon(
              Icons.topic,
              color: Colors.brown,
            )
          : Icon(
              Icons.person,
              color: Colors.brown,
            ),
      backgroundColor: Colors.orange[200],
      onPressed: () {
        setState(() {
          if (searchType == "userSearch") {
            searchType = "postSearch";
          } else {
            searchType = "userSearch";
          }
        });
      },
    );
    final size = MediaQuery.of(context).size;
    super.build(context);
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: size.height,
          width: size.width,
          child: Stack(children: [
            Center(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.yellow[50],
                    borderRadius: BorderRadius.circular(size.height * 0.04)),
                child: searchType == "postSearch"
                    ? PostSearch(widget.currentUser)
                    : UserSearch(widget.currentUser),
              ),
            ),
            Positioned(
              child: myFAB,
              bottom: size.height * 0.11,
              right: size.height * 0.02,
            ),
          ]),
        ),
      ),
    );
  }
}
