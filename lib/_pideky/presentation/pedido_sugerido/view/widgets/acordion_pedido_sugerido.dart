import 'package:emart/_pideky/domain/producto/model/producto.dart';
import 'package:emart/_pideky/infrastructure/productos/producto_repository_sqlite.dart';
import 'package:emart/_pideky/presentation/pedido_sugerido/view/widgets/grid_item_acordion.dart';
import 'package:emart/_pideky/presentation/pedido_sugerido/view_model/pedido_sugerido_view_model.dart';
import 'package:emart/_pideky/presentation/productos/view_model/producto_view_model.dart';
import 'package:emart/shared/widgets/acordion.dart';
import 'package:emart/shared/widgets/boton_agregar_carrito.dart';
import 'package:emart/src/pages/login/login.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final prefs = new Preferencias();

List<Widget> acordionDinamico(BuildContext context) {
  ProductoViewModel productViewModel = Get.find();

  final controller = Get.find<PedidoSugeridoViewModel>();
  List<Widget> lista = [];
  lista.clear();

  controller.listaProductosPorFabricante.forEach((fabricante, value) {
    bool isFrecuencia = prefs.paisUsuario == 'CR'
        ? productViewModel.validarFrecuencia(fabricante)
        : true;
    lista.add(
      Container(
          child: Acordion(
              bloqueoCartera: controller.listaProductosPorFabricante[fabricante]
                  ["bloqueoCartera"],
              section: "PedidoSugerido",
              sectionName:
                  "${controller.listaProductosPorFabricante[fabricante]["nombrecomercial"]}",
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
                                "Total: ${productViewModel.getCurrency(controller.listaProductosPorFabricante[fabricante]["precioProductos"])}",
                                style: TextStyle(
                                    color: ConstantesColores.azul_precio,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                            BotonAgregarCarrito(
                              color: isFrecuencia
                                  ? ConstantesColores.azul_aguamarina_botones
                                  : ConstantesColores.gris_sku,
                              height: 40,
                              width: 190,
                              onTap: () async {
                                UxcamTagueo().addToCartSuggestedOrder(
                                    value["items"], fabricante);
                                await _validarFrecuencia(
                                    isFrecuencia,
                                    value["items"],
                                    controller,
                                    productViewModel,
                                    context);
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

_validarFrecuencia(isFrecuencia, value, controller,
    ProductoViewModel productViewModel, context) async {
  if (prefs.usurioLogin == 1) {
    final db = ProductoRepositorySqlite();
    if (isFrecuencia) {
      value.forEach((prod) async {
        Producto producto = await db.consultarDatosProducto(prod.codigo);
        controller.llenarCarrito(producto, prod.cantidad, context);
      });
    } else {
      productViewModel.iniciarModal(context, value[0].negocio);
    }
  } else {
    Get.off(Login());
  }
}
