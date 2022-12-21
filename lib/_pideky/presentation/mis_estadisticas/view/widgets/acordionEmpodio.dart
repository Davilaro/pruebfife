import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/_pideky/domain/estadistica/model/estadistica.dart';
import 'package:emart/shared/widgets/acordion.dart';
import 'package:emart/src/preferences/const.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class AcordionEmpodio extends StatelessWidget {
  String? titulo, subTitulo, tipo;
  List lista;

  List imgSubCategoria = [
    'assets/image/Corazon.png',
    'assets/image/corona.png',
    'assets/image/estrella.png'
  ];
  AcordionEmpodio(
      {Key? key, this.titulo, required this.lista, this.subTitulo, this.tipo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Acordion(
      title: Text(
        titulo!,
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
                subTitulo!,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: ConstantesColores.gris_textos),
              ),
            ),
            empodio(lista, tipo!, imgSubCategoria),
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
                            padding: EdgeInsets.symmetric(
                                vertical: 9, horizontal: 14),
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
                                    : Image.asset(imgSubCategoria[index],
                                        alignment: Alignment.center,
                                        width: Get.width * 0.12),
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

  empodio(List lista, String tipo, List imgSubCategoria) {
    return Container(
      height: Get.height * 0.26,
      child: Stack(
        fit: StackFit.loose,
        clipBehavior: Clip.none,
        alignment: AlignmentDirectional.center,
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child:
                circuloPosicionEmpodio(lista[1], '2', tipo, imgSubCategoria[1]),
          ),
          Align(
            alignment: Alignment.topCenter,
            child:
                circuloPosicionEmpodio(lista[0], '1', tipo, imgSubCategoria[0]),
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: circuloPosicionEmpodio(
                  lista[2], '3', tipo, imgSubCategoria[2]))
        ],
      ),
    );
  }

  circuloPosicionEmpodio(
      Estadistica item, String posicion, String tipo, String imgSubCategoria) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(200),
      child: Stack(
        fit: StackFit.loose,
        clipBehavior: Clip.none,
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 40),
            child: Container(
                width: Get.width * 0.3,
                height: Get.width * 0.3,
                padding: EdgeInsets.all(50),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Color.fromARGB(255, 244, 242, 242),
                      width: Get.width * 0.03,
                      style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(100),
                )),
          ),
          Container(
            margin: EdgeInsets.only(top: 40),
            //Imagen
            child: Container(
                width: Get.width * 0.23,
                height: Get.width * 0.23,
                decoration: BoxDecoration(
                  image: tipo == 'productos' || tipo == 'marcas'
                      ? DecorationImage(
                          image: NetworkImage(
                            tipo == 'productos'
                                ? Constantes().urlImgProductos +
                                    '${item.codigo}.png'
                                : item.imagen,
                          ),
                          scale: 2,
                          fit: BoxFit.cover,
                        )
                      : DecorationImage(
                          image: AssetImage(
                            imgSubCategoria,
                          ),
                          fit: BoxFit.contain,
                        ),
                  border: Border.all(
                      color: Colors.transparent,
                      width: Get.width * 0.03,
                      style: BorderStyle.solid),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 194, 194, 194),
                      offset: const Offset(
                        1.0,
                        1.0,
                      ),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ), //BoxShadow
                    BoxShadow(
                      color: Colors.white,
                      offset: const Offset(0.0, 0.0),
                      blurRadius: 5.0,
                      spreadRadius: 5.0,
                    ), //BoxShadow
                  ],
                  borderRadius: BorderRadius.circular(100),
                )),
          ),
          Positioned(
            top: 0,
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 9, horizontal: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: posicion == '1'
                      ? ConstantesColores.empodio_verde
                      : posicion == '2'
                          ? ConstantesColores.empodio_amarillo
                          : ConstantesColores.azul_precio,
                ),
                child: Center(
                    //Posicion
                    child: AutoSizeText(posicion,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)))),
          ),
        ],
      ),
    );
  }
}
