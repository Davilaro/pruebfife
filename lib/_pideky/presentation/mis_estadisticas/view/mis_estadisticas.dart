import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/_pideky/presentation/mis_estadisticas/view_model/mis_estadisticas_view_model.dart';
import 'package:emart/shared/widgets/acordion.dart';
import 'package:emart/src/preferences/const.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/utils/colores.dart';
import 'package:emart/src/widget/acciones_carrito_bart.dart';
import 'package:emart/src/widget/boton_actualizar.dart';
import 'package:flutter/material.dart';
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantesColores.color_fondo_gris,
      appBar: AppBar(
        title: Text('Mis estadisticas',
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
                child: viewModel.listTopMarcas.length == 0 &&
                        viewModel.listTopProductos.length == 0 &&
                        viewModel.listTopSubCategorias.length == 0
                    ? Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 100, horizontal: 50),
                        child: Center(
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/image/jar-loading.gif',
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
                                      'No tienes información sificiente para calcular sus estadísticas. Te invitamos a seguir comprando en Pideky.',
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
                              'En esta sección encontrarás los productos, marcas y subcategorias que más compras en Pideky.',
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
                              acordionEmpodio(
                                  'Mi top 3 de productos',
                                  viewModel.listTopProductos.value,
                                  'Estos son los tres productos que más has comprado para tu negocio en el último mes.',
                                  'productos'),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Divider(
                                  thickness: 1,
                                  color: HexColor('#EAE8F5'),
                                ),
                              ),
                              acordionEmpodio('Mi top 3 de marcas',
                                  viewModel.listTopMarcas.value, '', 'marcas'),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Divider(
                                  thickness: 1,
                                  color: HexColor('#EAE8F5'),
                                ),
                              ),
                              acordionEmpodio(
                                  'Mi top 3 de subcategorias',
                                  viewModel.listTopSubCategorias.value,
                                  '',
                                  'subcategorias')
                            ],
                          ),
                        )
                      ])),
          )),
    );
  }
}

acordionEmpodio(String titulo, List lista, String subTitulo, String tipo) {
  return Acordion(
    title: Text(
      titulo,
      style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: ConstantesColores.azul_precio),
    ),
    elevation: 0,
    contenido: Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //Descripcion
          Container(
            margin: EdgeInsets.only(bottom: 20),
            width: Get.width * 0.83,
            child: AutoSizeText(
              subTitulo,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: ConstantesColores.gris_textos),
            ),
          ),
          for (var index = 0; index < lista.length; index++)
            //Cuerpo del acordion
            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Posicion
                      Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 9, horizontal: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: index + 1 == 1
                                ? ConstantesColores.empodio_verde
                                : index + 1 == 2
                                    ? ConstantesColores.empodio_amarillo
                                    : ConstantesColores.azul_precio,
                          ),
                          child: Center(
                              child: AutoSizeText('${index + 1}',
                                  style: TextStyle(
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                      color: index + 1 == 1 || index + 1 == 3
                                          ? Colors.white
                                          : ConstantesColores.azul_precio)))),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //Imagen
                            Container(
                              margin: EdgeInsets.only(right: 7),
                              child: tipo == 'productos' || tipo == 'marcas'
                                  ? CachedNetworkImage(
                                      height: Get.height * 0.08,
                                      imageUrl: tipo == 'productos'
                                          ? Constantes().urlImgProductos +
                                              '${lista[index].codigo}.png'
                                          : lista[index].imagen,
                                      placeholder: (context, url) =>
                                          Image.asset(
                                              'assets/image/jar-loading.gif'),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        'assets/image/logo_login.png',
                                        width: Get.width * 0.35,
                                      ),
                                      fit: BoxFit.fill,
                                    )
                                  : Image.asset(
                                      'assets/icon/mis_vendedores_img.png',
                                      alignment: Alignment.center,
                                      width: 30,
                                    ),
                            ),
                            //Descripcion
                            Container(
                              width: Get.width * 0.3,
                              margin: EdgeInsets.only(left: 10),
                              child: AutoSizeText(
                                lista[index].descripcion,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: ConstantesColores.azul_precio),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //Unidad
                      Container(
                        width: Get.width * 0.21,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[300],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            AutoSizeText(lista[index].cantidad.toString(),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: ConstantesColores.azul_precio)),
                            AutoSizeText('Unidades',
                                style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color: ConstantesColores.azul_precio))
                          ],
                        ),
                      )
                    ],
                  ),
                  index == 2
                      ? Container()
                      : Divider(
                          thickness: 1,
                          color: HexColor('#EAE8F5'),
                        ),
                ],
              ),
            ),
        ],
      ),
    ),
  );
}
