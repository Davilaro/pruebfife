// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:emart/src/pages/carrito/carrito_compras.dart';
import 'package:emart/src/pages/login/login.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:emart/src/provider/datos_listas_provider.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/utils/util.dart';
import 'package:emart/src/widget/column_table_car.dart';
import 'package:emart/src/widget/soporte.dart';
import 'package:emart/src/widget/titulo_pideky.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'acciones_carrito_bart.dart';
import 'column_table.dart';
import 'expansion_card_last.dart';

final TextEditingController _filtroController = TextEditingController();
final prefs = new Preferencias();

class PedidoRapido extends StatefulWidget {
  PedidoRapido({
    Key? key,
  }) : super(key: key);
  @override
  _PedidoRapidoState createState() => _PedidoRapidoState();
}

@override
class _PedidoRapidoState extends State<PedidoRapido> {
  @override
  void initState() {
    super.initState();
    validarVersionActual(context);
    //FIREBASE: Llamamos el evento select_content
    TagueoFirebase().sendAnalityticSelectContent(
        "Footer", "PedidoRapido", "", "", "PedidoRapido", 'MainActivity');
  }

  int seleccion = 1;
  String filtro = "-1";
  String fechaInicial = "-1";
  String fechaFinal = "-1";

  @override
  Widget build(BuildContext context) {
    //Se define el nombre de la pantalla para UXCAM
    FlutterUxcam.tagScreenName('QuickOrderPage');
    CarroModelo cartProvider = Provider.of<CarroModelo>(context);
    DatosListas providerDatos = Provider.of<DatosListas>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ConstantesColores.color_fondo_gris,
          title: TituloPideky(size: size),
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(10, 2.0, 0, 0),
            child: Container(
              width: 100,
              child: new IconButton(
                icon: SvgPicture.asset('assets/boton_soporte.svg'),
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Soporte(
                              numEmpresa: 1,
                            )),
                  ),
                },
              ),
            ),
          ),
          elevation: 0,
          actions: <Widget>[
            AccionesBartCarrito(esCarrito: false),
          ],
        ),
        body: SingleChildScrollView(
            //child: (seleccion == 1
            //    ? _ordenSugerida(size, cartProvider, providerDatos)
            //   : _ultimaOrden(size, cartProvider)))
            child: _ultimaOrden(size, cartProvider)));
  }

  Widget _tabs(size) {
    return Container(
        width: size.width * 0.9,
        margin: const EdgeInsets.only(top: 20, bottom: 20),
        child: Table(
          columnWidths: {
            0: FlexColumnWidth(4),
            1: FlexColumnWidth(0.1),
            2: FlexColumnWidth(4),
          },
          children: [
            TableRow(children: [
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: seleccion == 2
                        ? MaterialStateProperty.all(HexColor("#FFE24B"))
                        : MaterialStateProperty.all(HexColor("#FFE24B")),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ))),
                child: Text(
                  'Última orden',
                  style: TextStyle(
                      color:
                          seleccion == 2 ? HexColor("#43398E") : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
                onPressed: () {
                  setState(() {
                    seleccion = 2;
                  });
                },
              ),
              Visibility(
                  visible: false,
                  child: Column(
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: seleccion == 1
                                ? MaterialStateProperty.all(HexColor("#FFE24B"))
                                : MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ))),
                        child: Text(
                          'Pedir orden sugerida',
                          style: TextStyle(
                              color: seleccion == 1
                                  ? HexColor("#43398E")
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                        onPressed: () {
                          setState(() {
                            seleccion = 1;
                          });
                        },
                      ),
                      Container(
                        // color: Colors.red,
                        width: 2,
                      ),
                    ],
                  )),
            ])
          ],
        ));
  }

  Widget _sugerencia(size) {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      alignment: Alignment.center,
      child: Column(
        children: [
          Text("Te sugerimos los siguientes productos ",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold)),
          Container(
            width: size.width * 0.9,
            child: Text(
              "para que puedas hacer una compra rápida, Puedes modificar la cantidad, eliminar o agregar unidades",
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  Widget _tarjetaCantidades(size, cartProvider, providerDatos) {
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      width: size.width * 0.9,
      child: Column(
        children: [
          Table(
            columnWidths: {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(5),
              2: FlexColumnWidth(3),
            },
            children: [
              TableRow(children: [
                Text(""),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Descripción",
                    style: TextStyle(color: HexColor("#9F9F9F")),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Cant. Ped",
                    style: TextStyle(color: HexColor("#9F9F9F")),
                  ),
                ),
              ]),
            ],
          ),
          Column(
            children: getProductosCarrito(cartProvider, providerDatos),
          ),
          _botoCarrito()
        ],
      ),
    );
  }

  List<Widget> getProductosCarrito(cartProvider, providerDatos) {
    List<Widget> listaWidgets = [];
    if (providerDatos.getListaSugueridoHelper.length > 0) {
      PedidoEmart.listaValoresPedido!.forEach((key, value) {
        if (value == '') {
        } else if (int.parse(value) > 0 &&
            PedidoEmart.listaProductos!.containsKey(key) &&
            PedidoEmart.listaValoresPedidoAgregados![key] == true &&
            _existeSugerido(providerDatos, key)) {
          listaWidgets.add(ColumnTableCar(
              producto: PedidoEmart.listaProductos![key]!,
              cartProvider: cartProvider,
              cantidad: int.parse(value),
              providerDatos: providerDatos));
        }
      });
    }

    return listaWidgets;
  }

  Widget _tarjetaCantidadesSugeridas(size, cartProvider, providerDatos) {
    final providerDatos = Provider.of<DatosListas>(context);
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        width: size.width * 0.9,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 20),
              // color: Colors.yellow,
              child: Table(columnWidths: {
                0: FlexColumnWidth(6),
                1: FlexColumnWidth(3)
              }, children: [
                TableRow(children: [
                  // Text(""),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Descripción",
                      style: TextStyle(color: HexColor("#9F9F9F")),
                    ),
                  ),
                  // Text(
                  //   "Cant. Ped",
                  //   style: TextStyle(color: HexColor("#9F9F9F")),
                  // ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Cant. Sug",
                      style: TextStyle(color: HexColor("#9F9F9F")),
                    ),
                  ),
                ]),
              ]),
            ),
            _cargarSugeridos(providerDatos.getListaSugueridoHelper, size,
                cartProvider, providerDatos),
          ],
        ),
      ),
    );
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

  Widget _botonGigante(size) {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 20),
      width: size.width * 0.90,
      child: Row(
        children: [
          Expanded(
              child: Container(
            child: _separadorColor(size),
          )),
          SizedBox(
            width: 10,
          ),
          Text(
            'Orden sugerida',
            style: TextStyle(
                color: ConstantesColores.azul_precio,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
              child: Container(
            child: _separadorColor(size),
          )),
        ],
      ),
    );
  }

  Widget _separadorColor(size) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      width: size.width * 0.8,
      padding: EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            //                   <--- left side
            color: ConstantesColores.azul_precio,
            width: 0.9,
          ),
        ),
      ),
    );
  }

  Widget _botoCarrito() {
    return Container(
      padding: EdgeInsets.only(top: 16),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(HexColor("#30C3A3")),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ))),
        child: Text(
          'Ir a mi carrito',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
        ),
        onPressed: () {
          pasarCarrito();
        },
      ),
    );
  }

  pasarCarrito() {
    if (prefs.usurioLogin == -1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CarritoCompras(numEmpresa: prefs.numEmpresa)),
      );
    }
  }

  Widget _ordenSugerida(size, cartProvider, providerDatos) {
    return Column(
      children: [
        _tabs(size),
        _sugerencia(size),
        _tarjetaCantidades(size, cartProvider, providerDatos),
        _botonGigante(size),
        _tarjetaCantidadesSugeridas(size, cartProvider, providerDatos),
        SizedBox(
          height: 20,
        )
      ],
    );
  }

  Future pickDateRange(BuildContext context) async {
    DateTime now = new DateTime.now();
    DateTimeRange dateRange;
    final newDateRange = await showDateRangePicker(
      locale: const Locale("es", ""),
      context: context,
      firstDate: DateTime(2021, 1, 1),
      currentDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year, now.month, now.day),
    );
    if (newDateRange == null) return;
    dateRange = newDateRange;
    setState(() {
      fechaInicial = dateRange.start.toString();
      fechaFinal = dateRange.end.toString();
    });
  }

  Widget _ultimaOrden(Size size, cartProvider) {
    final providerDatos = Provider.of<DatosListas>(context);

    return FutureBuilder(
        future: providerDatos.getListaHistoricosHelper(
            filtro, fechaInicial, fechaFinal),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            var datos = snapshot.data;
            return Center(
                child: Container(
                    width: size.width * 0.9,
                    padding: EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        _tabs(size),
                        _buscador(size),
                        _selecciona(size),
                        for (int i = 0; i < datos!.length; i++)
                          Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              width: size.width * 0.9,
                              margin: EdgeInsets.only(bottom: 14),
                              child: ExpansionCardLast(
                                  historico: datos[i],
                                  cartProvider: cartProvider,
                                  providerDatos: providerDatos)),
                      ],
                    )));
          } else {
            return Text("No hay registros encontrados");
          }
        });
  }

  Widget _selecciona(Size size) {
    return Container(
      padding: EdgeInsets.only(bottom: 20, top: 14),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            width: size.width * 0.9,
            child: Text(
              "Seleccionar una de tus últimas ordenes para hacer un pedido rapido. ",
              textAlign: TextAlign.justify,
            ),
          )
        ],
      ),
    );
  }

  Widget _buscador(size) {
    return Container(
      width: size.width * 0.9,
      child: Row(
        children: [
          Container(
              width: size.width * 0.7,
              decoration: BoxDecoration(
                color: HexColor("#E4E3EC"),
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.only(right: 20.0),
              child: TextField(
                onChanged: (value) => {
                  setState(() => {
                        if (_filtroController.text == "")
                          {this.filtro = "-1"}
                        else
                          {this.filtro = _filtroController.text}
                      })
                },
                controller: _filtroController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 10),
                  border: InputBorder.none,
                  hintText: "Buscar Pedidos",
                  suffixIcon: Icon(
                    Icons.search,
                    color: HexColor("#43398E"),
                    size: 36,
                  ),
                ),
                textAlign: TextAlign.left,
                textAlignVertical: TextAlignVertical.center,
              )),
          GestureDetector(
            onTap: () => {pickDateRange(context)},
            child: Container(
              color: Colors.white,
              child: Icon(
                Icons.calendar_today_outlined,
                color: HexColor("#43398E"),
                size: 32,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _cargarSugeridos(
      List<dynamic> datos, size, cartProvider, providerDatos) {
    return Column(
      children: [
        for (int i = 0; i < datos.length; i++)
          ColumnTable(
              sugerido: datos[i],
              cartProvider: cartProvider!,
              providerDatos: providerDatos),
        _separador(size),
      ],
    );
  }

  bool _existeSugerido(providerDatos, producto) {
    for (int i = 0; i < providerDatos.getListaSugueridoHelper.length; i++) {
      if (providerDatos.getListaSugueridoHelper[i]!.codigo == producto) {
        return true;
      }
    }
    return false;
  }

  // Widget _tarjetaUltimaOrden(size) {
  //   return Container(
  //     padding: EdgeInsets.only(top: 16, bottom: 16),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(10),
  //       color: Colors.white,
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey.withOpacity(0.5),
  //           spreadRadius: 5,
  //           blurRadius: 7,
  //           offset: Offset(0, 3), // changes position of shadow
  //         ),
  //       ],
  //     ),
  //     width: size.width * 0.9,
  //     child: Column(
  //       children: [
  //         Table(columnWidths: {
  //           1: FractionColumnWidth(.3)
  //         }, children: [
  //           TableRow(
  //             children: [
  //               Container(
  //                 // color: Colors.white,
  //                 alignment: Alignment.centerLeft,
  //                 child: Container(
  //                   padding: EdgeInsets.only(left: 12),
  //                   child: Column(
  //                     children: [
  //                       Text(
  //                         "Orden Pideky 56789-0",
  //                         style: TextStyle(
  //                             fontSize: 15,
  //                             fontWeight: FontWeight.bold,
  //                             color: Colors.black),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               Container(
  //                 // color: Colors.green,
  //                 child: Row(
  //                   children: [
  //                     Container(
  //                       // color: Colors.yellow,
  //                       child: Icon(
  //                         Icons.clean_hands,
  //                         color: HexColor("#30C3A3"),
  //                       ),
  //                     ),
  //                     Container(
  //                       width: 10,
  //                     ),
  //                     Container(
  //                       color: Colors.white,
  //                       child: Text(
  //                         "Entregado",
  //                         style: TextStyle(fontSize: 10),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 // color: Colors.yellow,
  //               )
  //             ],
  //           ),
  //         ]),
  //         Table(
  //           children: [
  //             // TableRow(
  //             //   children: [AnimatedContainerCard()],
  //             // ),
  //             // TableRow(
  //             //   children: [AnimatedContainerCard()],
  //             // ),
  //             // TableRow(
  //             //   children: [AnimatedContainerCard()],
  //             // ),
  //           ],
  //         ),
  //         _separador(size),
  //         Container(
  //           // color: Colors.red,
  //           width: size.width * 0.9,
  //           margin: const EdgeInsets.only(top: 8.0),
  //           padding: EdgeInsets.only(right: 10),
  //           alignment: Alignment.centerRight,
  //           child: Container(
  //             width: 124,
  //             child: ElevatedButton(
  //               style: ButtonStyle(
  //                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
  //                       RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(18.0),
  //                           side: BorderSide(
  //                               color: HexColor("#43398E"), width: 1.0)))),
  //               child: Row(
  //                 children: [
  //                   Text(
  //                     'Pedir',
  //                     style: TextStyle(color: HexColor("#43398E")),
  //                   ),
  //                   Icon(
  //                     Icons.car_rental,
  //                     color: HexColor("#30C3A3"),
  //                   )
  //                 ],
  //               ),
  //               onPressed: () {},
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _separador(size) {
  //   return AnimatedContainer(
  //     duration: Duration(milliseconds: 500),
  //     width: size.width * 0.8,
  //     padding: EdgeInsets.only(left: 16, right: 16),
  //     decoration: BoxDecoration(
  //       border: Border(
  //         bottom: BorderSide(
  //           //                   <--- left side
  //           color: HexColor("#EAE8F5"),
  //           width: 0.5,
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
