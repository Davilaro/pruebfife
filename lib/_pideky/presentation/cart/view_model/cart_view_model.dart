import 'package:emart/_pideky/domain/product/model/product_model.dart';
import 'package:emart/_pideky/presentation/cart/widgets/private_alerts.dart';
import 'package:emart/_pideky/presentation/product/view_model/product_view_model.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/controllers/slide_up_automatic.dart';
import 'package:emart/src/pages/carrito/configurar_pedido.dart';
import 'package:emart/src/pages/principal_page/widgets/custom_buscador_fuzzy.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/metodo_ingresados.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/db_provider_helper.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class CartViewModel extends ChangeNotifier {
  double _precioTotal = 0;
  int cantidadItems = 0;
  Map<String, dynamic> _listaValorFabricante = new Map();
  int _cambioVista = 0;
  double _precioAhorro = 0;
  double _nuevoPrecioAhorro = 0;
  Map<String, dynamic> _frecuanciaFabricantes = new Map();
  bool loadAgain = false;
  ProductViewModel productoViewModel = Get.find();

  double get getTotal {
    return _precioTotal;
  }

  //--------------------------- AQUI SE LE DA INICIO A LOS GETTERS Y SETTERS---------------------------

  Map get getFrecuenciaFabricante => _frecuanciaFabricantes;

  void actualizarFrecuenciaFabricante(String fabricante, bool isFrecuancia) {
    _frecuanciaFabricantes[fabricante] = isFrecuancia;
  }

  set guardarValorCompra(double precio) {
    _precioTotal = precio;
    notifyListeners();
  }

  int get getCantidadItems {
    return cantidadItems;
  }

  set actualizarItems(int cantidad) {
    cantidadItems = cantidad;
    notifyListeners();
  }

  Map get getListaFabricante {
    return _listaValorFabricante;
  }

  set actualizarListaFabricante(Map<String, dynamic> fabricantes) {
    _listaValorFabricante = fabricantes;
    notifyListeners();
  }

  int get getCambiodevista {
    return _cambioVista;
  }

  set guardarCambiodevista(int vista) {
    _cambioVista = vista;
    notifyListeners();
  }

  double get getTotalAhorro {
    return _precioAhorro;
  }

  double get getNuevoTotalAhorro {
    return _nuevoPrecioAhorro;
  }

  set guardarValorAhorro(double precio) {
    _precioAhorro = precio;
    notifyListeners();
  }

  set setNuevoValorAhorro(double precio) {
    _nuevoPrecioAhorro = precio;
    notifyListeners();
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

  // ESTE METODO ES EL ENCARGADO DE MOSTRAR LOS MENSAJES DENTRO DEL PANEL EXPANDIDO DE CADA
  // FABRICANTE, ESTOS MENSAJES SON DE ALERTA PARA EL USUARIO
  String textAlertCompany(
      String acumuladoMontoMinimo,
      String fabricante,
      double valorPedido,
      double precioMinimo,
      String currentSymbol,
      int restrictivoFrecuencia,
      int restrictivoNoFrecuencia,
      List diasVisita,
      bool isFrecuencia,
      String texto1,
      String texto2,
      int itinerario,
      RxBool isValid) {
    // var calcular = topeMinimo * 1.19;
    String diasSinComa;
    String diasTemp = "";

    diasVisita.forEach((element) {
      diasTemp += "$element, ";
    });
    diasSinComa = diasTemp.substring(
        0, diasTemp.length - 2 < 0 ? 0 : diasTemp.length - 2);

    if (itinerario == 1) {
      if (precioMinimo != 0) {
        if (valorPedido < precioMinimo) {
          isValid.value = true;
          return 'Recuerda que tu pedido mínimo  debe ser superior a ${productoViewModel.getCurrency(precioMinimo)}.';
        }
      }
      isValid.value = false;
      return "";
    } else {
      if (restrictivoFrecuencia == 0 && isFrecuencia == false ||
          restrictivoNoFrecuencia == 0 && isFrecuencia == false) {
        if (valorPedido < precioMinimo) {
          isValid.value = true;
          return 'Recuerda que tu pedido mínimo  debe ser superior a ${productoViewModel.getCurrency(precioMinimo)}';
        }
        isValid.value = false;
        return "";
      } else {
        if (isFrecuencia == true) {
          if (precioMinimo == 0) {
            isValid.value = false;
            return "";
          }
          if (valorPedido < precioMinimo) {
            isValid.value = true;
            return "Recuerda que tu pedido mínimo  debe ser superior a ${productoViewModel.getCurrency(precioMinimo)}";
          }
        } else {
          if (precioMinimo == 0) {
            isValid.value = false;
            return "";
          }
          if (valorPedido < precioMinimo) {
            isValid.value = true;
            return "¡Solo te falta $acumuladoMontoMinimo $texto2 $diasSinComa.";
          }
        }
        isValid.value = false;
        return "";
      }
    }
  }

  // ESTE METODO Y EL DE MENOS, SON LOS ENCARGADOS DE AUMENTAR O DISMINUIR LA CANTIDAD DE PRODUCTOS
  mas(Product producto, CartViewModel cartProvider, VoidCallback setState) {
    String valorInicial = PedidoEmart.obtenerValor(producto)!;

    if (valorInicial.length < 3) {
      if (valorInicial == "") {
        PedidoEmart.listaControllersPedido![producto.codigo]!.text = "1";
        PedidoEmart.registrarValoresPedido(producto, '1', true);
      } else {
        int valoSuma = int.parse(valorInicial) + 1;

        PedidoEmart.listaControllersPedido![producto.codigo]!.text =
            "$valoSuma";
        PedidoEmart.registrarValoresPedido(producto, '$valoSuma', true);
        setState();
      }
      productoViewModel.insertarPedidoTemporal(producto.codigo);
      MetodosLLenarValores().calcularValorTotal(cartProvider);
    }
  }

  menos(Product producto, String fabricante, precioMinimo,
      VoidCallback setState, CartViewModel cartViewModel) {
    String valorInicial = PedidoEmart.obtenerValor(producto)!;
    final slideUpAutomatic = Get.find<SlideUpAutomatic>();
    if (valorInicial == "") {
    } else {
      int valorResta = int.parse(valorInicial) - 1;
      if (valorResta <= 0) {
        slideUpAutomatic.mostrarSlide(producto.negocio);
        PedidoEmart.listaControllersPedido![producto.codigo]!.text = "0";
        PedidoEmart.registrarValoresPedido(producto, '1', false);
        loadAgain = true;
        PedidoEmart.iniciarProductosPorFabricante();
        // eliminar producto de la temporal
        productoViewModel.eliminarProductoTemporal(producto.codigo);
        setState();
      } else {
        PedidoEmart.listaControllersPedido![producto.codigo]!.text =
            "$valorResta";
        PedidoEmart.registrarValoresPedido(producto, '$valorResta', true);
        setState();
        //UXCam: Llamamos el evento removeToCart
        UxcamTagueo()
            .removeToCart(producto, valorResta, cartViewModel, precioMinimo);
        // modificar producto de la temporal
        productoViewModel.insertarPedidoTemporal(producto.codigo);
      }
    }
    //FIREBASE: Llamamos el evento remove_from_cart
    TagueoFirebase().sendAnalityticRemoveFromCart(producto, '1');

    MetodosLLenarValores().calcularValorTotal(cartViewModel);
  }

  // ESTE METODO EDITA LA CANTIDAD DE PRODUCTOS MANUALMENTE
  editarCantidad(dynamic producto, CartViewModel cartProvider, String cantidad,
      VoidCallback setState) {
    if (cantidad != "" && int.parse(cantidad) > 0) {
      PedidoEmart.listaControllersPedido![producto.codigo]!.text = cantidad;
      PedidoEmart.registrarValoresPedido(producto.productos, cantidad, true);
    } else {
      PedidoEmart.registrarValoresPedido(producto.productos, "1", false);
      PedidoEmart.listaValoresPedido![producto.codigo] = "";
      PedidoEmart.listaControllersPedido![producto.codigo]!.text = "0";
      loadAgain = true;
      PedidoEmart.iniciarProductosPorFabricante();
    }
    MetodosLLenarValores().calcularValorTotal(cartProvider);

    setState();
  }

  // ESTE METODO VACIA EL CARRITO DE UN FABRICANTE
  vaciarProductosFabricante(String fabricante, CartViewModel cartViewModel) {
    final cargoConfirmar = Get.find<CambioEstadoProductos>();
    PedidoEmart.listaProductos!.forEach((key, value) {
      if (value.fabricante == fabricante) {
        PedidoEmart.listaControllersPedido![value.codigo]!.text = "0";
        PedidoEmart.registrarValoresPedido(value, "1", false);
        //eliminamos el pedido de la temporal
        productoViewModel.eliminarProductoTemporal(value.codigo);
        cartViewModel.loadAgain = true;
      }
    });
    PedidoEmart.iniciarProductosPorFabricante();
    cargoConfirmar.mapaHistoricos.updateAll((key, value) => value = false);
    MetodosLLenarValores().calcularValorTotal(cartViewModel);
  }

  // ESTE METODO LLEVA A LA SECCION DE PRODUCTOS PARA SEGUIR COMPRANDO
  onClickCatalogo(String codigo, BuildContext context, CartViewModel provider,
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

  // METODO ENCARGADO DE VALIDAR LA FRECUENCIA DE CADA USUARIO, PARA SABER SI PUEDE REALIZAR COMPRAS O NO
  bool validarFrecuencia(BuildContext context) {
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

  // METODO ENCARGADO DE VALIDAR SI EL PEDIDO MINIMO DE CADA FABRICANTE SE CUMPLE
  String validarPedidosMinimos(CartViewModel cartProvider) {
    String listaFabricantesSinPedidoMinimo = "";
    PedidoEmart.listaProductosPorFabricante!.forEach((fabricante, value) {
      if ((PedidoEmart.listaProductosPorFabricante![fabricante]
                      ["restrictivofrecuencia"] ==
                  1 &&
              PedidoEmart.listaProductosPorFabricante![fabricante]
                      ['isFrecuencia'] ==
                  true) ||
          (PedidoEmart.listaProductosPorFabricante![fabricante]
                      ["restrictivonofrecuencia"] ==
                  1 &&
              PedidoEmart.listaProductosPorFabricante![fabricante]
                      ['isFrecuencia'] ==
                  false)) {
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

  // METODO ENCARGADO DE RETORNAR LA CANTIDAD DE FABRICANTES EN EL CARRITO
  int verificarCantidadGrupos() {
    int cantidadFabricantes = 0;
    PedidoEmart.listaProductosPorFabricante!.forEach((key, value) {
      if (value['precioProducto'] > 0)
        cantidadFabricantes = cantidadFabricantes + 1;
    });

    return cantidadFabricantes;
  }

  // METODO ENCARGADO  DE NAVEGAR A LA PANTALLA DE CONFIGURACION DE PEDIDO
  void irConfigurarPedido(BuildContext context, prefs) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ConfigurarPedido(numEmpresa: prefs.numEmpresa)));
  }

  // METODO ENCARGADO DE MOSTRAR EL WIDGET CUANDO NINGUN PROVEEDOR CUMPLE CON LAS CONDICIONES DE NEGOCIO
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
                            botonAceptarNoCumplimiento(
                                size, fabricantes, context),
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

  // METODO ENCARGADO DE MOSTRAR EL WIDGET CUANDO EL PEDIDO NO CUMPLE CON LOS ESTANDARES MINIMOS REQUERIDOS POR EL NEGOCIO
  pedidoMinimoNoCumple(
      context, size, fabricantes, cartProvider, VoidCallback setState) {
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
                            _botonSeguirComprando(size, fabricantes, context),
                            _botonAceptar(size, fabricantes, cartProvider,
                                setState, context),
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
                    botonAceptarNoCumplimiento(size, fabricantes, context),
                  ],
                )
              ],
            ))
      ],
    );
  }

  void _cancelarPedidosSinPedidoMinimo(
      fabricantes, cartProvider, context, VoidCallback setState) {
    Navigator.of(context).pop();
    List<String> listaFabricantes = fabricantes.split(",");
    listaFabricantes.forEach((fabricante) {
      if (fabricante != "") {
        PedidoEmart.listaProductos!.forEach((codigo, producto) {
          if (producto.fabricante == fabricante) {
            PedidoEmart.listaControllersPedido![codigo]!.text = "0";
            PedidoEmart.registrarValoresPedido(producto, '1', false);
            PedidoEmart.calcularPrecioPorFabricante();
            setState();
          }
        });
      }
    });
    PedidoEmart.iniciarProductosPorFabricante();
    MetodosLLenarValores().calcularValorTotal(cartProvider);
    if (verificarCantidadGrupos() > 0) {
      irConfigurarPedido(context, prefs);
    }
  }

  // METODO ENCARGADO DE HACER LA CONFIGURACION DEL PEDIDO
  configurarPedido(size, CartViewModel cartProvider, Preferencias prefs,
      BuildContext context, VoidCallback setState) {
    try {
      bool isFrecuencia =
          prefs.paisUsuario == 'CR' ? validarFrecuencia(context) : true;

      String fabricantes = validarPedidosMinimos(cartProvider);
      if (verificarCantidadGrupos() > 0) {
        if (fabricantes == "") {
          if (isFrecuencia) {
            //UXCam: Llamamos el evento clickPlaceOrder
            UxcamTagueo().clickPlaceOrder(cartProvider);
            irConfigurarPedido(context, prefs);
          } else {
            PedidoEmart.listaProductosPorFabricante!
                .forEach((fabricante, value) {
              if (value['precioProducto'] != 0.0) {
                vaciarProductosFabricante(fabricante, cartProvider);
              }
            });
            productoViewModel.eliminarBDTemporal();
          }
        } else {
          if (verificarCantidadGrupos() == fabricantes.split(",").length) {
            showLoaderDialog(
                context,
                size,
                _ningunGrupoCumple(context, size, fabricantes),
                Get.height * 0.40);
          } else {
            showLoaderDialog(
                context,
                size,
                pedidoMinimoNoCumple(
                    context, size, fabricantes, cartProvider, setState),
                Get.height * 0.45);
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

  TextStyle valuesDesing() => TextStyle(
      fontSize: 15.0, color: HexColor("#43398E"), fontWeight: FontWeight.bold);

  llenarCarrito(Product producto, int cantidad, context) async {
    final cartProvider = Provider.of<CartViewModel>(context, listen: false);
    ProductViewModel productViewModel = Get.find();
    if (producto.codigo != "") {
      PedidoEmart.listaControllersPedido![producto.codigo]!.text = "$cantidad";
      PedidoEmart.registrarValoresPedido(producto, '$cantidad', true);
      MetodosLLenarValores().calcularValorTotal(cartProvider);
      productViewModel.insertarPedidoTemporal(producto.codigo);
    }
  }

  //----------------------------- METODOS ENCARGADOS DE MOSTRAR LOS BOTONES RESPECTIVOS---------------
  Widget _botonSeguirComprando(size, fabricantes, BuildContext context) {
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

  Widget _botonAceptar(
      size, fabricantes, cartProvider, VoidCallback setState, context) {
    return GestureDetector(
      onTap: () {
        _cancelarPedidosSinPedidoMinimo(fabricantes, cartProvider, context,
            setState); //UXCam: Llamamos el evento clickAction
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

  Widget botonAceptarNoCumplimiento(size, fabricantes, BuildContext context) {
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
}
