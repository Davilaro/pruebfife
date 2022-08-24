import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:emart/src/widget/dounser.dart';
import 'package:emart/src/pages/catalogo/widgets/tab_categorias_opciones.dart';
import 'package:emart/src/provider/logica_actualizar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

final prefs = new Preferencias();

class CategoriasGrilla extends StatefulWidget {
  const CategoriasGrilla({
    Key? key,
  }) : super(key: key);

  @override
  State<CategoriasGrilla> createState() => _CategoriasGrillaState();
}

class _CategoriasGrillaState extends State<CategoriasGrilla> {
  RxList<dynamic> listaCategoria = <dynamic>[].obs;
  List<dynamic> listaAllCategorias = [];
  final TextEditingController controllerSearch = TextEditingController();

  @override
  void initState() {
    //UXCAM: Se define el nombre de la pantalla
    FlutterUxcam.tagScreenName('CategoriesPage');
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
            Expanded(
                flex: 2,
                child: Obx(() => Container(
                    height: Get.height * 1,
                    width: Get.width * 1,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
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
                          childAspectRatio: 1.0,
                          crossAxisSpacing: 9.0,
                          mainAxisSpacing: 9.0,
                          children: _cargarCategorias(
                                  listaCategoria, context, provider)
                              .toList()),
                    ))))
          ]),
        ));
  }

  List<Widget> _cargarCategorias(
      List<dynamic> result, BuildContext context, CarroModelo provider) {
    final List<Widget> opciones = [];
    final size = MediaQuery.of(context).size;

    for (var element in result) {
      final widgetTemp = GestureDetector(
        onTap: () {
          //FIREBASE: Llamamos el evento select_content
          TagueoFirebase().sendAnalityticSelectContent(
              "Categorías",
              element.descripcion,
              '',
              element.descripcion,
              element.codigo,
              'ViewCategoris');
          //UXCam: Llamamos el evento seeCategory
          UxcamTagueo().seeCategory(element.descripcion);
          _onClickCatalogo(
              element.codigo, context, provider, element.descripcion);
        },
        child: Container(
          height: Get.height * 0.1,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Wrap(
            // mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                children: [
                  Container(
                    height: size.height * 0.090,
                    margin: EdgeInsets.fromLTRB(5, 2, 5, 0),
                    alignment: Alignment.center,
                    child: CachedNetworkImage(
                      imageUrl: element.ico,
                      alignment: Alignment.bottomCenter,
                      placeholder: (context, url) => Image.asset(
                        'assets/jar-loading.gif',
                        alignment: Alignment.center,
                        height: 50,
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/logo_login.png',
                        height: 50,
                        alignment: Alignment.center,
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
                child: AutoSizeText('${element.descripcion}',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: HexColor('#0061cc')),
                    textAlign: TextAlign.center,
                    minFontSize: 8,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ),
      );

      opciones.add(widgetTemp);
    }

    return opciones;
  }

  _onClickCatalogo(String codigo, BuildContext context, CarroModelo provider,
      String nombre) async {
    final List<dynamic> listaSubCategorias =
        await DBProvider.db.consultarCategoriasSubCategorias(codigo);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TabOpcionesCategorias(
                  listaCategorias: listaSubCategorias,
                  nombreCategoria: nombre,
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
          hintText: 'Encuentra tus categorías',
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
    listaAllCategorias =
        await DBProvider.db.consultarCategorias(controllerSearch.text, 0);
    listaCategoria.value = listaAllCategorias;
  }

  void _runFilter() {
    if (controllerSearch.text.isEmpty) {
      listaCategoria.value = listaAllCategorias;
    } else {
      if (controllerSearch.text.length > 2) {
        //FIREBASE: Llamamos el evento search
        TagueoFirebase().sendAnalityticsSearch(controllerSearch.text);
        //UXCam: Llamamos el evento search
        UxcamTagueo().search(controllerSearch.text);
        List listaAux = [];
        listaAllCategorias.forEach((element) {
          listaAux.add(element.descripcion);
        });
        final fuse = Fuzzy(listaAux);
        final result = fuse.search(controllerSearch.text);
        listaCategoria.value = [];
        result
            .map((r) => listaCategoria.add(listaAllCategorias
                .firstWhere((element) => element.descripcion == r.item)))
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
