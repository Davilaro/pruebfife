import 'dart:math';

import 'package:emart/_pideky/presentation/productos/view_model/producto_view_model.dart';
import 'package:emart/shared/widgets/popups.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/controllers/state_controller_radio_buttons.dart';
import 'package:emart/src/modelos/pedido.dart';
import 'package:emart/src/modelos/validar_pedido.dart';
import 'package:emart/src/pages/carrito/order_notification_page.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:emart/src/provider/db_provider_helper.dart';
import 'package:emart/src/provider/servicios.dart';
import 'package:emart/src/utils/alertas.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:emart/src/widget/pedido_realizado.dart';
import 'package:emart/src/widget/simple_card.dart';
import 'package:emart/src/widget/simple_card_condiciones_entrega.dart';
import 'package:emart/src/widget/simple_card_groups.dart';
import 'package:emart/src/widget/simple_card_one.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  ProductoViewModel productoViewModel = Get.find();
  final controller = Get.put(StateControllerRadioButtons());

  late ProgressDialog pr;
  late BuildContext _context2;
  late CarroModelo cartProvider;

  @override
  Widget build(BuildContext context) {
    //UXCAM: Se define el nombre de la pantalla
    FlutterUxcam.tagScreenName('ConfirmOrderPage');
    cartProvider = Provider.of<CarroModelo>(context);
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
            onPressed: () => Navigator.of(context).pop(),
          ),
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
                                    child: _total(size, cartProvider, format),
                                  ),
                                  SizedBox(height: 50),
                                  _botonGrandeConfigurar(size)
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

  Widget _botonGrandeConfigurar(size) {
    return GestureDetector(
      onTap: () => {
        if(controller.paymentCheckIsVisible.value == false){
            _dialogEnviarPedido(size)

        }else
        if (!controller.cashPayment.value && !controller.payOnLine.value)
          {
            showPopup(
              context,
              'Debes seleccionar un medio de pago',
              SvgPicture.asset('assets/image/Icon_incorrecto.svg'),
            )
          }
        else
          {_dialogEnviarPedido(size),
          controller.cashPayment.value = false,
          controller.payOnLine.value = false
          }
      },
      child: Container(
        width: size.width * 0.9,
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: HexColor("#30C3A3"),
          borderRadius: BorderRadius.circular(20),
        ),
        height: 45,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Confirma tu pedido',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  TextStyle disenoValores() => TextStyle(
      fontSize: 17.0, color: HexColor("#43398E"), fontWeight: FontWeight.bold);

  Widget _total(size, cartProvider, format) {
    return Container(
      child: Container(
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(height: 40.0),
            Text(
                'Total: ${productoViewModel.getCurrency(cartProvider.getTotal)}',
                style: disenoValores()),
            Text(
              '* Este pedido ya tiene incluido los impuestos',
              style: TextStyle(color: ConstantesColores.verde),
            ),
            cartProvider.getTotalAhorro - cartProvider.getTotal == 0
                ? Container()
                : Text(
                    'Estás ahorrando: ${productoViewModel.getCurrency((cartProvider.getTotalAhorro - cartProvider.getTotal))}',
                    style: TextStyle(color: Colors.red[600]),
                  ),
            Divider(height: 40.0),
          ],
        ),
      ),
    );
  }

  _dialogEnviarPedido(size) async {
    final List<Pedido> listaProductosPedidos = [];

    PedidoEmart.listaValoresPedido!.forEach((key, value) {
      if (value == "") {
      } else if (int.parse(value) > 0) {
        String directo = "";

        for (var i = 0; i < PedidoEmart.listaFabricante!.length; i++) {
          if (PedidoEmart.listaFabricante![i].empresa ==
              PedidoEmart.listaProductos![key]!.fabricante) {
            directo = PedidoEmart.listaFabricante![i].tipofabricante;
          }
        }

        Pedido pedidoNuevo = new Pedido(
          cantidad: int.parse(value),
          codigoProducto: key,
          iva: PedidoEmart.listaProductos![key]!.iva,
          precio: PedidoEmart.listaProductos![key]!.precio,
          fabricante: PedidoEmart.listaProductos![key]!.fabricante,
          codigoFabricante: PedidoEmart.listaProductos![key]!.codigoFabricante,
          nitFabricante: PedidoEmart.listaProductos![key]!.nitFabricante,
          codCliente: prefs.codCliente,
          tipoFabricante: directo,
          codProveedor: 1,
          codigocliente: PedidoEmart.listaProductos![key]!.codigocliente,
          nombreProducto: PedidoEmart.listaProductos![key]!.nombre,
          precioInicial: PedidoEmart.listaProductos![key]!.precioinicial,
          descuento: PedidoEmart.listaProductos![key]!.descuento,
        );

        if (PedidoEmart.listaValoresPedidoAgregados![key] == true) {
          listaProductosPedidos.add(pedidoNuevo);
        }
      }
    });

    showLoaderDialog(context, size, _cargandoPedido(context, size), 300);
    await _dialogPedidoRegistrado(listaProductosPedidos, size);
  }

  _dialogPedidoRegistrado(listaProductosPedidos, size) async {
    final controladorCambioEstadoProductos = Get.find<CambioEstadoProductos>();
    DateTime now = DateTime.now();
    String fechaPedido = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    var numeroAleatorio = Random();
    String numDoc = DateFormat('yyyyMMddHHmmssSSS').format(now);
    numDoc += numeroAleatorio.nextInt(1000 - 1).toString();

    ValidarPedido validar = await Servicies().enviarPedido(
        listaProductosPedidos,
        prefs.codClienteLogueado,
        fechaPedido,
        numDoc,
        cartProvider);

    if (validar.estado == 'OK') {
      PedidoEmart.listaValoresPedido!.forEach((key, value) {
        PedidoEmart
            .listaControllersPedido![PedidoEmart.listaProductos![key]!.codigo]!
            .text = "0";
        PedidoEmart.registrarValoresPedido(
            PedidoEmart.listaProductos![key]!, "1", false);
      });

      //FIREBASE: Llamamos el evento purchase
      TagueoFirebase().sendAnalityticsPurchase(
          cartProvider.getTotal, listaProductosPedidos, numDoc);
      //UXCam: Llamamos el evento confirmOrder
      UxcamTagueo().confirmOrder(listaProductosPedidos, cartProvider);
      cartProvider.guardarValorCompra = 0;
      cartProvider.guardarValorAhorro = 0;
      PedidoEmart.cantItems.value = '0';
      controladorCambioEstadoProductos.mapaHistoricos
          .updateAll((key, value) => value = false);
      productoViewModel.eliminarBDTemporal();

      if (controller.isPayOnLine.value) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => OrderNotificationPage(
                  numEmpresa: widget.numEmpresa,
                  numdoc: numDoc,
                )));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => PedidoRealizado(
                numEmpresa: widget.numEmpresa, numdoc: numDoc)));
      }
    } else {
      Navigator.pop(context);
      mostrarAlertaUtilsError(_context2, validar.mensaje!);
    }
  }

  showLoaderDialog(BuildContext context, size, Widget widget, double altura) {
    AlertDialog alert = AlertDialog(
        content: Container(
            height: altura,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.white,
            ),
            child: widget));
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _cargandoPedido(context, size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            height: 300,
            width: size.width * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(36.0),
                        child: Icon(
                          Icons.bus_alert,
                          size: 40,
                          color: HexColor("#30C3A3"),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(2),
                        width: size.width * 0.7,
                        child: Text(
                          "Tu pedido está",
                          style: TextStyle(
                              color: HexColor("#43398E"),
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(2),
                        height: 30,
                        width: size.width * 0.7,
                        child: Text(
                          "siendo procesado...",
                          style: TextStyle(
                              color: HexColor("#43398E"), fontSize: 22),
                          textAlign: TextAlign.left,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ))
      ],
    );
  }
}
