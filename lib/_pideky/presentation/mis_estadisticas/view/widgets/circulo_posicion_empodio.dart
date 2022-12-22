import 'package:auto_size_text/auto_size_text.dart';
import 'package:emart/_pideky/domain/estadistica/model/estadistica.dart';
import 'package:emart/src/preferences/const.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CirculoPosicionEmpodio extends StatelessWidget {
  Estadistica item;
  String? posicion;
  String? tipo;
  String? imgSubCategoria;

  CirculoPosicionEmpodio(
      {Key? key,
      required this.item,
      this.posicion,
      required this.tipo,
      this.imgSubCategoria})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  color: Colors.transparent,
                  border: Border.all(
                      color: Color.fromARGB(255, 249, 249, 249),
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
                            imgSubCategoria!,
                          ),
                          fit: BoxFit.contain,
                        ),
                  border: Border.all(
                      color: Colors.transparent,
                      width: Get.width * 0.03,
                      style: BorderStyle.solid),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 237, 234, 234),
                      offset: const Offset(
                        1.0,
                        1.0,
                      ),
                      blurRadius: 5.0,
                      spreadRadius: 2.0,
                    ), //BoxShadow
                    BoxShadow(
                      color: Colors.white,
                      offset: const Offset(0.0, 0.0),
                      blurRadius: 0.0,
                      spreadRadius: 0.0,
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
                    child: AutoSizeText(posicion!,
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
