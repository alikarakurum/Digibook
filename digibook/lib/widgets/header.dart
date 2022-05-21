import 'package:flutter/material.dart';
import 'package:digibook/constants.dart';
import 'package:digibook/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:digibook/blocs/authentication_bloc/authentication_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

AppBar header(context,
    {bool isAppTitle = false, String titleText, removeBackButton = false}) {
  return AppBar(
    elevation: 10,
    toolbarHeight: MediaQuery.of(context).size.height * 0.06,
    automaticallyImplyLeading: removeBackButton ? false : true,
    title: Text(
      isAppTitle ? "D G I B U" : titleText,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: kPrimaryColor,
        fontFamily: isAppTitle ? "Calibri" : "",
        fontSize: isAppTitle ? MediaQuery.of(context).size.height * 0.04 : 22.0,
      ),
      overflow: TextOverflow.ellipsis,
    ),
    centerTitle: true,
    titleSpacing: 0.1,
    actions: <Widget>[
      IconButton(
        icon: Icon(
          Icons.exit_to_app,
          color: kPrimaryColor,
        ),
        onPressed: () {
          BlocProvider.of<AuthenticationBloc>(context)
              .add(AuthenticationLoggedOut());
        },
      )
    ],
  );
}
