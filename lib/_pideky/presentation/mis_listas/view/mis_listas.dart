import 'package:emart/_pideky/presentation/mis_listas/widgets/body_my_lists.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';

class MisListas extends StatelessWidget {
  const MisListas({key});

  @override
  Widget build(BuildContext context) {
    //UXCAM: Se define el nombre de la interfaz
    FlutterUxcam.tagScreenName('MyListsPage');
    //FIREBASE: Llamamos el evento select_content
    TagueoFirebase().sendAnalityticSelectContent(
        "Footer", "MisListas", "", "", "MisListas", 'MainActivity');
    return Scaffold(
      backgroundColor: ConstantesColores.color_fondo_gris,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Tus listas de compras favoritas listas para que hagas un pedido más rápido y sencillo.",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: ConstantesColores.gris_oscuro,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 30, bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Image(
                        width: 30,
                        height: 30,
                        image: AssetImage(
                            'assets/icon/Icono_crear_nueva_lista.png')),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Crear nueva lista',
                    style: TextStyle(
                        fontSize: 16,
                        color: ConstantesColores.azul_precio,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(child: BodyMyLists())
          ],
        ),
      ),
    );
  }
}
