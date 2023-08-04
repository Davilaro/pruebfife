import 'package:flutter/material.dart';

// bool isSnackbarVisible = false;

// void slideUpNotification(BuildContext context) {
//   if (!isSnackbarVisible) {
//     isSnackbarVisible = true;
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext context) {
//         return SlideTransition(
//           position: Tween<Offset>(
//             begin: Offset(1.0, 0.0),
//             end: Offset.zero,
//           ).animate(
//             CurvedAnimation(
//               parent: ModalRoute.of(context)!.animation!,
//               curve: Curves.easeOut,
//             ),
//           ),
//           child: AnimatedOpacity(
//             opacity: ModalRoute.of(context)!.animation!.value,
//             duration: Duration(milliseconds: 250),
//             child: AnimatedContainer(
//               duration: Duration(minutes: 2),
//               padding: EdgeInsets.symmetric(horizontal: 0.01),
//               decoration: BoxDecoration(
//                 color: Colors.transparent,
//                 borderRadius: BorderRadius.all(Radius.circular(15)),
//               ),
//               child: SizedBox(
//                 width: MediaQuery.of(context).size.width * 3.8,
//                 height: MediaQuery.of(context).size.height * 0.12,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(12.0),
//                         bottomLeft: Radius.circular(12.0),
//                       ),
//                       child: Image.asset(
//                         'assets/image/slide_up_tosh_prueba.png',
//                         fit: BoxFit.cover,
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
//                     Icon(Icons.arrow_forward_ios, color: Colors.white),
//                     SizedBox(width: 10)
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     ).then((value) {
//       // Cuando se cierra el BottomSheet
//       isSnackbarVisible = false;
//     });
//   }
// }

slideUpNotification(context) {
  return SnackBar(
    elevation: 0,
    duration: Duration(minutes: 2),
    backgroundColor: Colors.transparent,
    content: GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
      child: Card(
          shadowColor: Colors.transparent,
          color: Colors.grey,
          margin: EdgeInsets.symmetric(
            horizontal: 0.01,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: SizedBox(
              width: MediaQuery.of(context).size.width * 3.8,
              height: MediaQuery.of(context).size.height * 0.12,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        bottomLeft: Radius.circular(12.0),
                      ),
                      child: Image.asset(
                        'assets/image/slide_up_tosh_prueba.png',
                        // height: MediaQuery.of(context).size.height * 0.1,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(top: 15, left: 20, bottom: 20),
                        child: Text(
                          '¡Lleva tu negocio al siguiente nivel! pide galletas Tosh con 15% de descuento, Pide aquí ...',
                          style: TextStyle(fontSize: 12, color: Colors.black),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.white),
                    SizedBox(width: 10)
                  ]))),
    ),
  );
}

  // Get.showSnackbar(
  //                 GetSnackBar(
  //                   duration: Duration(seconds: 15),
  //                   // snackPosition: SnackPosition.BOTTOM,
  //                   backgroundColor: Colors.grey.shade400,
  //                   borderRadius: 15,
  //                   margin: EdgeInsets.symmetric(vertical: 60),
  //                   padding: EdgeInsets.all(0.0),
  //                   // colorText: Colors.transparent,
  //                   forwardAnimationCurve: Curves.easeOutBack,
  //                   reverseAnimationCurve: Curves.fastLinearToSlowEaseIn,
  //                   maxWidth: Get.width - 60,
  //                   messageText: GestureDetector(
  //                     onTap: () {
  //                       Get.back();
  //                     },
  //                     child: Row(
  //                       children: [
  //                         ClipRRect(
  //                           borderRadius: BorderRadius.only(
  //                             topLeft: Radius.circular(12.0),
  //                             bottomLeft: Radius.circular(12.0),
  //                           ),
  //                           child: Image.asset(
  //                             'assets/image/slide_up_tosh_prueba.png',
  //                             height:
  //                                 Get.height * 0.10,
  //                             fit: BoxFit.cover,
  //                           ),
  //                         ),
  //                         SizedBox(width: 10),
  //                         Flexible(
  //                           child: Text(
  //                             '¡Lleva tu negocio al siguiente nivel! pide galletas Tosh con 15% de descuento, Pide aquí ...',
  //                             style: TextStyle(
  //                                 color: Colors.black, fontSize: 12),
  //                             maxLines: 3,
  //                             overflow: TextOverflow.ellipsis,
  //                           ),
  //                         ),
  //                         Icon(Icons.arrow_forward_ios, color: Colors.white),
  //                         SizedBox(
  //                           width: 10,
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 ));
//}
