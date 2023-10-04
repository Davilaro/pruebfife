import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/controllers/notifiactions_controllers.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
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
  late final String imageUrl; // Reemplaza con la URL de tu imagen
  final String uniqueKey = UniqueKey().toString();
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
    imageUrl = widget.data.imageUrl;
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
                      child: GestureDetector(
                        onTap: () async {
                          setState(() {
                            cerrado = true;
                          });
                          _animationController.reverse();
                          await Future.delayed(
                              Duration(milliseconds: 300),
                              () async => {
                                    await notificationController
                                        .validarRedireccionOnTap(
                                            widget.data,
                                            context,
                                            provider,
                                            cargoConfirmar,
                                            prefs,
                                            widget.ubicacion,
                                            true)
                                  });
                          notificationController.onTapPushInUp.value = true;
                          UxcamTagueo().onTapPushInUp(false);
                        },
                        child: Center(
                          child: Container(
                            height: Get.height * 0.7,
                            width: Get.width * 0.85,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: CachedNetworkImage(
                                placeholder: (context, url) => Image.asset(
                                  'assets/image/jar-loading.gif',
                                  alignment: Alignment.center,
                                  height: 50,
                                ),
                                imageUrl: '$imageUrl?$uniqueKey',
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
                    //  FadeInImage(
                    //               fit: BoxFit.cover,
                    //               placeholder: AssetImage(
                    //                   'assets/image/jar-loading.gif'),
                    //               image: NetworkImage(
                    //                 widget.data.imageUrl,
                    //               ))

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
                          UxcamTagueo().onTapPushInUp(true);
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
