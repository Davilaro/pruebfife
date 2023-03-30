import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/_pideky/domain/mis_pedidos/model/seguimiento_pedido.dart';
import 'package:emart/_pideky/presentation/mis_pedidos/view_model/mis_pedidos_view_model.dart';
import 'package:emart/_pideky/presentation/productos/view_model/producto_view_model.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
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
        body: Container(
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
                              imageUrl: pedido.icoFabricante!,
                              placeholder: (context, url) =>
                                  Image.asset('assets/image/jar-loading.gif'),
                              errorWidget: (context, url, error) => Image.asset(
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
                  Obx(() => Stepper(
                        currentStep: _index.value,
                        // onStepCancel: () {
                        //   if (_index > 0) {
                        //     _index.value -= 1;
                        //   }
                        // },
                        // onStepContinue: () {
                        //   if (_index <= 0) {
                        //     _index.value += 1;
                        //   }
                        // },
                        // onStepTapped: (int index) {
                        //   _index.value = index;
                        // },
                        steps: <Step>[
                          Step(
                            title: new Text('Account'),
                            content: Column(
                              children: <Widget>[
                                TextFormField(
                                  decoration: InputDecoration(
                                      labelText: 'Email Address'),
                                ),
                                TextFormField(
                                  decoration:
                                      InputDecoration(labelText: 'Password'),
                                ),
                              ],
                            ),
                            isActive: _index >= 0,
                            state: _index >= 0
                                ? StepState.complete
                                : StepState.disabled,
                          ),
                          Step(
                            title: Text('Pedido en proceso'),
                            content: Text(''),
                          ),
                          Step(
                            title: Text('Pedido en tránsito'),
                            content: Text(''),
                          ),
                        ],
                      )),
                  // for (int i = 0; i < detalles!.length; i++)
                  //   Container(
                  //     color: Color.fromARGB(20, 186, 183, 183),
                  //     margin: EdgeInsets.only(top: 10),
                  //     padding:
                  //         EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Container(
                  //           margin: EdgeInsets.symmetric(horizontal: 5),
                  //           child: AutoSizeText(
                  //             '${i + 1}',
                  //             textAlign: TextAlign.left,
                  //             style: TextStyle(
                  //               fontSize: 13,
                  //               color: ConstantesColores.gris_textos,
                  //             ),
                  //           ),
                  //         ),
                  //         Expanded(
                  //           flex: 2,
                  //           child: Container(
                  //             child: AutoSizeText(
                  //               detalles[i].codigoRef,
                  //               textAlign: TextAlign.left,
                  //               style: TextStyle(
                  //                 fontSize: 12,
                  //                 color: ConstantesColores.gris_textos,
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //         Expanded(
                  //           flex: 3,
                  //           child: Container(
                  //             child: AutoSizeText(
                  //               detalles[i].nombreProducto,
                  //               textAlign: TextAlign.left,
                  //               style: TextStyle(
                  //                 fontSize: 13,
                  //                 color: ConstantesColores.gris_textos,
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //         Expanded(
                  //           flex: 1,
                  //           child: Container(
                  //             child: AutoSizeText(
                  //               detalles[i].cantidad.toString(),
                  //               textAlign: TextAlign.left,
                  //               style: TextStyle(
                  //                 fontSize: 13,
                  //                 color: ConstantesColores.gris_textos,
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //         Expanded(
                  //           flex: 2,
                  //           child: Container(
                  //             child: AutoSizeText(
                  //               productViewModel
                  //                   .getCurrency(detalles[i].precio),
                  //               textAlign: TextAlign.left,
                  //               style: TextStyle(
                  //                 fontSize: 13,
                  //                 color: ConstantesColores.gris_textos,
                  //               ),
                  //             ),
                  //           ),
                  //         )
                  //       ],
                  //     ),
                  //   )
                ],
              ),
            ),
          ),
        ));
  }
}
