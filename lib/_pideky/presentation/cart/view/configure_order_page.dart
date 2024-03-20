import 'package:emart/_pideky/presentation/cart/view_model/configure_order_view_model.dart';
import 'package:emart/_pideky/presentation/cart/widgets/confirm_order_button.dart';
import 'package:emart/_pideky/presentation/product/view_model/product_view_model.dart';
import 'package:emart/src/controllers/state_controller_radio_buttons.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/_pideky/presentation/cart/view_model/cart_view_model.dart';
import 'package:emart/src/provider/db_provider_helper.dart';
import 'package:emart/src/widget/simple_card.dart';
import 'package:emart/src/widget/simple_card_condiciones_entrega.dart';
import 'package:emart/src/widget/simple_card_groups.dart';
import 'package:emart/src/widget/simple_card_one.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';

class ConfigurarPedido extends StatefulWidget {
  final int numEmpresa;
  const ConfigurarPedido({Key? key, required this.numEmpresa})
      : super(key: key);

  @override
  _ConfigurarPedidoState createState() => _ConfigurarPedidoState();
}

class _ConfigurarPedidoState extends State<ConfigurarPedido> {
  final prefs = new Preferencias();
  ProductViewModel productoViewModel = Get.find();
  final controller = Get.put(StateControllerRadioButtons());
  final configureOrderViewModel = Get.put(ConfigureOrderViewModel());
  late ProgressDialog pr;
  late BuildContext _context2;
  late CartViewModel cartProvider;

  @override
  Widget build(BuildContext context) {
    configureOrderViewModel.numEmpresa.value = widget.numEmpresa;
    //UXCAM: Se define el nombre de la pantalla
    FlutterUxcam.tagScreenName('ConfirmOrderPage');
    cartProvider = Provider.of<CartViewModel>(context);
    final size = MediaQuery.of(context).size;
    var locale = Intl().locale;
    var format = locale.toString() != 'es_CO'
        ? locale.toString() == 'es_CR'
            ? NumberFormat.currency(locale: locale.toString(), symbol: '\₡')
            : NumberFormat.simpleCurrency(locale: locale.toString())
        : NumberFormat.currency(locale: locale.toString(), symbol: '\$');
    _context2 = context;

    return Scaffold(
        appBar: AppBar(
          title: Text('Verifica tu pedido',
              style: TextStyle(
                  color: HexColor("#43398E"), fontWeight: FontWeight.bold)),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: ConstantesColores.color_fondo_gris,
            statusBarIconBrightness: Brightness.dark,
          ),
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back_ios, color: HexColor("#30C3A3")),
              onPressed: () {
                controller.cashPayment.value = false;
                controller.payOnLine.value = false;
                controller.isPayOnLine.value = false;
                Navigator.of(context).pop();
              }),
          elevation: 0,
        ),
        body: Container(
          margin: EdgeInsets.only(top: 14),
          child: Center(
            child: Container(
              width: size.width * 0.9,
              child: ListView(
                children: [
                  FutureBuilder(
                    future: DBProviderHelper.db.consultarDatosCliente(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<dynamic>> snapshot) {
                      if (snapshot.hasData) {
                        var data = snapshot.data;
                        return Column(
                          children: [
                            for (int i = 0; i < data!.length; i++)
                              Column(
                                children: [
                                  SimpleCard(
                                      texto: "Dirección de entrega",
                                      ciudad: data[i].ciudad,
                                      direccion: data[i].direccion,
                                      razonsocial: data[i].razonsocial),
                                  SimpleCardCondicionesEntrega(
                                      texto: "Condiciones de entrega",
                                      referencia: "Solo en el domicilio"),
                                  SimpleCardOne(
                                      texto: "Forma de Pago",
                                      referencia: data[i].condicionPago),
                                  SimpleCardGroups(texto: "Total a facturar"),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: configureOrderViewModel.total(
                                        size, cartProvider, format),
                                  ),
                                  SizedBox(height: 50),
                                  botonGrandeConfigurar(
                                      size, context, _context2)
                                ],
                              )
                          ],
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
