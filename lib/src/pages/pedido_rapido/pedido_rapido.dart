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
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:emart/src/widget/boton_actualizar.dart';
import 'package:emart/src/widget/column_table_car.dart';
import 'package:emart/src/provider/logica_actualizar.dart';
import 'package:emart/src/widget/soporte.dart';
import 'package:emart/src/widget/titulo_pideky.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import '../../widget/acciones_carrito_bart.dart';
import '../../widget/column_table.dart';
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
    //UXCam: Llamamos el evento selectFooter
    UxcamTagueo().selectFooter('Pedido Rápido');
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
                  //UXCam: Llamamos el evento clickSoport
                  UxcamTagueo().clickSoport(),
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
            BotonActualizar(),
            AccionesBartCarrito(esCarrito: false),
          ],
        ),
        body: RefreshIndicator(
          color: ConstantesColores.azul_precio,
          backgroundColor: ConstantesColores.agua_marina.withOpacity(0.6),
          onRefresh: () async {
            await LogicaActualizar().actualizarDB();

            Navigator.pushReplacementNamed(
              context,
              'tab_opciones',
            ).timeout(Duration(seconds: 3));
            return Future<void>.delayed(const Duration(seconds: 3));
          },
          child: SingleChildScrollView(
              child: _ultimaOrden(size, cartProvider, providerDatos)),
        ));
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
                        width: 2,
                      ),
                    ],
                  )),
            ])
          ],
        ));
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

  Widget _ultimaOrden(Size size, cartProvider, providerDatos) {
    return FutureBuilder(
        initialData: [],
        future: providerDatos.getListaHistoricosHelper(
            filtro, fechaInicial, fechaFinal),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            var datos = snapshot.data;
            return Center(
                child: Container(
                    width: size.width,
                    padding: EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        _tabs(size),
                        _buscador(size),
                        _selecciona(size),
                        Container(
                          height: size.height * 0.8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: ListView.builder(
                            itemCount: datos?.length,
                            itemBuilder: (BuildContext context, int position) {
                              return Container(
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
                                  margin: EdgeInsets.only(
                                      bottom: 14, left: 10, right: 10, top: 5),
                                  child: ExpansionCardLast(
                                      historico: datos![position],
                                      cartProvider: cartProvider,
                                      providerDatos: providerDatos));
                            },
                          ),
                        ),
                        // for (int i = 0; i < datos!.length; i++)
                        //   Container(
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(10),
                        //         color: Colors.white,
                        //         boxShadow: [
                        //           BoxShadow(
                        //             color: Colors.grey.withOpacity(0.5),
                        //             spreadRadius: 5,
                        //             blurRadius: 7,
                        //             offset: Offset(
                        //                 0, 3), // changes position of shadow
                        //           ),
                        //         ],
                        //       ),
                        //       width: size.width * 0.9,
                        //       margin: EdgeInsets.only(bottom: 14),
                        //       child: ExpansionCardLast(
                        //           historico: datos[i],
                        //           cartProvider: cartProvider,
                        //           providerDatos: providerDatos)),
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
                        _filtroController.text == ""
                            ? this.filtro = "-1"
                            : this.filtro = _filtroController.text
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

  bool _existeSugerido(providerDatos, producto) {
    for (int i = 0; i < providerDatos.getListaSugueridoHelper.length; i++) {
      if (providerDatos.getListaSugueridoHelper[i]!.codigo == producto) {
        return true;
      }
    }
    return false;
  }
}
