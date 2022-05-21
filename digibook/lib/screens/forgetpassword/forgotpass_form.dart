import 'package:digibook/blocs/resetpass_bloc/resetpass_event.dart';
import 'package:digibook/blocs/resetpass_bloc/resetpass_state.dart';
import 'package:digibook/blocs/resetpass_bloc/resetpass_bloc.dart';
import 'package:digibook/widgets/gradient_button.dart';
import 'package:digibook/widgets/input_field_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:digibook/repositories/user_repository.dart';

class ForgotPasswordForm extends StatefulWidget {
  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final TextEditingController _emailController = TextEditingController();

  bool get isPopulated => _emailController.text.isNotEmpty;

  bool isButtonEnabled(RePassState state) {
    return state.isRePassEmailValid;
  }

  RePassBloc _rePassBloc;

  @override
  void initState() {
    super.initState();
    _rePassBloc = BlocProvider.of<RePassBloc>(context);
    _emailController.addListener(_onEmailChange);
  }



  @override
  Widget build(BuildContext context) {
    return BlocListener<RePassBloc, RePassState>(
      listener: (context, state) {
        bool _isFormValid;
        _isFormValid = state.isFormValid;
        if (_isFormValid) {
          Scaffold.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Email Submitted'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Color(0xffffae88),
              ),
            );
        }

        if (state.isRePassSent) {
          Scaffold.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Check your email box'),
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  ],
                ),
                backgroundColor: Color(0xffffae88),
              ),
            );
        }
      },
      child: BlocBuilder<RePassBloc, RePassState>(
        builder: (context, state) {
          return Form(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: Text(
                    "D G I B U",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: TextFormField(
                    decoration: DecorationSpecific().textFieldStyle(
                      hintText: "Enter your account e-mail",
                      labelText: "New Password",
                      suffixIcon: Icon(Icons.lock),
                    ),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.always,
                    autocorrect: false,
                    validator: (_) {
                      return !state.isRePassEmailValid
                          ? 'E-mail must be written in true format'
                          : null;
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: GradientButton(
                    width: MediaQuery.of(context).size.width * 0.7,
                    onPressed: () {
                      if (isButtonEnabled(state)) {
                        UserRepository().passwordReset(_emailController.text);
                      }
                    },
                    text: Text(
                      'Register',
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
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.3,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onEmailChange() {
    _rePassBloc.add(RePassEmailChanged(email: _emailController.text));
  }
}
