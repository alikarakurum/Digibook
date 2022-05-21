import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digibook/screens/home_screen.dart';

import 'package:digibook/screens/tabbed_pages/profile_page_screen.dart';
import 'package:digibook/widgets/input_field_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:digibook/models/user_of_app.dart';

class UserSearch extends StatefulWidget {
  final UserOfApp currentUser;

  UserSearch(this.currentUser);
  @override
  _UserSearchState createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch> {
  String searchType = "userSearch";
  TextEditingController searchController = TextEditingController();

  Future<QuerySnapshot> userSearchResultsFuture;

  @override
  void initState() {
    super.initState();
    searchController.clear();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  handleUserSearch(String userQuery) {
    try {
      Future<QuerySnapshot> users =
          usersRef.where("username", isGreaterThanOrEqualTo: userQuery).get();
      setState(() {
        userSearchResultsFuture = users;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  clearSearch() {
    searchController.clear();
  }

  searchForUserInput(Size size) {
    return Container(
      height: size.height * 0.1,
      decoration: BoxDecoration(
          color: Colors.orange[100],
          borderRadius: BorderRadius.circular(size.height * 0.03)),
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(
          horizontal: size.height * 0.02, vertical: size.height * 0.01),
      child: Padding(
        padding: EdgeInsets.all(size.height * 0.02),
        child: TextFormField(
          key: ValueKey(1),
          controller: searchController,
          decoration: DecorationSpecific().textFieldStyle(
            hintText: "Look for a writer...",
            icon: Icon(
              Icons.account_box,
              size: 28.0,
              color: Colors.brown[300],
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: clearSearch,
            ),
          ),
          onFieldSubmitted: (userQuery) {
            handleUserSearch(userQuery);
          },
        ),
      ),
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

  buildUserSearchResults(Size size) {
    return FutureBuilder(
      future: userSearchResultsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return buildNoResultPage();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          List<UserResult> searchResults = [];
          snapshot.data.docs.forEach((doc) {
            Map<String, dynamic> docdata = doc.data();
            UserOfApp user = UserOfApp.fromDocument(docdata);
            UserResult searchResult = UserResult(user);
            searchResults.add(searchResult);
          });
          return Container(
            height: size.height * 0.86,
            width: size.width * 0.96,
            margin: EdgeInsets.symmetric(
                horizontal: size.height * 0.02, vertical: size.height * 0.01),
            alignment: Alignment.center,
            child: ListView(
              children: searchResults,
            ),
          );
        } else
          return Center(
            child: Container(
              child: Text(
                "HATALI ARAMA",
                style: TextStyle(color: Colors.black),
              ),
            ),
          );
      },
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
              searchForUserInput(size),
              Container(
                margin: EdgeInsets.symmetric(vertical: size.height * 0.1),
                alignment: Alignment.center,
                child: userSearchResultsFuture == null
                    ? buildNoContent(size)
                    : buildUserSearchResults(size),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserResult extends StatelessWidget {
  final UserOfApp user;

  UserResult(this.user);

  showProfile(BuildContext context, UserOfApp userOfApp) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Profile(
          profileId: userOfApp.userID,
          currentUser: userOfApp,
          isComingFromSearch: "yes",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.7),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => showProfile(context, user),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
              ),
              title: Text(
                user.username,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                user.displayName,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Divider(
            height: 2.0,
            color: Colors.white54,
          ),
        ],
      ),
    );
  }
}
