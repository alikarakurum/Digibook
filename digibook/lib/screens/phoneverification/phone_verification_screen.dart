import 'package:digibook/blocs/phone_bloc/phoneverify_bloc.dart';
import 'package:digibook/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:digibook/screens/phoneverification/phone_verification_form.dart';

class PhoneVerifyScreen extends StatelessWidget {
  final UserRepository _userRepository;

  const PhoneVerifyScreen({Key key, UserRepository userRepository})
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
      body: BlocProvider<PhoneVerifyBloc>(
        create: (context) => PhoneVerifyBloc(userRepository: _userRepository),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: PhoneVerifyForm(
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
