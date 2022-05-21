import 'package:digibook/models/user_of_app.dart';
import 'package:digibook/widgets/post_create_type_box.dart';
import 'package:flutter/material.dart';
import 'package:digibook/screens/create_posts/standart_post_create.dart';
import 'package:digibook/screens/create_posts/question_post_create.dart';
import 'package:digibook/screens/create_posts/argumentum_post_create.dart';

class PostCreateScreen extends StatefulWidget {
  final UserOfApp user;
  PostCreateScreen(this.user);

  @override
  _PostCreateScreenState createState() => _PostCreateScreenState();
}

class _PostCreateScreenState extends State<PostCreateScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.yellow[45],
      body: Container(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PostCreateTypeBox(
                    "assets/icons/LOGO.svg",
                    true,
                    text: "STANDART",
                    width: width * 0.45,
                    height: height * 0.25,
                    onPressed: () {
                      pushStandartPostPage(widget.user, context);
                    },
                  ),
                  SizedBox(
                    width: width * 0.01,
                  ),
                  PostCreateTypeBox(
                    "assets/icons/LOGO.svg",
                    false,
                    text: "QUESTION",
                    width: width * 0.45,
                    height: height * 0.25,
                    onPressed: () {
                      pushQuestionPostPage(widget.user, context);
                    },
                  ),
                ],
              ),
              Center(
                child: SizedBox(
                  width: width,
                  height: height * 0.01,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PostCreateTypeBox(
                    "assets/icons/LOGO.svg",
                    true,
                    text: "ARGUMENTUM",
                    width: width * 0.45,
                    height: height * 0.25,
                    onPressed: () {
                      pushArgumentumPostPage(widget.user, context);
                    },
                  ),
                  SizedBox(
                    width: width * 0.01,
                  ),
                  PostCreateTypeBox(
                    "assets/icons/LOGO.svg",
                    false,
                    text: "CHAMPIONA",
                    width: width * 0.45,
                    height: height * 0.25,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  pushStandartPostPage(UserOfApp userOfApp, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => StandartPostCreatePage(
              user: userOfApp,
            )));
  }

  pushQuestionPostPage(UserOfApp userOfApp, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => QuestionPostCreatePage(
              user: userOfApp,
            )));
  }

  pushArgumentumPostPage(UserOfApp userOfApp, BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ArgumentumPostCreatePage()));
  }
}
