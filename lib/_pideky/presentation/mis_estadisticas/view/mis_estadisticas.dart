import 'package:auto_size_text/auto_size_text.dart';
import 'package:emart/_pideky/presentation/mis_estadisticas/view/widgets/acordion_empodio.dart';
import 'package:emart/_pideky/presentation/mis_estadisticas/view_model/mis_estadisticas_view_model.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/widget/acciones_carrito_bart.dart';
import 'package:emart/src/widget/boton_actualizar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class MisEstadisticas extends StatefulWidget {
  MisEstadisticas({Key? key}) : super(key: key);

  @override
  State<MisEstadisticas> createState() => _MisEstadisticasState();
}

class _MisEstadisticasState extends State<MisEstadisticas> {
  final MisEstadisticasViewModel viewModel = Get.find();

  @override
  void initState() {
    viewModel.initData();
    //UXCAM: Se define el nombre de la interfaz
    FlutterUxcam.tagScreenName('MyStatisticsPage');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantesColores.color_fondo_gris,
      appBar: AppBar(
        title: Text('Mis estadísticas',
            style: TextStyle(
                color: ConstantesColores.azul_precio,
                fontWeight: FontWeight.bold)),
        elevation: 0,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: HexColor("#30C3A3")),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          BotonActualizar(),
          AccionesBartCarrito(esCarrito: true),
        ],
      ),
      body: Obx(() => SingleChildScrollView(
            child: Container(
                color: ConstantesColores.color_fondo_gris,
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: viewModel.listTopMarcas.value.length < 3 ||
                        viewModel.listTopProductos.value.length < 3 ||
                        viewModel.listTopSubCategorias.value.length < 3
                    ? Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 100, horizontal: 50),
                        child: Center(
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/image/carritos_sin_prod_img.png',
                                alignment: Alignment.center,
                                width: Get.width * 0.6,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child: Column(
                                  children: [
                                    AutoSizeText(
                                      'Lo sentimos',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              ConstantesColores.empodio_verde),
                                    ),
                                    AutoSizeText(
                                      'No tienes información suficiente para calcular sus estadísticas. Te invitamos a seguir comprando en Pideky.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          color: ConstantesColores.gris_textos),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Column(children: [
                        Container(
                          padding: EdgeInsets.only(top: 40, bottom: 20),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'En esta sección encontrarás los productos, marcas y subcategorías que más compras en Pideky.',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: ConstantesColores.gris_textos,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              AcordionEmpodio(
                                  section: "MisEstadisticas",
                                  sectionName: "top3Productos",
                                  titulo: 'Mi top 3 de productos',
                                  lista: viewModel.listTopProductos.value,
                                  subTitulo:
                                      'Estos son los tres productos que más has comprado para tu negocio en el último mes.',
                                  tipo: 'productos'),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Divider(
                                  thickness: 1,
                                  color: HexColor('#EAE8F5'),
                                ),
                              ),
                              AcordionEmpodio(
                                  section: "MisEstadisticas",
                                  sectionName: "top3Marcas",
                                  titulo: 'Mi top 3 de marcas',
                                  lista: viewModel.listTopMarcas.value,
                                  subTitulo:
                                      'Estas son las tres marcas que más has comprado para tu negocio en el último mes.',
                                  tipo: 'marcas'),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Divider(
                                  thickness: 1,
                                  color: HexColor('#EAE8F5'),
                                ),
                              ),
                              AcordionEmpodio(
                                  section: "MisEstadisticas",
                                  sectionName: "top3Subcategorias",
                                  titulo: 'Mi top 3 de subcategorías',
                                  lista: viewModel.listTopSubCategorias,
                                  subTitulo:
                                      'Estas son las tres subcategorías que más has comprado para tu negocio en el último mes.',
                                  tipo: 'subcategorias')
                            ],
                          ),
                        )
                      ])),
          )),
    );
  }
}
