import 'package:digibook/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:digibook/blocs/authentication_bloc/authentication_event.dart';
import 'package:digibook/blocs/phone_bloc/phoneverify_bloc.dart';
import 'package:digibook/blocs/phone_bloc/phoneverify_event.dart';
import 'package:digibook/blocs/phone_bloc/phoneverify_state.dart';
import 'package:digibook/widgets/gradient_button.dart';
import 'package:digibook/widgets/input_field_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneVerifyForm extends StatefulWidget {
  const PhoneVerifyForm({Key key}) : super(key: key);

  @override
  _PhoneVerifyFormState createState() => _PhoneVerifyFormState();
}

class _PhoneVerifyFormState extends State<PhoneVerifyForm> {
  bool isLoginEnabled(PhoneVerifyState state) {
    return state.isPhoneNumberValid && state.isSubmitting;
  }

  bool isFailed(PhoneVerifyState state) {
    return !state.isSuccess && state.isFailure && !state.isSubmitting;
  }

  bool isButtonEnabled(PhoneVerifyState state) {
    return state.isPhoneNumberValid;
  }

  PhoneVerifyBloc _phoneVerifyBloc;

  @override
  void initState() {
    super.initState();
    _phoneVerifyBloc = BlocProvider.of<PhoneVerifyBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PhoneVerifyBloc, PhoneVerifyState>(
      listener: (context, state) {
        if (isLoginEnabled(state)) {
          Scaffold.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Submitting'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Color(0xffffae88),
              ),
            );
        }

        if (isFailed(state)) {
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
      child: BlocBuilder<PhoneVerifyBloc, PhoneVerifyState>(
        builder: (context, state) {
          return Form(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.10,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Text(
                    "D G I B U",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Center(
                    child: InternationalPhoneNumberInput(
                      selectorConfig: SelectorConfig(
                          selectorType: PhoneInputSelectorType.DIALOG),
                      inputDecoration: DecorationSpecific().textFieldStyle(
                          labelText: "Phone Number",
                          suffixIcon: Icon(Icons.phone)),
                      onInputValidated: (bool) {
                        _onPhoneNumberValidation(bool);
                      },
                      onInputChanged: (phoneNumber) {
                        _onPhoneNumberChange(phoneNumber);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                GradientButton(
                  width: MediaQuery.of(context).size.width * 0.7,
                  onPressed: () {
                    if (isButtonEnabled(state)) {
                      _onPhoneSignInSubmitted(state.parsedNumberText);
                    }
                  },
                  text: Text(
                    'Verify Phone Number',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
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
    super.dispose();
  }

  void _onPhoneNumberValidation(bool phoneNumberValidation) {
    _phoneVerifyBloc.add(
        PhoneNumberValidation(phoneNumberValidation: phoneNumberValidation));
  }

  void _onPhoneNumberChange(PhoneNumber phoneNumber) {
    _phoneVerifyBloc.add(PhoneNumberChange(phoneNumber: phoneNumber));
  }

  void _onPhoneSignInSubmitted(String phoneNumber) {
    _phoneVerifyBloc.add(LoginWithPhoneSignPressed(phoneNumber: phoneNumber));
  }

//////////// WIDGET DEGİSTİR SMS CODE AL//////////
  ///
  // void _onSmsRequestSubmitted() {
  //   Navigator.push(context, MaterialPageRoute(builder: (_) {
  //     return RegisterScreen();
  //   }));
  // }
}
