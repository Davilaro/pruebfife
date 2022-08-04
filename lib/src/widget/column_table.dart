import 'package:emart/src/modelos/productos.dart';
import 'package:emart/src/modelos/sugerido.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/metodo_ingresados.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:emart/src/provider/datos_listas_provider.dart';
import 'package:emart/src/provider/db_provider_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class ColumnTable extends StatefulWidget {
  final Sugerido sugerido;
  final CarroModelo cartProvider;
  final DatosListas providerDatos;
  ColumnTable(
      {Key? key,
      required this.sugerido,
      required this.cartProvider,
      required this.providerDatos})
      : super(key: key);

  @override
  _ColumnTableState createState() => _ColumnTableState();
}

class _ColumnTableState extends State<ColumnTable> {
  // late bool activo = true;
  @override
  Widget build(BuildContext context) {
    return widget.sugerido.estado!
        ? Container(
            padding: const EdgeInsets.only(left: 30),
            child: GestureDetector(
              onTap: () =>
                  {mas(widget.sugerido.codigo!, widget.sugerido.cantidad!)},
              child: Table(columnWidths: {
                0: FlexColumnWidth(6),
                1: FlexColumnWidth(3),
              }, children: [
                TableRow(
                  children: [
                    Container(
                      color: Colors.white,
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.only(top: 14, bottom: 12, left: 0),
                        child: Column(
                          children: [
                            Container(
                              width: Get.width * 0.9,
                              child: Text(
                                widget.sugerido.descripcion!.trimLeft(),
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: HexColor("#30C3A3")),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Cantidad: ${widget.sugerido.cantidad!.toString()}",
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        top: 22,
                      ),
                      child: Text(
                        widget.sugerido.cantidad.toString(),
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.center,
                    ),
                  ],
                )
              ]),
            ),
          )
        : Container();
  }

  mas(String prod, int cantidad) async {
    Productos producto = await DBProviderHelper.db.consultarDatosProducto(prod);

    String valorInicial = PedidoEmart.obtenerValor(producto)!;
    bool valorInicialController = PedidoEmart.obtenerValorController(producto)!;

    if (valorInicialController == false) {
      PedidoEmart.listaControllersPedido!
          .putIfAbsent(producto.codigo, () => TextEditingController());
      PedidoEmart.listaValoresPedido!.putIfAbsent(
          producto.codigo, () => PedidoEmart.obtenerValor(producto)!);

      PedidoEmart.listaControllersPedido![producto.codigo]!.text = "1";
      PedidoEmart.registrarValoresPedido(producto, '1', true);
    } else {
      if (valorInicial == "") {
        PedidoEmart.listaControllersPedido![producto.codigo]!.text = "1";
        PedidoEmart.registrarValoresPedido(producto, '1', true);
      } else {
        int valoSuma;
        if (PedidoEmart.listaValoresPedidoAgregados![producto] == true) {
          valoSuma = int.parse(valorInicial) + cantidad;
        } else {
          valoSuma = int.parse(valorInicial) + cantidad - 1;
        }
        setState(() {
          PedidoEmart.listaControllersPedido![producto.codigo]!.text =
              "$valoSuma";
          PedidoEmart.registrarValoresPedido(producto, '$valoSuma', true);
          widget.providerDatos.pasarSugeridoCarrito(prod);
        });
      }
    }

    MetodosLLenarValores().calcularValorTotal(widget.cartProvider);
  }

  void calcularValorTotal(CarroModelo cartProvider) {
    double valorTotal = 0;
    double valorAhorro = 0;
    int cantidad = 0;

    PedidoEmart.listaValoresPedido!.forEach((key, value) {
      if (value != "0" &&
          PedidoEmart.listaValoresPedidoAgregados![key] == true) {
        double precio = PedidoEmart.listaProductos![key]!.precio;
        valorTotal = valorTotal + precio * int.parse(value);
        valorAhorro = valorAhorro +
            PedidoEmart.listaProductos![key]!.precio * int.parse(value);
        cantidad++;
      }
    });

    cartProvider.actualizarItems = cantidad;
    cartProvider.guardarValorCompra = valorTotal;
    cartProvider.guardarValorAhorro = valorAhorro;
    PedidoEmart.calcularPrecioPorFabricante();
    cartProvider.actualizarListaFabricante =
        PedidoEmart.listaPrecioPorFabricante!;
    MetodosLLenarValores().calcularValorTotal(cartProvider);
  }
}
