import 'package:auto_size_text/auto_size_text.dart';
import 'package:emart/src/pages/catalogo/view_model/botones_proveedores_vm.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class BotonTodosfiltro extends StatelessWidget {
  final int idTab;
  BotonTodosfiltro({required this.idTab});
  final botonesProveedoresVm = Get.put(BotonesProveedoresVm());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          
          botonesProveedoresVm.esBuscadoTodos.value =
              !botonesProveedoresVm.esBuscadoTodos.value;
          botonesProveedoresVm.proveedor.value = "";
          botonesProveedoresVm.proveedor2.value = "";

          for (int i = 0; i < botonesProveedoresVm.seleccionados.length; i++) {
            botonesProveedoresVm.seleccionados[i] = false;
          }

          botonesProveedoresVm.cargarLista(idTab);
        },
        child: Container(
          height: Get.height * 0.08,
          width: Get.width * 0.2,
          margin: EdgeInsets.fromLTRB(5, 2, 5, 5),
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: botonesProveedoresVm.esBuscadoTodos.value
                  ? ConstantesColores.azul_precio
                  : Colors.transparent,
              width: 2,
            ),
            color: Colors.white,
          ),
          child: Container(
            padding: EdgeInsets.only(
              top: Get.height * 0.009,
            ),
            child: Column(
              children: [
                Container(
                  child: SvgPicture.asset(
                    'assets/icon/Icono_Todos.svg',
                    height: Get.height * 0.032,
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                  ),
                ),
                AutoSizeText('Todos',
                    maxFontSize: 10,
                    style: TextStyle(color: ConstantesColores.azul_precio, fontWeight: FontWeight.bold),
                    minFontSize: 6,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
