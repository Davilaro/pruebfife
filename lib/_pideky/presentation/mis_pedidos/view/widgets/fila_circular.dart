import 'package:auto_size_text/auto_size_text.dart';
import 'package:emart/generated/l10n.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilaCircular extends StatelessWidget {
  final String titulo;
  final bool isActivo;
  FilaCircular({required this.titulo, required this.isActivo});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //Borde externo
          Expanded(
            flex: 1,
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color.fromARGB(255, 147, 145, 145),
                    width: 1,
                  ),
                ),
                child: FittedBox(
                    fit: BoxFit.contain,
                    //color interno
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActivo
                            ? ConstantesColores.agua_marina
                            : Colors.transparent,
                      ),
                      padding: EdgeInsets.all(50),
                    ))),
          ),
          Expanded(
            flex: 3,
            child: Container(
              child: AutoSizeText(
                titulo,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 15,
                    color: ConstantesColores.azul_precio,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Visibility(
              visible: titulo == 'Pedido recibido',
              child: Container(
                height: Get.height * 0.08,
                padding: EdgeInsets.only(left: 32),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: new AssetImage('assets/image/burbuja_texto.png'),
                      fit: BoxFit.fill),
                ),
                child: AutoSizeText(
                  S.current.your_order_is_being_prepared,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: ConstantesColores.azul_precio, fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
