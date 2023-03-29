import 'package:auto_size_text/auto_size_text.dart';
import 'package:emart/_pideky/domain/mis_pedidos/model/historico.dart';
import 'package:emart/_pideky/presentation/mis_pedidos/view/widgets/detalle_pedido.dart';
import 'package:emart/_pideky/presentation/mis_pedidos/view_model/mis_pedidos_view_model.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class ContainerAcordion extends StatelessWidget {
  final Historico historico;
  final bool isVisibleSeparador;
  ContainerAcordion({required this.historico, this.isVisibleSeparador = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            padding: EdgeInsets.only(left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //Imagen
                Container(
                  margin: EdgeInsets.only(right: 5),
                  child: CachedNetworkImage(
                    height: Get.height * 0.05,
                    imageUrl: historico.icoFabricante!,
                    placeholder: (context, url) =>
                        Image.asset('assets/image/jar-loading.gif'),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/image/logo_login.png',
                      width: Get.width * 0.02,
                    ),
                    fit: BoxFit.scaleDown,
                  ),
                ),
                //message: No.pedido
                Container(
                  width: Get.width * 0.42,
                  margin: EdgeInsets.only(left: 10),
                  child: AutoSizeText(
                    'No.pedido ${historico.ordenCompra.toString()}',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: ConstantesColores.azul_precio),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 3,
          ),
          //message: Ver detalle
          Container(
              width: Get.width * 0.25,
              child: TextButton(
                  onPressed: () =>
                      Get.to(() => DetallePedidoPage(historico: historico)),
                  child: Text(
                    'Ver detalle',
                    style: TextStyle(
                        color: ConstantesColores.agua_marina,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  )))
        ]),
        Visibility(visible: isVisibleSeparador, child: _separador())
      ],
    );
  }

  Widget _separador() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      width: Get.width * 0.8,
      padding: EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: HexColor("#EAE8F5"),
            width: 0.5,
          ),
        ),
      ),
    );
  }
}
