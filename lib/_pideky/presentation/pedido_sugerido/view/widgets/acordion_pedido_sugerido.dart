// ignore: import_of_legacy_library_into_null_safe
import 'package:emart/_pideky/presentation/pedido_sugerido/view/widgets/grid_item_acordion.dart';
import 'package:emart/_pideky/presentation/pedido_sugerido/view_model/pedido_sugerido_controller.dart';
import 'package:emart/_pideky/presentation/widgets/widgets.dart';
import 'package:emart/src/modelos/productos.dart';
import 'package:emart/src/pages/carrito/carrito_compras.dart';
import 'package:emart/src/pages/mi_negocio/widgets/acordion.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/provider/db_provider_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../src/preferences/metodo_ingresados.dart';
import '../../../../../src/provider/carrito_provider.dart';

List<Widget> acordionDinamico(BuildContext context) {
  final cartProvider = Provider.of<CarroModelo>(context);
  Locale locale = Localizations.localeOf(context);
  var format = NumberFormat.simpleCurrency(locale: locale.toString());
  final controller = Get.find<PedidoSugeridoController>();
  List<Widget> lista = [];

  controller.listaProductosPorFabricante.forEach((fabricante, value) {
    print(fabricante);
    print(value);
    lista.add(
      Container(
          child: Acordion(
              contenido2: Column(
                children: [
                  Container(
                    child: Text(
                      "Total: ${format.currencySymbol}" +
                          formatNumber
                              .format(controller
                                      .listaProductosPorFabricante[fabricante]
                                  ["precioProductos"])
                              .replaceAll(",00", ""),
                      style: TextStyle(
                          color: ConstantesColores.azul_precio,
                          fontSize: 18,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                  BotonAgregarCarrito(
                    color: ConstantesColores.agua_marina,
                    height: 40,
                    width: 190,
                    onTap: () async {
                      value["items"].forEach((prod) async {
                        Productos producto = await DBProviderHelper.db
                            .consultarDatosProducto(prod.codigo);
                        controller.llenarCarrito(
                            producto, prod.cantidad);
                      });
                    },
                    text: 'Agregar al carrito',
                  )
                ],
              ),
              title: Container(
                width: MediaQuery.of(context).size.width / 4,
                child: Text(
                  controller.listaProductosPorFabricante[fabricante]
                      ["nombrecomercial"],
                  style: TextStyle(
                      color: ConstantesColores.azul_precio,
                      fontSize: 19,
                      fontWeight: FontWeight.w800),
                ),
              ),
              urlIcon: controller.listaProductosPorFabricante[fabricante]
                  ["imagen"],
              contenido: Container(
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    Column(
                      children: [
                        ...gridItem(context, fabricante, value["items"]),
                      ],
                    )
                  ],
                )),
              ))),
    );
  });
  return lista;
}
