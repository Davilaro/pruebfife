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

  InAppWebViewController? _webViewController;
  bool _isPaused = false;

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
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      color: Colors.black,
                        padding: EdgeInsets.only(bottom: 5),
                        height: Get.height * 0.25,
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
                                onWebViewCreated: (controller) {
                                  _webViewController = controller;
                                  _injectJavaScriptToDetectPlayback();
                                },
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

  void _injectJavaScriptToDetectPlayback() {
    final script = """
      // Detecta el evento de estado del reproductor
      function onPlayerStateChange(event) {
        // Reproduce: 1, Pausa: 2
        if (event.data === 1) {
          window.flutter_inappwebview.callHandler('onPlay');
        } else if (event.data === 2) {
          window.flutter_inappwebview.callHandler('onPause');
        }
      }

      // Añade el listener al reproductor de video
      var player = document.querySelector('iframe');
      if (player) {
        player.contentWindow.postMessage({
          event: 'infoDelivery',
          func: 'addEventListener',
          args: ['onStateChange', onPlayerStateChange]
        }, '*');
      }
    """;

    _webViewController?.evaluateJavascript(source: script);

    _webViewController?.addJavaScriptHandler(
      handlerName: 'onPlay',
      callback: (args) {
        setState(() {
          _isPaused = false;
          print('xxxxxxxxxxxxxxxxxxxxxxxxxxxx  Video started playing');
        });
      },
    );

    _webViewController?.addJavaScriptHandler(
      handlerName: 'onPause',
      callback: (args) {
        setState(() {
          _isPaused = true;
          print('rrrrrrrrrrrrrrrrrrrr Video paused');
        });
      },
    );
  }
}

