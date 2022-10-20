import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/src/classes/uiUtil.dart';
import 'package:emart/src/modelos/productos.dart';
import 'package:emart/src/pages/carrito/carrito_compras.dart';
import 'package:emart/src/preferences/const.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class CardCustom extends StatelessWidget {
  Productos producto;
  bool isProductoPromo;
  bool isProductoEnOferta;
  bool isAgotado;
  bool validatePromo;
  bool validateProductNuevo;
  void Function()? onTapCard;
  void Function()? onTapBtn;
  CardCustom(
      {Key? key,
      required this.producto,
      required this.isProductoPromo,
      required this.isProductoEnOferta,
      required this.isAgotado,
      this.validatePromo = false,
      this.validateProductNuevo = false,
      this.onTapCard,
      this.onTapBtn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Locale locale = Localizations.localeOf(context);
    var format = NumberFormat.simpleCurrency(locale: locale.toString());
    final screeSize = MediaQuery.of(context).size;
    var dateNow =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    UIUtills()
        .updateScreenDimesion(width: screeSize.width, height: screeSize.height);

    return Card(
      shape: RoundedRectangleBorder(
          side: new BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(8.0)),
      child: GestureDetector(
        onTap: onTapCard,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 2),
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Cuerpo de la carta
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.13,
                    // height: producto.descuento != 0
                    //     ? MediaQuery.of(context).size.height * 0.13
                    //     : MediaQuery.of(context).size.height * 0.15,
                    padding: EdgeInsets.only(top: 5.0, left: 10, right: 10),
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: CachedNetworkImage(
                        imageUrl: Constantes().urlImgProductos +
                            '${producto.codigo}.png',
                        placeholder: (context, url) =>
                            Image.asset('assets/jar-loading.gif'),
                        errorWidget: (context, url, error) =>
                            Image.asset('assets/logo_login.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  // Visibility(
                  //     visible: (((producto.activopromocion == 1 &&
                  //                     ((DateTime.parse(producto
                  //                                 .fechafinpromocion_1!))
                  //                             .compareTo(dateNow) >=
                  //                         0)) ||
                  //                 isProductoPromo ||
                  //                 isProductoEnOferta) ||
                  //             (producto.activoprodnuevo == 1 &&
                  //                 ((DateTime.parse(producto.fechafinnuevo_1!))
                  //                         .compareTo(dateNow) >=
                  //                     0))) ==
                  //         false,
                  //     child: Spacer()),
                  //nombre y sku
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${producto.nombre}',
                          maxLines: 2,
                          // maxLines: (producto.activopromocion == 1 &&
                          //             ((DateTime.parse(producto
                          //                         .fechafinpromocion_1!))
                          //                     .compareTo(dateNow) >=
                          //                 0)) ||
                          //         isProductoPromo ||
                          //         isProductoEnOferta
                          //     ? 3
                          //     : 2,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: ConstantesColores.verde),
                        ),
                        Text(
                          'SKU: ${producto.codigo}',
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: HexColor("#a2a2a2")),
                        ),
                      ],
                    ),
                  ),
                  //precio
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Visibility(
                              visible: producto.descuento != 0,
                              child: Container(
                                height: Get.width * 0.07,
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  '${format.currencySymbol}' +
                                      formatNumber
                                          .format(producto.precio)
                                          .replaceAll(',00', ''),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.red),
                                ),
                              )),
                          Expanded(
                            child: Container(
                              // height: Get.width * 0.07,
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              alignment: Alignment.topLeft,
                              child: Text(
                                '${format.currencySymbol}' +
                                    formatNumber
                                        .format(producto.descuento != 0
                                            ? producto.precioinicial
                                            : producto.precio)
                                        .replaceAll(',00', ''),
                                textAlign: TextAlign.left,
                                style: (producto.descuento != 0
                                    ? TextStyle(
                                        color: ConstantesColores.azul_precio,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                        decoration: TextDecoration.lineThrough)
                                    : TextStyle(
                                        color: ConstantesColores.azul_precio,
                                        fontWeight: FontWeight.bold,
                                        fontSize: isAgotado ? 16 : 18)),
                              ),
                            ),
                          ),
                          Visibility(
                              visible: isAgotado,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  margin: EdgeInsets.only(left: 10, bottom: 3),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.red[100],
                                  ),
                                  // height: Get.width * 0.06,
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Text(
                                    'Agotado',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.red),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !isAgotado,
                    child: Expanded(
                      child: Container(
                          height: Get.width * 0.1,
                          width: 150,
                          alignment: Alignment.center,
                          child: GestureDetector(
                              child: Image.asset("assets/agregar_btn.png"),
                              onTap: onTapBtn)),
                    ),
                  ),
                ],
              ),
              Positioned(
                  left: Get.width * 0.18,
                  child: Column(children: [
                    Visibility(
                        visible: validatePromo,
                        child: Visibility(
                          visible: (producto.activopromocion == 1 &&
                                  ((DateTime.parse(
                                              producto.fechafinpromocion_1!))
                                          .compareTo(dateNow) >=
                                      0)) ||
                              isProductoPromo ||
                              isProductoEnOferta,
                          child: Container(
                            child: Image.asset(
                              'assets/promo_abel.png',
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )),
                    Visibility(
                      visible: validateProductNuevo,
                      child: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(top: 5, right: 10),
                        child: Visibility(
                          visible: producto.activoprodnuevo == 1 &&
                              ((DateTime.parse(producto.fechafinnuevo_1!))
                                      .compareTo(dateNow) >=
                                  0),
                          child: Container(
                            child: Image.asset(
                              'assets/nuevos_label.png',
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    )
                  ]))
            ],
          ),
        ),
      ),
    );
  }
}
