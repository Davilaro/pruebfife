import 'package:emart/_pideky/presentation/mis_pagos_nequi/view_model/mis_pagos_nequi_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/widgets/acordion.dart';
import '../../../../../src/preferences/cont_colores.dart';
import 'lista_pagos_pendientes.dart';

class AcordionPagosPendientes extends StatelessWidget {
  const AcordionPagosPendientes({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MisPagosNequiViewModel>();
    return Acordion(
        section: "MisPagosNequi",
        sectionName: "pagosPendientes",
        elevation: 0,
        margin: 0,
        title: Text(
          "Pagos Pendientes",
          style: TextStyle(
              color: ConstantesColores.gris_oscuro,
              fontWeight: FontWeight.w600,
              fontSize: 18),
        ),
        contenido: Obx(() => controller.listaPagosPendientes.isNotEmpty
            ? Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Fecha Aproximada",
                            style: TextStyle(
                                color: ConstantesColores.azul_precio,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          ...listaPagosPendientesFecha(context)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Valor a Consignar",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: ConstantesColores.azul_precio,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          ...listaPagosPendientesValor(context)
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Container()));
  }
}
