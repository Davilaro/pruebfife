import 'package:emart/_pideky/presentation/buscador_general/view_model/search_fuzzy_view_model.dart';
import 'package:emart/_pideky/presentation/resultados_buscador_general/view_model/resultado_buscador_general_view_model.dart';
import 'package:emart/_pideky/presentation/resultados_buscador_general/widgets/campo_texto_resultado.dart';
import 'package:emart/shared/widgets/drawer_sucursales.dart';
import 'package:emart/shared/widgets/new_app_bar.dart';
import 'package:emart/src/controllers/bannnersController.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

final prefs = new Preferencias();

class ResultadoBuscadorGeneral extends StatelessWidget {
  final List<dynamic> allresultados;

  ResultadoBuscadorGeneral({Key? key, required this.allresultados})
      : super(key: key);

  final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();
  final controllerBanner = Get.find<BannnerControllers>();
  final resultadoBuscadorGeneralVm = Get.put(ResultadoBuscadorGeneralVm());
  final searchFuzzyViewModel = Get.put(SearchFuzzyViewModel());

  Widget build(BuildContext context) {
    resultadoBuscadorGeneralVm.listaProductos.refresh();

    return Scaffold(
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
      body: Column(
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
                searchFuzzyViewModel.searchInput.isEmpty
                    ? 'Estás buscando en todas las secciones'
                    : 'Estás buscando "${searchFuzzyViewModel.searchInput.value}" en todas las secciones',
                style: TextStyle(
                    color: Colors.black.withOpacity(.5),
                    fontSize: 13,
                    fontWeight: FontWeight.bold))),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
            child: SizedBox(
              height: Get.height * 0.03,
              child: Row(
                children: [
                  SizedBox(width: Get.width * 0.05),
                  Expanded(
                    flex: 3,
                    child: CustomButton(
                      isFontBold: true,
                      sizeText: 12,
                      onPressed: () {
                        resultadoBuscadorGeneralVm.cargarProductosPromo();
                      },
                      text: 'Promociones',
                      backgroundColor: ConstantesColores.color_fondo_gris,
                      colorContent: ConstantesColores.azul_precio,
                    ),
                  ),
                  SizedBox(width: Get.width * 0.02),
                  Expanded(
                    flex: 3,
                    child: CustomButton(
                      isFontBold: true,
                      sizeText: 12,
                      onPressed: () {
                        resultadoBuscadorGeneralVm.cargarProductosMasVendidos();
                      },
                      text: 'Más vendidos',
                      backgroundColor: ConstantesColores.color_fondo_gris,
                      colorContent: ConstantesColores.azul_precio,
                    ),
                  ),
                  SizedBox(width: Get.width * 0.02),
                  Expanded(
                    flex: 3,
                    child: CustomButton(
                      isFontBold: true,
                      sizeText: 12,
                      onPressed: () {},
                      text: 'chocolatina',
                      backgroundColor: ConstantesColores.color_fondo_gris,
                      colorContent: ConstantesColores.azul_precio,
                    ),
                  ),
                  SizedBox(width: Get.width * 0.05),
                ],
              ),
            ),
          ),
          Expanded(
              child: Obx(() => GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 9.0,
                  childAspectRatio: 2 / 3.1,
                  padding: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.04,
                      vertical: Get.height * 0.01),
                  children: resultadoBuscadorGeneralVm
                      .cargarResultadosCard(context)
                      .toList())))
        ],
      ),
    );
  }
}
