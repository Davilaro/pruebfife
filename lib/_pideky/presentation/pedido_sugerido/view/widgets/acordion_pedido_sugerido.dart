// ignore: import_of_legacy_library_into_null_safe
import 'package:emart/_pideky/domain/producto/model/producto.dart';
import 'package:emart/_pideky/infrastructure/productos/producto_repository_sqlite.dart';
import 'package:emart/_pideky/presentation/pedido_sugerido/view/widgets/grid_item_acordion.dart';
import 'package:emart/_pideky/presentation/pedido_sugerido/view_model/pedido_sugerido_controller.dart';
import 'package:emart/shared/widgets/acordion.dart';
import 'package:emart/shared/widgets/boton_agregar_carrito.dart';
import 'package:emart/src/pages/carrito/carrito_compras.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

List<Widget> acordionDinamico(BuildContext context) {
  Locale locale = Localizations.localeOf(context);
  var format = locale.toString() != 'es_CO'
      ? locale.toString() != 'es_CR'
          ? NumberFormat.currency(locale: locale.toString(), symbol: '\₡')
          : NumberFormat.simpleCurrency(locale: locale.toString())
      : NumberFormat.currency(locale: locale.toString(), symbol: '\$');
  NumberFormat formatNumber = new NumberFormat("#,##0.00", "es_AR");
  final db = ProductoRepositorySqlite();
  final controller = Get.find<PedidoSugeridoController>();
  List<Widget> lista = [];
  lista.clear();

  controller.listaProductosPorFabricante.forEach((fabricante, value) {
    lista.add(
      Container(
          child: Acordion(
              elevation: 0,
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
                        SizedBox(
                          height: 35,
                        ),
                        Column(
                          children: [
                            Container(
                              child: Text(
                                "Total: ${format.currencySymbol}" +
                                    formatNumber
                                        .format(controller
                                                .listaProductosPorFabricante[
                                            fabricante]["precioProductos"])
                                        .replaceAll(",00", ""),
                                style: TextStyle(
                                    color: ConstantesColores.azul_precio,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                            BotonAgregarCarrito(
                              color: HexColor("#42B39C"),
                              height: 40,
                              width: 190,
                              onTap: () async {
                                value["items"].forEach((prod) async {
                                  Producto producto = await db
                                      .consultarDatosProducto(prod.codigo);
                                  controller.llenarCarrito(
                                      producto, prod.cantidad);
                                });
                              },
                              text: 'Agregar al carrito',
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                )),
              ))),
    );
  });
  return lista;
}
