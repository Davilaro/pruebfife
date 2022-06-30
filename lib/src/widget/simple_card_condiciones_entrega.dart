import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:emart/src/provider/db_provider_helper.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

late CarroModelo cartProvider;
NumberFormat formatNumber = new NumberFormat("#,##0.00", "es_AR");

class SimpleCardCondicionesEntrega extends StatefulWidget {
  final String texto;
  final String referencia;
  SimpleCardCondicionesEntrega(
      {Key? key, required this.texto, required this.referencia})
      : super(key: key);

  @override
  _SimpleCardCondicionesEntregaState createState() =>
      _SimpleCardCondicionesEntregaState();
}

class _SimpleCardCondicionesEntregaState
    extends State<SimpleCardCondicionesEntrega> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    cartProvider = Provider.of<CarroModelo>(context);
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: 14),
      child: Column(
        children: [
          SingleChildScrollView(
            child: Container(
              // height: 62,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.white,
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.withOpacity(0.5),
                //     spreadRadius: 5,
                //     blurRadius: 7,
                //     offset: Offset(0, 3), // changes position of shadow
                //   ),
                // ],
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
                          // color: Colors.white,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          padding: const EdgeInsets.all(20.0),
                          child: Text(widget.texto,
                              style: TextStyle(
                                color: _isExpanded
                                    ? HexColor("#43398E")
                                    : Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              )),
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
                      children:
                          _cargarWidgetDinamicoAcordeon(context, cartProvider),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  List<Widget> _cargarWidgetDinamicoAcordeon(
      BuildContext context1, CarroModelo cartProvider) {
    List<Widget> listaWidget = [];

    PedidoEmart.listaProductosPorFabricante!.forEach((fabricante, value) {
      if (value['precioProducto'] > 0.0) {
        listaWidget.add(
          Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
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
                              Image.asset('assets/jar-loading.gif'),
                          errorWidget: (context, url, error) =>
                              Image.asset('assets/logo_login.png'),
                          fit: BoxFit.cover),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Container(
                          child: FutureBuilder<dynamic>(
                        future: DBProviderHelper.db
                            .consultarCondicionEntrega(fabricante),
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.hasData) {
                            var condicionEntrega = snapshot.data!;

                            return Text(mensajeCard(
                                fabricante,
                                cartProvider.getListaFabricante[fabricante]
                                    ["precioFinal"],
                                value["preciominimo"],
                                value["topeMinimo"],
                                condicionEntrega));
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      )),
                    ),
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

  String mensajeCard(String fabricante, double valorPedido, double precioMinimo,
      double topeMinimo, condicionEntrega) {
    DateTime now = new DateTime.now();

    String hora = now.hour.toString();
    String minuto = now.minute.toString();
    String segundo = now.second.toString();

    DateTime hourRes = new DateFormat("HH:mm:ss").parse(condicionEntrega.hora);
    DateTime horaActual = new DateFormat("HH:mm:ss")
        .parse(hora + ":" + minuto.toString() + ":" + segundo.toString());

    if (fabricante.toUpperCase() == "MEALS") {
      if (valorPedido < (topeMinimo * 1.19)) {
        return condicionEntrega.mensaje1;
      } else {
        return "Tu pedido será entregado el siguiente día hábil.";
      }
    } else {
      return horaActual.isBefore(hourRes)
          ? condicionEntrega.mensaje1
          : condicionEntrega.mensaje2;
    }
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
                        // SizedBox(
                        //   height: 40.0,
                        //   width: 40.0,
                        //   child: IconButton(
                        //     icon: Image.asset('assets/menos.png'),
                        //     onPressed: () => menos(
                        //         product.productos, cartProvider, fabricante),
                        //   ),
                        // ),
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
                                    if (value != "") {
                                      if (value != "0") {
                                        PedidoEmart.registrarValoresPedido(
                                            product.productos, value, true);
                                      }
                                    } else
                                      PedidoEmart.registrarValoresPedido(
                                          product.productos, "0", false);
                                  });
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
                        // SizedBox(
                        //   height: 40.0,
                        //   width: 40.0,
                        //   child: IconButton(
                        //     icon: Image.asset('assets/mas.png'),
                        //     onPressed: () =>
                        //         mas(product.productos, cartProvider),
                        //   ),
                        // ),
                      ],
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
