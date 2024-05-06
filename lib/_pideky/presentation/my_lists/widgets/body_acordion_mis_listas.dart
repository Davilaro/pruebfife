import 'package:emart/_pideky/domain/my_lists/model/detail_list_model.dart';
import 'package:emart/_pideky/presentation/my_lists/view_model/my_lists_view_model.dart';
import 'package:emart/_pideky/presentation/my_lists/widgets/item_acordion_listas.dart';
import 'package:emart/_pideky/presentation/product/view_model/product_view_model.dart';
import 'package:emart/shared/widgets/acordion_mis_listas.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

List createAcordionListas(context, VoidCallback setState) {
  RxList listaProductos = [].obs;
  final misListasViewModel = Get.find<MyListsViewModel>();
  ProductViewModel productViewModel = Get.find();

  misListasViewModel.mapListasProductos.forEach((fabricante, productos) {
    RxBool isSelected = productos['isSelected'];

    if (productos['items'].length != 0) {
      listaProductos
        ..add(Obx(
          () => misListasViewModel.mapListasProductos.isNotEmpty
              ? AcordionMisListas(
                  sectionName:
                      "${misListasViewModel.mapListasProductos[fabricante]["nombrecomercial"]}",
                  elevation: 0,
                  title: Container(
                    width: Get.width / 4,
                    child: Text(
                      misListasViewModel.mapListasProductos[fabricante]
                          ["nombrecomercial"],
                      style: TextStyle(
                          color: ConstantesColores.azul_precio,
                          fontSize: 14,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                  urlIcon: misListasViewModel.mapListasProductos[fabricante]
                      ["imagen"],
                  checkBox: Checkbox(
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
                      misListasViewModel
                          .mapListasProductos[fabricante]["isSelected"]
                          .value = isSelected.value;
                      productos['items'].forEach((DetailList producto) {
                        producto.isSelected = misListasViewModel
                            .mapListasProductos[fabricante]["isSelected"].value;
                        if (producto.isSelected!) {
                          misListasViewModel
                              .mapListasProductos[fabricante]["precioProductos"]
                              .value += producto.precio * producto.cantidad;
                        } else {
                          misListasViewModel
                              .mapListasProductos[fabricante]["precioProductos"]
                              .value = 0.0;
                        }
                      });
                    },
                  ),
                  contenido: SingleChildScrollView(
                    child: Column(
                      children: [
                        Column(
                          children: [
                            ...gridItemLista(
                                context, fabricante, productos['items'], setState),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Divider(color: Colors.grey),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "Total: ${productViewModel.getCurrency(misListasViewModel.mapListasProductos[fabricante]["precioProductos"].value)}",
                                style: TextStyle(
                                    color: ConstantesColores.azul_precio,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ));
    }
  });

  return listaProductos;
}
