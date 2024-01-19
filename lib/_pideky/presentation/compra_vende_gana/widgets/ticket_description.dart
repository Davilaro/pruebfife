import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TicketDescription extends StatelessWidget {
  const TicketDescription({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.4,
      margin: EdgeInsets.only(right: Get.width * 0.07, top: Get.height * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "La Especial Kraks Limons caja x 12",
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: Get.height * 0.01),
          Text(
            "Compras: \$10.000",
            style:
                TextStyle(color: ConstantesColores.gris_oscuro, fontSize: 13),
          ),
          Text(
            "Vende: \$12.000",
            style:
                TextStyle(color: ConstantesColores.gris_oscuro, fontSize: 13),
          ),
          SizedBox(height: Get.height * 0.01),
          Text(
            "GANA: \$2.000",
            style: TextStyle(
                color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: Get.height * 0.02),
          Container(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                child: Container(
                    width: Get.width * 0.33,
                    height: Get.height * 0.04,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Agregar",
                          style: TextStyle(
                              color: ConstantesColores.azul_precio,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Icon(Icons.add,
                              size: 15,
                              color: ConstantesColores.azul_aguamarina_botones),
                        )
                      ],
                    )),
                onTap: () {},
              )),
        ],
      ),
    );
  }
}
