import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/_pideky/domain/estadistica/model/estadistica.dart';
import 'package:emart/_pideky/presentation/mis_estadisticas/view/widgets/empodio.dart';
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
    'assets/image/corona.png',
    'assets/image/Corazon.png',
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
            //Empodio
            Empodio(
                lista: lista, tipo: tipo!, imgSubCategoria: imgSubCategoria),
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
                                width: Get.width * 0.28,
                                margin: EdgeInsets.only(left: 10),
                                child: AutoSizeText(
                                  tipo == 'marcas'
                                      ? ''
                                      : lista[index].descripcion,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: ConstantesColores.azul_precio),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        //Unidad
                        Container(
                          width: Get.width * 0.25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[300],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              AutoSizeText(lista[index].cantidad.toString(),
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: ConstantesColores.azul_precio)),
                              AutoSizeText('Unidades',
                                  maxLines: 1,
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
}
