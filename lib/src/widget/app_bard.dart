import 'package:emart/src/widget/acciones_carrito_bart.dart';
import 'package:emart/src/widget/boton_actualizar.dart';
import 'package:emart/src/widget/imagen_notification.dart';
import 'package:emart/src/widget/soporte.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBarGeneral extends StatelessWidget {
  const AppBarGeneral({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 20, 10, 10),
        child: SvgPicture.asset('assets/app_bar.svg', fit: BoxFit.fill),
      ),
      leading: Padding(
        padding: const EdgeInsets.fromLTRB(10, 2.0, 0, 0),
        child: new IconButton(
          icon: Image.asset('assets/boton_soporte.png'),
          onPressed: () => {
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
      elevation: 0,
      actions: <Widget>[
        BotonActualizar(),
        AccionNotificacion(),
        AccionesBartCarrito(esCarrito: false),
      ],
    );
  }
}
