import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/_pideky/domain/mis_pedidos/model/historico.dart';
import 'package:emart/_pideky/presentation/mis_pedidos/view_model/mis_pedidos_view_model.dart';
import 'package:emart/_pideky/presentation/productos/view_model/producto_view_model.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class DetallePedidoPage extends StatelessWidget {
  final Historico historico;
  DetallePedidoPage({Key? key, required this.historico}) : super(key: key);
  final misPedidosViewModel = Get.find<MisPedidosViewModel>();
  final ProductoViewModel productViewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    //Se define el nombre de la pantalla para UXCAM
    FlutterUxcam.tagScreenName('OrderDetailsPage');

    return Scaffold(
      backgroundColor: HexColor('#eeeeee'),
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios,
              color: ConstantesColores.agua_marina),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Detalle del pedido',
          style: TextStyle(
              color: ConstantesColores.azul_precio,
              fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: FutureBuilder(
        initialData: [],
        future: misPedidosViewModel.misPedidosService
            .consultarDetalleGrupoHistorico(historico.numeroDoc.toString(),
                historico.fabricante.toString()),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return Text('No hay informacion para mostrar');
              } else {
                var detalles = snapshot.data;
                return Container(
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
                                      imageUrl: historico.icoFabricante!,
                                      placeholder: (context, url) =>
                                          Image.asset(
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
                                      "Pedido #${historico.ordenCompra}",
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        AutoSizeText(
                                          productViewModel
                                              .getCurrency(historico.precio),
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontSize: 17,
                                              color:
                                                  ConstantesColores.azul_precio,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        AutoSizeText(
                                          '${detalles[0].fechaTrans} ${misPedidosViewModel.tranformarHora(detalles[0].horaTrans.toString())}',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color:
                                                ConstantesColores.gris_textos,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            color: Color.fromARGB(20, 186, 183, 183),
                            margin: EdgeInsets.only(top: 10),
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 5),
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
                                  flex: 2,
                                  child: Container(
                                    child: AutoSizeText(
                                      'Cantidad',
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
                                      'Precio',
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
                          ),
                          for (int i = 0; i < detalles!.length; i++)
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
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      child: AutoSizeText(
                                        '${i + 1}',
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
                                        detalles[i].codigoRef,
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
                                        detalles[i].nombreProducto,
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
                                    flex: 1,
                                    child: Container(
                                      child: AutoSizeText(
                                        detalles[i].cantidad.toString(),
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
                                        productViewModel
                                            .getCurrency(detalles[i].precio),
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
                            )
                        ],
                      ),
                    ),
                  ),
                );
              }
          }
        },
      ),
    );
  }
}
