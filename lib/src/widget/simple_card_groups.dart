import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/metodo_ingresados.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

bool cargarDeNuevo = false;
NumberFormat formatNumber = new NumberFormat("#,##0.00", "es_AR");

class SimpleCardGroups extends StatefulWidget {
  final String texto;
  SimpleCardGroups({Key? key, required this.texto}) : super(key: key);

  @override
  _SimpleCardGroupsState createState() => _SimpleCardGroupsState();
}

class _SimpleCardGroupsState extends State<SimpleCardGroups> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    CarroModelo cartProvider = Provider.of<CarroModelo>(context);

    // Locale locale = Localizations.localeOf(context);
    // var format = NumberFormat.simpleCurrency(locale: locale.toString());
    var locale = Intl().locale;

    var format = locale.toString() != 'es_CO'
        ? locale.toString() == 'es_CR'
            ? NumberFormat.currency(locale: locale.toString(), symbol: '\₡')
            : NumberFormat.simpleCurrency(locale: locale.toString())
        : NumberFormat.currency(locale: locale.toString(), symbol: '\$');

    return Container(
      margin: EdgeInsets.only(bottom: 14),
      child: Column(
        children: [
          SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Table(
                    columnWidths: {
                      0: FlexColumnWidth(5),
                      1: FlexColumnWidth(1),
                    },
                    children: [
                      TableRow(children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            widget.texto,
                            style: TextStyle(
                                color: _isExpanded
                                    ? HexColor("#43398E")
                                    : Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          padding: const EdgeInsets.all(5.0),
                          alignment: Alignment.center,
                          child: ExpandIcon(
                            size: 20,
                            color: HexColor("#30C3A3"),
                            isExpanded: _isExpanded,
                            padding: const EdgeInsets.all(16.0),
                            onPressed: (bool isExpanded) {
                              setState(() {
                                _isExpanded = !_isExpanded;
                              });
                            },
                          ),
                        ),
                      ])
                    ],
                  ),
                ],
              ),
            ),
          ),
          _isExpanded
              ? AnimatedContainer(
                  duration: Duration(milliseconds: 2000),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          child: Table(
                            columnWidths: {
                              0: FlexColumnWidth(2),
                              1: FlexColumnWidth(5)
                            },
                            children: [
                              TableRow(children: [
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: _cargarWidgetDinamicoAcordeon(
                                        context, cartProvider, format)),
                              ])
                            ],
                          ),
                          margin: EdgeInsets.only(top: 14),
                        ),
                      ],
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  List<Widget> _cargarWidgetDinamicoAcordeon(
      BuildContext context1, CarroModelo cartProvider, NumberFormat format) {
    List<Widget> listaWidget = [];

    PedidoEmart.listaProductosPorFabricante!.forEach((fabricante, value) {
      if (value['precioProducto'] != 0.0) {
        listaWidget.add(
          Column(
            children: [
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 70,
                      width: 70,
                      alignment: Alignment.center,
                      child: CachedNetworkImage(
                          imageUrl: PedidoEmart
                                  .listaProductosPorFabricante![fabricante]
                              ["imagen"],
                          placeholder: (context, url) =>
                              Image.asset('assets/image/jar-loading.gif'),
                          errorWidget: (context, url, error) =>
                              Image.asset('assets/image/logo_login.png'),
                          fit: BoxFit.cover),
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        width: MediaQuery.of(context).size.width / 3,
                        child: Text(
                            cartProvider.getListaFabricante[fabricante] == null
                                ? '0'
                                : '${format.currencySymbol}' +
                                    formatNumber
                                        .format(cartProvider
                                                .getListaFabricante[fabricante]
                                            ["precioFinal"])
                                        .replaceAll(',00', ''),
                            style: diseno_valores())),
                  ],
                ),
              )
            ],
          ),
        );
      }
    });

    return listaWidget;
  }

  List<Widget> gridItem(List<dynamic> value, String fabricante,
      BuildContext context, CarroModelo cartProvider) {
    List<Widget> result = [];

    final size = MediaQuery.of(context).size;

    value.forEach((product) {
      if (product.fabricante == fabricante && product.cantidad > 0) {
        result
          ..add(Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Container(
              child: Row(
                children: [
                  Container(
                    width: size.width / 3,
                    child: Text(
                      product.nombre,
                      style: TextStyle(color: Colors.cyan[800]),
                    ),
                  ),
                  Container(
                    width: size.width / 3,
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          alignment: Alignment.center,
                          child: ConstrainedBox(
                            constraints: new BoxConstraints(
                              minWidth: 20,
                              maxWidth: 100,
                              minHeight: 10,
                              maxHeight: 70.0,
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              reverse: true,
                              child: TextField(
                                maxLines: 1,
                                controller: PedidoEmart
                                    .listaControllersPedido![product.codigo],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black),
                                onChanged: (value) {
                                  setState(() {
                                    if (value != "") if (value != "0") {
                                      PedidoEmart.registrarValoresPedido(
                                          product.productos, value, true);
                                    } else
                                      PedidoEmart.registrarValoresPedido(
                                          product.productos, "0", false);
                                  });

                                  MetodosLLenarValores()
                                      .calcularValorTotal(cartProvider);
                                },
                                decoration: InputDecoration(
                                  fillColor: Colors.black,
                                  hintText: '0',
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: size.width / 6,
                    child: Text(
                      formatNumber.format(product.precio).replaceAll(',00', ''),
                    ),
                  ),
                  _separador(size)
                ],
              ),
            ),
          ))
          ..add(Divider());
      }
    });

    return result;
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

  TextStyle diseno_valores() => TextStyle(
      fontSize: 17.0, color: HexColor("#43398E"), fontWeight: FontWeight.bold);
}
