import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/controllers/notifiactions_controllers.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/_pideky/presentation/cart/view_model/cart_view_model.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void showSlideUpNotification(context, data, ubicacion) {
  final provider = Provider.of<CartViewModel>(context, listen: false);
  final String imageUrl = data.imageUrl; // Reemplaza con la URL de tu imagen
  final String uniqueKey = UniqueKey().toString();
  final cargoConfirmar = Get.find<CambioEstadoProductos>();
  final notificationController =
      Get.find<NotificationsSlideUpAndPushInUpControllers>();
  Preferencias prefs = Preferencias();

  Get.showSnackbar(GetSnackBar(
    onTap: (snack) {
      Get.back();
      notificationController.closeSlideUp.value = true;
      notificationController.validarRedireccionOnTap(
          data, context, provider, cargoConfirmar, prefs, ubicacion, false);
      UxcamTagueo().onTapSlideUp(true, data.nombre);
    },
    duration: Duration(minutes: 2),
    animationDuration: Duration(milliseconds: 500),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.grey.shade400,
    borderRadius: 15,
    messageText: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            bottomLeft: Radius.circular(15.0),
          ),
          child: Container(
            height: 80,
            width: 80,
            child: CachedNetworkImage(
              placeholder: (context, url) => Image.asset(
                'assets/image/jar-loading.gif',
                alignment: Alignment.center,
                height: 50,
              ),
              imageUrl: '$imageUrl?$uniqueKey',
              errorWidget: (context, url, error) => Image.asset(
                'assets/image/logo_login.png',
                height: 50,
                alignment: Alignment.center,
              ),
              fit: BoxFit.fill,
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            data.descripcion,
            style: TextStyle(color: Colors.black, fontSize: 12),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Icon(Icons.arrow_forward_ios, color: Colors.white),
        SizedBox(
          width: 10,
        )
      ],
    ),
    margin: EdgeInsets.symmetric(horizontal: 24, vertical: 65),
    padding: EdgeInsets.all(0.0),
    isDismissible: false,
    dismissDirection: DismissDirection.horizontal,
    forwardAnimationCurve: Curves.easeOutBack,
    reverseAnimationCurve: Curves.ease,
  ));
}
