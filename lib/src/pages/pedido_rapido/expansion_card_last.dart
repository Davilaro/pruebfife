import 'package:emart/_pideky/domain/producto/service/producto_service.dart';
import 'package:emart/_pideky/infrastructure/productos/producto_repository_sqlite.dart';
import 'package:emart/_pideky/presentation/productos/view_model/producto_view_model.dart';
import 'package:emart/shared/widgets/boton_agregar_carrito.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/modelos/historico.dart';
import 'package:emart/_pideky/domain/producto/model/producto.dart';
import 'package:emart/src/pages/login/login.dart';
import 'package:emart/src/pages/pedido_rapido/view_model/repetir_orden_view_model.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/metodo_ingresados.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:emart/src/provider/datos_listas_provider.dart';
import 'package:emart/src/provider/db_provider_helper.dart';
import 'package:emart/src/widget/animated_container_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../widget/animated_container_card.dart';

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
  ProductoService productService = ProductoService(ProductoRepositorySqlite());
  RepetirOrdenViewModel repetirOrdenViewModel = Get.find();
  ProductoViewModel productViewModel = Get.find();

  RxBool _cargando = false.obs;
  final controlador = Get.find<CambioEstadoProductos>();

  @override
  Widget build(BuildContext context) {
    RxBool isFrecuencia = true.obs;
    RxString fabricanteFrecuencia = ''.obs;
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            width: size.width,
            child: SingleChildScrollView(
              child: _body(context, isFrecuencia, fabricanteFrecuencia),
            ),
          ),
          //antiguo boton de agregar al carrito
          Container(
            width: 200,
            child: Obx(() => AbsorbPointer(
                  absorbing: _cargando.value,
                  child: BotonAgregarCarrito(
                      color: isFrecuencia.value
                          ? ConstantesColores.azul_aguamarina_botones
                          : ConstantesColores.gris_sku,
                      height: 40,
                      width: 190,
                      onTap: () async {
                        onBlockBoubleClick();
                        if (isFrecuencia.value) {
                          await _cargarPedido(
                              widget.historico.numeroDoc!.toString(),
                              widget.providerDatos);
                        } else {
                          productViewModel.iniciarModal(
                              context, fabricanteFrecuencia.value);
                        }
                      },
                      text: "Agregar al carrito"),
                )),
          ),
        ],
      ),
    );
  }

  Widget _body(BuildContext context, RxBool isFrecuencia,
      RxString fabricanteFrecuencia) {
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
                    "Orden Pideky ${widget.historico.numeroDoc}",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: "RoundedMplus1c-ExtraBold.ttf",
                        fontWeight: FontWeight.bold,
                        color: Color(0xff4f4f4f)),
                  ),
                  padding: EdgeInsets.only(top: 16, bottom: 16, left: 4),
                ),
              ],
            ),
          ],
        ),
      ),
      Column(
        children: [
          _grupoComercial(size, widget.historico.numeroDoc, isFrecuencia,
              fabricanteFrecuencia),
          Container(
            width: size.width * 0.9,
            margin: const EdgeInsets.only(top: 8.0),
            padding: EdgeInsets.only(right: 10),
            alignment: Alignment.centerRight,
          ),
        ],
      )
    ]);
  }

  onBlockBoubleClick() {
    Future.delayed(Duration(seconds: 2), () {
      _cargando.value = false;
    });
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

  Widget _grupoComercial(size, numeroDocumento, RxBool isFrecuencia,
      RxString fabricanteFrecuencia) {
    return FutureBuilder<List<Historico>>(
        future: DBProviderHelper.db.consultarGrupoHistorico(numeroDocumento),
        builder: (context, AsyncSnapshot<List<Historico>> snapshot) {
          if (snapshot.hasData) {
            var grupos = snapshot.data;
            return Column(
              children: _cargarContainer(grupos, size, numeroDocumento,
                  isFrecuencia, fabricanteFrecuencia),
            );
          }
          return CircularProgressIndicator();
        });
  }

  _cargarContainer(List<Historico>? grupos, size, numeroDocumento,
      RxBool isFrecuencia, RxString fabricanteFrecuencia) {
    List<Widget> contenido = [];
    for (int i = 0; i < grupos!.length; i++) {
      if (prefs.paisUsuario == 'CR') {
        repetirOrdenViewModel.validarFrecuenciaPedidoRapido(
            numeroDocumento,
            grupos[i].fabricante!,
            isFrecuencia,
            productViewModel,
            fabricanteFrecuencia);
      }

      contenido.add(
        AnimatedContainerCard(
          grupo: grupos[i].fabricante!,
          numeroDoc: numeroDocumento,
          ordenCompra: grupos[i].ordenCompra.toString(),
        ),
      );
      contenido.add(
        _separador(size),
      );
    }

    return contenido;
  }

  _cargarPedido(String numeroDoc, providerDatos) async {
    //if (estado) {
    if (prefs.usurioLogin == 1) {
      List<Historico> datosDetalle =
          await DBProviderHelper.db.consultarDetallePedido(numeroDoc);
      cargarCadaProducto(datosDetalle);
      await PedidoEmart.iniciarProductosPorFabricante();
      onBlockBoubleClick();
      // pasarCarrito(providerDatos, ordenCompra, estado);
      //}
      actualizarEstadoPedido(widget.providerDatos, numeroDoc);
      calcularValorTotal(widget.cartProvider);
    } else {
      Get.off(Login());
    }
  }

  // menos(String prop, int cantidad, String numeroDoc) async {
  //   onBlockBoubleClick();
  //   Productos producto = await DBProviderHelper.db.consultarDatosProducto(prop);
  //   if (producto.codigo != "") {
  //     int nuevaCantidad = PedidoEmart
  //                 .listaControllersPedido![producto.codigo]!.text ==
  //             ""
  //         ? cantidad
  //         : (int.parse(
  //                 PedidoEmart.listaControllersPedido![producto.codigo]!.text) -
  //             cantidad);

  //     setState(() {
  //       if (nuevaCantidad == 0) {
  //         PedidoEmart.listaControllersPedido![producto.codigo]!.text = "0";
  //         PedidoEmart.registrarValoresPedido(producto, '1', false);
  //         if (controlador.mapaHistoricos
  //             .containsKey(widget.historico.numeroDoc)) {
  //           // controlador.mapaHistoricos[numeroDoc] = false;
  //           controlador.mapaHistoricos
  //               .update(widget.historico.numeroDoc, (value) => false);
  //         }
  //       } else {
  //         PedidoEmart.listaControllersPedido![producto.codigo]!.text =
  //             "$nuevaCantidad";
  //         PedidoEmart.registrarValoresPedido(producto, '$nuevaCantidad', true);
  //         controlador.mapaHistoricos
  //             .addAll({widget.historico.numeroDoc: false});
  //       }
  //       determinarBotonCarrito(widget.historico.numeroDoc!);
  //     });

  //     MetodosLLenarValores().calcularValorTotal(widget.cartProvider);
  //   }
  // }

  mas(String prod, int cantidad, String numeroDoc) async {
    Producto producto = await productService.consultarDatosProducto(prod);
    if (producto.codigo != "") {
      // int nuevaCantidad = PedidoEmart
      //             .listaControllersPedido![producto.codigo]!.text ==
      //         ""
      //     ? cantidad
      //     : (int.parse(
      //             PedidoEmart.listaControllersPedido![producto.codigo]!.text) +
      //         cantidad);
      setState(() {
        PedidoEmart.listaControllersPedido![producto.codigo]!.text =
            "$cantidad";
        PedidoEmart.registrarValoresPedido(producto, '$cantidad', true);
        if (controlador.mapaHistoricos
            .containsKey(widget.historico.numeroDoc)) {
          controlador.mapaHistoricos
              .update(widget.historico.numeroDoc, (value) => true);
        } else {
          controlador.mapaHistoricos.addAll({widget.historico.numeroDoc: true});
        }
      });
    }
  }

  void actualizarEstadoPedido(datosProvider, ordenCompra) {
    datosProvider.actualizarHistoricoPedido(ordenCompra);
  }

  cargarCadaProducto(List<Historico> datosDetalle) {
    datosDetalle.forEach((element) {
      mas(element.codigoRef.toString(), element.cantidad!,
          "${element.numeroDoc}");
    });
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

// class Item {
//   String orden;
//   String fecha;
//   String numeroPedido;
//   Item({required this.orden, required this.fecha, required this.numeroPedido});
// }
