import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/_pideky/domain/pedido_sugerdio/model/pedido_sugerido.dart';
import 'package:emart/_pideky/presentation/pedido_sugerido/view_model/pedido_sugerido_view_model.dart';
import 'package:emart/_pideky/presentation/productos/view_model/producto_view_model.dart';

import 'package:emart/src/preferences/const.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

List<Widget> gridItem(
    BuildContext context, String fabricante, List<dynamic> lista) {
  ProductoViewModel productViewModel = Get.find();

  final size = MediaQuery.of(context).size;
  List<Widget> result = [];
  List<PedidoSugeridoModel> listTag = [];

  lista.forEach((producto) {
    final controller = Get.find<PedidoSugeridoViewModel>();
    PedidoSugeridoModel productos = controller.listaProductos[producto.codigo]!;

    if (producto.negocio == fabricante && producto.cantidad > 0) {
      listTag.add(productos);
      result
        ..add(Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            children: [
              Divider(color: Colors.grey),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: CachedNetworkImage(
                          height: size.height * 0.11,
                          imageUrl: Constantes().urlImgProductos +
                              '${producto.codigo}.png',
                          placeholder: (context, url) =>
                              Image.asset('assets/image/jar-loading.gif'),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/image/logo_login.png',
                            width: size.width * 0.35,
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        width: size.width / 1.4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              producto.nombre,
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: ConstantesColores.verde,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "SKU: ${producto.codigo}",
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: ConstantesColores.gris_textos,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Cant",
                            style: TextStyle(
                                color: ConstantesColores.azul_precio,
                                fontWeight: FontWeight.w800,
                                fontSize: 13),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            producto.cantidad.toString(),
                            style: TextStyle(
                                color: ConstantesColores.gris_textos,
                                fontWeight: FontWeight.bold,
                                fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Total",
                            style: TextStyle(
                                color: ConstantesColores.azul_precio,
                                fontWeight: FontWeight.w800,
                                fontSize: 13),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            productViewModel.getCurrency(
                                producto.cantidad * producto.precio),
                            style: TextStyle(
                                color: ConstantesColores.gris_textos,
                                fontWeight: FontWeight.bold,
                                fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
    }
  });

  return result;
}
