import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/src/controllers/notifiactions_controllers.dart';
import 'package:emart/src/pages/principal_page/widgets/custom_buscador_fuzzy.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:emart/src/provider/datos_listas_provider.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/utils/alertas.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/utils/util.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:emart/src/widget/dounser.dart';
import 'package:emart/src/provider/logica_actualizar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class Fabricantes extends StatefulWidget {
  @override
  State<Fabricantes> createState() => _FabricantesState();
}

class _FabricantesState extends State<Fabricantes> {
  RxList<dynamic> listaFabricante = <dynamic>[].obs;
  List<dynamic> listaAllFabricantes = [];
  final TextEditingController controllerSearch = TextEditingController();

  late DatosListas? providerDatos;

  final prefs = new Preferencias();

  final Debouncer onSearchDebouncer =
      new Debouncer(delay: new Duration(milliseconds: 500));

  @override
  void initState() {
    super.initState();
    controllerSearch.addListener(_runFilter);
    cargarLista();
    validarVersionActual(context);
  }

  @override
  Widget build(BuildContext context) {
    //UXCAM: Se define el nombre de la pantalla
    FlutterUxcam.tagScreenName('ProvidersPage');
    final provider = Provider.of<CarroModelo>(context);
    providerDatos = Provider.of<DatosListas>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: ConstantesColores.color_fondo_gris,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Column(
          children: [
            _campoTexto(context),
            Flexible(
              flex: 2,
              child: Obx(
                () => Container(
                    height: size.height * 0.7,
                    margin: EdgeInsets.only(top: 10),
                    child: RefreshIndicator(
                      color: ConstantesColores.azul_precio,
                      backgroundColor:
                          ConstantesColores.agua_marina.withOpacity(0.6),
                      onRefresh: () async {
                        await LogicaActualizar().actualizarDB();

                        setState(() {
                          cargarLista();
                        });
                        return Future<void>.delayed(const Duration(seconds: 3));
                      },
                      child: GridView.count(
                          crossAxisCount: 3,
                          childAspectRatio: 1,
                          crossAxisSpacing: 1.0, // Espaciado vertical
                          mainAxisSpacing: 1.0,
                          children: _cargarFabricantes(
                                  listaFabricante, context, provider)
                              .toList()),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _cargarFabricantes(
      List<dynamic> result, BuildContext context, CarroModelo provider) {
    final List<Widget> opciones = [];

    for (var element in result) {
      final widgetTemp = GestureDetector(
        onTap: element.bloqueoCartera == 1
            ? () => mostrarAlertCartera(
                  context,
                  "Estos productos no se encuentran disponibles. Revisa el estado de tu cartera para poder comprar.",
                  null,
                )
            : () => {
                  //FIREBASE: Llamamos el evento select_content
                  TagueoFirebase().sendAnalityticSelectContent(
                      "Proveedores",
                      element.nombrecomercial,
                      element.nombrecomercial,
                      "",
                      "-1",
                      'ViewProviders'),
                  //UXCam: Llamamos el evento seeProvider
                  UxcamTagueo().seeProvider(element.nombrecomercial),
                  _onClickCatalogo(element.empresa, context, provider,
                      element.nombrecomercial, element.icono),
                },
        child: Stack(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                alignment: Alignment.center,
                child: CachedNetworkImage(
                    imageUrl: '${element.icono}',
                    placeholder: (context, url) =>
                        Image.asset('assets/image/jar-loading.gif'),
                    errorWidget: (context, url, error) =>
                        Image.asset('assets/image/logo_login.png'),
                    fit: BoxFit.fill),
              ),
            ),
            Visibility(
                visible: element.bloqueoCartera == 1 ? true : false,
                child: Container(
                  margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  height: Get.height,
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ))
          ],
        ),
      );
      opciones.add(widgetTemp);
    }
    return opciones;
  }

  _onClickCatalogo(String codigo, BuildContext context, CarroModelo provider,
      String nombre, String icono) async {
    final controllerNotificaciones =
        Get.find<NotificationsSlideUpAndPushInUpControllers>();
    controllerNotificaciones.llenarMapSlideUp(nombre);
    controllerNotificaciones.llenarMapPushInUp(nombre);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CustomBuscardorFuzzy(
                  codCategoria: codigo,
                  numEmpresa: 'nutresa',
                  tipoCategoria: 4,
                  nombreCategoria: nombre,
                  img: icono,
                  locacionFiltro: "proveedor",
                  codigoProveedor: codigo,
                )));
  }

  _campoTexto(BuildContext context) {
    return Container(
        height: 50,
        width: Get.width * 0.86,
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        decoration: BoxDecoration(
          color: HexColor("#E4E3EC"),
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
          controller: controllerSearch,
          style: TextStyle(color: HexColor("#41398D"), fontSize: 13),
          decoration: InputDecoration(
            fillColor: HexColor("#41398D"),
            hintText: 'Encuentra lo que necesitas',
            hintStyle: TextStyle(
              color: HexColor("#41398D"),
            ),
            suffixIcon: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.search,
                    color: HexColor("#41398D"),
                  ),
                )),
            border: InputBorder.none,
            contentPadding: EdgeInsets.fromLTRB(10.0, 15, 10.0, 0),
          ),
        ));
  }

  void cargarLista() async {
    listaAllFabricantes = prefs.usurioLogin != -1
        ? await DBProvider.db.consultarFabricanteBloqueo()
        : await DBProvider.db.consultarFricante(controllerSearch.text);
    listaFabricante.value = listaAllFabricantes;
  }

  void _runFilter() {
    if (controllerSearch.text.isEmpty) {
      listaFabricante.value = listaAllFabricantes;
    } else {
      if (controllerSearch.text.length > 2) {
        //FIREBASE: Llamamos el evento search
        TagueoFirebase().sendAnalityticsSearch(controllerSearch.text);
        //UXCam: Llamamos el evento search
        UxcamTagueo().search(controllerSearch.text);
        List listaAux = [];
        listaAllFabricantes.forEach((element) {
          listaAux.add(element.nombrecomercial);
        });

        final result = extractTop(
          limit: 10,
          query: controllerSearch.text,
          choices:
              listaAllFabricantes.map((element) => element.nombre).toList(),
          cutoff: 10,
        );
        listaFabricante.value = [];
        result
            .map((r) => listaFabricante.add(listaAllFabricantes
                .firstWhere((element) => element.nombrecomercial == r.choice)))
            .forEach(print);
      }
    }
  }

  @override
  void dispose() {
    controllerSearch.dispose();
    super.dispose();
  }
}
