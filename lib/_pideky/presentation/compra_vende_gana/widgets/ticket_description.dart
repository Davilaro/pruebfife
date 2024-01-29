import 'package:emart/_pideky/domain/compra_vende_gana/model/compra_vende_gana_model.dart';
import 'package:emart/_pideky/presentation/productos/view_model/producto_view_model.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TicketDescription extends StatelessWidget {
  final CompraVendeGanaModel compraVendeGanaModel;
  const TicketDescription({
    Key? key,
    required this.compraVendeGanaModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProductoViewModel productViewModel = Get.find();
    return Container(
      width: Get.width * 0.4,
      margin: EdgeInsets.only(right: Get.width * 0.07, top: Get.height * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            compraVendeGanaModel.nombre,
            maxLines: 2,
            style: TextStyle(
                color:
                    Color(toInt("0xff${compraVendeGanaModel.colorLetraGran}")),
                fontSize: 14,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis),
          ),
          SizedBox(height: Get.height * 0.01),
          Text(
            "Compra: ${productViewModel.getCurrency(compraVendeGanaModel.compra)}",
            style: TextStyle(
                color:
                    Color(toInt("0xff${compraVendeGanaModel.colorLetraPequ}")),
                fontSize: 13),
          ),
          Text(
            "Vende: ${productViewModel.getCurrency(compraVendeGanaModel.vende)}",
            style: TextStyle(
                color:
                    Color(toInt("0xff${compraVendeGanaModel.colorLetraPequ}")),
                fontSize: 13),
          ),
          SizedBox(height: Get.height * 0.01),
          Text(
            "GANA: ${productViewModel.getCurrency(compraVendeGanaModel.gana)}",
            style: TextStyle(
                color:
                    Color(toInt("0xff${compraVendeGanaModel.colorLetraGran}")),
                fontSize: 15,
                fontWeight: FontWeight.bold),
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
                onTap: () async {},
              )),
        ],
      ),
    );
  }
}
