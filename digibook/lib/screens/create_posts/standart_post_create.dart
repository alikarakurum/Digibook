import 'dart:io';
import 'dart:convert';
import 'package:digibook/screens/home_screen.dart';
import 'package:digibook/constants.dart';
import 'package:digibook/models/user_of_app.dart';
import 'package:digibook/widgets/input_field_custom.dart';
import 'package:digibook/widgets/progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:uuid/uuid.dart';
import 'package:zefyr/zefyr.dart';
import 'package:image/image.dart' as Im;
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:fluttertoast/fluttertoast.dart';

class StandartPostCreatePage extends StatefulWidget {
  final UserOfApp user;

  StandartPostCreatePage({this.user});

  @override
  _StandartPostCreatePageState createState() => _StandartPostCreatePageState();
}

class _StandartPostCreatePageState extends State<StandartPostCreatePage> {
  TextEditingController _titleController;
  ZefyrController _controller;
  FocusNode _focusNode;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  File file;
  bool isUploading = false;
  bool isUploadingDone = false;
  String postId = Uuid().v4();
  List<String> images;
  bool isAnonymous = false;

  @override
  void initState() {
    super.initState();
    final document = _loadDocument();
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
    _titleController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _controller.dispose();
    super.dispose();
  }

  NotusDocument _loadDocument() {
    final Delta delta = Delta()..insert("Insert text here\n");
    return NotusDocument.fromDelta(delta);
  }

  compressImage(ImageSource imageSourceOnPhone) async {
    final path = await pickImage(imageSourceOnPhone);
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    setState(() {
      file = compressedImageFile;
    });
  }

  Future pickImage(ImageSource source) async {
    final file = await ImagePicker().getImage(source: source);
    if (file == null) return null;
  }

  Future<bool> uploadPostToFirestore(
      String titleOfPost, String contents) async {
    await postsRef
        .doc(widget.user.userID)
        .collection("userPosts")
        .doc(postId)
        .set({
      "postId": postId,
      "postsUserId": widget.user.userID,
      "postTopic": selectedTopic,
      "typeOfPost": "standartPost",
      "username": isAnonymous ? "anonym" : widget.user.username,
      "userProfilePhotoUrl":
          isAnonymous ? null : widget.user.userProfilePhotoUrl,
      "postTitle": titleOfPost,
      "postContent": contents,
      "postPhotoUrls": images ?? {},
      "sentTimeOfPost": timestamp,
      "likesCountOfPost": 0,
      "comments": {},
    });
    return true;
  }

  handleSubmit(BuildContext context) async {
    final titleOfPost = _titleController.text;
    final contents = jsonEncode(_controller.document);
    if (selectedTopic != "" &&
        contents.length >= 35 &&
        titleOfPost.length >= 2) {
      try {
        setState(() {
          isUploading = true;
        });
        final resultOfUploading =
            await uploadPostToFirestore(titleOfPost, contents);
        setState(() {
          isUploadingDone = resultOfUploading;
          isUploading = false;
          postId = Uuid().v4();
        });
      } catch (e) {
        setState(() {
          isUploadingDone = false;
          isUploading = false;
        });
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("UPLOADING FAILED PLEASE TRY AGAIN"),
        ));
      }
    } else if (selectedTopic != "" &&
        titleOfPost.length >= 2 &&
        contents.length < 35) {
      Fluttertoast.showToast(msg: "Sharing content is too short !");
    } else if (selectedTopic != "" &&
        contents.length >= 35 &&
        titleOfPost.length < 2) {
      Fluttertoast.showToast(msg: "Title of post is too short !");
    } else if (selectedTopic == "" &&
        contents.length >= 35 &&
        titleOfPost.length >= 2) {
      Fluttertoast.showToast(msg: "Please select a topic !");
    } else {
      Fluttertoast.showToast(msg: "Please create your own post !");
    }
  }

  Future<String> uploadImage(imageFile) async {
    storage.UploadTask uploadTask = storage.FirebaseStorage.instance
        .ref("post_$postId.jpg")
        .putFile(imageFile);
    storage.TaskSnapshot storageSnap = await uploadTask;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  buildUploadingSuccessPage() {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/icons/LOGO.svg",
              height: MediaQuery.of(context).size.height * 0.10,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Text(
              "SUCCESSFULL",
              style: TextStyle(
                  fontFamily: "Calibri",
                  fontSize: MediaQuery.of(context).size.height * 0.05),
            ),
          ],
        ),
      ),
    );
  }

  buildEditor(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.indigo[50],
        ),
        height: MediaQuery.of(context).size.height * 0.85,
        width: MediaQuery.of(context).size.width * 0.98,
        child: ZefyrScaffold(
          child: ZefyrEditor(
            padding: EdgeInsets.all(16),
            controller: _controller,
            focusNode: _focusNode,
          ),
        ),
      ),
    );
  }

  buildTopicScroll(BuildContext context) {
    Picker _picker = new Picker(
      adapter: PickerDataAdapter(pickerdata: scrollTopics),
      changeToFirst: false,
      headerDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kLightColor,
      ),
      onConfirm: (Picker picker, List value) {
        setState(() {
          selectedTopic = picker.adapter.text;
        });
        debugPrint(selectedTopic + "!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
      },
    );
    _picker.show(_scaffoldKey.currentState);
  }

  postCreator() {
    return Container(
      color: Colors.yellow[45],
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[
          Container(
            color: kPrimaryLightColor,
            height: MediaQuery.of(context).size.height * 0.09,
            child: Column(
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.005),
                Container(
                  color: kLightColor,
                  height: MediaQuery.of(context).size.height * 0.08,
                  child: Row(
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                          height: MediaQuery.of(context).size.height * 0.08),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        width: MediaQuery.of(context).size.width * 0.08,
                        child: CircleAvatar(
                          backgroundColor:
                              isAnonymous ? Colors.black : kPrimaryColor,
                          backgroundImage: isAnonymous
                              ? null
                              : NetworkImage(widget.user.userProfilePhotoUrl),
                        ),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                          height: MediaQuery.of(context).size.height * 0.08),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.04,
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: isAnonymous
                              ? Text(
                                  "anonym",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04,
                                      fontFamily: "Calibri"),
                                )
                              : Text(
                                  widget.user.username,
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04,
                                      fontFamily: "Calibri"),
                                ),
                        ),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                          height: MediaQuery.of(context).size.height * 0.08),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.15,
                        height: MediaQuery.of(context).size.height * 0.04,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: kPrimaryLightColor,
                            borderRadius: BorderRadius.circular(12)),
                        child: MaterialButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          shape: StadiumBorder(),
                          child: Text(
                            "Topic",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.025,
                                fontFamily: "Calibri"),
                          ),
                          onPressed: () {
                            buildTopicScroll(context);
                          },
                        ),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.03,
                          height: MediaQuery.of(context).size.height * 0.08),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.1,
                        height: MediaQuery.of(context).size.height * 0.08,
                        alignment: Alignment.center,
                        child: AdvancedSwitch(
                          value: isAnonymous,
                          height: MediaQuery.of(context).size.height * 0.04,
                          inactiveChild: Container(
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.person_add_disabled),
                          ),
                          activeChild: Container(
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.person_outline),
                          ),
                          onChanged: (value) {
                            setState(() {
                              isAnonymous = value;
                            });
                          },
                          activeColor: Colors.black,
                        ),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.03,
                          height: MediaQuery.of(context).size.height * 0.08),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.23,
                        height: MediaQuery.of(context).size.height * 0.04,
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(12)),
                        child: MaterialButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          shape: StadiumBorder(),
                          child: Text(
                            "Share",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.03,
                                fontFamily: "Calibri"),
                          ),
                          onPressed: () {
                            handleSubmit(context);
                          },
                        ),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.01,
                          height: MediaQuery.of(context).size.height * 0.08),
                    ],
                  ),
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.005),
              ],
            ),
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.007),
          Container(
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.07,
            alignment: Alignment.center,
            child: TextFormField(
              decoration: DecorationSpecific().textFieldStyle(
                  labelText: "Title",
                  suffixIcon: Icon(Icons.title),
                  hintText: "Title Of Post"),
              controller: _titleController,
            ),
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.005),
          isUploading ? circularProgress() : buildEditor(context)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            "CREATE STANDART POST",
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: kPrimaryColor,
              fontFamily: "Calibri",
              fontSize: MediaQuery.of(context).size.height * 0.02,
            ),
          ),
          centerTitle: true,
          titleSpacing: 0.2,
        ),
        body: isUploadingDone ? buildUploadingSuccessPage() : postCreator());
  }
}
