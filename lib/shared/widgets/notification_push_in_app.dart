import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationPushInApp extends StatefulWidget {
  const NotificationPushInApp();

  @override
  _NotificationPushInAppState createState() => _NotificationPushInAppState();
}

class _NotificationPushInAppState extends State<NotificationPushInApp>
    with SingleTickerProviderStateMixin {
 late AnimationController _controller;
  bool _isFadingIn = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );
    _controller.forward();

    Future.delayed(Duration(seconds: 4)).then((_) {
      setState(() {
        _isFadingIn = false;
      });
      _controller.reverse().then((_) {
        Get.back();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isFadingIn ? 1.0 : 0.0,
      duration: Duration(seconds: 2),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.6),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/image/push_in_app_prueba.png',
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.height * 0.47,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 100,
            right: 1,
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  Icons.close,
                  size: 25,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}