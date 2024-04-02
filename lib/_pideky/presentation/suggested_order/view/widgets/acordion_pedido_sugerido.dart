import 'package:emart/_pideky/domain/suggested_order/model/suggested_order_model.dart';
import 'package:emart/_pideky/domain/product/model/product_model.dart';
import 'package:emart/_pideky/infrastructure/product/product_service.dart';
import 'package:emart/_pideky/presentation/my_lists/view_model/my_lists_view_model.dart';
import 'package:emart/_pideky/presentation/my_lists/widgets/pop_up_choose_list.dart';
import 'package:emart/_pideky/presentation/suggested_order/view/widgets/grid_item_acordion.dart';
import 'package:emart/_pideky/presentation/suggested_order/view_model/suggested_order_view_model.dart';
import 'package:emart/_pideky/presentation/product/view_model/product_view_model.dart';
import 'package:emart/shared/widgets/acordion_mis_listas.dart';
import 'package:emart/shared/widgets/boton_agregar_carrito.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/pages/login/login.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/utils/util.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final prefs = new Preferencias();

List<Widget> acordionDinamico(BuildContext context) {
  ProductViewModel productViewModel = Get.find();

  final controller = Get.find<SuggestedOrderViewModel>();
  final listViewModel = Get.find<MyListsViewModel>();

  List<Widget> lista = [];

  lista.clear();

  controller.listaProductosPorFabricante.forEach((fabricante, value) {
    RxBool isSelected = value['isSelected'];
    bool isFrecuencia = prefs.paisUsuario == 'CR'
        ? productViewModel.validarFrecuencia(fabricante)
        : true;
    lista.add(
      Obx(
        () => Container(
            child: AcordionMisListas(
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
          urlIcon: controller.listaProductosPorFabricante[fabricante]["imagen"],
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
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: Get.width * 0.15),
                          child: BotonAgregarCarrito(
                            color: isFrecuencia
                                ? ConstantesColores.azul_aguamarina_botones
                                : ConstantesColores.gris_sku,
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
                          ),
                        ),
                        TextButton(
                            onPressed: () async {
                              await listViewModel.getMisListas();
                              _addToList(
                                  value["items"], productViewModel, context);
                            },
                            child: Text(
                              "Agregar a mis listas",
                              style: TextStyle(
                                  color: ConstantesColores.azul_precio,
                                  fontSize: 15,
                                  decoration: TextDecoration.underline),
                            ))
                      ],
                    ),
                  ],
                )
              ],
            )),
          ),
          checkBox: Checkbox(
            shape: OutlinedBorder.lerp(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                1)!,
            checkColor: ConstantesColores.azul_precio,
            activeColor: ConstantesColores.azul_precio,
            value: isSelected.value,
            onChanged: (_) {
              isSelected.value = !isSelected.value;
              controller.listaProductosPorFabricante[fabricante]["isSelected"]
                  .value = isSelected.value;
              value['items'].forEach((SuggestedOrderModel producto) {
                producto.isSelected = controller
                    .listaProductosPorFabricante[fabricante]["isSelected"]
                    .value;
                if (producto.isSelected!) {
                  controller.listaProductosPorFabricante[fabricante]
                          ["precioProductos"] +=
                      producto.precio! * producto.cantidad!;
                } else {
                  controller.listaProductosPorFabricante[fabricante]
                      ["precioProductos"] = 0.0;
                }
              });
            },
          ),
        )),
      ),
    );
  });
  return lista;
}

_validarFrecuencia(isFrecuencia, value, controller,
    ProductViewModel productViewModel, context) async {
  if (prefs.usurioLogin == 1) {
    final db = ProductoRepositorySqlite();
    if (isFrecuencia) {
      value.forEach((prod) async {
        if (prod.isSelected) {
          Product producto = await db.consultarDatosProducto(prod.codigo);
          controller.llenarCarrito(producto, prod.cantidad, context);
        }
      });
    } else {
      productViewModel.iniciarModal(context, value[0].negocio);
    }
  } else {
    Get.off(Login());
  }
}

_addToList(value, ProductViewModel productViewModel, context) async {
  final db = ProductoRepositorySqlite();
  final cargoConfirmar = Get.find<CambioEstadoProductos>();
  List<Product> listProductsToAdList = [];
  value.forEach((prod) async {
    if (prod.isSelected) {
      Product producto = await db.consultarDatosProducto(prod.codigo);
      listProductsToAdList.add(producto);
    }
  });
  showDialog(
      context: context,
      builder: (context) => PopUpChooseList(
            productos: listProductsToAdList,
            cantidad: toInt(cargoConfirmar.controllerCantidadProducto.value),
          ));
}
