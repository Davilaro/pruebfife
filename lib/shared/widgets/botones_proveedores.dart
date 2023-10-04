// ignore_for_file: unrelated_type_equality_checks

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/src/pages/catalogo/view_model/botones_proveedores_vm.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/utils/alertas.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BotonesProveedores extends StatelessWidget {
  final int idTab;

  BotonesProveedores({
    Key? key,
    required this.idTab,
  }) : super(key: key);

  final botonesProveedoresVm = Get.put(BotonesProveedoresVm());
  final prefs = Preferencias();

  @override
  Widget build(BuildContext context) {
    botonesProveedoresVm.cargarSeleccionados();

    return SizedBox(
        height: Get.height * 0.09,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: botonesProveedoresVm.listaFabricante.length,
          itemBuilder: (context, index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (botonesProveedoresVm
                            .listaFabricante[index].bloqueoCartera ==
                        1) {
                      mostrarAlertCartera(
                        context,
                        "Este producto no se encuentra disponible. Revisa el estado de tu cartera para poder comprar.",
                        null,
                      );
                    } else {
                      // Si el botón no está seleccionado, se verifica si hay menos de dos botones botonesProveedoresVm.seleccionados

                      if (!botonesProveedoresVm.seleccionados[index]) {
                      
                        for (var i = 0;
                            i < botonesProveedoresVm.seleccionados.length;
                            i++) {
                          botonesProveedoresVm.seleccionados[i] = (index == i);
                        }

                        botonesProveedoresVm.seleccionados[index] = true;

                        botonesProveedoresVm.listaProveedores.value = [];

                        botonesProveedoresVm.listaProveedores.addIf(
                            !botonesProveedoresVm.listaProveedores.contains(
                                botonesProveedoresVm
                                    .listaFabricante[index].empresa),
                            botonesProveedoresVm
                                .listaFabricante[index].empresa);
                      }
                      botonesProveedoresVm.cargarLista(idTab);
                    }
                    botonesProveedoresVm.esBuscadoTodos.value = false;
                  },
                  child: Obx(
                    () => Stack(
                      children: [
                        Container(
                          width: Get.width * 0.2,
                          margin: EdgeInsets.fromLTRB(5, 2, 5, 5),
                          padding: EdgeInsets.all(
                            prefs.paisUsuario == 'CO' ? 10 : 12,
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: botonesProveedoresVm.seleccionados[index]
                                  ? ConstantesColores.azul_precio
                                  : Colors.transparent,
                              width: 2,
                            ),
                            color: Colors.white,
                          ),
                          child: Container(
                            //color: Colors.amber,
                            padding: EdgeInsets.only(
                              top: Get.height * 0.002,
                            ),
                            child: CachedNetworkImage(
                              imageUrl: botonesProveedoresVm
                                  .listaFabricante[index].icono!,
                              alignment: Alignment.bottomCenter,
                              errorWidget: (context, url, error) => Image.asset(
                                'assets/icon/cerrar_ventana.png',
                                alignment: Alignment.center,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: botonesProveedoresVm
                                      .listaFabricante[index].bloqueoCartera ==
                                  1
                              ? true
                              : false,
                          child: Container(
                            width: Get.width * 0.2,
                            margin: EdgeInsets.fromLTRB(5, 2, 5, 5),
                            padding: EdgeInsets.all(
                                prefs.paisUsuario == 'CO' ? 10 : 12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ));
  }
}
