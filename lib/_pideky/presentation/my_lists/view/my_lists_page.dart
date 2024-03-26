import 'package:emart/_pideky/presentation/my_lists/view_model/my_lists_view_model.dart';
import 'package:emart/_pideky/presentation/my_lists/widgets/body_my_lists.dart';
import 'package:emart/_pideky/presentation/my_lists/widgets/pop_up_crear_lista.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';

class MyListsPage extends StatelessWidget {
  const MyListsPage({key});

  @override
  Widget build(BuildContext context) {
    final misListasViewModel = Get.find<MyListsViewModel>();
    misListasViewModel.getMisListas();
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
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) => PopUpCrearNuevaLista());
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 20, top: 30, bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image(
                        width: 30,
                        height: 30,
                        image: AssetImage(
                            'assets/icon/Icono_crear_nueva_lista.png')),
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
            ),
            BodyMyLists(),
          ],
        ),
      ),
    );
  }
}
