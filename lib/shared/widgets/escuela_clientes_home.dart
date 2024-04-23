import 'package:emart/shared/widgets/boton_agregar_carrito.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../_pideky/presentation/principal_page/view_model/view_model_principal_page.dart';
import '../../src/modelos/multimedia.dart';
import '../../src/provider/db_provider.dart';

class EscuelaClientes extends StatefulWidget {
  const EscuelaClientes({Key? key}) : super(key: key);

  @override
  State<EscuelaClientes> createState() => _EscuelaClientesState();
}

class _EscuelaClientesState extends State<EscuelaClientes> {

  bool _hasErrorSchoolClient = false;

 final viewModelPrincipalPage = Get.put(ViewModelPrincipalPage());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        initialData: [],
        future: DBProvider.db.consultarMultimedia(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.data == null || snapshot.data.length == 0) {
            return Container();
          } else {
            Multimedia multimedia = snapshot.data[0];
            // cargoConfirmar.setUrlMultimedia(multimedia.link);
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              margin: EdgeInsets.only(top: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 15, left: 15, right: 15),
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
                        SvgPicture.asset(
                          'assets/image/logo-escuela-clientes-top.svg',
                          width: 90,
                        )
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                        //margin: EdgeInsets.only(top: 5),
                        height: Get.height * 0.25,
                        // padding: EdgeInsets.symmetric(horizontal: 3),

                        child: _hasErrorSchoolClient
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Container(
                                  color: Colors.black,
                                  height: Get.height * 0.25,
                                  child: Center(
                                      child: Text(
                                    'No se puede mostrar el contenido',
                                    style: TextStyle(color: Colors.white),
                                  )),
                                ),
                              )
                            : InAppWebView(
                                initialData: InAppWebViewInitialData(
                                  data: """
                                       ${multimedia.link}
                                       ${multimedia.orientacion}
                                                """,
                                ),
                                // initialSettings: InAppWebViewSettings(
                                //   crossPlatform: InAppWebViewOptions(
                                //     mediaPlaybackRequiresUserGesture: false,
                                //   ),
                                //  ),
                                onReceivedError: ((controller, request, error) {
                                  setState(() {
                                    _hasErrorSchoolClient = true;
                                  });
                                }),
                                // onReceivedHttpError:
                                //     (controller, request, errorResponse) {
                                //   setState(() {
                                //       _hasErrorSchoolClient = true;
                                //       });
                                //     },
                              )

                        // ReproductVideo(multimedia),
                        ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Text(
                      'Si te apasiona el aprendizaje y quieres ver más contenido como este.',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: HexColor("#41398D"),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Center(
                    child: BotonAgregarCarrito(
                      marginTop: 10,
                      width: Get.width * 0.9,
                      height: Get.height * 0.07,
                      color: ConstantesColores.empodio_verde,
                      onTap: () {
                        viewModelPrincipalPage.launchUrlcustomersSchool();
                      },
                      text: 'Visita escuela de clientes',
                      borderRadio: 30,
                    ),
                  )
                ],
              ),
            );
          }
        });
  }
}
// class EscuelaClientes extends StatelessWidget {
//   EscuelaClientes();

//   @override
//   Widget build(BuildContext context) {
//     return 
    
//     Container(
//       height: Get.height * 0.55,
//       width: double.infinity,
//       //color: Colors.red,
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(18.0),
//             child: Row(
//               children: [
//                 Text(
//                   'Desarrolla tu negocio',
//                   style: TextStyle(
//                       fontSize: 16.0,
//                       color: HexColor("#41398D"),
//                       fontWeight: FontWeight.bold),
//                 ),
//                 Spacer(),
//                 SvgPicture.asset(
//                   'assets/image/logo-escuela-clientes-top.svg',
//                   width: 90,
//                 )
//               ],
//             ),
//           ),
//           //Card escuela de clientes
//           ClipRRect(
//             borderRadius: BorderRadius.circular(19),
//             child: Container(
//              //padding: EdgeInsets.only(bottom: 10),
//              // color: Colors.black,
//               alignment: Alignment.center,
//               height: Get.height * 0.25,
//               width: Get.width * 0.95,
             
//               child: InAppWebView(
                
//                 initialData: InAppWebViewInitialData(
//                   data: """                    
//                   <html>
//                       <head>
//                         <style>
//                           body, html {
//                             margin: 0;
//                             padding: 0;
//                             height: 100%;
//                             overflow: hidden;
//                           }
//                           iframe {
//                             position: absolute;
//                             top: 0;
//                             left: 0;
//                             right: 0;
//                             bottom: 0;
//                             width: 100%;
//                             height: 100%;
//                             border: none; /* Elimina el borde del iframe */
//                             background-color: #f0f0f0; /* Cambia el color de fondo según tus preferencias */
//                           }
//                           .ytp-chrome-bottom {
//                             bottom: 200px; /* Ajusta la posición vertical de la barra de controles */
//                           }
//                         </style>
//                       </head>
//                       <body>
//                         <iframe src="https://www.youtube.com/embed/njX2bu-_Vw4?modestbranding=1&showinfo=0" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
//                       </body>
//                     </html>
                             
//                       """,
//                 // src="https://www.youtube.com/embed/Al87y8JpvlY?controls=0"
//                 ),
//                 initialOptions: InAppWebViewGroupOptions(
                  
//                   crossPlatform: InAppWebViewOptions(
                    
//                     javaScriptEnabled: true,
//                     mediaPlaybackRequiresUserGesture: false,
//                   ),
//                 ),
//               )
//                //Image.asset('assets/image/jar-loading.gif'),
            
            
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             child: Text(
//               'Si te apasiona el aprendizaje y quieres ver más contenido como este.',
//               textAlign: TextAlign.start,
//               style: TextStyle(
//                   fontSize: 16.0,
//                   color: HexColor("#41398D"),
//                   fontWeight: FontWeight.bold),
//             ),
//           ),

//           BotonAgregarCarrito(
//             marginTop: 10,
//             width: Get.width * 0.9,
//             height: Get.height * 0.07,
//             color: ConstantesColores.empodio_verde,
//             onTap: () {
//               _launchUrl();
//             },
//             text: 'Visita escuela de clientes',
//             borderRadio: 30,
//           )
//         ],
//       ),
//     );
//   }

//   _launchUrl() async {
//     const String url = 'https://escueladeclientesnutresa.com';
//      final Uri uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     } else {
//       throw 'No se pudo abrir la URL $url';
//     }
//   }
// }
