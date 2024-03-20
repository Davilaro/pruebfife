import 'package:emart/_pideky/domain/cart/use_cases/cart_use_cases.dart';
import 'package:emart/_pideky/presentation/product/view_model/product_view_model.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class ConfigureOrderViewModel extends GetxController {
  final CartUseCases cartUseCases = CartUseCases();
  final productoViewModel = Get.find<ProductViewModel>();
  RxInt numEmpresa = 0.obs;

  TextStyle disenoValores() => TextStyle(
      fontSize: 17.0, color: HexColor("#43398E"), fontWeight: FontWeight.bold);

  Widget total(size, cartProvider, format) {
    return Container(
      child: Container(
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(height: 40.0),
            Text(
                'Total: ${productoViewModel.getCurrency(cartProvider.getTotal)}',
                style: disenoValores()),
            Text(
              '* Este pedido ya tiene incluido los impuestos',
              style: TextStyle(color: ConstantesColores.verde),
            ),
            cartProvider.getTotalAhorro - cartProvider.getTotal == 0
                ? Container()
                : Text(
                    'Estás ahorrando: ${productoViewModel.getCurrency((cartProvider.getTotalAhorro - cartProvider.getTotal))}',
                    style: TextStyle(color: Colors.red[600]),
                  ),
            Divider(height: 40.0),
          ],
        ),
      ),
    );
  }
}
