import 'package:digibook/models/post.dart';
import 'package:flutter/material.dart';
import 'package:digibook/widgets/header.dart';
import 'package:digibook/constants.dart';

class StandartPostFullPage extends StatefulWidget {
  final Post postFromFlowPage;

  StandartPostFullPage({this.postFromFlowPage});

  @override
  _StandartPostFullPageState createState() => _StandartPostFullPageState();
}

class _StandartPostFullPageState extends State<StandartPostFullPage> {
  buildContentViewer() {
    return Center(
      child: Text(widget.postFromFlowPage.postContent),
    );
  }

  buildPostHeader(BuildContext context) {
    return Column(
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
                  backgroundColor: widget.postFromFlowPage.username == "anonym"
                      ? Colors.black
                      : kPrimaryColor,
                  backgroundImage: widget.postFromFlowPage.username == "anonym"
                      ? null
                      : NetworkImage(
                          widget.postFromFlowPage.userProfilePhotoUrl),
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
                  child: Text(
                    widget.postFromFlowPage.username,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        fontFamily: "Calibri"),
                  ),
                ),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                  height: MediaQuery.of(context).size.height * 0.08),
              Container(
                width: MediaQuery.of(context).size.width * 0.04,
                height: MediaQuery.of(context).size.height * 0.05,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: kPrimaryLightColor,
                    borderRadius: BorderRadius.circular(12)),
                child: MaterialButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: StadiumBorder(),
                  child: Icon(Icons.person_add),
                  onPressed: () {},
                ),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.08,
                  height: MediaQuery.of(context).size.height * 0.08),
              Container(
                width: MediaQuery.of(context).size.width * 0.06,
                height: MediaQuery.of(context).size.height * 0.06,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: kPrimaryLightColor,
                    borderRadius: BorderRadius.circular(12)),
                child: MaterialButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: StadiumBorder(),
                  child: Text(
                    "L",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.025,
                        fontFamily: "Calibri"),
                  ),
                  onPressed: () {},
                ),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.03,
                  height: MediaQuery.of(context).size.height * 0.08),
              Container(
                width: MediaQuery.of(context).size.width * 0.06,
                height: MediaQuery.of(context).size.height * 0.06,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: kPrimaryLightColor,
                    borderRadius: BorderRadius.circular(12)),
                child: MaterialButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: StadiumBorder(),
                  child: Text(
                    "D",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.025,
                        fontFamily: "Calibri"),
                  ),
                  onPressed: () {},
                ),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.03,
                  height: MediaQuery.of(context).size.height * 0.08),
              Container(
                width: MediaQuery.of(context).size.width * 0.1,
                height: MediaQuery.of(context).size.height * 0.04,
                decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(12)),
                child: MaterialButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: StadiumBorder(),
                  child: Text(
                    "Write",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.03,
                        fontFamily: "Calibri"),
                  ),
                  onPressed: () {},
                ),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.03,
                  height: MediaQuery.of(context).size.height * 0.08),
            ],
          ),
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.007),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.07,
          alignment: Alignment.center,
          child: Text(
            widget.postFromFlowPage.postTitle,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.03,
                fontFamily: "Calibri"),
          ),
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.005),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: widget.postFromFlowPage.username),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildPostHeader(context),
            Expanded(
              child: buildContentViewer(),
            ),
          ],
        ),
      ),
    );
  }
}
