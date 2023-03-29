import 'package:flutter/material.dart';

class TopText extends StatelessWidget {
  String message;
  TopText({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: 20,
      ),
      alignment: Alignment.center,
      child: Text(
        message,
        textAlign: TextAlign.start,
        style: TextStyle(
          height: 1.2,
          fontSize: 15,
          fontFamily: "RoundedMplus1c-Medium.ttf",
          color: Color(0xff707070),
        ),
      ),
    );
  }
}
