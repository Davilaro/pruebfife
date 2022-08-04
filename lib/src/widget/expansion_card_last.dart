import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/modelos/historico.dart';
import 'package:emart/src/modelos/productos.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/metodo_ingresados.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:emart/src/provider/datos_listas_provider.dart';
import 'package:emart/src/provider/db_provider_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import 'animated_container_card.dart';

final prefs = new Preferencias();
const double _kPanelHeaderCollapsedHeight = 80.0;
const double _kPanelHeaderExpandedHeight = 80.0;
const EdgeInsets kExpandedEdgeInsets = const EdgeInsets.symmetric(
    vertical: _kPanelHeaderExpandedHeight - _kPanelHeaderCollapsedHeight);

class ExpansionCardLast extends StatefulWidget {
  final Historico historico;
  final CarroModelo cartProvider;
  final DatosListas providerDatos;
  const ExpansionCardLast({
    Key? key,
    required this.historico,
    required this.cartProvider,
    required this.providerDatos,
  }) : super(key: key);

  @override
  _ExpansionCardLastState createState() => _ExpansionCardLastState();
}

class _ExpansionCardLastState extends State<ExpansionCardLast> {
  bool _cargando = false;
  RxBool estadoBoton = true.obs;
  final controlador = Get.find<CambioEstadoProductos>();
  @override
  void initState() {
    super.initState();
    determinarBotonCarrito("${widget.historico.numeroDoc}");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(children: [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Table(
          columnWidths: {1: FractionColumnWidth(.36)},
          children: [
            TableRow(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Text(
                    "Orden Pideky ${widget.historico.ordenCompra}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  padding: EdgeInsets.all(16),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Container(
                        child: Icon(
                          Icons.clean_hands,
                          color: HexColor("#30C3A3"),
                        ),
                      ),
                      Container(
                        width: 10,
                      ),
                      Container(
                        color: Colors.white,
                        child: Text(
                          "Entregado",
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      Column(
        children: [
          _grupoComercial(size, widget.historico.numeroDoc),
          Container(
            width: size.width * 0.9,
            margin: const EdgeInsets.only(top: 8.0),
            padding: EdgeInsets.only(right: 10),
            alignment: Alignment.centerRight,
            child: Container(
              width: 124,
              child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(
                                color: HexColor("#43398E"), width: 1.0)))),
                child: Row(
                  children: [
                    Obx(
                      () => Text(
                        estadoBoton.value ? 'Pedir' : 'Cancelar',
                        style: TextStyle(color: HexColor("#43398E")),
                      ),
                    ),
                    !_cargando
                        ? Icon(
                            Icons.car_rental,
                            color: HexColor("#30C3A3"),
                          )
                        : Container(
                            height: 10,
                            width: 10,
                            margin: EdgeInsets.all(6),
                            child: CircularProgressIndicator(
                              color: HexColor("#30C3A3"),
                            ),
                          )
                  ],
                ),
                onPressed: () {
                  setState(() {
                    _cargando = true;
                  });
                  determinarBotonCarrito(widget.historico.numeroDoc!);
                  _cargarPedido(widget.historico.numeroDoc!.toString(),
                      estadoBoton.value, widget.providerDatos);
                },
              ),
            ),
          ),
        ],
      )
    ]);
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

  Widget _grupoComercial(size, numeroDocumento) {
    return FutureBuilder<List<Historico>>(
        future: DBProviderHelper.db.consultarGrupoHistorico(numeroDocumento),
        builder: (context, AsyncSnapshot<List<Historico>> snapshot) {
          if (snapshot.hasData) {
            var grupos = snapshot.data;
            return Column(
              children: [
                for (int i = 0; i < grupos!.length; i++)
                  AnimatedContainerCard(
                    grupo: grupos[i].fabricante!,
                    numeroDoc: numeroDocumento,
                    ordenCompra: "",
                  ),
                _separador(size),
              ],
            );
          }
          return CircularProgressIndicator();
        });
  }

  _cargarPedido(String numeroDoc, estado, providerDatos) async {
    if (estado) {
      List<Historico> datosDetalle =
          await DBProviderHelper.db.consultarDetallePedido(numeroDoc);
      await cargarCadaProducto(datosDetalle);
      await PedidoEmart.iniciarProductosPorFabricante();
      // pasarCarrito(providerDatos, ordenCompra, estado);
    } else {
      List<Historico> datosDetalle =
          await DBProviderHelper.db.consultarDetallePedido(numeroDoc);
      datosDetalle.forEach((element) {
        menos(element.codigoRef!, element.cantidad!, "${element.numeroDoc}");
      });
    }
    actualizarEstadoPedido(widget.providerDatos, numeroDoc);
    calcularValorTotal(widget.cartProvider);
    _cargando = false;
  }

  menos(String prop, int cantidad, String numeroDoc) async {
    Productos producto = await DBProviderHelper.db.consultarDatosProducto(prop);
    if (producto.codigo != "") {
      int nuevaCantidad = PedidoEmart
                  .listaControllersPedido![producto.codigo]!.text ==
              ""
          ? cantidad
          : (int.parse(
                  PedidoEmart.listaControllersPedido![producto.codigo]!.text) -
              cantidad);
      setState(() {
        if (nuevaCantidad == 0) {
          PedidoEmart.listaControllersPedido![producto.codigo]!.text = "0";
          PedidoEmart.registrarValoresPedido(producto, '0', false);
          if (controlador.mapaHistoricos
              .containsKey(widget.historico.numeroDoc)) {
            // controlador.mapaHistoricos[numeroDoc] = false;
            controlador.mapaHistoricos
                .update(widget.historico.numeroDoc, (value) => false);
          }
        } else {
          PedidoEmart.listaControllersPedido![producto.codigo]!.text =
              "$nuevaCantidad";
          PedidoEmart.registrarValoresPedido(producto, '$nuevaCantidad', true);
        }
        determinarBotonCarrito(widget.historico.numeroDoc!);
      });

      MetodosLLenarValores().calcularValorTotal(widget.cartProvider);
    }
  }

  mas(String prod, int cantidad, String numeroDoc) async {
    Productos producto = await DBProviderHelper.db.consultarDatosProducto(prod);
    if (producto.codigo != "") {
      int nuevaCantidad = PedidoEmart
                  .listaControllersPedido![producto.codigo]!.text ==
              ""
          ? cantidad
          : (int.parse(
                  PedidoEmart.listaControllersPedido![producto.codigo]!.text) +
              cantidad);
      setState(() {
        PedidoEmart.listaControllersPedido![producto.codigo]!.text =
            "$nuevaCantidad";
        PedidoEmart.registrarValoresPedido(producto, '$nuevaCantidad', true);
        if (controlador.mapaHistoricos
            .containsKey(widget.historico.numeroDoc)) {
          controlador.mapaHistoricos
              .update(widget.historico.numeroDoc, (value) => true);
        } else {
          controlador.mapaHistoricos.addAll({widget.historico.numeroDoc: true});
        }
        determinarBotonCarrito(widget.historico.numeroDoc!);
      });

      MetodosLLenarValores().calcularValorTotal(widget.cartProvider);
    }
  }

  void actualizarEstadoPedido(datosProvider, ordenCompra) {
    datosProvider.actualizarHistoricoPedido(ordenCompra);
  }

  cargarCadaProducto(List<Historico> datosDetalle) {
    datosDetalle.forEach((element) {
      mas(element.codigoRef!, element.cantidad!, "${element.numeroDoc}");
    });
  }

  void determinarBotonCarrito(String numeroDoc) {
    if (controlador.mapaHistoricos.containsKey(numeroDoc)) {
      controlador.mapaHistoricos[numeroDoc]
          ? estadoBoton.value = false
          : estadoBoton.value = true;
    }
  }
}

void calcularValorTotal(cartProvider) {
  double valorTotal = 0;

  int cantidad = 0;

  PedidoEmart.listaValoresPedido!.forEach((key, value) {
    if (value != "0" && PedidoEmart.listaValoresPedidoAgregados![key] == true) {
      double precio = PedidoEmart.listaProductos![key]!.precio;
      valorTotal = valorTotal + precio * int.parse(value);
      cantidad++;
    }
  });

  cartProvider.actualizarItems = cantidad;
  cartProvider.guardarValorCompra = valorTotal;
  PedidoEmart.calcularPrecioPorFabricante();
  cartProvider.actualizarListaFabricante =
      PedidoEmart.listaPrecioPorFabricante!;

  MetodosLLenarValores().calcularValorTotal(cartProvider);
}

class Item {
  String orden;
  String fecha;
  String numeroPedido;
  Item({required this.orden, required this.fecha, required this.numeroPedido});
}
