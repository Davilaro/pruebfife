// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:emart/_pideky/presentation/productos/view_model/producto_view_model.dart';
import 'package:emart/src/modelos/lista_sucursales_data.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/crear_file.dart';
import 'package:emart/src/provider/datos_listas_provider.dart';
import 'package:emart/src/provider/db_provider_helper.dart';
import 'package:emart/src/provider/servicios.dart';
import 'package:emart/src/utils/alertas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import '../../_pideky/presentation/mis_pagos_nequi/view_model/mis_pagos_nequi_view_model.dart';
import '../../_pideky/presentation/pedido_sugerido/view_model/pedido_sugerido_view_model.dart';
import '../../generated/l10n.dart';
import '../../src/controllers/cambio_estado_pedido.dart';
import '../../src/provider/carrito_provider.dart';
import '../../src/provider/opciones_app_bart.dart';
import '../../src/utils/uxcam_tagueo.dart';

final prefs = new Preferencias();
late ProgressDialog pr;

class DrawerSucursales extends StatefulWidget {
  final GlobalKey<ScaffoldState> drawerKey;

  const DrawerSucursales(this.drawerKey);

  @override
  State<DrawerSucursales> createState() => _DrawerSucursalesState();
}

class _DrawerSucursalesState extends State<DrawerSucursales> {
  late Object? valueRadio;
  late OpcionesBard? opcionesAppBard;
  final cargoConfirmar = Get.find<CambioEstadoProductos>();

  @override
  void initState() {
    setState(() {
      valueRadio = prefs.sucursal;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatosListas>(context);
    final cartProvider = Provider.of<CarroModelo>(context);
    opcionesAppBard = Provider.of<OpcionesBard>(context);
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
            color: ConstantesColores.color_fondo_gris,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30))),
        width: Get.width * 0.9,
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 15, top: 30),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Tus sucursales",
                            style: TextStyle(
                                color: ConstantesColores.azul_precio,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )),
                    )),
                    IconButton(
                        onPressed: () {
                          widget.drawerKey.currentState!.openEndDrawer();
                        },
                        icon: Icon(
                          Icons.close,
                          size: 35,
                          color: ConstantesColores.azul_precio,
                        )),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text(
                    S.current.upper_text_drawer,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 16, color: ConstantesColores.gris_oscuro),
                  ),
                ),
                Divider(
                  color: Colors.black26,
                ),
              ],
            ),
            FutureBuilder(
              future: Servicies().getListaSucursales(prefs.codClienteLogueado),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                List listaSucursales = snapshot.data;
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: listaSucursales.length,
                      itemBuilder: (BuildContext context, int index) {
                        ListaSucursalesData sucursal = listaSucursales[index];
                        return GestureDetector(
                          onTap: () => mostrarCategorias(
                              context, sucursal, provider, cartProvider),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18)),
                                  color: Colors.white),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 10, left: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            sucursal.nombre.toString(),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                          Text(
                                            "Dirección: ${sucursal.direccion.toString()}",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          Text(
                                            "Ciudad ${sucursal.ciudad.toString()}",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Radio(
                                    focusColor: ConstantesColores.agua_marina,
                                    activeColor: ConstantesColores.agua_marina,
                                    groupValue: valueRadio,
                                    value: sucursal.sucursal!,
                                    onChanged: (value) {
                                      setState(() {
                                        valueRadio = value;
                                      });
                                      mostrarCategorias(context, sucursal,
                                          provider, cartProvider);
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return Expanded(
                    child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: ConstantesColores.agua_marina,
                  ),
                ));
              },
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  widthFactor: 0.87,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(18)),
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 18),
                      child: Column(children: [
                        Image.asset(
                          'assets/image/alerta_img.png',
                          height: 50,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          S.current.bottom_alert_drawer,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              color: ConstantesColores.gris_oscuro),
                        )
                      ]),
                    ),
                  ),
                )),
            SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }

  mostrarCategorias(BuildContext context, dynamic elemento,
      DatosListas provider, cartProvider) async {
    final providerCar = Provider.of<OpcionesBard>(context, listen: false);
    final productViewModel = Get.find<ProductoViewModel>();
    pr = ProgressDialog(context);
    pr.style(message: 'Cambiando sucursal');
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);

    await pr.show();
    await cargarInformacion(provider, elemento);
    await cargarDataUsuario(elemento.sucursal);

    if (prefs.usurioLogin == 1) {
      UxcamTagueo().validarTipoUsuario();
    }
    await pr.hide();
    productViewModel.eliminarBDTemporal();
    providerCar.selectOptionMenu = 0;
    providerCar.setNumeroClickCarrito = 0;
    PedidoEmart.cantItems.value = '0';

    setState(() {});
    Navigator.pushReplacementNamed(context, 'tab_opciones');
    mostrarAlertCustomWidget(
        context,
        Text(
          S.current.text_change_of_branch,
          textAlign: TextAlign.center,
        ),
        SvgPicture.asset('assets/image/check_producto_agregado.svg'));
  }

  Future<void> cargarInformacion(DatosListas provider, dynamic elemento) async {
    List datosCliente = await DBProviderHelper.db.consultarDatosCliente();
    prefs.direccionSucursal = datosCliente[0].direccion;
    prefs.usurioLogin = 1;
    prefs.usurioLoginCedula = prefs.codClienteLogueado;
    opcionesAppBard!.selectOptionMenu = 0;

    PedidoEmart.listaControllersPedido = new Map();
    PedidoEmart.listaValoresPedido = new Map();
    PedidoEmart.listaProductos = new Map();
    PedidoEmart.listaValoresPedidoAgregados = new Map();

    await AppUtil.appUtil
        .downloadZip(prefs.usurioLoginCedula!, elemento.sucursal, false);
    await AppUtil.appUtil.abrirBases();
  }

  cargarDataUsuario(sucursal) async {
    List datosCliente = await DBProviderHelper.db.consultarDatosCliente();
    final controllerPedidoSugerido = Get.find<PedidoSugeridoViewModel>();
    final controllerNequi = Get.find<MisPagosNequiViewModel>();

    controllerPedidoSugerido.initController();
    controllerNequi.initData();

    prefs.usuarioRazonSocial = datosCliente[0].razonsocial;
    prefs.codCliente = datosCliente[0].codigo;
    prefs.codTienda = 'nutresa';
    prefs.codigonutresa = datosCliente[0].codigonutresa;
    prefs.codigozenu = datosCliente[0].codigozenu;
    prefs.codigomeals = datosCliente[0].codigomeals;
    prefs.codigopozuelo = datosCliente[0].codigopozuelo;
    prefs.codigoalpina = datosCliente[0].codigoalpina;
    prefs.paisUsuario = datosCliente[0].pais;
    prefs.sucursal = sucursal;
    prefs.ciudad = datosCliente[0].ciudad;

    S.load(datosCliente[0].pais == 'CR'
        ? Locale('es', datosCliente[0].pais)
        : datosCliente[0].pais == 'CO'
            ? Locale('es', 'CO')
            : Locale('es', 'CO'));
  }
}
