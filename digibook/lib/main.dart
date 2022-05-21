import 'package:digibook/blocs/authentication_bloc/authentication_state.dart';
import 'package:digibook/blocs/login_bloc/login_bloc.dart';
import 'package:digibook/blocs/register_bloc/register_bloc.dart';
import 'package:digibook/blocs/simple_bloc_observer.dart';
import 'package:digibook/constants.dart';
import 'package:digibook/models/user_of_app.dart';
import 'package:digibook/repositories/user_repository.dart';
import 'package:digibook/screens/home_screen.dart';
import 'package:digibook/screens/login/login_screen.dart';
import 'package:digibook/widgets/progress.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/authentication_bloc/authentication_bloc.dart';
import 'blocs/authentication_bloc/authentication_event.dart';
import 'blocs/resetpass_bloc/resetpass_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digibook/widgets/username_dialog.dart';
import 'package:digibook/blocs/userinfo_bloc/userinfo_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  final UserRepository userRepository = UserRepository();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
            create: (BuildContext context) => AuthenticationBloc(
                  userRepository: userRepository,
                )..add(AuthenticationStarted())),
        BlocProvider<RegisterBloc>(
            create: (BuildContext context) =>
                RegisterBloc(userRepository: userRepository)),
        BlocProvider<LoginBloc>(
            create: (BuildContext context) =>
                LoginBloc(userRepository: userRepository)),
        BlocProvider<RePassBloc>(
            create: (BuildContext context) => RePassBloc()),
        BlocProvider<UserInfoBloc>(
            create: (BuildContext context) =>
                UserInfoBloc(userRepository: userRepository)),
      ],
      child: MyApp(
        userRepository: userRepository,
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final UserRepository _userRepository;

  MyApp({UserRepository userRepository}) : _userRepository = userRepository;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.white,
        cursorColor: kPrimaryColor,
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationFailure) {
            return LoginScreen(
              userRepository: widget._userRepository,
            );
          }

          if (state is AuthenticationSuccess) {
            final User currentUser = state.firebaseUser;
            return FutureBuilder<bool>(
              initialData: true,
              future: usernameQuery(currentUser),
              builder: (context, AsyncSnapshot<bool> result) {
                if (result.data) {
                  return UserCreationAtStart(state.firebaseUser.uid);
                } else
                  return UsernameDialogAlert(
                    userID: currentUser.uid,
                  );
              },
            );
          }

          return Scaffold(
            appBar: AppBar(),
            body: Container(
              child: Center(child: Text("Loading")),
            ),
          );
        },
      ),
    );
  }

/////////BELOW CODE////////////IS USER NEW? IS HE/SHE HAS USERNAME??///////////////////////
  Future<bool> usernameQuery(User currentUser) async {
    debugPrint(usersRef.get().toString() + "////////////////////////////////");
    var result = false;
    try {
      DocumentSnapshot document = await usersRef.doc(currentUser.uid).get();
      if (document.data().containsKey("username")) {
        result = true;
      } else {
        result = false;
      }
    } catch (e) {
      result = false;
    }
    return result;
  }
  ///////////////////////////////////////////////////////////////////////////////////////////
  ///
  ///
  ///

}

class UserCreationAtStart extends StatefulWidget {
  final String userUid;
  UserCreationAtStart(this.userUid);
  @override
  _UserCreationAtStartState createState() => _UserCreationAtStartState();
}

class _UserCreationAtStartState extends State<UserCreationAtStart> {
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
