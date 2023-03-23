// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/_pideky/presentation/productos/view_model/producto_view_model.dart';
import 'package:emart/src/classes/producto_cambiante.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/modelos/fabricantes.dart';
import 'package:emart/_pideky/domain/producto/model/producto.dart';
import 'package:emart/src/pages/principal_page/tab_opciones.dart';
import 'package:emart/src/pages/principal_page/widgets/custom_buscador_fuzzy.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/metodo_ingresados.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/provider/db_provider_helper.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/utils/util.dart';
import 'package:emart/src/pages/carrito/configurar_pedido.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:emart/src/widget/custom_expansion_panel_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:imagebutton/imagebutton.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

bool cargarDeNuevo = false;
final prefs = new Preferencias();
late ProgressDialog pr;
RxBool isValid = false.obs;
//late CarroModelo cartProvider;

class CarritoCompras extends StatefulWidget {
  final int numEmpresa;

  const CarritoCompras({Key? key, required this.numEmpresa}) : super(key: key);

  @override
  State<CarritoCompras> createState() => _CarritoComprasState();
}

class _CarritoComprasState extends State<CarritoCompras> {
  final cargoConfirmar = Get.find<CambioEstadoProductos>();
  ProductoViewModel productoViewModel = Get.find();
  late final cartProvider = Provider.of<CarroModelo>(context);

  @override
  void initState() {
    super.initState();
    //UXCAM: Se define el nombre de la interfaz
    FlutterUxcam.tagScreenName('ShoppingCart');
    cargarDeNuevo = false;
    PedidoEmart.iniciarProductosPorFabricante();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MetodosLLenarValores().calcularValorTotal(cartProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    //UXCAM: Se define el nombre de la pantalla
    FlutterUxcam.tagScreenName('ShoppingCartPage');

    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Haz tu pedido',
              style: TextStyle(color: HexColor("#41398D"))),
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back_ios, color: HexColor("#30C3A3")),
              onPressed: () => {
                    PedidoEmart.cambioVista.value = 1,
                    cartProvider.guardarCambiodevista = 1,
                    Navigator.of(context).pop()
                  }),
          elevation: 0,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  child: GestureDetector(
                    onTap: () => {_configurarPedido(size, cartProvider)},
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: HexColor("#42B39C"),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: Get.height * 0.08,
                      width: Get.width * 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Realizar pedido',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: Get.height * 0.18,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                            'Total: ${productoViewModel.getCurrency(cartProvider.getTotal)}',
                            style: disenoValores()),
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
              ),
              Expanded(
                flex: 3,
                child: Container(
                  height: Get.height * 0.8,
                  child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            _cargarWidgetDinamicoAcordeon(context, cartProvider)
                                .toList()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle disenoValores() => TextStyle(
      fontSize: 15.0, color: HexColor("#43398E"), fontWeight: FontWeight.bold);

  List<Widget> _cargarWidgetDinamicoAcordeon(
      BuildContext context1, CarroModelo cartProvider) {
    List<Widget> listaWidget = [];
    try {
      PedidoEmart.listaProductosPorFabricante!.forEach((fabricante, value) {
        if (value['precioProducto'] == 0.0) {
        } else {
          listaWidget.add(
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: CustomExpansionPanelList(
                expansionCallback: (int i, bool status) {
                  setState(() {
                    PedidoEmart.listaProductosPorFabricante!
                        .forEach((key, value) {
                      if (key != fabricante) {
                        value["expanded"] = false;
                      }
                    });
                    value["expanded"] = !status;
                    cargarDeNuevo = false;
                  });
                },
                children: [
                  ExpansionPanel(
                    canTapOnHeader: true,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 70,
                              width: 70,
                              alignment: Alignment.center,
                              child: CachedNetworkImage(
                                  imageUrl:
                                      PedidoEmart.listaProductosPorFabricante![
                                          fabricante]["imagen"],
                                  placeholder: (context, url) => Image.asset(
                                      'assets/image/jar-loading.gif'),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                          'assets/image/logo_login.png'),
                                  fit: BoxFit.cover),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width / 3,
                                child: Text(
                                    cartProvider.getListaFabricante[
                                                fabricante] ==
                                            null
                                        ? '${productoViewModel.getFormat().currencySymbol}: 0'
                                        : productoViewModel.getCurrency(
                                            cartProvider.getListaFabricante[
                                                fabricante]["precioFinal"]),
                                    style: TextStyle(
                                        color: ConstantesColores.azul_precio,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold))),
                          ],
                        ),
                      );
                    },
                    body: Container(
                      constraints: BoxConstraints(
                          minHeight: 50, maxWidth: double.infinity),
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Visibility(
                              visible: getVisibilityMessage(
                                  fabricante,
                                  cartProvider.getListaFabricante[fabricante]
                                      ["precioFinal"],
                                  value["preciominimo"],
                                  value["topeMinimo"]),
                              child: Container(
                                padding: EdgeInsets.fromLTRB(20, 2, 10, 2),
                                child: Row(
                                  children: [
                                    Obx(() => Visibility(
                                          visible: isValid.value,
                                          child: SvgPicture.asset(
                                            'assets/image/alerta_pedido_inferio.svg',
                                            color: value['restrictivofrecuencia'] ==
                                                            0 &&
                                                        value['isFrecuencia'] ==
                                                            true ||
                                                    value['restrictivonofrecuencia'] ==
                                                            0 &&
                                                        value['isFrecuencia'] ==
                                                            false
                                                ? HexColor("#42B39C")
                                                : Colors.red,
                                          ),
                                        )),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        margin:
                                            EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        child: Center(
                                            child: Text(
                                          textAlertCompany(
                                              fabricante,
                                              cartProvider.getListaFabricante[
                                                  fabricante]["precioFinal"],
                                              value["preciominimo"],
                                              value["topeMinimo"],
                                              productoViewModel
                                                  .getFormat()
                                                  .currencySymbol,
                                              value["iva"],
                                              value['restrictivo'],
                                              value['restrictivofrecuencia'],
                                              value['restrictivonofrecuencia'],
                                              value["diasVisita"],
                                              value["isFrecuencia"],
                                              value["texto1"]),
                                          style: TextStyle(
                                              color: value['restrictivofrecuencia'] ==
                                                              0 &&
                                                          value['isFrecuencia'] ==
                                                              true ||
                                                      value['restrictivonofrecuencia'] ==
                                                              0 &&
                                                          value['isFrecuencia'] ==
                                                              false
                                                  ? Colors.black.withOpacity(.7)
                                                  : Colors.red,
                                              fontWeight: FontWeight.bold),
                                        )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              constraints: BoxConstraints(
                                  minHeight: 150,
                                  maxHeight: 250,
                                  maxWidth: double.infinity),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      child: Column(
                                        children: this
                                            .gridItem(
                                                value["items"],
                                                fabricante,
                                                context,
                                                cartProvider,
                                                value["preciominimo"])
                                            .toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    isExpanded: cargarDeNuevo ? true : value["expanded"],
                  )
                ],
              ),
            ),
          );
        }
      });

      return listaWidget;
    } catch (e) {
      print('ERRORR ---------- $e');
      return listaWidget;
    }
  }

  List<Widget> gridItem(List<dynamic> value, String fabricante,
      BuildContext context, CarroModelo cartProvider, precioMinimo) {
    List<Widget> result = [];
    List<Producto> listTag = [];

    final size = MediaQuery.of(context).size;

    value.forEach((product) {
      Producto productos = PedidoEmart.listaProductos![product.codigo]!;

      if (product.fabricante == fabricante && product.cantidad > 0) {
        listTag.add(productos);
        result
          ..add(Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Container(
              child: Row(
                children: [
                  Container(
                    width: size.width / 4,
                    child: GestureDetector(
                      onTap: () => {
                        cargoConfirmar.cambiarValoresEditex(
                            PedidoEmart.obtenerValor(productos)!),
                        cargoConfirmar.cargarProductoNuevo(
                            ProductoCambiante.m(
                                productos.nombre, productos.codigo),
                            1),
                        PedidoEmart.cambioVista.value = 1,
                        cartProvider.guardarCambiodevista = 1,
                        Navigator.popAndPushNamed(
                            context, 'detalle_compra_producto'),
                      },
                      child: Text(
                        product.nombre,
                        style: TextStyle(color: ConstantesColores.verde),
                      ),
                    ),
                  ),
                  Container(
                    width: size.width / 3,
                    child: Row(
                      children: [
                        SizedBox(
                          height: 40.0,
                          width: 40.0,
                          child: IconButton(
                            icon: Image.asset('assets/image/menos.png'),
                            onPressed: () => {
                              menos(product.productos, cartProvider, fabricante,
                                  precioMinimo),
                            },
                          ),
                        ),
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
                              child: TextFormField(
                                maxLines: 1,
                                controller: PedidoEmart
                                    .listaControllersPedido![product.codigo],
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                maxLength: 3,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black),
                                onChanged: (value) => editarCantidad(
                                    product, cartProvider, value),
                                decoration: InputDecoration(
                                  fillColor: Colors.black,
                                  hintText: '0',
                                  counterText: "",
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40.0,
                          width: 40.0,
                          child: IconButton(
                            icon: Image.asset('assets/image/mas.png'),
                            onPressed: () =>
                                mas(product.productos, cartProvider),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10.0),
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Text(
                        productoViewModel.getCurrency(product
                                    .productos.descuento !=
                                0
                            ? (toInt(PedidoEmart
                                    .listaControllersPedido![product.codigo]!
                                    .text) *
                                product.productos.precio)
                            : (toInt(PedidoEmart
                                    .listaControllersPedido![product.codigo]!
                                    .text) *
                                product.productos.preciodescuento)),
                        style: disenoValores(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ));
      }
    });

    result.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          dialogVaciarCarrito(fabricante, cartProvider, value, precioMinimo);
        },
        child: Row(
          children: [
            Icon(
              Icons.delete_outline,
              color: HexColor("#42B39C"),
            ),
            Text(
              "Vaciar carrito",
              style: TextStyle(
                  color: HexColor("#42B39C"),
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    ));

    result
      ..add(Container(
        height: 80,
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: ImageButton(
                children: <Widget>[],
                width: 250,
                height: 35,
                paddingTop: 5,
                pressedImage: Image.asset(
                  "assets/image/seguir_comprando_btn_detalle-white.png",
                ),
                unpressedImage: Image.asset(
                    "assets/image/seguir_comprando_btn_detalle-white.png"),
                onTap: () async {
                  PedidoEmart.cambioVista.value = 1;
                  cartProvider.guardarCambiodevista = 1;
                  Navigator.pop(context);
                  List<Fabricantes> fabricanteSeleccionado =
                      await DBProvider.db.consultarFricante(fabricante);

                  _onClickCatalogo(
                      fabricanteSeleccionado[0].empresa!,
                      context,
                      cartProvider,
                      fabricanteSeleccionado[0].nombrecomercial!,
                      fabricanteSeleccionado[0].icono!);
                },
              ),
            )
          ],
        ),
      ));
    //FIREBASE: Llamamos el evento view_cart
    TagueoFirebase()
        .sendAnalityticViewCart(cartProvider, listTag, 'CarritoCompras');
    return result;
  }

  _onClickCatalogo(String codigo, BuildContext context, CarroModelo provider,
      String nombre, String icono) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CustomBuscardorFuzzy(
                  codCategoria: codigo,
                  numEmpresa: 'nutresa',
                  tipoCategoria: 4,
                  nombreCategoria: nombre,
                  img: icono,
                  locacionFiltro: "categoria",
                  codigoProveedor: "",
                )));
  }

  void dialogVaciarCarrito(String fabricante, CarroModelo cartProvider,
      List<dynamic> listProductos, precioMinimo) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Advertencia'),
            content: Text('Está seguro de vaciar el carrito?'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.black),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    //UXCam: Llamamos el evento emptyToCart
                    UxcamTagueo().emptyToCart(
                        fabricante, cartProvider, listProductos, precioMinimo);
                    //FIREBASE: Llamamos el evento delete_cart
                    TagueoFirebase().sendAnalityticDeleteCart("2", "Delete");
                    vaciarProductosFabricante(fabricante);
                  },
                  child: Text(
                    'Aceptar',
                    style: TextStyle(color: Colors.black),
                  )),
            ],
          );
        });
  }

  vaciarProductosFabricante(String fabricante) {
    PedidoEmart.listaProductos!.forEach((key, value) {
      if (value.fabricante == fabricante) {
        PedidoEmart.listaControllersPedido![value.codigo]!.text = "0";
        PedidoEmart.registrarValoresPedido(value, "1", false);
        //eliminamos el pedido de la temporal
        productoViewModel.eliminarProductoTemporal(value.codigo);
        cargarDeNuevo = true;
      }
    });
    PedidoEmart.iniciarProductosPorFabricante();
    cargoConfirmar.mapaHistoricos.updateAll((key, value) => value = false);
    MetodosLLenarValores().calcularValorTotal(cartProvider);
  }

  editarCantidad(dynamic producto, CarroModelo cartProvider, String cantidad) {
    if (cantidad != "" && int.parse(cantidad) > 0) {
      PedidoEmart.listaControllersPedido![producto.codigo]!.text = cantidad;
      PedidoEmart.registrarValoresPedido(producto.productos, cantidad, true);
    } else {
      PedidoEmart.registrarValoresPedido(producto.productos, "1", false);
      PedidoEmart.listaValoresPedido![producto.codigo] = "";
      PedidoEmart.listaControllersPedido![producto.codigo]!.text = "0";
      cargarDeNuevo = true;
      PedidoEmart.iniciarProductosPorFabricante();
    }
    MetodosLLenarValores().calcularValorTotal(cartProvider);

    setState(() {});
  }

  mas(Producto producto, CarroModelo cartProvider) {
    String valorInicial = PedidoEmart.obtenerValor(producto)!;

    if (valorInicial.length < 3) {
      if (valorInicial == "") {
        PedidoEmart.listaControllersPedido![producto.codigo]!.text = "1";
        PedidoEmart.registrarValoresPedido(producto, '1', true);
      } else {
        int valoSuma = int.parse(valorInicial) + 1;
        setState(() {
          PedidoEmart.listaControllersPedido![producto.codigo]!.text =
              "$valoSuma";
          PedidoEmart.registrarValoresPedido(producto, '$valoSuma', true);
        });
      }
      productoViewModel.insertarPedidoTemporal(producto.codigo);
      MetodosLLenarValores().calcularValorTotal(cartProvider);
    }
  }

  menos(Producto producto, CarroModelo cartProvider, String fabricante,
      precioMinimo) {
    String valorInicial = PedidoEmart.obtenerValor(producto)!;

    if (valorInicial == "") {
    } else {
      int valorResta = int.parse(valorInicial) - 1;
      if (valorResta <= 0) {
        PedidoEmart.listaControllersPedido![producto.codigo]!.text = "0";
        PedidoEmart.registrarValoresPedido(producto, '1', false);
        cargarDeNuevo = true;
        PedidoEmart.iniciarProductosPorFabricante();
        // eliminar producto de la temporal
        productoViewModel.eliminarProductoTemporal(producto.codigo);
        setState(() {});
      } else {
        PedidoEmart.listaControllersPedido![producto.codigo]!.text =
            "$valorResta";
        PedidoEmart.registrarValoresPedido(producto, '$valorResta', true);
        setState(() {});
        //UXCam: Llamamos el evento removeToCart
        UxcamTagueo()
            .removeToCart(producto, valorResta, cartProvider, precioMinimo);
        // modificar producto de la temporal
        productoViewModel.insertarPedidoTemporal(producto.codigo);
      }
    }
    //FIREBASE: Llamamos el evento remove_from_cart
    TagueoFirebase().sendAnalityticRemoveFromCart(producto, '1');

    MetodosLLenarValores().calcularValorTotal(cartProvider);
  }

  _configurarPedido(size, CarroModelo cartProvider) {
    try {
      bool isFrecuencia =
          prefs.paisUsuario == 'CR' ? validarFrecuencia() : true;

      String fabricantes = _validarPedidosMinimos(cartProvider);
      if (_verificarCantidadGrupos() > 0) {
        if (fabricantes == "") {
          if (isFrecuencia) {
            //UXCam: Llamamos el evento clickPlaceOrder
            UxcamTagueo().clickPlaceOrder(cartProvider);
            _irConfigurarPedido();
          } else {
            PedidoEmart.listaProductosPorFabricante!
                .forEach((fabricante, value) {
              if (value['precioProducto'] != 0.0) {
                vaciarProductosFabricante(fabricante);
              }
            });
            productoViewModel.eliminarBDTemporal();
          }
        } else {
          if (_verificarCantidadGrupos() == fabricantes.split(",").length) {
            showLoaderDialog(
                context,
                size,
                _ningunGrupoCumple(context, size, fabricantes),
                Get.height * 0.40);
          } else {
            showLoaderDialog(
                context,
                size,
                _pedidoMinimoNoCumple(context, size, fabricantes, cartProvider),
                Get.height * 0.55);
          }
        }
      } else {
        showLoaderDialog(
            context,
            size,
            _noExistePedidosCargados(context, size, fabricantes),
            Get.height * 0.25);
      }
    } catch (error) {
      print("---CARRITO ERROR! $error");
    }
  }

  bool validarFrecuencia() {
    var res = true;
    PedidoEmart.listaProductosPorFabricante!.forEach((fabricante, value) {
      if (value['precioProducto'] != 0.0) {
        if (!productoViewModel.validarFrecuencia(fabricante)) {
          productoViewModel.iniciarModal(context, fabricante);
          res = false;
        }
      }
    });
    return res;
  }

  String _validarPedidosMinimos(CarroModelo cartProvider) {
    String listaFabricantesSinPedidoMinimo = "";
    PedidoEmart.listaProductosPorFabricante!.forEach((fabricante, value) {
      if (PedidoEmart.listaProductosPorFabricante![fabricante]
                      ["restrictivofrecuencia"] ==
                  1 &&
              PedidoEmart.listaProductosPorFabricante![fabricante]
                      ['isFrecuencia'] ==
                  true ||
          PedidoEmart.listaProductosPorFabricante![fabricante]
                      ["restrictivonofrecuencia"] ==
                  1 &&
              PedidoEmart.listaProductosPorFabricante![fabricante]
                      ['isFrecuencia'] ==
                  false) {
        if (value['precioProducto'] > 0.0) {
          if (cartProvider.getListaFabricante[fabricante]["precioFinal"] <
              PedidoEmart.listaProductosPorFabricante![fabricante]
                  ["preciominimo"]) {
            listaFabricantesSinPedidoMinimo += "," + fabricante;
          }
        }
      }
    });
    return listaFabricantesSinPedidoMinimo != ""
        ? listaFabricantesSinPedidoMinimo.substring(
            1, listaFabricantesSinPedidoMinimo.length)
        : listaFabricantesSinPedidoMinimo;
  }

  _pedidoMinimoNoCumple(context, size, fabricantes, cartProvider) {
    return FutureBuilder(
        future: DBProviderHelper.db.consultarNombreComercial(fabricantes),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            var proveedores =
                snapshot.data.substring(0, snapshot.data.length - 2);
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: ConstantesColores.agua_marina,
                  size: 74.0,
                ),
                Container(
                    height: Get.height * 0.4,
                    width: Get.width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(2),
                              width: Get.width * 0.7,
                              child: new RichText(
                                textAlign: TextAlign.center,
                                text: new TextSpan(
                                  text:
                                      "Recuerda que tu pedido llegará sin los productos de ",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                  children: <TextSpan>[
                                    new TextSpan(
                                      text: proveedores,
                                      style: TextStyle(
                                          color: ConstantesColores.agua_marina,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    new TextSpan(
                                      text:
                                          " porque no cumples con el pedido mínimo",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            _botonSeguirComprando(size, fabricantes),
                            _botonAceptar(size, fabricantes, cartProvider),
                          ],
                        )
                      ],
                    ))
              ],
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  showLoaderDialog(BuildContext context, size, Widget widget, double altura) {
    AlertDialog alert = AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24.0))),
        content: Container(
            height: altura,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.white,
            ),
            child: widget));
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget _botonSeguirComprando(size, fabricantes) {
    return GestureDetector(
      onTap: () => {
        Navigator.pop(context),
        //UXCam: Llamamos el evento clickAction
        UxcamTagueo().clickAction('Cancelar', fabricantes)
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
          borderRadius: BorderRadius.circular(20),
        ),
        height: 45,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.contain,
              child: Text('Cancelar y seguir comprando',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _botonAceptar(size, fabricantes, cartProvider) {
    return GestureDetector(
      onTap: () {
        _cancelarPedidosSinPedidoMinimo(
            fabricantes, cartProvider); //UXCam: Llamamos el evento clickAction
        UxcamTagueo().clickAction('Aceptar', fabricantes);
      },
      child: Container(
        width: size.width * 0.9,
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(
          top: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: ConstantesColores.azul_precio, width: 2.0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Aceptar',
                style: TextStyle(
                    color: ConstantesColores.azul_precio,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _botonAceptarNoCumplimiento(size, fabricantes) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: size.width * 1.2,
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(
          top: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: ConstantesColores.azul_precio, width: 2.0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Aceptar',
                style: TextStyle(
                    color: ConstantesColores.azul_precio,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _irConfigurarPedido() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ConfigurarPedido(numEmpresa: prefs.numEmpresa)));
  }

  void _cancelarPedidosSinPedidoMinimo(fabricantes, cartProvider) {
    Navigator.of(context).pop();
    List<String> listaFabricantes = fabricantes.split(",");
    listaFabricantes.forEach((fabricante) {
      if (fabricante != "") {
        PedidoEmart.listaProductos!.forEach((codigo, producto) {
          if (producto.fabricante == fabricante) {
            setState(() {
              PedidoEmart.listaControllersPedido![codigo]!.text = "0";
              PedidoEmart.registrarValoresPedido(producto, '1', false);
              PedidoEmart.calcularPrecioPorFabricante();
            });
          }
        });
      }
    });
    PedidoEmart.iniciarProductosPorFabricante();
    MetodosLLenarValores().calcularValorTotal(cartProvider);
    if (_verificarCantidadGrupos() > 0) {
      _irConfigurarPedido();
    }
  }

  int _verificarCantidadGrupos() {
    int cantidadFabricantes = 0;
    PedidoEmart.listaProductosPorFabricante!.forEach((key, value) {
      if (value['precioProducto'] > 0)
        cantidadFabricantes = cantidadFabricantes + 1;
    });

    return cantidadFabricantes;
  }

  Widget _ningunGrupoCumple(BuildContext context, size, String fabricantes) {
    var singulaPlural = fabricantes.split(",").length > 1
        ? 'de los proveedores'
        : 'del proveedor';
    return FutureBuilder(
        future: DBProviderHelper.db.consultarNombreComercial(fabricantes),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            var proveedores =
                snapshot.data.substring(0, snapshot.data.length - 2);
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: Get.height * 0.35,
                    width: Get.width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.red,
                              size: 74.0,
                            ),
                            Container(
                              margin: const EdgeInsets.all(2),
                              width: Get.width * 0.9,
                              child: new RichText(
                                textAlign: TextAlign.center,
                                text: new TextSpan(
                                  children: <TextSpan>[
                                    new TextSpan(
                                      style: TextStyle(
                                          color: ConstantesColores.azul_precio,
                                          fontSize: 18),
                                      text:
                                          "Tu pedido no fue finalizado. Continúa comprando para cumplir con el pedido mínimo",
                                    ),
                                    new TextSpan(
                                      text: " " + singulaPlural,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    new TextSpan(
                                      text: " " + proveedores,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            _botonAceptarNoCumplimiento(size, fabricantes),
                          ],
                        )
                      ],
                    ))
              ],
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Widget _noExistePedidosCargados(
      BuildContext context, size, String fabricantes) {
    String mensaje = "No existe ningún pedido cargado!";
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            height: Get.height * 0.12,
            width: Get.width * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(2),
                      width: Get.width * 0.7,
                      child: Text(
                        mensaje,
                        style: TextStyle(
                            color: ConstantesColores.azul_precio,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    _botonAceptarNoCumplimiento(size, fabricantes),
                  ],
                )
              ],
            ))
      ],
    );
  }

  bool getVisibilityMessage(String fabricante, double valorPedido,
      double precioMinimo, double topeMinimo) {
    if (fabricante.toUpperCase() == "MEALS") {
      return true;
    } else {
      if (valorPedido < precioMinimo) {
        return true;
      } else {
        return false;
      }
    }
  }

  String textAlertCompany(
      String fabricante,
      double valorPedido,
      double precioMinimo,
      double topeMinimo,
      String currentSymbol,
      double iva,
      String restrictivo,
      int restrictivoFrecuencia,
      int restrictivoNoFrecuencia,
      List diasVisita,
      bool isFrecuencia,
      String texto1) {
    // var calcular = topeMinimo * 1.19;

    String diasSinComa;
    String diasTemp = "";
    diasVisita.forEach((element) {
      diasTemp += "$element, ";
    });
    diasSinComa = diasTemp.substring(0, diasTemp.length - 2);

    if (restrictivoFrecuencia == 0 && isFrecuencia == true) {
      if (valorPedido < precioMinimo) {
        isValid.value = true;
        return texto1;
      }
      isValid.value = true;
      return "Tu pedido será entregado el siguiente día hábil.";
    } else {
      if (isFrecuencia == true) {
        if (precioMinimo == 0) {
          isValid.value = false;
          return "";
        }
        if (valorPedido < precioMinimo) {
          isValid.value = true;
          return 'Para que tu pedido sea entregado debes cumplir una compra mínima de ' +
              productoViewModel.getCurrency(precioMinimo);
        }
      } else {
        if (precioMinimo == 0) {
          isValid.value = false;
          return "";
        }
        if (valorPedido < precioMinimo) {
          isValid.value = true;
          return "El pedido será entregado en 1 día hábil si cumples con una compra mínima de ${productoViewModel.getCurrency(precioMinimo)}, de lo contrario, deberás hacer tu pedido los días asignados que son los $diasSinComa.";
        } else {
          return "Tu pedido será entregado el siguiente día hábil.";
        }
      }
      isValid.value = false;
      return "";
    }
    // if (fabricante.toUpperCase() == "MEALS") {
    //   if (valorPedido < (topeMinimo * 1.19)) {
    //     return 'Si deseas que tu pedido sea entregado el siguiente día hábil realiza una compra mínima de : $currentSymbol ' +
    //         formatNumber.format(((calcular.toInt()))).replaceAll(',00', '');
    //   }
    //   return "Tu pedido será entregado el siguiente día hábil.";
    // } else {
    //   if (valorPedido < precioMinimo) {
    //     return 'El pedido no cumple con el mínimo valor que establece el proveedor : $currentSymbol ' +
    //         formatNumber.format(precioMinimo).replaceAll(',00', '');
    //   }
    //   return "";
    // }
  }
}
