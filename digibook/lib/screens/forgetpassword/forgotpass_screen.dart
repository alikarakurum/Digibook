import 'package:digibook/blocs/resetpass_bloc/resetpass_bloc.dart';
import 'package:digibook/repositories/user_repository.dart';
import 'package:digibook/screens/forgetpassword/forgotpass_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final UserRepository _userRepository;

  const ForgotPasswordScreen({Key key, UserRepository userRepository})
      : _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Color(0xff6a515e),
        ),
      ),
      body: BlocProvider<RePassBloc>(
        create: (context) => RePassBloc(userRepository: _userRepository),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white70, Colors.white],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.08,
                      ),
                      SvgPicture.asset(
                        "assets/icons/LOGO.svg",
                        height: MediaQuery.of(context).size.height * 0.18,
                      ),
                    ],
                  ),
                ),

                /*CurvedWidget(
                  child: Container(
                    padding: const EdgeInsets.only(top: 100, left: 50),
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.white, Colors.white.withOpacity(0.4)],
                      ),
                    ),
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 40,
                        color: Color(0xff6a515e),
                      ),
                    ),
                  ),
                ),*/
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: ForgotPasswordForm(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
