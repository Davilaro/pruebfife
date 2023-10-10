import 'package:emart/_pideky/domain/marca/model/marca.dart';
import 'package:emart/_pideky/domain/marca/service/marca_service.dart';
import 'package:emart/_pideky/infrastructure/marcas/marca_repository_sqlite.dart';
import 'package:emart/shared/widgets/botones_proveedores.dart';
import 'package:emart/src/controllers/notifiactions_controllers.dart';
import 'package:emart/src/pages/catalogo/view_model/botones_proveedores_vm.dart';
import 'package:emart/src/pages/catalogo/widgets/boton_todos_filtro.dart';
import 'package:emart/src/pages/principal_page/widgets/custom_buscador_fuzzy.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:emart/src/utils/alertas.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:emart/src/provider/logica_actualizar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

final prefs = new Preferencias();

class MarcasWidget extends StatefulWidget {
  const MarcasWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<MarcasWidget> createState() => _MarcasWidgetState();
}

class _MarcasWidgetState extends State<MarcasWidget> {
  final TextEditingController controllerSearch = TextEditingController();

  MarcaService marcaService = MarcaService(MarcaRepositorySqlite());

  final botonesProveedoresVm = Get.put(BotonesProveedoresVm());

  @override
  void initState() {
    //UXCAM:Se define el nombre de la pantalla
    FlutterUxcam.tagScreenName('BrandsPage');
    botonesProveedoresVm.cargarListaProovedor();
    botonesProveedoresVm.cargarLista(2);
    botonesProveedoresVm.cargarSeleccionados();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CarroModelo>(context);

    return Scaffold(
        backgroundColor: ConstantesColores.color_fondo_gris,
        body: Padding(
            padding: EdgeInsets.only(top: 10),
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
                              ))
                            : BotonesProveedores(idTab: 2)),
                        BotonTodosfiltro(idTab: 2),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
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

                          botonesProveedoresVm.cargarLista(2);

                          return Future<void>.delayed(
                              const Duration(seconds: 3));
                        },
                        child: GridView.count(
                            crossAxisCount: 3,
                            childAspectRatio: 1.0,
                            crossAxisSpacing: 1.0,
                            mainAxisSpacing: 3,
                            children: _cargarMarcas(
                                    botonesProveedoresVm.listaMarca,
                                    context,
                                    provider)
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
          if (botonesProveedoresVm.listaFabricantesBloqueados
              .contains(element.fabricante))
            {
              mostrarAlertCartera(
                context,
                "Esta marca no se encuentra disponible. Revisa el estado de tu cartera para poder comprar.",
                null,
              )
            }
          else
            {
              //Firebase: Llamamos el evento select_content
              TagueoFirebase().sendAnalityticSelectContent(
                  "Marcas",
                  (element as Marca).nombre,
                  element.nombre,
                  element.nombre,
                  element.codigo,
                  'ViewMarcs'),
              //UXCam: Llamamos el evento seeBrand
              UxcamTagueo().seeBrand(element.nombre),
              _onClickCatalogo(
                  element.codigo, context, provider, element.nombre)
            }
        },
        child: Stack(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
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
              ),
            ),
            Container(
              margin: EdgeInsets.all(4),
              child: Visibility(
                visible: botonesProveedoresVm.listaFabricantesBloqueados
                    .contains(element.fabricante),
                child: Container(
                  height: Get.height * 4,
                  width: Get.width * 1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ],
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

  @override
  void dispose() {
    controllerSearch.dispose();
    super.dispose();
  }
}
