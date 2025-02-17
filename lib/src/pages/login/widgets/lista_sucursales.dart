import 'package:auto_size_text/auto_size_text.dart';
import 'package:emart/generated/l10n.dart';
import 'package:emart/src/controllers/controller_db.dart';
import 'package:emart/src/controllers/notifiactions_controllers.dart';
import 'package:emart/src/modelos/screen_arguments.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/crear_file.dart';
import 'package:emart/src/provider/datos_listas_provider.dart';
import 'package:emart/src/provider/db_provider_helper.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';

import '../../../../_pideky/presentation/my_payments/view_model/my_payments_view_model.dart';
import '../../../../_pideky/presentation/suggested_order/view_model/suggested_order_view_model.dart';

final prefs = new Preferencias();
late ProgressDialog pr;
late String? usuariLogin;

class ListaSucursales extends StatefulWidget {
  const ListaSucursales({
    Key? key,
  }) : super(key: key);
  @override
  State<ListaSucursales> createState() => _ListaSucursalesState();
}

class _ListaSucursalesState extends State<ListaSucursales> {
  final TextEditingController _controllerBuscarSucursal =
      TextEditingController();
  var colorSeleccion = false;
  String seleccion = "";
  final cargoControllerBase = Get.put(ControlBaseDatos());
  final cargoConfirmar = Get.find<ControlBaseDatos>();

  @override
  Widget build(BuildContext context) {
    //Se define el nombre de la pantalla para UXCAM
    FlutterUxcam.tagScreenName('ListBranchesPage');

    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    final provider = Provider.of<DatosListas>(context);

    return Scaffold(
      backgroundColor: HexColor('F7F7F7'),
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ConstantesColores.color_fondo_gris,
          statusBarIconBrightness: Brightness.dark,
        ),
        elevation: 0,
        title: Text('Seleccionar Sucursal'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _campoTexto(context),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: SingleChildScrollView(
                    child: Column(
                        children: _cargarDatos(
                            context, args.listaEmpresas, provider))),
                // child: ListView(
                //   shrinkWrap: true,
                //   children: _cargarDatos(context, args.listaEmpresas, provider),
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _campoTexto(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      decoration: BoxDecoration(
        color: HexColor("#E4E3EC"),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: _controllerBuscarSucursal,
        style: TextStyle(color: HexColor("#41398D"), fontSize: 12),
        decoration: InputDecoration(
            fillColor: HexColor("#41398D"),
            hintText: 'Ingresa el nombre de la sucursal',
            hintStyle: TextStyle(
              color: HexColor("#41398D"),
            ),
            suffixIcon: Icon(
              Icons.search,
              color: HexColor("#41398D"),
            ),
            border: InputBorder.none),
      ),
    );
  }

  List<Widget> _cargarDatos(
      BuildContext context, List<dynamic> listaEmpresas, DatosListas provider) {
    final List<Widget> opciones = [];

    if (listaEmpresas.length == 0) {
      return opciones..add(Text(S.current.no_information_to_display));
    }

    listaEmpresas.forEach((element) {
      final widgetTemp = Card(
        color: seleccion == element.sucursal
            ? ConstantesColores.azul_precio
            : Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 0,
        child: ListTile(
          onTap: () => {
            setState(() {
              colorSeleccion = true;
              seleccion = element.sucursal;
            }),
            mostrarCategorias(context, element, provider)
          },
          title: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
                width: 200,
                margin: EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                child: Text(
                  '${element.razonsocial}',
                  style: TextStyle(
                      fontSize: 15,
                      color: seleccion == element.sucursal
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.bold),
                )),
          ),
          subtitle: Container(
            width: 200,
            margin: EdgeInsets.all(10.0),
            child: valoresSubTitulo(element, colorSeleccion),
          ),
        ),
      );

      opciones..add(widgetTemp);
    });

    return opciones;
  }

  TextStyle diseno_sucursales(dynamic element) => TextStyle(
      fontSize: 15,
      color: seleccion == element.sucursal ? Colors.white : Colors.black);

  Widget valoresSubTitulo(dynamic element, bool color) {
    return Container(
      height: Get.height * 0.2,
      width: double.infinity,
      child: Row(
        children: [
          Container(
            width: Get.width * 0.55,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 
                Flexible(
                    flex: 2,
                    child: AutoSizeText('Nombre: ${element.nombre}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        presetFontSizes: [16, 14],
                        style: diseno_sucursales(element))),
                Flexible(
                    child: Text('Télefono: ${element.telefono}',
                        overflow: TextOverflow.clip,
                        style: diseno_sucursales(element))),
                Flexible(
                    flex: 2,
                    child: AutoSizeText('Dirección: ${element.direccion}',
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                        style: diseno_sucursales(element))),
                Flexible(
                    child: Text('Ciudad: ${element.ciudad}',
                        overflow: TextOverflow.clip,
                        style: diseno_sucursales(element))),
                Flexible(
                    child: Text( prefs.paisUsuario == "CR" ?'Distrito:  ${element.barrio}': 'Barrio:  ${element.barrio}',
                        overflow: TextOverflow.clip,
                        style: diseno_sucursales(element))),
              ],
            ),
          ),
          Icon(
            Icons.play_arrow_rounded,
            size: 44,
            color: seleccion == element.sucursal
                ? Colors.white
                : ConstantesColores.azul_precio,
          )
        ],
      ),
    );
  }

  mostrarCategorias(
      BuildContext context, dynamic elemento, DatosListas provider) async {
    // prefs.usuarioRazonSocial = elemento.razonsocial;
    // prefs.codCliente = elemento.codigo;
    // prefs.codTienda = 'nutresa';
    // prefs.codigonutresa = elemento.codigonutresa;
    // prefs.codigozenu = elemento.codigozenu;
    // prefs.codigomeals = elemento.codigomeals;
    // prefs.codigopozuelo = elemento.codigopozuelo;
    // prefs.codigoalpina = elemento.codigoalpina;
    // prefs.codigopadrepideky = elemento.codigopadrepideky;
    // prefs.paisUsuario = elemento.pais;
    // prefs.sucursal = elemento.sucursal;
    // prefs.ciudad = elemento.ciudad;

    // S.load(elemento.pais == 'CR'
    //     ? Locale('es', elemento.pais)
    //     : elemento.pais == 'CO'
    //         ? Locale('es', 'CO')
    //         : Locale('es', 'CO'));
    pr = ProgressDialog(context, isDismissible: false);
    pr.style(
        message: S.current.logging_in,
        progressWidget: Image(
          image: AssetImage('assets/image/jar-loading.gif'),
          fit: BoxFit.cover,
          height: 20,
        ));

    await pr.show();
    await cargarInformacion(provider, elemento);
    await cargarDataUsuario(elemento.sucursal);
    if (prefs.usurioLogin == 1) {
      UxcamTagueo().validarTipoUsuario();
    }
    await pr.hide();

    //opcionesAppBard.selectOptionMenu = 0;

    //Get.offAll(() => TabOpciones());
    Navigator.of(context).pushNamedAndRemoveUntil(
        'tab_opciones', (Route<dynamic> route) => false);
  }

  Future<void> cargarInformacion(DatosListas provider, dynamic elemento) async {
    final notificationController =
        Get.find<NotificationsSlideUpAndPushInUpControllers>();
    final controllerPedidoSugerido = Get.find<SuggestedOrderViewModel>();
    final controllerNequi = Get.find<MyPaymentsViewModel>();
    notificationController.resetMaps();
    prefs.usurioLogin = 1;
    prefs.usurioLoginCedula = prefs.codClienteLogueado;

    PedidoEmart.listaControllersPedido = new Map();
    PedidoEmart.listaValoresPedido = new Map();
    PedidoEmart.listaProductos = new Map();
    PedidoEmart.listaValoresPedidoAgregados = new Map();

    await AppUtil.appUtil
        .downloadZip(prefs.codigoUnicoPideky!, elemento.sucursal, false);
    // var cargo = await AppUtil.appUtil.downloadZip(
    //     usuariLogin!,
    //     prefs.codCliente,
    //     prefs.sucursal,
    //     prefs.codigonutresa,
    //     prefs.codigozenu,
    //     prefs.codigomeals,
    //     prefs.codigopadrepideky,
    //     false);
    await AppUtil.appUtil.abrirBases();
    controllerPedidoSugerido.initController();
    controllerNequi.initData();
  }

  cargarDataUsuario(sucursal) async {
    List datosCliente = await DBProviderHelper.db.consultarDatosCliente();

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
    prefs.direccionSucursal = datosCliente[0].direccion;
    prefs.codClienteLogueado = datosCliente[0].nit;

    S.load(datosCliente[0].pais == 'CR'
        ? Locale('es', datosCliente[0].pais)
        : datosCliente[0].pais == 'CO'
            ? Locale('es', 'CO')
            : Locale('es', 'CO'));
  }
}
