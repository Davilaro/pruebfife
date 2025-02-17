import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/widgets/acordion.dart';
import '../../../../../src/preferences/cont_colores.dart';
import '../../view_model/my_payments_view_model.dart';
import 'lista_pagos_realizados.dart';

class AcordionPagosRealizados extends StatelessWidget {
  const AcordionPagosRealizados({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MyPaymentsViewModel>();
    return Acordion(
        section: "MisPagosNequi",
        sectionName: "pagosRealizados",
        elevation: 0,
        margin: 0,
        title: Text(
          "Pagos Realizados",
          style: TextStyle(
              color: ConstantesColores.gris_oscuro,
              fontWeight: FontWeight.w600,
              fontSize: 18),
        ),
        contenido: Obx(() => controller.listaPagosRealizados.isNotEmpty
            ? Container(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Fecha",
                            style: TextStyle(
                                color: ConstantesColores.azul_precio,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          ...listaPagosRealizadosFecha(context)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Valor Consignado",
                            style: TextStyle(
                                color: ConstantesColores.azul_precio,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          ...listaPagosRealizadosValor(context)
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Container()));
  }
}
