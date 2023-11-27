import 'package:emart/_pideky/presentation/mis_listas/view_model/mis_listas_view_model.dart';
import 'package:emart/shared/widgets/boton_agregar_carrito.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PopUpCrearNuevaLista extends StatelessWidget {
  const PopUpCrearNuevaLista({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myList = Get.find<MyListsViewModel>();
    return Container(
      margin: EdgeInsets.only(
          left: Get.width * 0.05,
          right: Get.width * 0.05,
          top: Get.height * 0.18,
          bottom: Get.height * 0.33),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
            height: Get.height,
            width: Get.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Column(
                children: [
                  Text('Lista personalizada',
                      style: TextStyle(
                          color: ConstantesColores.gris_oscuro,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 17),
                  Text(
                      'Guarda productos en listas personalizadas para realizar compras mucho más rápido y o sencillas',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: ConstantesColores.gris_oscuro, fontSize: 15)),
                  SizedBox(height: 20),
                  Card(
                    elevation: 0,
                    child: TextField(
                      onChanged: (value) {
                        Get.find<MyListsViewModel>().nombreNuevaLista.value =
                            value;
                      },
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40.0),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white),
                    ),
                  ),
                  BotonAgregarCarrito(
                      height: 40,
                      color: ConstantesColores.azul_precio,
                      onTap: () async {
                        await myList.addList(context);
                      },
                      text: 'Aceptar')
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 8,
            child: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: ConstantesColores.azul_precio,
                borderRadius: BorderRadius.circular(50),
              ),
              child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Icon(Icons.close, color: Colors.white, size: 30)),
            ),
          )
        ],
      ),
    );
  }
}
