import 'package:emart/_pideky/presentation/mis_pagos_nequi/view/widgets/acordion_pagos_pendientes.dart';
import 'package:emart/_pideky/presentation/mis_pagos_nequi/view/widgets/acordion_pagos_realizados.dart';
import 'package:emart/_pideky/presentation/mis_pagos_nequi/view/widgets/card_micuenta.dart';
import 'package:emart/_pideky/presentation/mis_pagos_nequi/view_model/mis_pagos_nequi_view_model.dart';
import 'package:emart/shared/widgets/boton_agregar_carrito.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../src/widget/acciones_carrito_bart.dart';
import '../../../../src/widget/boton_actualizar.dart';
import '../../../../src/widget/imagen_notification.dart';
import '../../../../src/widget/soporte.dart';

class MisPagosNequiPage extends StatefulWidget {
  const MisPagosNequiPage({Key? key}) : super(key: key);

  @override
  State<MisPagosNequiPage> createState() => _MisPagosNequiPageState();
}

class _MisPagosNequiPageState extends State<MisPagosNequiPage> {
  final controller = Get.find<MisPagosNequiViewModel>();
  @override
  void initState() {
    super.initState();
    controller.initData();
    //UXCAM: Se define el nombre de la interfaz
    FlutterUxcam.tagScreenName('MyNequiPaymentsPage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantesColores.color_fondo_gris,
      appBar: AppBar(
        title: Text(
          'Mis Pagos Nequi',
          style: TextStyle(
              color: ConstantesColores.azul_precio,
              fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: HexColor("#30C3A3")),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          BotonActualizar(),
          AccionNotificacion(),
          AccionesBartCarrito(esCarrito: true),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CardMicuenta(controller: controller),
              AcordionPagosRealizados(),
              AcordionPagosPendientes(),
              SizedBox(
                height: 40,
              ),
              Text(
                "¿Necesitas ayuda con tus pagos?",
                style: TextStyle(
                    color: ConstantesColores.azul_precio, fontSize: 18),
              ),
              BotonAgregarCarrito(
                  height: 40,
                  width: Get.width * 0.85,
                  color: ConstantesColores.azul_aguamarina_botones,
                  onTap: () {
                    //UXCam: Llamamos el evento clickSoport
                    UxcamTagueo().clickSoport();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Soporte(
                                numEmpresa: 1,
                              )),
                    );
                  },
                  text: "Soporte")
            ],
          ),
        ),
      ),
    );
  }
}
