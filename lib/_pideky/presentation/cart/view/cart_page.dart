// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:emart/_pideky/presentation/cart/widgets/expanded_shopping_cart_panel.dart';
import 'package:emart/_pideky/presentation/product/view_model/product_view_model.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/controllers/slide_up_automatic.dart';
import 'package:emart/src/controllers/state_controller_radio_buttons.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/metodo_ingresados.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/_pideky/presentation/cart/view_model/cart_view_model.dart';
import 'package:emart/src/utils/alertas.dart';
import 'package:emart/src/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

final prefs = new Preferencias();
RxBool isValid = false.obs;
//late CarroModelo cartProvider;

class CartPage extends StatefulWidget {
  final int numEmpresa;

  const CartPage({Key? key, required this.numEmpresa}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final cargoConfirmar = Get.find<CambioEstadoProductos>();
  ProductViewModel productoViewModel = Get.find();
  late final cartViewModel = Provider.of<CartViewModel>(context);
  final controller = Get.put(StateControllerRadioButtons());
  final slideUpAutomatic = Get.find<SlideUpAutomatic>();

  @override
  void initState() {
    super.initState();
    //UXCAM: Se define el nombre de la interfaz
    FlutterUxcam.tagScreenName('ShoppingCart');
    PedidoEmart.iniciarProductosPorFabricante();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MetodosLLenarValores().calcularValorTotal(cartViewModel);
    });
  }

  updateStateSendingAsParameter() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    cartViewModel.loadAgain = false;
    //UXCAM: Se define el nombre de la pantalla
    FlutterUxcam.tagScreenName('ShoppingCartPage');

    final size = MediaQuery.of(context).size;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: ConstantesColores.color_fondo_gris,
        appBar: AppBar(
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back_ios, color: HexColor("#30C3A3")),
              onPressed: () => {
                    PedidoEmart.cambioVista.value = 1,
                    cartViewModel.guardarCambiodevista = 1,
                    Navigator.of(context).pop()
                  }),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20, top: 10),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0)),
                    child: GestureDetector(
                      onTap: () => {
                        controller.cashPayment.value = false,
                        controller.payOnLine.value = false,
                        prefs.typeCollaborator != "2"
                            ? cartViewModel.configurarPedido(
                                size,
                                cartViewModel,
                                prefs,
                                context,
                                updateStateSendingAsParameter)
                            : mostrarAlert(
                                context,
                                "No puedes realizar pedidos ya que te encuentras en modo colaborador",
                                null)
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: prefs.typeCollaborator != "2"
                              ? HexColor("#42B39C")
                              : ConstantesColores.gris_sku,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        height: Get.height * 0.08,
                        width: Get.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Realizar pedido',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: cartViewModel.getNuevoTotalAhorro != 0.0
                      ? Get.height * 0.21
                      : Get.height * 0.12,
                  child: Container(
                    width: Get.width,
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                            'Total: ${productoViewModel.getCurrency(cartViewModel.getTotal)}',
                            style: TextStyle(
                                fontSize: 17.0,
                                color: HexColor("#43398E"),
                                fontWeight: FontWeight.w500)),
                        Visibility(
                          visible: cartViewModel.getNuevoTotalAhorro == 0.0
                              ? false
                              : true,
                          child: Container(
                            padding: EdgeInsets.only(top: 5),
                            width: Get.width * 0.8,
                            height: Get.height * 0.099,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              color: ConstantesColores.azul_precio,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Container(
                                    width: 45.0,
                                    height: 45.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: ConstantesColores
                                          .azul_aguamarina_botones,
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        'assets/icon/Icono_valor_ahorrado.png',
                                        fit: BoxFit.cover,
                                        width: 30,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Expanded(
                                    child: Stack(children: [
                                      Positioned(
                                        right: -5,
                                        bottom: -30,
                                        child: Image.asset(
                                          'assets/icon/Icono_marca_de_agua.png',
                                          width: 100.0,
                                          height: 100.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'El total ahorrado en estos pedidos es:',
                                            style: TextStyle(
                                                fontSize: 13.5,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "${getCurrency(cartViewModel.getNuevoTotalAhorro)}",
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                            'Estos productos serán entregados según el itinerario del proveedor',
                            style: TextStyle(fontSize: 15.0)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    height: Get.height * 0.8,
                    child: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: loadDynamicExpansionPanel(
                                  context,
                                  cartViewModel,
                                  cartViewModel.loadAgain,
                                  updateStateSendingAsParameter,
                                  isValid)
                              .toList()),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
