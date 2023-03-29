import 'package:auto_size_text/auto_size_text.dart';
import 'package:emart/_pideky/presentation/mis_pedidos/view_model/mis_pedidos_view_model.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AcordionMisPedidos extends StatelessWidget {
  final Widget contend;
  final String? titulo;
  final String? supTitulo;
  final String? precio;
  final String? fecha;
  AcordionMisPedidos(
      {required this.contend,
      this.titulo = '',
      this.supTitulo = '',
      this.precio = '',
      this.fecha = ''});

  final MisPedidosViewModel misPedidosViewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    RxBool _mostrarContenido = false.obs;
    ejecutarOnPress() => _mostrarContenido.value = !_mostrarContenido.value;

    return Container(
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 10),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 15, bottom: 15, left: 5, right: 12),
          child: Column(
            children: [
              GestureDetector(
                onTap: ejecutarOnPress,
                child: Table(
                  columnWidths: {
                    0: FlexColumnWidth(0.25),
                    2: FractionColumnWidth(.32)
                  },
                  children: [
                    TableRow(
                      children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.fill,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            alignment: Alignment.topLeft,
                            icon: Icon(
                              _mostrarContenido.value
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: 35,
                            ),
                            color: ConstantesColores.agua_marina,
                            onPressed: ejecutarOnPress,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: AutoSizeText(
                            titulo.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: ConstantesColores.azul_precio),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 3,
                          ),
                          child: AutoSizeText(
                            precio.toString(),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 15,
                                color: ConstantesColores.azul_precio,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Container(),
                        AutoSizeText(
                          supTitulo.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: ConstantesColores.azul_precio),
                        ),
                        AutoSizeText(
                          fecha.toString(),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 13,
                            color: ConstantesColores.gris_textos,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Obx(() => _mostrarContenido.value
                  ? Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Container(
                        child: contend,
                      ),
                    )
                  : Container())
            ],
          ),
        ),
      ),
    );
  }
}
