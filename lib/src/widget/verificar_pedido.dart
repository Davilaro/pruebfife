import 'package:emart/src/modelos/pedido.dart';
import 'package:emart/src/modelos/validar_pedido.dart';
import 'package:emart/src/pages/login/login.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:emart/src/provider/db_provider_helper.dart';
import 'package:emart/src/provider/servicios.dart';
import 'package:emart/src/utils/alertas.dart';
import 'package:emart/src/widget/simple_card_condiciones_entrega.dart';
import 'package:emart/src/widget/simple_card_not_expand.dart';
import 'package:emart/src/widget/simple_card_one_not_expand.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

final prefs = new Preferencias();
NumberFormat formatNumber = new NumberFormat("#,##0.00", "es_AR");
late ProgressDialog pr;
late BuildContext _context2;
late CarroModelo cartProvider;

class VerificarPedido extends StatefulWidget {
  final int numEmpresa;
  const VerificarPedido({Key? key, required this.numEmpresa}) : super(key: key);

  @override
  _VerificarPedidoState createState() => _VerificarPedidoState();
}

class _VerificarPedidoState extends State<VerificarPedido> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    _context2 = context;
    cartProvider = Provider.of<CarroModelo>(context);
    final size = MediaQuery.of(context).size;
    Locale locale = Localizations.localeOf(context);
    var format = NumberFormat.simpleCurrency(locale: locale.toString());
    return Scaffold(
        appBar: AppBar(
          title: Text('Verificar tu pedido',
              style: TextStyle(color: HexColor("#43398E"))),
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
                                  _botonGrandeConfirmar(size),
                                  _separador(size),
                                  _total(size, cartProvider, format),
                                  _separador(size),
                                  SimpleCardNotExpand(
                                      texto: "Dirección de entrega",
                                      ciudad: data[i].ciudad,
                                      direccion: data[i].direccion,
                                      razonsocial: data[i].razonsocial),
                                  _separador(size),
                                  SimpleCardCondicionesEntrega(
                                      texto: "Condiciones de entrega",
                                      referencia: "Solo en el domicilio"),
                                  _separador(size),
                                  SimpleCardOneNotExpand(
                                      texto: "Forma de Pago",
                                      referencia: data[i].condicion_pago),
                                  _separador(size),
                                  // SimpleCardGroups(
                                  //     texto: "Preferencias de facturación"),
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

  Widget _separador(size) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      width: size.width * 0.8,
      padding: EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            //                   <--- left side
            color: HexColor("#EAE8F5"),
            width: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _botonGrandeConfirmar(size) {
    return GestureDetector(
      onTap: () {
        _dialogEnviarPedido();
      },
      child: Container(
        width: size.width * 0.9,
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(
          top: 10,
          bottom: 10,
        ),
        decoration: BoxDecoration(
          color: HexColor("#30C3A3"),
          //border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(20),
        ),
        height: 45,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Confirmar pedido',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  TextStyle diseno_valores() => TextStyle(
      fontSize: 17.0, color: HexColor("#43398E"), fontWeight: FontWeight.bold);

  Widget _total(size, cartProvider, format) {
    return Container(
      height: size.height * 0.2,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 5, 20, 5),
        child: Container(
          width: double.infinity,
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                  'SubTotal: ${format.currencySymbol}' +
                      formatNumber
                          .format(cartProvider.getTotal)
                          .replaceAll(',00', ''),
                  style: diseno_valores()),
              SizedBox(
                height: 20,
              ),
              Text(
                  'Estos productos serán entregados según el itinerario del proveedor',
                  style: TextStyle(fontSize: 15.0)),
            ],
          ),
        ),
      ),
    );
  }

  _dialogEnviarPedido() async {
    if (prefs.usurioLogin == -1) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    } else {
      final List<Pedido> listaProductosPedidos = [];

      PedidoEmart.listaValoresPedido!.forEach((key, value) {
        if (int.parse(value) > 0) {
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
            codCliente: prefs.codCliente,
            tipoFabricante: directo,
            codProveedor: 1,
          );

          listaProductosPedidos.add(pedidoNuevo);
        }
      });

      pr = ProgressDialog(_context2);
      pr.style(message: 'Registrando Pedido');
      pr = ProgressDialog(_context2,
          type: ProgressDialogType.Normal,
          isDismissible: false,
          showLogs: true);

      await pr.show();
      await _dialogPedidoRegistrado(listaProductosPedidos);
    }
  }

  _dialogPedidoRegistrado(listaProductosPedidos) async {
    DateTime now = DateTime.now();
    String fechaPedido = DateFormat('yyyy-MM-dd HH:mm').format(now);
    String numDoc = DateFormat('yyyyMMddHHmmss').format(now);

    ValidarPedido validar = await Servicies().enviarPedido(
        listaProductosPedidos, prefs.codClienteLogueado, fechaPedido, numDoc);

    if (validar.estado == 'OK') {
      await pr.hide();
      setState(() {
        listaProductosPedidos = [];
        PedidoEmart.eliminarRegistros();
        cartProvider.guardarValorCompra = 0;
        cartProvider.guardarValorAhorro = 0;
      });

      mostrarAlert(_context2, validar.mensaje!, null);
    } else {
      await pr.hide();
      mostrarAlertaUtilsError(_context2, validar.mensaje!);
    }
  }
}
