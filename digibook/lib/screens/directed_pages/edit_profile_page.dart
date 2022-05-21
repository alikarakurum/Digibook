import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digibook/constants.dart';
import 'package:digibook/models/user_of_app.dart';
import 'package:digibook/screens/home_screen.dart';
import 'package:digibook/widgets/gradient_button.dart';
import 'package:digibook/widgets/input_field_custom.dart';
import 'package:digibook/widgets/progress.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final String currentUserId;
  EditProfilePage({this.currentUserId});
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final currentUserID = EditProfilePage().currentUserId;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _displayNameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  bool isLoading = false;
  UserOfApp user;
  bool _displayNameValid = true;
  bool _bioValid = true;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc = await usersRef.doc(widget.currentUserId).get();
    Map<String, dynamic> docdata = doc.data();
    UserOfApp user = UserOfApp.fromDocument(docdata);
    _displayNameController.text = user.displayName;
    _bioController.text = user.biography;
    setState(() {
      isLoading = false;
    });
  }

  updateProfileData() {
    setState(() {
      _displayNameController.text.trim().length < 3 ||
              _displayNameController.text.isEmpty
          ? _displayNameValid = false
          : _displayNameValid = true;
      _bioController.text.trim().length > 100
          ? _bioValid = false
          : _bioValid = true;
    });

    if (_displayNameValid && _bioValid) {
      usersRef.doc(widget.currentUserId).update({
        "displayName": _displayNameController.text,
        "biography": _bioController.text,
      });
      SnackBar snackbar = SnackBar(content: Text("Profile updated!"));
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.done,
              size: 30.0,
              color: Colors.green,
            ),
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: isLoading
            ? circularProgress()
            : ListView(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          child: CircleAvatar(
                            backgroundColor: kPrimaryColor,
                          ),
                          onTap: () {},
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        alignment: Alignment.center,
                        child: TextFormField(
                          controller: _displayNameController,
                          decoration: DecorationSpecific().textFieldStyle(
                              labelText: "Displayname",
                              hintText: "example: 'Name Surname' ",
                              suffixIcon: Icon(Icons.panorama_fish_eye)),
                          autovalidateMode: AutovalidateMode.always,
                          autocorrect: false,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.height * 0.3,
                        alignment: Alignment.center,
                        child: TextField(
                          maxLength: 40,
                          scrollController: ScrollController(),
                          controller: _bioController,
                          decoration: DecorationSpecific().textFieldStyle(
                            hintText: "Update Biography",
                            errorText:
                                _bioValid ? null : "Biography is too long",
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: GradientButton(
                          width: MediaQuery.of(context).size.width * 0.4,
                          onPressed: () => updateProfileData(),
                          text: Text(
                            'Update Profile',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          icon: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
