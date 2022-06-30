import 'package:emart/src/controllers/controller_db.dart';
import 'package:emart/src/pages/login/login.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/crear_file.dart';
import 'package:emart/src/provider/datos_listas_provider.dart';
import 'package:emart/src/provider/opciones_app_bart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

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

  late OpcionesBard? opcionesAppBard;

  @override
  Widget build(BuildContext context) {
    //Se define el nombre de la pantalla para UXCAM
    FlutterUxcam.tagScreenName('ListBranchesPage');
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    final provider = Provider.of<DatosListas>(context);
    opcionesAppBard = Provider.of<OpcionesBard>(context);

    usuariLogin = args.usuario;

    return Scaffold(
      backgroundColor: HexColor('F7F7F7'),
      appBar: AppBar(
        elevation: 0,
        title: Text('Seleccionar Sucursal'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _campoTexto(context),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: ListView(
                  shrinkWrap: true,
                  children: _cargarDatos(context, args.listaEmpresas, provider),
                ),
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
      return opciones..add(Text('No hay informacion para mostrar'));
    }

    listaEmpresas.forEach((element) {
      final widgetTemp = Card(
        color: seleccion == element.codigo
            ? ConstantesColores.azul_precio
            : Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 0,
        child: ListTile(
          onTap: () => {
            setState(() {
              colorSeleccion = true;
              seleccion = element.codigo;
            }),
            _mostrarCategorias(
                context,
                element.codigo,
                provider,
                element.fabricantes,
                element.codigonutresa,
                element.codigozenu,
                element.codigomeals,
                element.razonsocial)
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
                      color: seleccion == element.codigo
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
      color: seleccion == element.codigo ? Colors.white : Colors.black);

  Widget valoresSubTitulo(dynamic element, bool color) {
    return Container(
      height: 80.0,
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
                    child: Text('Nombre: ${element.nombre}',
                        overflow: TextOverflow.clip,
                        style: diseno_sucursales(element))),
                Flexible(
                    child: Text('Télefono: ${element.telefono}',
                        overflow: TextOverflow.clip,
                        style: diseno_sucursales(element))),
                Flexible(
                    child: Text('Dirección: ${element.direccion}',
                        overflow: TextOverflow.clip,
                        style: diseno_sucursales(element))),
                Flexible(
                    child: Text('Ciudad: ${element.ciudad}',
                        overflow: TextOverflow.clip,
                        style: diseno_sucursales(element))),
              ],
            ),
          ),
          Icon(
            Icons.play_arrow_rounded,
            size: 44,
            color: seleccion == element.codigo
                ? Colors.white
                : ConstantesColores.azul_precio,
          )
        ],
      ),
    );
  }

  _mostrarCategorias(
      BuildContext context,
      String codigo,
      DatosListas provider,
      final List<dynamic> listaFabricantes,
      String codigonutresa,
      String codigozenu,
      String codigomeals,
      String razonSocial) async {
    prefs.usuarioRazonSocial = razonSocial;
    prefs.codCliente = codigo;
    prefs.codTienda = 'nutresa';
    prefs.codigonutresa = codigonutresa;
    prefs.codigozenu = codigozenu;
    prefs.codigomeals = codigomeals;

    pr = ProgressDialog(context);
    pr.style(message: 'Cargando información');
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);

    await pr.show();
    await cargarInformacion(provider);
    await pr.hide();
    setState(() {});
    Navigator.pushReplacementNamed(context, 'tab_opciones');
  }

  Future<void> cargarInformacion(DatosListas provider) async {
    prefs.usurioLogin = 1;
    prefs.usurioLoginCedula = usuariLogin;
    opcionesAppBard!.selectOptionMenu = 0;

    PedidoEmart.listaControllersPedido = new Map();
    PedidoEmart.listaValoresPedido = new Map();
    PedidoEmart.listaProductos = new Map();
    PedidoEmart.listaValoresPedidoAgregados = new Map();

    var cargo = await AppUtil.appUtil.downloadZip(
        usuariLogin!,
        prefs.codCliente,
        prefs.codigonutresa,
        prefs.codigozenu,
        prefs.codigomeals,
        false);
    await AppUtil.appUtil.abrirBases();
  }
}
