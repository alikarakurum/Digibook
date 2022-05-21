/*import 'package:digibook/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:digibook/blocs/authentication_bloc/authentication_event.dart';
import 'package:digibook/blocs/phone_bloc/phoneverify_bloc.dart';
import 'package:digibook/blocs/phone_bloc/phoneverify_event.dart';
import 'package:digibook/blocs/phone_bloc/phoneverify_state.dart';
import 'package:digibook/repositories/user_repository.dart';
import 'package:digibook/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:digibook/widgets/input_field_custom.dart';


class PhoneVerifyCode extends StatefulWidget {
  final String phoneNumber;
  final UserRepository userRepository;
  final PhoneVerifyState state;

  const PhoneVerifyCode(
      {Key key, this.userRepository, this.phoneNumber, this.state})
      : super(key: key);

      /*_userRepository = userRepository,
        _phoneNumber = phoneNumber,
        _state=state, */

  @override
  _PhoneVerifyCodeState createState() => _PhoneVerifyCodeState();
}

class _PhoneVerifyCodeState extends State<PhoneVerifyCode> {
  final TextEditingController _smsCodeController = TextEditingController();

  bool get isPopulated => _smsCodeController.text.isNotEmpty;

  bool isButtonEnabled(PhoneVerifyState state) {
    return state.isPhoneNumberValid && state.isSmsCodeValid;
  }

  PhoneVerifyBloc _phoneVerifyBloc;

  @override
  void initState() {
    super.initState();
    _phoneVerifyBloc = BlocProvider.of<PhoneVerifyBloc>(context);
    _smsCodeController.addListener(_onSmsCodeChange);
  }

  @override
  Widget build(BuildContext context) {
    String _phoneNumber = PhoneVerifyCode().phoneNumber;
    return BlocListener<PhoneVerifyBloc, PhoneVerifyState>(
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
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: DecorationSpecific().textFieldStyle(),
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
                      _onPhoneSignInSubmitted(_phoneNumber);
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
    _smsCodeController.dispose();
    super.dispose();
  }

  void _onSmsCodeChange() {
    _phoneVerifyBloc.add(SmsCodeChange(smsCode: _smsCodeController.text));
  }

//////////// WIDGET DEGİSTİR SMS CODE AL//////////
  ///
  void _onPhoneSignInSubmitted(String phoneNumber) {
    _phoneVerifyBloc.add(LoginWithPhoneSignPressed(
        phoneNumber: phoneNumber, smsCode: _smsCodeController.text));
  }
}
*/