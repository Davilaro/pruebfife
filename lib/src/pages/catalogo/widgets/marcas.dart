import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/src/pages/principal_page/widgets/custom_buscador_fuzzy.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:emart/src/provider/crear_file.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/widget/logica_actualizar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:fuzzy/fuzzy.dart';
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
                        onRefresh: () async {
                          await LogicaActualizar().actualizarDB();

                          setState(() {});
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

    for (var element in result) {
      final widgetTemp = GestureDetector(
        onTap: () => {
          //Firebase: Llamamos el evento select_content
          TagueoFirebase().sendAnalityticSelectContent("Marcas", element.titulo,
              element.titulo, element.titulo, element.codigo, 'ViewMarcs'),
          _onClickCatalogo(element.codigo, context, provider, element.titulo)
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
            child: CachedNetworkImage(
              imageUrl: element.ico,
              placeholder: (context, url) =>
                  Image.asset('assets/jar-loading.gif'),
              errorWidget: (context, url, error) =>
                  Image.asset('assets/logo_login.png'),
              fit: BoxFit.fill,
            ),
          ),
        ),
      );

      opciones.add(widgetTemp);
    }

    return opciones;
  }

  _onClickCatalogo(String codigo, BuildContext context, CarroModelo provider,
      String nombre) {
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
    listaAllMarcas = await DBProvider.db.consultarMarcas(controllerSearch.text);
    listaMarca.value = listaAllMarcas;
  }

  void _runFilter() {
    if (controllerSearch.text.isEmpty) {
      listaMarca.value = listaAllMarcas;
    } else {
      if (controllerSearch.text.length > 2) {
        //FIREBASE: Llamamos el evento search
        TagueoFirebase().sendAnalityticsSearch(controllerSearch.text);
        List listaAux = [];
        listaAllMarcas.forEach((element) {
          listaAux.add(element.titulo);
        });
        final fuse = Fuzzy(listaAux);
        final result = fuse.search(controllerSearch.text);
        listaMarca.value = [];
        result
            .map((r) => listaMarca.add(listaAllMarcas
                .firstWhere((element) => element.titulo == r.item)))
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
