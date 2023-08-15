import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:emart/src/provider/db_provider_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

late CarroModelo cartProvider;

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
                              Image.asset('assets/image/jar-loading.gif'),
                          errorWidget: (context, url, error) =>
                              Image.asset('assets/image/logo_login.png'),
                          fit: BoxFit.cover),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Container(
                          padding: EdgeInsets.only(right: 25),
                          child: FutureBuilder<dynamic>(
                            future: DBProviderHelper.db
                                .consultarCondicionEntrega(fabricante),
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData) {
                                var condicionEntrega = snapshot.data!;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    prefs.paisUsuario == 'CR'
                                        ? Text(
                                            'Estimado cliente',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )
                                        : Container(),
                                    Text(mensajeCard(
                                      fabricante,
                                      cartProvider
                                              .getListaFabricante[fabricante]
                                          ["precioFinal"],
                                      value["preciominimo"],
                                      value["topeMinimo"],
                                      condicionEntrega,
                                      value["isFrecuencia"],
                                      value["diasVisita"],
                                      value["itinerario"],
                                    )),
                                  ],
                                );
                              }
                              return CircularProgressIndicator();
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

  int calcularDiasFaltantes(
      List<String> diasSemana, diasEspecificos, String diaActual) {
    // Obtener el índice del dia actual en la lista de días de la semana
    int indexDiaActual = diasSemana.indexOf(diaActual);

    // Inicializar el contador de dia faltantes
    int diasFaltantes = 1;

    // Recorrer la lista de días de la semana en orden para encontrar el proximo dia de visita
    for (int i = 1; i <= diasSemana.length; i++) {
      int indexSiguienteDia = (indexDiaActual + i) % diasSemana.length;
      String siguienteDia = diasSemana[indexSiguienteDia];

      if (diasEspecificos.contains(siguienteDia)) {
        break;
      } else {
        diasFaltantes++;
      }
    }

    return diasFaltantes + 1;
  }

  String mensajeCard(
      String fabricante,
      double valorPedido,
      double precioMinimo,
      double topeMinimo,
      condicionEntrega,
      isFrecuencia,
      diasVisita,
      itinerario) {
    late int diasFaltantes;
    List<String> diasDeLaSemana = [
      'lunes',
      'martes',
      'miércoles',
      'jueves',
      'viernes',
      'sábado',
      'domingo'
    ];

    diasFaltantes =
        calcularDiasFaltantes(diasDeLaSemana, diasVisita, prefs.diaActual);
    // DateTime now = new DateTime.now();

    // String hora = now.hour.toString();
    // String minuto = now.minute.toString();
    // String segundo = now.second.toString();

    // DateTime hourRes = new DateFormat("HH:mm:ss").parse(condicionEntrega.hora);
    // DateTime horaActual = new DateFormat("HH:mm:ss")
    //     .parse(hora + ":" + minuto.toString() + ":" + segundo.toString());

    if (prefs.paisUsuario == 'CR') {
      return condicionEntrega.texto1;
    } else {
      if (itinerario == 1 && isFrecuencia == true) {
        return condicionEntrega.texto1;
      } else if (itinerario == 1 && isFrecuencia == false) {
        return "Tu pedido será entregado aproximadamente en $diasFaltantes días hábiles.";
      } else {
        if (valorPedido > (precioMinimo)) {
          return "Tu pedido será entregado en el siguiente día habil";
        }

        return condicionEntrega.texto2;
      }
    }
    // if (prefs.paisUsuario == 'CR') {
    //   return condicionEntrega.texto1;
    // } else {
    //   return horaActual.isBefore(hourRes)
    //       ? condicionEntrega.mensaje1
    //       : condicionEntrega.mensaje2;
    // }
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
            color: HexColor("#EAE8F5"),
            width: 0.5,
          ),
        ),
      ),
    );
  }
}
