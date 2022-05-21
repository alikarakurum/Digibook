import 'package:flutter/material.dart';
import 'package:zefyr/zefyr.dart';
import 'package:quill_delta/quill_delta.dart';

class ArgumentumPostCreatePage extends StatefulWidget {
  @override
  _ArgumentumPostCreatePageState createState() =>
      _ArgumentumPostCreatePageState();
}

class _ArgumentumPostCreatePageState extends State<ArgumentumPostCreatePage> {
  ZefyrController _controller;
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    final document = _loadDocument();
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
  }

  NotusDocument _loadDocument() {
    final Delta delta = Delta()..insert("Insert text here\n");
    return NotusDocument.fromDelta(delta);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ZefyrScaffold(
        child: ZefyrEditor(
          controller: _controller,
          focusNode: _focusNode,
        ),
      ),
    );
  }
}
