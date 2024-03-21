import 'package:emart/shared/widgets/boton_agregar_carrito.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class EscuelaClientes extends StatelessWidget {
   EscuelaClientes();
  
  

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.45,
      width: double.infinity,
      //color: Colors.red,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: [
                Text(
                  'Desarrolla tu negocio',
                  style: TextStyle(
                      fontSize: 16.0,
                      color: HexColor("#41398D"),
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Icon(Icons.search, color: HexColor("#41398D"))
              ],
            ),
          ),
          //Card escuela de clientes
          Container(
            height: Get.height * 0.2,
            width: Get.width * 0.95,
            decoration: BoxDecoration(
                color: Colors.black38, 
                borderRadius: BorderRadius.circular(30)),
            child: Image.asset('assets/image/jar-loading.gif'),

            // child: ClipRRect(
            //     borderRadius: BorderRadius.circular(10.0),
            //     child: Image.network(
            //       item?.link,
            //       fit: BoxFit.fill,
            //       errorBuilder: (context, url, error) =>
            //           Image.asset('assets/image/jar-loading.gif'),
            //     )
            //     ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
                  'Si te apasiona el aprendizaje y quieres ver más contenido como este.',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 16.0,
                      color: HexColor("#41398D"),
                      fontWeight: FontWeight.bold),
                ),
          ),

          BotonAgregarCarrito(
            marginTop: 10,
            width: Get.width * 0.9,
            height: Get.height * 0.07,
            color: ConstantesColores.empodio_verde, 
            onTap: (){}, 
            text: 'Visita escuela de clientes',
            borderRadio: 30,
            )
        ],
        
      ),
    );
  }
}
