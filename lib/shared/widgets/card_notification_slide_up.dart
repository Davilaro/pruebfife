import 'package:emart/src/provider/opciones_app_bart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void showSlideUpNotification(context, data) {
  final provider = Provider.of<OpcionesBard>(context, listen: false);

  Get.showSnackbar(GetSnackBar(
    onTap: (snack) {
      provider.selectOptionMenu = 2;
      Get.back();
    },
    duration: Duration(minutes: 2),
    animationDuration: Duration(milliseconds: 800),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.grey.shade400,
    borderRadius: 15,
    messageText: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.0),
            bottomLeft: Radius.circular(12.0),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: 70,
            child: Image.network(
              data.imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(width: 10),
        Flexible(
          child: Text(
            data.descripcion,
            style: TextStyle(color: Colors.black, fontSize: 12),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(child: Icon(Icons.arrow_forward_ios, color: Colors.white)),
      ],
    ),
    margin: EdgeInsets.symmetric(horizontal: 24, vertical: 65),
    padding: EdgeInsets.all(0.0),
    isDismissible: false,
    dismissDirection: DismissDirection.horizontal,
    forwardAnimationCurve: Curves.easeOutBack,
    reverseAnimationCurve: Curves.ease,
  ));
}
// slideUpNotification(context) {
//   final provider = Provider.of<OpcionesBard>(context, listen: false);
//   return SnackBar(
//     elevation: 0,
//     dismissDirection: DismissDirection.horizontal,
//     duration: Duration(minutes: 2),
//     backgroundColor: Colors.transparent,
//     content: GestureDetector(
//       onTap: () {
//         provider.selectOptionMenu = 2;
//         ScaffoldMessenger.of(context).hideCurrentSnackBar();
//       },
//       child: Card(
//           shadowColor: Colors.transparent,
//           color: Colors.grey[400],
//           margin: EdgeInsets.symmetric(
//             horizontal: 0.01,
//           ),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(15)),
//           ),
//           child: SizedBox(
//               width: MediaQuery.of(context).size.width * 3.8,
//               height: MediaQuery.of(context).size.height * 0.12,
//               child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(12.0),
//                         bottomLeft: Radius.circular(12.0),
//                       ),
//                       child: Image.asset(
//                         'assets/image/slide_up_tosh_prueba.png',
//                         // height: MediaQuery.of(context).size.height * 0.1,
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//                     Flexible(
//                       child: Padding(
//                         padding: EdgeInsets.only(top: 15, left: 20, bottom: 20),
//                         child: Text(
//                           '¡Lleva tu negocio al siguiente nivel! pide galletas Tosh con 15% de descuento, Pide aquí ...',
//                           style: TextStyle(fontSize: 12, color: Colors.black),
//                           maxLines: 3,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 10)
//                   ]))),
//     ),
//   );
// }
