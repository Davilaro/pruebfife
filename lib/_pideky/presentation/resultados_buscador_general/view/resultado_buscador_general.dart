import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/_pideky/domain/producto/model/producto.dart';
import 'package:emart/_pideky/presentation/resultados_buscador_general/view_model/resultado_buscador_general_view_model.dart';
import 'package:emart/_pideky/presentation/resultados_buscador_general/widgets/campo_texto_resultado.dart';
import 'package:emart/shared/widgets/drawer_sucursales.dart';
import 'package:emart/shared/widgets/new_app_bar.dart';
import 'package:emart/src/controllers/bannnersController.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:emart/src/widget/card_product_custom.dart';
import 'package:flutter/material.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

final prefs = new Preferencias();

class ResultadoBuscadorGeneral extends StatelessWidget {
  final List<dynamic> allresultados;

  ResultadoBuscadorGeneral({Key? key, required this.allresultados})
      : super(key: key);

  final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();
  final controllerBanner = Get.find<BannnerControllers>();
  final resultadoBuscadorGeneralVm = Get.put(ResultadoBuscadorGeneralVm());

  Widget build(BuildContext context) {
    resultadoBuscadorGeneralVm.selecionarSoloProductos(allresultados);

    return Scaffold(
      backgroundColor: ConstantesColores.color_fondo_gris,
      key: drawerKey,
      drawerEnableOpenDragGesture:
          resultadoBuscadorGeneralVm.prefs.usurioLogin == 1 ? true : false,
      drawer: DrawerSucursales(drawerKey),
      appBar: PreferredSize(
        preferredSize: resultadoBuscadorGeneralVm.prefs.usurioLogin == 1
            ? const Size.fromHeight(118)
            : const Size.fromHeight(70),
        child: SafeArea(child: NewAppBar(drawerKey)),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FittedBox(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: ConstantesColores.agua_marina,
                          size: 30,
                        ),
                      ),
                      CampoTextoResultado(),
                      GestureDetector(
                        onTap: () => {resultadoBuscadorGeneralVm.irFiltro()},
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: Get.height * 0.01,
                              horizontal: Get.width * 0.02),
                          child: GestureDetector(
                            child: SvgPicture.asset('assets/image/filtro_btn.svg',
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Obx(() => Text(
                  resultadoBuscadorGeneralVm.searchInput.isEmpty
                      ? 'Estás buscando en todas las secciones'
                      : 'Estás buscando "${resultadoBuscadorGeneralVm.searchInput}" en todas las secciones',
                  style: TextStyle(
                      color: Colors.black.withOpacity(.5),
                      fontSize: 13,
                      fontWeight: FontWeight.bold))),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                  width: Get.width * 1,
                  decoration: BoxDecoration(
                    color: HexColor("#E4E3EC"),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 4.0, // Espaciado vertical
                      mainAxisSpacing:
                          4.0, // espaciado entre ejes principales (horizontal)
                      childAspectRatio: 2 / 3.3, //entre mas cerca de cero
                      children: resultadoBuscadorGeneralVm.cargarProductosLista(
                          resultadoBuscadorGeneralVm.listaProductos, context))),
            )
          ],
        ),
      ),
    );
  }
}
