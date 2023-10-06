import 'package:auto_size_text/auto_size_text.dart';
import 'package:emart/_pideky/presentation/authentication/view/log_in/login_page.dart';
import 'package:emart/src/pages/carrito/carrito_compras.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/opciones_app_bart.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

final prefs = new Preferencias();

class AccionesBartCarrito extends StatelessWidget {
  final bool esCarrito;

  const AccionesBartCarrito({
    Key? key,
    required this.esCarrito,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OpcionesBard>(context);

    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 5.0, 10, 0),
        child: Stack(
          children: [
            IconButton(
              icon: Image.asset('assets/image/carrito_btn.png'),
              tooltip: 'Show Snackbar',
              onPressed: () {
                _cambiarDePantalla(context, esCarrito, provider);
              },
            ),
            Positioned(
                top: 0,
                right: 1,
                child: Obx(
                  () => Container(
                      height: 20,
                      width: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: HexColor("#41398D"),
                          ),
                          color: Colors.white),
                      child: AutoSizeText(
                        int.parse(PedidoEmart.cantItems.value) >= 0
                            ? '${PedidoEmart.cantItems.value}'
                            : '0',
                        presetFontSizes: [12, 10],
                        style: TextStyle(
                            color: HexColor("#41398D"), fontSize: 10.0),
                      )),
                )),
          ],
        ));
  }

  _cambiarDePantalla(
      BuildContext context, bool esCarrito, OpcionesBard provider) async {
    if (prefs.usurioLogin == -1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LogInPage()),
      );
    } else {
      //UXCam: Llamamos el evento clickCarrito
      UxcamTagueo().clickCarrito(provider, 'Superior');
      if (!esCarrito) {
       await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CarritoCompras(numEmpresa: prefs.numEmpresa)),
        );
      } else {
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CarritoCompras(numEmpresa: prefs.numEmpresa)),
        );
      }
    }
  }
}
