import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/_pideky/presentation/mis_listas/view_model/mis_listas_view_model.dart';
import 'package:emart/_pideky/presentation/productos/view_model/producto_view_model.dart';

import 'package:emart/src/preferences/const.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

List<Widget> gridItemLista(
    BuildContext context, String fabricante, RxList lista) {
  ProductoViewModel productViewModel = Get.find();
  MyListsViewModel misListasViewModel = Get.find();

  final size = MediaQuery.of(context).size;
  List<Widget> result = [];

  lista.forEach((producto) {
    RxBool isSelected = RxBool(producto.isSelected!);
    RxInt cantidadProducto = RxInt(producto.cantidad);
    if (producto.proveedor == fabricante && producto.cantidad > 0) {
      result
        ..add(Obx(
          () => Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              children: [
                Divider(color: Colors.grey),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        shape: OutlinedBorder.lerp(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            1)!,
                        checkColor: ConstantesColores.azul_precio,
                        activeColor: ConstantesColores.azul_precio,
                        value: isSelected.value,
                        onChanged: (_) {
                          isSelected.value = !isSelected.value;
                          producto.isSelected = !producto.isSelected!;
                          if (lista.length == 1 && !producto.isSelected!) {
                            misListasViewModel
                                .mapListasProductos[fabricante]["isSelected"]
                                .value = false;
                          } else {
                            misListasViewModel
                                .mapListasProductos[fabricante]["isSelected"]
                                .value = true;
                          }
                          if (producto.isSelected!) {
                            misListasViewModel
                                .mapListasProductos[fabricante]
                                    ["precioProductos"]
                                .value += producto.precio * producto.cantidad;
                          } else {
                            misListasViewModel
                                .mapListasProductos[fabricante]
                                    ["precioProductos"]
                                .value -= producto.precio * producto.cantidad;
                          }
                        },
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: CachedNetworkImage(
                            height: size.height * 0.05,
                            imageUrl: Constantes().urlImgProductos +
                                '${producto.codigo}.png',
                            placeholder: (context, url) =>
                                Image.asset('assets/image/jar-loading.gif'),
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/image/logo_login.png',
                              width: size.width * 0.195,
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 10),
                          //width: size.width / 1.4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                producto.nombreProducto,
                                overflow: TextOverflow.ellipsis,
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
                      SizedBox(width: 14),
                      Container(
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
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 32.0,
                                  width: 32.0,
                                  child: IconButton(
                                    icon: Image.asset(
                                      'assets/image/menos.png',
                                    ),
                                    onPressed: () async {
                                      if (producto.cantidad > 1) {
                                        await misListasViewModel.updateProduct(
                                            producto.id,
                                            producto.codigo,
                                            producto.cantidad - 1,
                                            producto.proveedor,
                                            context);
                                        cantidadProducto.value =
                                            producto.cantidad;
                                      } else {
                                        misListasViewModel.deleteProduct(
                                            producto.codigo, context);
                                        // await actualizarPaginaSinReset(
                                        //     context, cargoConfirmar);
                                      }
                                    },
                                  ),
                                ),
                                Text(
                                  cantidadProducto.value.toString(),
                                  style: TextStyle(
                                      color: ConstantesColores.gris_textos,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11),
                                ),
                                SizedBox(
                                  height: 32.0,
                                  width: 32.0,
                                  child: IconButton(
                                    icon: Image.asset('assets/image/mas.png'),
                                    onPressed: () async {
                                      await misListasViewModel.updateProduct(
                                          producto.id,
                                          producto.codigo,
                                          producto.cantidad + 1,
                                          producto.proveedor,
                                          context);
                                      cantidadProducto.value =
                                          producto.cantidad;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Total",
                                style: TextStyle(
                                    color: ConstantesColores.azul_precio,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13),
                              ),
                              SizedBox(
                                height: 10,
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
    }
  });

  return result;
}
