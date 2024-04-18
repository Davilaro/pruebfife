import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/_pideky/domain/my_orders/model/historical_model.dart';
import 'package:emart/_pideky/presentation/product/view_model/product_view_model.dart';
import 'package:emart/src/preferences/const.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetails extends StatelessWidget {
  const OrderDetails({
    Key? key,
    required this.detalles,
    required this.i,
  }) : super(key: key);

  final List<HistoricalModel>? detalles;
  final int i;

  @override
  Widget build(BuildContext context) {
    ProductViewModel productViewModel = Get.find();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          SizedBox(height: 10),
          Divider(
            color: ConstantesColores.gris_textos,
          ),
          Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        height: Get.height * 0.09,
                        imageUrl: Constantes().urlImgProductos +
                            '${detalles![i].codigoRef}.png',
                        placeholder: (context, url) =>
                            Image.asset('assets/image/jar-loading.gif'),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/image/logo_login.png',
                          width: Get.width * 0.195,
                        ),
                        fit: BoxFit.fill,
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              detalles![i].nombreProducto!,
                              overflow: TextOverflow.visible,
                              maxLines: 3,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: ConstantesColores.azul_aguamarina_botones,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "SKU: ${detalles![i].codigoRef}",
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: ConstantesColores.gris_textos,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        productViewModel.getCurrency(
                            detalles![i].cantidad! * detalles![i].precio!),
                        style: TextStyle(
                            color: detalles![i].descuento! != 0
                                ? ConstantesColores.rojo_letra
                                : ConstantesColores.azul_precio,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                      Visibility(
                        visible: detalles![i].descuento != 0,
                        child: Container(
                          margin: EdgeInsets.only(left: 10.0),
                          child: Text(
                            productViewModel.getCurrency(
                                detalles![i].cantidad! *
                                    detalles![i].precioDescuento!),
                            style: TextStyle(
                                color: ConstantesColores.gris_textos,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                decoration: TextDecoration.lineThrough),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container()
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: ConstantesColores.azul_precio, width: 2),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            detalles![i].cantidad.toString(),
                            style: TextStyle(
                                color: ConstantesColores.azul_precio,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
