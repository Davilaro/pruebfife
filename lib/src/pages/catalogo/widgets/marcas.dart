import 'package:emart/_pideky/domain/marca/model/marca.dart';
import 'package:emart/_pideky/domain/marca/service/marca_service.dart';
import 'package:emart/_pideky/infrastructure/marcas/marca_repository_sqlite.dart';
import 'package:emart/src/controllers/notifiactions_controllers.dart';
import 'package:emart/src/pages/principal_page/widgets/custom_buscador_fuzzy.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:emart/src/provider/logica_actualizar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../../widget/dounser.dart';

final prefs = new Preferencias();

class MarcasWidget extends StatefulWidget {
  const MarcasWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<MarcasWidget> createState() => _MarcasWidgetState();
}

class _MarcasWidgetState extends State<MarcasWidget> {
  RxList<dynamic> listaMarca = <dynamic>[].obs;
  List<dynamic> listaAllMarcas = [];
  final TextEditingController controllerSearch = TextEditingController();

  MarcaService marcaService = MarcaService(MarcaRepositorySqlite());

  @override
  void initState() {
    //UXCAM:Se define el nombre de la pantalla
    FlutterUxcam.tagScreenName('BrandsPage');
    controllerSearch.addListener(_runFilter);
    cargarLista();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CarroModelo>(context);

    final Debouncer onSearchDebouncer =
        new Debouncer(delay: new Duration(milliseconds: 500));

    return Scaffold(
        backgroundColor: ConstantesColores.color_fondo_gris,
        body: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(children: [
              _campoTexto(context, onSearchDebouncer),
              Flexible(
                  flex: 2,
                  child: Obx(() => Container(
                      height: Get.height * 1,
                      width: Get.width * 1,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                      child: RefreshIndicator(
                        color: ConstantesColores.azul_precio,
                        backgroundColor:
                            ConstantesColores.agua_marina.withOpacity(0.5),
                        onRefresh: () async {
                          await LogicaActualizar().actualizarDB();

                          // cargarLista();

                          setState(() {
                            initState();
                            (context as Element).reassemble();
                          });
                          return Future<void>.delayed(
                              const Duration(seconds: 3));
                        },
                        child: GridView.count(
                            crossAxisCount: 3,
                            childAspectRatio: 1.0,
                            crossAxisSpacing: 1.0,
                            mainAxisSpacing: 3,
                            children:
                                _cargarMarcas(listaMarca, context, provider)
                                    .toList()),
                      ))))
            ])));
  }

  List<Widget> _cargarMarcas(
      List<dynamic> result, BuildContext context, CarroModelo provider) {
    final List<Widget> opciones = [];
    PaintingBinding.instance.imageCache.clear();
    for (var element in result) {
      RxString icon = element.ico.toString().obs;

      final widgetTemp = GestureDetector(
        onTap: () => {
          //Firebase: Llamamos el evento select_content
          TagueoFirebase().sendAnalityticSelectContent("Marcas", (element as Marca).nombre,
              element.nombre, element.nombre, element.codigo, 'ViewMarcs'),
          //UXCam: Llamamos el evento seeBrand
          UxcamTagueo().seeBrand(element.nombre),
          _onClickCatalogo(element.codigo, context, provider, element.nombre)
        },
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 0,
          child: Container(
            height: Get.height * 4,
            width: Get.width * 1,
            margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
            alignment: Alignment.center,
            color: Colors.white,
            child: Obx(() => Image.network(
                  icon.value,
                  errorBuilder: (context, error, stackTrace) =>
                      Image.asset('assets/image/logo_login.png'),
                  fit: BoxFit.fill,
                )),
            // child: CachedNetworkImage(
            //   imageUrl: element.ico,
            //   placeholder: (context, url) =>
            //       Image.asset('assets/image/jar-loading.gif'),
            //   errorWidget: (context, url, error) =>
            //       Image.asset('assets/image/logo_login.png'),
            //   fit: BoxFit.fill,
            // ),
          ),
        ),
      );

      opciones.add(widgetTemp);
    }

    return opciones;
  }

  _onClickCatalogo(
    String codigo,
    BuildContext context,
    CarroModelo provider,
    String nombre,
  ) {
    final controllerNotificaciones =
        Get.find<NotificationsSlideUpAndPushInUpControllers>();
    controllerNotificaciones.llenarMapPushInUp(nombre);
    controllerNotificaciones.llenarMapSlideUp(nombre);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CustomBuscardorFuzzy(
                  codCategoria: codigo,
                  numEmpresa: 'nutresa',
                  tipoCategoria: 3,
                  nombreCategoria: nombre,
                  isActiveBanner: false,
                  locacionFiltro: "marca",
                  codigoProveedor: "",
                )));
  }

  _campoTexto(BuildContext context, Debouncer onSearchDebouncer) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
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
          hintText: 'Encuentra tus marcas',
          hintStyle: TextStyle(
            color: HexColor("#41398D"),
          ),
          suffixIcon: Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: EdgeInsets.fromLTRB(10.0, 15, 10.0, 0),
        ),
      ),
    );
  }

  void cargarLista() async {
    listaAllMarcas = await marcaService.consultaMarcas(controllerSearch.text);
    listaMarca.value = listaAllMarcas;
  }

  void _runFilter() {
    if (controllerSearch.text.isEmpty) {
      listaMarca.value = listaAllMarcas;
    } else {
      if (controllerSearch.text.length > 2) {
        //FIREBASE: Llamamos el evento search
        TagueoFirebase().sendAnalityticsSearch(controllerSearch.text);
        //UXCam: Llamamos el evento search
        UxcamTagueo().search(controllerSearch.text);
        List listaAux = [];
        listaAllMarcas.forEach((element) {
          listaAux.add(element.titulo);
        });
        final result = extractTop(
        limit: 10,
        query: controllerSearch.text,
        choices: listaAllMarcas.map((element) => element.nombre).toList(),
        cutoff: 10,
      );
        listaMarca.value = [];
        result
            .map((r) => listaMarca.add(listaAllMarcas
                .firstWhere((element) => element.titulo == r.choice)))
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
