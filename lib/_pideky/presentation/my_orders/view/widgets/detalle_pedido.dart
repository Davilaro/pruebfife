import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/_pideky/domain/my_orders/model/historical_model.dart';
import 'package:emart/_pideky/presentation/my_orders/view/widgets/order_details.dart';
import 'package:emart/_pideky/presentation/my_orders/view_model/mis_pedidos_view_model.dart';
import 'package:emart/_pideky/presentation/product/view_model/product_view_model.dart';
import 'package:emart/generated/l10n.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class DetallePedidoPage extends StatelessWidget {
  final HistoricalModel historico;
  DetallePedidoPage({Key? key, required this.historico}) : super(key: key);
  final misPedidosViewModel = Get.find<MyOrdersViewModel>();
  final ProductViewModel productViewModel = Get.find();

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
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ConstantesColores.color_fondo_gris,
          statusBarIconBrightness: Brightness.dark,
        ),
        title: Text(
          S.current.order_detail,
          style: TextStyle(
              color: ConstantesColores.azul_precio,
              fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
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
                  return Text(S.current.no_information_to_display);
                } else if (snapshot.data.isNotEmpty) {
                  List<HistoricalModel>? detalles = snapshot.data;
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                    child: Card(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 15, bottom: 15, left: 12, right: 15),
                        child: Column(
                          children: [
                            Table(
                              columnWidths: {
                                0: FlexColumnWidth(0.25),
                                2: FractionColumnWidth(.35)
                              },
                              children: [
                                TableRow(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 5),
                                      child: CachedNetworkImage(
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
                                        "${S.current.order} #${historico.ordenCompra}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color:
                                                ConstantesColores.azul_precio),
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
                                            productViewModel.getCurrency(
                                                misPedidosViewModel
                                                    .calculaTotalSeguimiento(
                                                        detalles!)),
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: ConstantesColores
                                                    .azul_precio,
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
                            for (int i = 0; i < detalles.length; i++)
                              OrderDetails(detalles: detalles, i: i)
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
            }
          },
        ),
      ),
    );
  }
}


