import 'package:emart/_pideky/presentation/cart/view_model/cart_view_model.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GeneralSavedIndicator extends StatelessWidget {
  const GeneralSavedIndicator({
    Key? key,
    required this.cartViewModel,
  }) : super(key: key);

  final CartViewModel cartViewModel;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: cartViewModel.getNuevoTotalAhorro == 0.0
          ? false
          : true,
      child: Container(
        padding: EdgeInsets.only(top: 5, bottom: 5),
        height: Get.height * 0.099,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          color: ConstantesColores.azul_precio,
          child: Row(
            children: [
              SizedBox(
                width: 10.0,
              ),
              Container(
                width: 45.0,
                height: 45.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: ConstantesColores
                      .azul_aguamarina_botones,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/icon/Icono_valor_ahorrado.png',
                    fit: BoxFit.cover,
                    width: 30,
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Stack(children: [
                  Positioned(
                    right: -5,
                    bottom: -30,
                    child: Image.asset(
                      'assets/icon/Icono_marca_de_agua.png',
                      width: 100.0,
                      height: 100.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'El total ahorrado en estos pedidos es:',
                        style: TextStyle(
                            fontSize: 13.5,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${getCurrency(cartViewModel.getNuevoTotalAhorro)}",
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}