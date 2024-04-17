import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/_pideky/presentation/my_lists/view_model/my_lists_view_model.dart';
import 'package:emart/_pideky/presentation/product/view_model/product_view_model.dart';

import 'package:emart/src/preferences/const.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

List<Widget> gridItemLista(
    BuildContext context, String fabricante, RxList lista) {
  ProductViewModel productViewModel = Get.find();
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
                SizedBox(
                  height: 10,
                ),
                Divider(color: Colors.grey),
                Stack(
                  children: [
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
                                    .mapListasProductos[fabricante]
                                        ["isSelected"]
                                    .value = false;
                              } else {
                                misListasViewModel
                                    .mapListasProductos[fabricante]
                                        ["isSelected"]
                                    .value = true;
                              }
                              if (producto.isSelected!) {
                                misListasViewModel
                                        .mapListasProductos[fabricante]
                                            ["precioProductos"]
                                        .value +=
                                    producto.precio * producto.cantidad;
                              } else {
                                misListasViewModel
                                        .mapListasProductos[fabricante]
                                            ["precioProductos"]
                                        .value -=
                                    producto.precio * producto.cantidad;
                              }
                            },
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: Get.width * 0.6,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      alignment: Alignment.topCenter,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: CachedNetworkImage(
                                          height: size.height * 0.05,
                                          imageUrl:
                                              Constantes().urlImgProductos +
                                                  '${producto.codigo}.png',
                                          placeholder: (context, url) =>
                                              Image.asset(
                                                  'assets/image/jar-loading.gif'),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                            'assets/image/logo_login.png',
                                            width: size.width * 0.195,
                                          ),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding:
                                            EdgeInsets.only(left: 5, top: 7),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              producto.nombreProducto,
                                              overflow: TextOverflow.visible,
                                              maxLines: 3,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color:
                                                      ConstantesColores.verde,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "SKU: ${producto.codigo}",
                                              overflow: TextOverflow.visible,
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: ConstantesColores
                                                    .gris_textos,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      productViewModel.getCurrency(
                                          producto.cantidad * producto.precio),
                                      style: TextStyle(
                                          color: producto.descuento != 0
                                              ? ConstantesColores.rojo_letra
                                              : ConstantesColores.azul_precio,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                    Visibility(
                                      visible: producto.descuento != 0,
                                      child: Container(
                                        margin: EdgeInsets.only(left: 10.0),
                                        child: Text(
                                          productViewModel.getCurrency(
                                              producto.cantidad *
                                                  producto.precioInicial),
                                          style: TextStyle(
                                              color:
                                                  ConstantesColores.gris_textos,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              decoration:
                                                  TextDecoration.lineThrough),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 1,
                      right: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: ConstantesColores.azul_precio, width: 2),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 30.0,
                                  width: 30.0,
                                  child: IconButton(
                                    padding: EdgeInsets.all(0),
                                    icon: producto.cantidad != 1
                                        ? Icon(
                                            Icons.remove,
                                            color: ConstantesColores.gris_sku,
                                          )
                                        : Icon(
                                            Icons.delete_outline,
                                            color: ConstantesColores.gris_sku,
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
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(
                                    cantidadProducto.value.toString(),
                                    style: TextStyle(
                                        color: ConstantesColores.azul_precio,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                  ),
                                ),
                                SizedBox(
                                  height: 30.0,
                                  width: 30.0,
                                  child: IconButton(
                                    padding: EdgeInsets.all(0),
                                    icon: Icon(
                                      Icons.add,
                                      color: ConstantesColores
                                          .azul_aguamarina_botones,
                                    ),
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
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
    }
  });

  return result;
}
