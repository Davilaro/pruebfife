import 'package:emart/src/preferences/preferencias.dart';
import 'package:flutter/material.dart';

class NotificationPushInApp extends StatefulWidget {
  const NotificationPushInApp();

  @override
  _NotificationPushInAppState createState() => _NotificationPushInAppState();
}

class _NotificationPushInAppState extends State<NotificationPushInApp>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool cerrado = false;
  final prefs = Preferencias();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _fadeAnimation =
        Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.forward();
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(seconds: 4), () {
          if (cerrado == false) {
            _animationController.reverse();
            Future.delayed(Duration(milliseconds: 300), () {
              Navigator.of(context).pop();
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      color: Colors.transparent,
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
                      onTap: () async {
                        setState(() {
                          cerrado = true;
                        });
                        _animationController.reverse();
                        await Future.delayed(Duration(milliseconds: 300), () {
                          Navigator.of(context).pop();
                        });
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
            ),
          );
        });
  }
}
