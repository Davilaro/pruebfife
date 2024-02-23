// ignore_for_file: unrelated_type_equality_checks

import 'package:emart/shared/widgets/drawer_sucursales.dart';
import 'package:emart/src/controllers/validations_forms.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomCardSucursales extends StatelessWidget {
  const CustomCardSucursales({
    Key? key,
    required this.nombre,
    required this.barrio,
    required this.telefono,
    required this.direccion,
    required this.razonSocial,
    required this.ciudad,
    required this.onTap,
  }) : super(key: key);

  final String nombre;
  final String barrio;
  final String telefono;
  final String direccion;
  final String razonSocial;
  final String ciudad;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final _validationForm = Get.find<ValidationForms>();
    return Obx(
      () => GestureDetector(
        onTap: onTap,
        child: Card(
          color: _validationForm.seleccionSucursal.value == razonSocial
              ? ConstantesColores.azul_precio
              : Colors.white,
          shape: ShapeBorder.lerp(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              1),
          child: Container(
            width: Get.width,
            child: Row(
              children: [
                Container(
                    padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
                    width: Get.width * 0.6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          razonSocial,
                          style: TextStyle(
                              color: _validationForm.seleccionSucursal ==
                                      razonSocial
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 16),
                        ),
                        Text(
                          "Nombre: $nombre",
                          style: desingSucursales(razonSocial,
                              _validationForm.seleccionSucursal.value),
                        ),
                        Text(
                          "Telefono: $telefono",
                          style: desingSucursales(razonSocial,
                              _validationForm.seleccionSucursal.value),
                        ),
                        Text(
                          "Dirección: $direccion",
                          style: desingSucursales(razonSocial,
                              _validationForm.seleccionSucursal.value),
                        ),
                        Text(
                          prefs.paisUsuario == "CR" ?"Distrito: $barrio" : "Barrio: $barrio",
                          style: desingSucursales(razonSocial,
                              _validationForm.seleccionSucursal.value),
                        ),
                        Text(
                          "Ciudad: $ciudad",
                          style: desingSucursales(razonSocial,
                              _validationForm.seleccionSucursal.value),
                        ),
                      ],
                    )),
                Container(
                  width: Get.width * 0.2,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow_rounded,
                      size: 44,
                      color:
                          _validationForm.seleccionSucursal.value == razonSocial
                              ? Colors.white
                              : ConstantesColores.azul_precio,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextStyle desingSucursales(dynamic element, seleccion) => TextStyle(
      fontSize: 15, color: seleccion == element ? Colors.white : Colors.black);
}
