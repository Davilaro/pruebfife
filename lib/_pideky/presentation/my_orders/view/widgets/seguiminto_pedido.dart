import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/_pideky/domain/my_orders/model/order_tracking.dart';
import 'package:emart/_pideky/presentation/my_orders/view/widgets/fila_circular.dart';
import 'package:emart/_pideky/presentation/my_orders/view_model/mis_pedidos_view_model.dart';
import 'package:emart/_pideky/presentation/product/view_model/product_view_model.dart';
import 'package:emart/generated/l10n.dart';
import 'package:emart/shared/widgets/boton_agregar_carrito.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:emart/src/widget/soporte.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class SeguimientoPedidoPage extends StatelessWidget {
  final List<OrderTracking> listPedido;
  SeguimientoPedidoPage({Key? key, required this.listPedido}) : super(key: key);
  final misPedidosViewModel = Get.find<MyOrdersViewModel>();
  final ProductViewModel productViewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    //Se define el nombre de la pantalla para UXCAM
    FlutterUxcam.tagScreenName('OrdertrackingPage');
    return Scaffold(
        backgroundColor: HexColor('#eeeeee'),
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios,
                color: ConstantesColores.agua_marina),
            onPressed: () => Get.back(),
          ),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: ConstantesColores.color_fondo_gris,
            statusBarIconBrightness: Brightness.dark,
          ),
          title: Text(
            'Seguimiento del pedido',
            style: TextStyle(
                color: ConstantesColores.azul_precio,
                fontWeight: FontWeight.bold),
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                child: Card(
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 10),
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
                                    imageUrl:
                                        listPedido[0].icoFabricante.toString(),
                                    placeholder: (context, url) => Image.asset(
                                        'assets/image/jar-loading.gif'),
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
                                    "Pedido #${listPedido[0].consecutivo}",
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
                                        productViewModel.getCurrency(
                                            misPedidosViewModel
                                                .calculaTotalSeguimiento(
                                                    listPedido)),
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            fontSize: 17,
                                            color:
                                                ConstantesColores.azul_precio,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      AutoSizeText(
                                        '${listPedido[0].fechaServidor} ${misPedidosViewModel.tranformarHora(listPedido[0].horaTrans.toString())}',
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
                            Container(
                                margin: EdgeInsets.only(top: 30, bottom: 10),
                                child: FilaCircular(
                                    titulo: 'Pedido recibido',
                                    subTitulo:
                                        S.current.our_system_has_received,
                                    isActivo: listPedido[0].estado! >= 1,
                                    isActivoText: listPedido[0].estado == 1)),
                            Container(
                              width: Get.width * 0.09,
                              child: Dash(
                                  direction: Axis.vertical,
                                  length: 70,
                                  dashLength: 5,
                                  dashColor: ConstantesColores.agua_marina),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: FilaCircular(
                                  titulo: 'Pedido en proceso',
                                  subTitulo: S.current.your_order_checked,
                                  isActivo: listPedido[0].estado! >= 2,
                                  isActivoText: listPedido[0].estado == 2),
                            ),
                            Container(
                              width: Get.width * 0.09,
                              child: Dash(
                                  direction: Axis.vertical,
                                  length: 70,
                                  dashLength: 5,
                                  dashColor: ConstantesColores.agua_marina),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: FilaCircular(
                                  titulo: 'Pedido en tránsito',
                                  subTitulo: S.current.your_order_is_ready,
                                  isActivo: listPedido[0].estado! == 3,
                                  isActivoText: listPedido[0].estado == 3),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 40),
                              child: BotonAgregarCarrito(
                                  height: Get.height * 0.06,
                                  borderRadio: 30,
                                  color: ConstantesColores.agua_marina,
                                  onTap: () {
                                    //UXCam: Llamamos el evento selectSoport
                                    UxcamTagueo()
                                        .selectSoport('Reportar novedad');
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Soporte(
                                                numEmpresa: 1,
                                              )),
                                    );
                                  },
                                  text: 'Reportar novedad'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                child: Column(
                  children: [
                    AutoSizeText(
                      S.current.order_detail,
                      style: TextStyle(
                          color: ConstantesColores.azul_precio,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Card(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: AutoSizeText(
                                      '#',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: ConstantesColores.gris_textos,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    child: AutoSizeText(
                                      'SKU',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: ConstantesColores.gris_textos,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    child: AutoSizeText(
                                      S.current.product,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: ConstantesColores.gris_textos,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    child: AutoSizeText(
                                      S.current.quantity,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: ConstantesColores.gris_textos,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    child: AutoSizeText(
                                      S.current.price,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: ConstantesColores.gris_textos,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            for (int i = 0; i < listPedido.length; i++)
                              Container(
                                color: Color.fromARGB(20, 186, 183, 183),
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        child: AutoSizeText(
                                          '${i + 1}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color:
                                                ConstantesColores.gris_textos,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        padding: EdgeInsets.only(right: 2),
                                        child: AutoSizeText(
                                          listPedido[i]
                                              .codigoProducto
                                              .toString(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color:
                                                ConstantesColores.gris_textos,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        child: AutoSizeText(
                                          listPedido[i]
                                              .nombreProducto
                                              .toString(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color:
                                                ConstantesColores.gris_textos,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: AutoSizeText(
                                          listPedido[i].cantidad.toString(),
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color:
                                                ConstantesColores.gris_textos,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: AutoSizeText(
                                          productViewModel.getCurrency(
                                              listPedido[i].precio! *
                                                  listPedido[i].cantidad!),
                                          textAlign: TextAlign.left,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color:
                                                ConstantesColores.gris_textos,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
