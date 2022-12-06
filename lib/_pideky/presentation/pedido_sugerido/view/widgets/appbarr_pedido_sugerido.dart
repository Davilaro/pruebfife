import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:emart/src/widget/acciones_carrito_bart.dart';
import 'package:emart/src/widget/boton_actualizar.dart';
import 'package:emart/src/widget/imagen_notification.dart';
import 'package:emart/src/widget/soporte.dart';
import 'package:emart/src/widget/titulo_pideky.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBarPedidoSugerido extends StatelessWidget {
  const AppBarPedidoSugerido({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ConstantesColores.color_fondo_gris,
      title: TituloPideky(size: size),
      leading: Padding(
        padding: const EdgeInsets.fromLTRB(10, 2.0, 0, 0),
        child: Container(
          width: 100,
          child: new IconButton(
            icon: SvgPicture.asset('assets/boton_soporte.svg'),
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
      elevation: 0,
      actions: <Widget>[
        BotonActualizar(),
        AccionNotificacion(),
        AccionesBartCarrito(esCarrito: false),
      ],
    );
  }
}