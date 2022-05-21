import 'package:digibook/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:digibook/blocs/authentication_bloc/authentication_event.dart';
import 'package:digibook/blocs/login_bloc/login_bloc.dart';
import 'package:digibook/blocs/login_bloc/login_event.dart';
import 'package:digibook/blocs/login_bloc/login_state.dart';
import 'package:digibook/components/or_divider.dart';
import 'package:digibook/components/social_icon.dart';
import 'package:digibook/repositories/user_repository.dart';
import 'package:digibook/screens/forgetpassword/forgotpass_screen.dart';
import 'package:digibook/screens/register/register_screen.dart';
import 'package:digibook/widgets/gradient_button.dart';
import 'package:digibook/widgets/input_field_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:digibook/screens/phoneverification/phone_verification_screen.dart';

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;

  const LoginForm({Key key, UserRepository userRepository})
      : _userRepository = userRepository,
        super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChange);
    _passwordController.addListener(_onPasswordChange);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isFailure) {
          Scaffold.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Login Failure'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Color(0xffffae88),
              ),
            );
        }

        if (state.isSubmitting) {
          Scaffold.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Logging In...'),
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  ],
                ),
                backgroundColor: Color(0xffffae88),
              ),
            );
        }

        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(
            AuthenticationLoggedIn(),
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Form(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.015,
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
                    controller: _emailController,
                    decoration: DecorationSpecific().textFieldStyle(
                        labelText: "Email", suffixIcon: Icon(Icons.email)),
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.always,
                    autocorrect: false,
                    validator: (_) {
                      return !state.isEmailValid
                          ? 'E-mail must be written in true format'
                          : null;
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: DecorationSpecific().textFieldStyle(
                        labelText: "Password", suffixIcon: Icon(Icons.lock)),
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.always,
                    autocorrect: false,
                    validator: (_) {
                      return !state.isPasswordValid
                          ? 'Password must be written in true format'
                          : null;
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: GradientButton(
                    width: MediaQuery.of(context).size.width * 0.7,
                    onPressed: () {
                      if (isButtonEnabled(state)) {
                        _onFormSubmitted();
                      }
                    },
                    text: Text(
                      'LogIn',
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
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.03,
                  child: GestureDetector(
                    child: Text("Forgotten Password ?"),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return ForgotPasswordScreen();
                      }));
                    },
                  ),
                ),
                //////////////////////////////////////////////////////////////////////
                OrDivider(),
                //////////////////////////////////////////////////////////////////////
                Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width * 0.1,
                      ),
                      SocalIcon(
                          iconSrc: "assets/icons/google-plus.svg",
                          press: () {
                            _onGoogleSignInSubmitted();
                            debugPrint("Google Oturum Açma");
                          }),
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      SocalIcon(
                          iconSrc: "assets/icons/phone_login.svg",
                          press: () {
                            debugPrint("Telefon Oturum Açma");
                            _onPhoneSignInSubmitted();
                          }),
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width * 0.1,
                      ),
                    ],
                  ),
                ),
                //////////////////////////////////////////////////////////////////////
                OrDivider(),
                //////////////////////////////////////////////////////////////////////
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: GradientButton(
                    width: MediaQuery.of(context).size.width * 0.4,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return RegisterScreen(
                          userRepository: widget._userRepository,
                        );
                      }));
                    },
                    text: Text(
                      'Register',
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
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChange() {
    _loginBloc.add(LoginEmailChange(email: _emailController.text));
  }

  void _onPasswordChange() {
    _loginBloc.add(LoginPasswordChanged(password: _passwordController.text));
  }

  void _onFormSubmitted() {
    _loginBloc.add(LoginWithCredentialsPressed(
        email: _emailController.text, password: _passwordController.text));
  }

  void _onGoogleSignInSubmitted() {
    _loginBloc.add(LoginWithGoogleSignPressed());
  }

  void _onPhoneSignInSubmitted() {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return PhoneVerifyScreen(
        userRepository: widget._userRepository,
      );
    }));
  }
}
