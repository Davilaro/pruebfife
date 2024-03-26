import 'package:emart/_pideky/domain/buy_sell_earn/model/buy_sell_earn_model.dart';
import 'package:emart/_pideky/presentation/buy_sell_earn/view_model/buy_sell_earn_view_model.dart';
import 'package:emart/_pideky/presentation/product/view_model/product_view_model.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TicketDescription extends StatelessWidget {
  final BuySellEarnModel compraVendeGana;
  const TicketDescription({
    Key? key,
    required this.compraVendeGana,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BuySellEarnViewModel compraVendeGanaViewModel =
        BuySellEarnViewModel.getMyController();
    ProductViewModel productViewModel = Get.find();
    return Container(
      width: Get.width * 0.4,
      margin: EdgeInsets.only(
          right: Get.width * 0.07,
          top: Get.height * 0.01,
          bottom: Get.height * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${compraVendeGana.nombre}",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Color(int.parse("0xff${compraVendeGana.colorLetra1!}")),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: Get.height * 0.01),
          Text(
            "Compra: ${productViewModel.getCurrency(compraVendeGana.precio)}",
            style: TextStyle(
                color: Color(int.parse("0xff${compraVendeGana.colorLetra2!}")),
                fontSize: 13),
          ),
          Text(
            "Vende: ${productViewModel.getCurrency(compraVendeGana.vende)}",
            style: TextStyle(
                color: Color(int.parse("0xff${compraVendeGana.colorLetra2!}")),
                fontSize: 13),
          ),
          SizedBox(height: Get.height * 0.01),
          Text(
            "GANA: ${productViewModel.getCurrency(compraVendeGana.gana)}",
            style: TextStyle(
                color: Color(int.parse("0xff${compraVendeGana.colorLetra1!}")),
                fontSize: 15,
                fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Container(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  child: Container(
                      width: Get.width * 0.33,
                      height: Get.height * 0.03,
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
                                color:
                                    ConstantesColores.azul_aguamarina_botones),
                          )
                        ],
                      )),
                  onTap: () async {
                    await compraVendeGanaViewModel.addCuponToCar(
                        compraVendeGana.codigo!, context);
                  },
                )),
          ),
        ],
      ),
    );
  }
}
