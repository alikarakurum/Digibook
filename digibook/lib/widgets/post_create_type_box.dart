import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class PostCreateTypeBox extends StatelessWidget {
  final Function onPressed;
  final double width;
  final double height;
  final String text;
  final String assetPath;
  final bool isOutsideLeft;
  PostCreateTypeBox(this.assetPath, this.isOutsideLeft,
      {this.onPressed, this.width, this.height, this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      height: this.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width * 0.12),
        gradient: LinearGradient(
          begin:
              this.isOutsideLeft ? Alignment.centerLeft : Alignment.centerRight,
          end:
              this.isOutsideLeft ? Alignment.centerRight : Alignment.centerLeft,
          colors: [Colors.orange[200], Colors.orange[100]],
        ),
      ),
      child: MaterialButton(
        onPressed: this.onPressed,
        shape: StadiumBorder(),
        child: Center(
          widthFactor: 2,
          heightFactor: 2,
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              SvgPicture.asset(
                this.assetPath,
                height: MediaQuery.of(context).size.height * 0.15,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Text(
                this.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "Calibri",
                    fontSize: MediaQuery.of(context).size.height * 0.02,
                    color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
