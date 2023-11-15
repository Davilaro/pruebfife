import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditList extends StatelessWidget {
  const EditList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map arguments = Get.arguments;
    final title = arguments['title'];
    return Scaffold(
      backgroundColor: ConstantesColores.color_fondo_gris,
      appBar: AppBar(
        leading: IconButton(
          iconSize: 30,
          icon: Icon(Icons.arrow_back_ios),
          color: ConstantesColores.azul_aguamarina_botones,
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Mis listas',
          textAlign: TextAlign.left,
          style: TextStyle(
              color: ConstantesColores.azul_precio,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  '$title',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: ConstantesColores.azul_precio,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 7,
                ),
                Image(
                  image: AssetImage('assets/icon/Icono_editar.png'),
                  height: 18,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Puede que alguno de los productos no estén disponibles o hayan cambiado de precio desde la ultima vez',
                style: TextStyle(
                  color: ConstantesColores.gris_oscuro,
                  fontSize: 15,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 13, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Seleccionar todos',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: ConstantesColores.azul_precio,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Image(
                    image: AssetImage('assets/icon/Icono_eliminar.png'),
                    height: 25,
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
