import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../src/preferences/cont_colores.dart';


class NotificationMaximumPromotionlimit extends StatelessWidget {
  final VoidCallback onClose;

  NotificationMaximumPromotionlimit({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: GetSnackBar(       
          backgroundColor: Colors.white,
          borderRadius: 20,
          messageText: Row(
            children: [
              Expanded(
                child: Text('Has alcanzado la cantidad máxima de compra para esta promoción',
                    style: TextStyle(
                        color: ConstantesColores.rojo_letra,
                        fontWeight: FontWeight.bold)),
              ),
              Container(
                alignment: Alignment.topRight,
                color: Colors.amber,
                child: IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: onClose,
                    ),
              ),
            ],
          ),
          duration: Duration(seconds: 5),
          snackPosition: SnackPosition.TOP,
        ),
    );
    
    // SafeArea(
    //   child: Container(
    //     height: 75,
    //     width: double.infinity,
    //     color: Colors.grey[400], // Fondo gris oscuro
    //     child: Container(
    //       margin: EdgeInsets.all(8.0),
    //       decoration: BoxDecoration(
    //         color: Colors.white,
    //         borderRadius: BorderRadius.circular(19.0),
    //       ),
    //       child: Padding(
    //         padding: EdgeInsets.symmetric(horizontal: 20.0),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             Flexible(
    //               child: Text(
    //                 "Has alcanzado la cantidad máxima de compra para esta promoción",
    //                 style: TextStyle(
    //                   color: Colors.red,
    //                   fontWeight: FontWeight.bold,
    //                 ),
    //               ),
    //             ),
    //             IconButton(
    //               icon: Icon(Icons.close, color: Colors.red),
    //               onPressed: onClose,
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
