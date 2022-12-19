import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageNotification extends StatelessWidget {
  final VoidCallback onReplay;
  final Widget message;
  final Widget title;

  const MessageNotification(
      {required Key key,
      required this.onReplay,
      required this.message,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: SafeArea(
        child: ListTile(
          leading: SizedBox.fromSize(
              size: const Size(40, 40),
              child: ClipOval(child: Image.asset('assets/image/app_bar2.png'))),
          title: title,
          subtitle: message,
          trailing: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                ///TODO i'm not sure it should be use this widget' BuildContext to create a Dialog
                if (onReplay != null) onReplay();
              }),
        ),
      ),
    );
  }
}
