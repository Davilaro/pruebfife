// ignore_for_file: unnecessary_statements

import 'package:emart/shared/widgets/notification_push_in_app.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/widget/soporte.dart';
import 'package:emart/src/widget/titulo_pideky.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../src/utils/uxcam_tagueo.dart';
import '../../src/widget/acciones_carrito_bart.dart';
import '../../src/widget/boton_actualizar.dart';
import '../../src/widget/imagen_notification.dart';

class NewAppBar extends StatelessWidget {
  final GlobalKey<ScaffoldState> drawerKey;
  NewAppBar(this.drawerKey);

  @override
  Widget build(BuildContext context) {
    final prefs = Preferencias();
    return Container(
      color: ConstantesColores.color_fondo_gris,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4, right: 1, left: 8),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      width: 60,
                      height: 48,
                      child: new IconButton(
                        icon:
                            SvgPicture.asset('assets/image/boton_soporte.svg'),
                        onPressed: () => {
                          //UXCam: Llamamos el evento clickSoport
                          UxcamTagueo().clickSoport(),
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Soporte(
                                      numEmpresa: 1,
                                    )),
                          ),
                        },
                      ),
                    ),
                  ),
                  TituloPideky(size: MediaQuery.of(context).size)
                ],
              ),
              Row(
                children: [
                  BotonActualizar(),
                  AccionNotificacion(),
                  AccionesBartCarrito(esCarrito: false),
                ],
              ),
            ],
          ),
          Divider(
            color: Colors.black26,
          ),
          prefs.usurioLogin == 1
              ? GestureDetector(
                  onTap: () {
                    if (prefs.usurioLogin == 1)
                      drawerKey.currentState!.openDrawer();

                    
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                            width: 25,
                            height: 25,
                            image: AssetImage(
                                "assets/icon/Icono_ubi_sucursal.png")),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Text(
                            "Sucursal: ${prefs.direccionSucursal}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 15,
                                color: ConstantesColores.gris_textos,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 25,
                          color: ConstantesColores.azul_aguamarina_botones,
                        )
                      ],
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
