import 'package:digibook/repositories/user_repository.dart';
import 'package:digibook/widgets/input_field_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:digibook/widgets/gradient_button.dart';
import 'package:digibook/blocs/userinfo_bloc/userinfo_bloc.dart';
import 'package:digibook/blocs/userinfo_bloc/userinfo_event.dart';
import 'package:digibook/blocs/userinfo_bloc/userinfo_state.dart';
import 'package:digibook/screens/home_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digibook/models/user_of_app.dart';
import 'package:digibook/widgets/progress.dart';

class UsernameDialogAlert extends StatefulWidget {
  final String userID;
  UsernameDialogAlert(
      {UserRepository userRepository, BuildContext context, this.userID});

  @override
  _UsernameDialogAlertState createState() => _UsernameDialogAlertState();
}

class _UsernameDialogAlertState extends State<UsernameDialogAlert> {
  UserInfoBloc _userInfoBloc;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_onUsernameChange);
    _displayNameController.addListener(_onDisplayNameChange);
    _userInfoBloc = BlocProvider.of<UserInfoBloc>(context);
    selectedDate = DateTime(1995);
  }

  bool isButtonValid(UserInfoState state) {
    if (state.isDisplayNameValid && state.isUsernameValid) {
      return true;
    } else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserInfoBloc, UserInfoState>(
      listener: (context, state) {},
      child: BlocBuilder<UserInfoBloc, UserInfoState>(
        builder: (context, state) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                        "Hoşgeldin, devam etmek için bir kullanıcı adı seçmelisin",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Calibri",
                          fontSize: 15,
                          letterSpacing: 0.09,
                        ),
                      ),
                      alignment: Alignment.center,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextFormField(
                          controller: _usernameController,
                          decoration: DecorationSpecific().textFieldStyle(
                              labelText: "Username*",
                              hintText: "Username is mandatory. exp: dgibuser1",
                              suffixIcon: Icon(Icons.person)),
                          autovalidateMode: AutovalidateMode.always,
                          autocorrect: false,
                          validator: (_) {
                            return !state.isUsernameValid
                                ? 'Password must be written in true format'
                                : null;
                          }),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextFormField(
                          controller: _displayNameController,
                          decoration: DecorationSpecific().textFieldStyle(
                              labelText: "Displayname",
                              hintText: "example: 'Name Surname' ",
                              suffixIcon: Icon(Icons.panorama_fish_eye)),
                          autovalidateMode: AutovalidateMode.always,
                          autocorrect: false,
                          validator: (_) {
                            return !state.isDisplayNameValid
                                ? 'Displayname must have min:2 & max:15 character '
                                : null;
                          }),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.height * 0.2,
                              child: Text(
                                "Choose your birth date",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "Calibri",
                                ),
                              ),
                            ),
                            Container(
                              child: GradientButton(
                                width: MediaQuery.of(context).size.width * 0.4,
                                onPressed: () {
                                  _selectDate(context: context);
                                },
                                text: Text(
                                  'Birth Date Picker',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                icon: Icon(
                                  Icons.calendar_today,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: GradientButton(
                        width: MediaQuery.of(context).size.width * 0.7,
                        onPressed: () {
                          if (state.isUsernameValid &&
                              _usernameController.text != null &&
                              selectedDate != null) {
                            try {
                              _onSubmitPressed(selectedDate);
                              debugPrint("Form Submit Edildi ++++++ OKAY");
                              return UserCreationForFirst(widget.userID);
                            } catch (_) {
                              Fluttertoast.showToast(
                                  msg: "Check your connection");
                            }
                          } else
                            Fluttertoast.showToast(
                                msg: "Please Fill the blanks");
                        },
                        text: Text(
                          'Go and Join !',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        icon: Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _displayNameController.dispose();
    _userInfoBloc.close();
  }

  void _onUsernameChange() {
    _userInfoBloc.add(UsernameChange(username: _usernameController.text));
  }

  void _onDisplayNameChange() {
    _userInfoBloc
        .add(DisplayNameChange(displayname: _displayNameController.text));
  }

  void _onSubmitPressed(DateTime selectedDate) {
    _userInfoBloc.add(UserInfoSubmitted(
        displayname: _displayNameController.text,
        username: _usernameController.text,
        birthdate: selectedDate));
  }
  //////////////////////// DATE TIME PICKER HERE!!!/////////////After-Line-189///////////////////////
  ///
  ///

  _selectDate({BuildContext context}) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2003),
        cancelText: 'Not now',
        confirmText: "Ok",
        fieldHintText: "Month/Date/Year",
        fieldLabelText: "Birth Date of user");
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}

class UserCreationForFirst extends StatefulWidget {
  final String userUid;
  UserCreationForFirst(this.userUid);
  @override
  _UserCreationForFirstState createState() => _UserCreationForFirstState();
}

class _UserCreationForFirstState extends State<UserCreationForFirst> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: usersRef.doc(widget.userUid).get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.done) {
            if (dataSnapshot.hasData) {
              Map<String, dynamic> docdata = dataSnapshot.data.data();
              UserOfApp user = UserOfApp.fromDocument(docdata);
              return HomeScreen(curUser: user);
            }
          }
          return circularProgress();
        });
  }
}

// Navigator.pushAndRemoveUntil(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => HomeScreen(curUser: ,)),
//                                   (route) => false);
