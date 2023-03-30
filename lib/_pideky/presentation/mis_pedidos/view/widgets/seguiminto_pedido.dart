import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/_pideky/domain/mis_pedidos/model/seguimiento_pedido.dart';
import 'package:emart/_pideky/presentation/mis_pedidos/view_model/mis_pedidos_view_model.dart';
import 'package:emart/_pideky/presentation/productos/view_model/producto_view_model.dart';
import 'package:emart/shared/widgets/boton_agregar_carrito.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:emart/src/widget/soporte.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class SeguimientoPedidoPage extends StatelessWidget {
  final SeguimientoPedido pedido;
  SeguimientoPedidoPage({Key? key, required this.pedido}) : super(key: key);
  final misPedidosViewModel = Get.find<MisPedidosViewModel>();
  final ProductoViewModel productViewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    RxInt _index = 0.obs;

    return Scaffold(
        backgroundColor: HexColor('#eeeeee'),
        appBar: AppBar(
          // backgroundColor: Colors.red,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios,
                color: ConstantesColores.agua_marina),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Seguiminto del pedido',
            style: TextStyle(
                color: ConstantesColores.azul_precio,
                fontWeight: FontWeight.bold),
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            child: Card(
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 10),
              // elevation: widget.elevation,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 15, bottom: 15, left: 12, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Table(
                      columnWidths: {
                        0: FlexColumnWidth(0.25),
                        2: FractionColumnWidth(.32)
                      },
                      children: [
                        TableRow(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 5),
                              child: CachedNetworkImage(
                                height: Get.height * 0.05,
                                imageUrl: pedido.icoFabricante!,
                                placeholder: (context, url) =>
                                    Image.asset('assets/image/jar-loading.gif'),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  'assets/image/logo_login.png',
                                  width: Get.width * 0.02,
                                ),
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: AutoSizeText(
                                "Pedido #${pedido.consecutivo}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: ConstantesColores.azul_precio),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 3,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  AutoSizeText(
                                    productViewModel.getCurrency(pedido.precio),
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: ConstantesColores.azul_precio,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  AutoSizeText(
                                    '${pedido.fechaServidor} ${misPedidosViewModel.tranformarHora(pedido.horaTrans.toString())}',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: ConstantesColores.gris_textos,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RowCirculo(),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Dash(
                              direction: Axis.vertical,
                              length: 70,
                              dashLength: 5,
                              dashColor: ConstantesColores.agua_marina),
                        ),
                        RowCirculo(),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Dash(
                              direction: Axis.vertical,
                              length: 70,
                              dashLength: 5,
                              dashColor: ConstantesColores.agua_marina),
                        ),
                        RowCirculo(),
                        Container(
                          margin:
                              EdgeInsets.symmetric(vertical: Get.height * 0.1),
                          child: BotonAgregarCarrito(
                              height: Get.height * 0.06,
                              borderRadio: 30,
                              color: ConstantesColores.agua_marina,
                              onTap: () {
                                //UXCam: Llamamos el evento selectSoport
                                UxcamTagueo().selectSoport('Reportar novedad');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Soporte(
                                            numEmpresa: 1,
                                          )),
                                );
                              },
                              text: 'Reportat novedad'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  RowCirculo() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
      child: Row(
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
                        color: ConstantesColores.agua_marina,
                      ),
                      padding: EdgeInsets.all(50),
                    ))),
          ),
          Expanded(
            flex: 3,
            child: Container(
              child: AutoSizeText(
                'Pedido recibido',
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
            child: Container(
              child: AutoSizeText(
                'Producto',
                maxLines: 1,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 13,
                  color: ConstantesColores.gris_textos,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.red,
              child: Container(
                // height: Get.height * 0.2,
                // width: Get.width * 0.2,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: new AssetImage('assets/icon/icon.png'),
                      fit: BoxFit.fill),
                ),
                child: AutoSizeText(
                    'hola ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
