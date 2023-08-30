import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/shared/widgets/modal_cerrar_sesion.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/controllers/notifiactions_controllers.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class NotificationPushInApp extends StatefulWidget {
  const NotificationPushInApp(this.data, this.ubicacion);
  final data;
  final String ubicacion;

  @override
  _NotificationPushInAppState createState() => _NotificationPushInAppState();
}

class _NotificationPushInAppState extends State<NotificationPushInApp>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool cerrado = false;
  final prefs = Preferencias();
  final notificationController =
      Get.find<NotificationsSlideUpAndPushInUpControllers>();

  final cargoConfirmar = Get.find<CambioEstadoProductos>();

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
        Future.delayed(Duration(seconds: 5), () {
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
    notificationController.closePushInUp.value = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CarroModelo>(context, listen: false);
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
                        child: GestureDetector(
                          onTap: () async {
                            setState(() {
                              cerrado = true;
                            });
                            _animationController.reverse();
                            await Future.delayed(Duration(milliseconds: 300),
                                () {
                              notificationController.validarRedireccionOnTap(
                                  widget.data,
                                  context,
                                  provider,
                                  cargoConfirmar,
                                  prefs,
                                  widget.ubicacion);
                            });
                            notificationController.onTapPushInUp.value = true;
                            Navigator.of(context).pop();
                          },
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: CachedNetworkImage(
                                placeholder: (context, url) => Image.asset(
                                  'assets/image/jar-loading.gif',
                                  alignment: Alignment.center,
                                  height: 50,
                                ),
                                imageUrl: widget.data.imageUrl,
                                height:
                                    MediaQuery.of(context).size.height * 0.7,
                                width:
                                    MediaQuery.of(context).size.height * 0.47,
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  'assets/image/logo_login.png',
                                  height: 50,
                                  alignment: Alignment.center,
                                ),
                                fit: BoxFit.fill,
                              ),
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
                          notificationController.closePushInUp.value = true;
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
              ));
        });
  }
}
