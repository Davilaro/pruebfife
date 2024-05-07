import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../src/preferences/cont_colores.dart';

void notificationMaximumPromotionlimit() {
  Get.showSnackbar(GetSnackBar(
    margin: EdgeInsets.symmetric(horizontal: 10),
    backgroundColor: Colors.white,
    borderRadius: 20,
    messageText: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
              'Has alcanzado la cantidad máxima de compra para esta promoción',
              style: TextStyle(
                  color: ConstantesColores.rojo_letra,
                  fontWeight: FontWeight.bold)),
        ),
        GestureDetector(
          onTap: () => {
            Get.back(),
            },
          child: Container(
            alignment: Alignment.topRight,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(Icons.close, color: Colors.white, size: 25.0)
          ),
        ),
      ],
    ),
    duration: Duration(seconds: 5),
    snackPosition: SnackPosition.TOP,
  ));
}
