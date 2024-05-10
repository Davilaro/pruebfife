import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/_pideky/presentation/customers_prospection/view/customers_prospection_page.dart';
import 'package:emart/shared/widgets/botones_proveedores.dart';
import 'package:emart/src/pages/catalogo/view_model/botones_proveedores_vm.dart';
import 'package:emart/src/pages/catalogo/widgets/boton_todos_filtro.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/_pideky/presentation/cart/view_model/cart_view_model.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/utils/alertas.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:emart/src/pages/catalogo/widgets/tab_categorias_opciones.dart';
import 'package:emart/src/provider/logica_actualizar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
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
  final TextEditingController controllerSearch = TextEditingController();

  final botonesProveedoresVm = Get.find<BotonesProveedoresVm>();

  @override
  void initState() {
    //UXCAM: Se define el nombre de la pantalla
    FlutterUxcam.tagScreenName('CategoriesPage');
    botonesProveedoresVm.cargarListaProovedor('Categoria');
    botonesProveedoresVm.cargarLista(1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    botonesProveedoresVm.cargarSeleccionados();
    final provider = Provider.of<CartViewModel>(context);
    return Scaffold(
        backgroundColor: ConstantesColores.color_fondo_gris,
        body: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Get.width * 0.045, vertical: 0),
              child: Container(
                width: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(() => botonesProveedoresVm.listaFabricante.isEmpty
                          ? Center(
                              child: CircularProgressIndicator(
                                color: ConstantesColores.azul_precio,
                              ),
                            )
                          : BotonesProveedores(idTab: 1)),
                      BotonTodosfiltro(idTab: 1),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
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
                        botonesProveedoresVm.cargarLista(1);
                        return Future<void>.delayed(const Duration(seconds: 3));
                      },
                      child: GridView.count(
                          crossAxisCount: 3,
                          childAspectRatio: 1.0,
                          crossAxisSpacing: 9.0,
                          mainAxisSpacing: 9.0,
                          children: _cargarCategorias(
                                  botonesProveedoresVm.listaCategoria,
                                  context,
                                  provider)
                              .toList()),
                    ))))
          ]),
        ));
  }

  List<Widget> _cargarCategorias(
      List<dynamic> result, BuildContext context, CartViewModel provider) {
    final List<Widget> opciones = [];
    final size = MediaQuery.of(context).size;

    for (var element in result) {
      final widgetTemp = GestureDetector(
        onTap: () {
          if (botonesProveedoresVm.listaFabricantesBloqueados
              .contains(element.fabricante)) {
            mostrarAlertCartera(
              context,
              "Esta categoría no se encuentra disponible. Revisa el estado de tu cartera para poder comprar.",
              null,
            );
          } else if (botonesProveedoresVm.listaProveedoresInactivos
                  .contains(element.fabricante) &&
              !botonesProveedoresVm.listaFabricantesBloqueados
                  .contains(element.fabricante)) {
          } else {
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
          }
        },
        child: Stack(
          children: [
            Container(
              
              child: Container(
                decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
                child: Stack(
                  children: [
                    Wrap(
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
                                  'assets/image/jar-loading.gif',
                                  alignment: Alignment.center,
                                  height: 50,
                                ),
                                errorWidget: (context, url, error) => Image.asset(
                                  'assets/image/logo_login.png',
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
                    Align(
                      alignment: Alignment.center,
                      child: Visibility(
                        visible: botonesProveedoresVm.listaFabricantesBloqueados
                            .contains(element.fabricante),
                        child: Container(
                          height: Get.height * 0.14,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                    if (botonesProveedoresVm.listaProveedoresInactivos
                            .contains(element.fabricante) &&
                        !botonesProveedoresVm.listaFabricantesBloqueados
                            .contains(element.fabricante))
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: Get.height * 0.14,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (botonesProveedoresVm.listaProveedoresInactivos
                    .contains(element.fabricante) &&
                !botonesProveedoresVm.listaFabricantesBloqueados
                    .contains(element.fabricante))
              Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => Get.to(() => CustomersProspectionPage()),
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: ConstantesColores.azul_precio,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          'Activar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ))
          ],
        ),
      );

      opciones.add(widgetTemp);
    }

    return opciones;
  }

  _onClickCatalogo(String codigo, BuildContext context, CartViewModel provider,
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

  @override
  void dispose() {
    controllerSearch.dispose();
    super.dispose();
  }
}
