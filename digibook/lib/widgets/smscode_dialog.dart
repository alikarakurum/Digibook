import 'package:flutter/material.dart';

class SmsCodeDialog extends StatefulWidget {
  final Function onChanged;
  final Function onPressed;


  const SmsCodeDialog(
      {Key key, this.onChanged, this.onPressed})
      : super(key: key);

  @override
  _SmsCodeDialogState createState() => _SmsCodeDialogState();
}

class _SmsCodeDialogState extends State<SmsCodeDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Enter OTP'),
      content: TextField(
        onChanged: SmsCodeDialog().onChanged,
      ),
      contentPadding: EdgeInsets.all(10.0),
      actions: <Widget>[FlatButton(onPressed: SmsCodeDialog().onPressed,
      child: Text(
        'done',
        style: TextStyle(color: Colors.white),
      ),)],
      
    );
  }
}
