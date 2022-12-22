// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:emart/src/controllers/controller_historico.dart';
import 'package:emart/src/pages/carrito/carrito_compras.dart';
import 'package:emart/src/pages/historico/widgets/filtro_historico.dart';
import 'package:emart/src/pages/login/login.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:emart/src/provider/datos_listas_provider.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/utils/util.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:emart/src/widget/column_table_car.dart';
import 'package:emart/src/provider/logica_actualizar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import '../../../_pideky/domain/producto/model/producto.dart';
import '../../../_pideky/domain/producto/service/producto_service.dart';
import '../../../_pideky/infrastructure/productos/producto_repository_sqlite.dart';
import '../../../_pideky/presentation/widgets/boton_agregar_carrito.dart';
import '../../controllers/cambio_estado_pedido.dart';
import '../../modelos/historico.dart';
import '../../provider/db_provider_helper.dart';
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
  final controllerHistorico = Get.find<ControllerHistorico>();
  final controlador = Get.find<CambioEstadoProductos>();
  ProductoService productService = ProductoService(ProductoRepositorySqlite());
  @override
  void initState() {
    super.initState();
    validarVersionActual(context);
    //FIREBASE: Llamamos el evento select_content
    TagueoFirebase().sendAnalityticSelectContent(
        "Footer", "PedidoRapido", "", "", "PedidoRapido", 'MainActivity');
    //UXCam: Llamamos el evento selectFooter
    UxcamTagueo().selectFooter('Pedido Rápido');
    controllerHistorico.inicializarController();
  }

  int seleccion = 1;
  String filtro = "-1";

  @override
  Widget build(BuildContext context) {
    //Se define el nombre de la pantalla para UXCAM
    FlutterUxcam.tagScreenName('QuickOrderPage');
    CarroModelo cartProvider = Provider.of<CarroModelo>(context);
    DatosListas providerDatos = Provider.of<DatosListas>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      color: ConstantesColores.color_fondo_gris,
      child: RefreshIndicator(
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
      ),
    ));
  }

  Widget _tabs(size) {
    return Container(
        width: size.width * 0.9,
        child: Table(
          columnWidths: {
            0: FlexColumnWidth(4),
            1: FlexColumnWidth(0.1),
            2: FlexColumnWidth(4),
          },
          children: [
            TableRow(children: [
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

  Widget _ultimaOrden(Size size, cartProvider, DatosListas providerDatos) {
    return Obx(() => FutureBuilder(
        initialData: [],
        future: providerDatos.getListaHistoricosHelper(
            filtro,
            controllerHistorico.fechaInicial.value,
            controllerHistorico.fechaFinal.value),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            var datos = snapshot.data;
            return Center(
                child: Container(
                    width: size.width,
                    padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
                    child: Column(
                      children: [
                        _tabs(size),
                        _buscador(size),
                        _selecciona(size),
                        Container(
                          padding: EdgeInsets.only(bottom: 45),
                          height: size.height * 0.62,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListView.builder(
                            itemCount: datos?.length,
                            itemBuilder: (BuildContext context, int position) {
                              return Column(
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                      ),
                                      width: size.width * 0.9,
                                      margin: EdgeInsets.only(top: 5),
                                      child: ExpansionCardLast(
                                          historico: datos![position],
                                          cartProvider: cartProvider,
                                          providerDatos: providerDatos)),
                                  BotonAgregarCarrito(
                                    color: HexColor("#42B39C"),
                                    height: 40,
                                    width: 190,
                                    onTap: () async {
                                      _cargarPedido(
                                        datos[position].numeroDoc,
                                        providerDatos,
                                      );
                                    },
                                    text: 'Agregar al carrito',
                                  ),
                                  SizedBox(
                                    height: 5,
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    )));
          } else {
            return Text("No hay registros encontrados");
          }
        }));
  }

  Widget _selecciona(Size size) {
    return Container(
      padding: EdgeInsets.only(bottom: 20, top: 14),
      alignment: Alignment.center,
      child: Text(
        "Seleccionar una de tus últimas órdenes para hacer un pedido rápido.",
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 15,
          fontFamily: "RoundedMplus1c-Medium.ttf",
          color: Color(0xff707070),
        ),
      ),
    );
  }

  Widget _buscador(size) {
    return Container(
      width: size.width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              width: size.width * 0.75,
              decoration: BoxDecoration(
                color: HexColor("#E4E3EC"),
                borderRadius: BorderRadius.circular(45),
              ),
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
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FiltroHistorico(
                          controlerFiltro: controllerHistorico,
                        ))),
            child: Container(
                color: Colors.transparent,
                child: Image.asset(
                  'assets/icon/calendario.png',
                  width: 35,
                )),
          )
        ],
      ),
    );
  }

  _cargarPedido(
    String numeroDoc,
    providerDatos,
  ) async {
    List<Historico> datosDetalle =
        await DBProviderHelper.db.consultarDetallePedido(numeroDoc);
    cargarCadaProducto(datosDetalle);
    await PedidoEmart.iniciarProductosPorFabricante();
    actualizarEstadoPedido(providerDatos, numeroDoc);
  }

  mas(String prod, int cantidad, String numeroDoc, Historico historico) async {
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
        if (controlador.mapaHistoricos.containsKey(historico.numeroDoc)) {
          controlador.mapaHistoricos
              .update(historico.numeroDoc, (value) => true);
        } else {
          controlador.mapaHistoricos.addAll({historico.numeroDoc: true});
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
          "${element.numeroDoc}", element);
    });
  }

  bool _existeSugerido(providerDatos, producto) {
    for (int i = 0; i < providerDatos.getListaSugueridoHelper.length; i++) {
      if (providerDatos.getListaSugueridoHelper[i]!.codigo == producto) {
        return true;
      }
    }
    return false;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
