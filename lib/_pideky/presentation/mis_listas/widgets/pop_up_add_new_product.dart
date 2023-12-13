import 'package:emart/_pideky/domain/producto/model/producto.dart';
import 'package:emart/_pideky/presentation/mis_listas/widgets/pop_up_choose_list.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PopUpAddNewProduct extends StatelessWidget {
  final List nombresListas;
  final Producto producto;
  final cantidad;

  const PopUpAddNewProduct(
      {Key? key,
      required this.nombresListas,
      required this.producto,
      required this.cantidad})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List nombresDeUsuarios =
        nombresListas.map((lista) => lista.nombre).toList();
    String resultado = nombresDeUsuarios.join(", ");
    String texto = nombresListas.length > 1
        ? "ya esta en las listas"
        : "ya esta en la lista";
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      content: Container(
        constraints: BoxConstraints(
            minHeight: 300, minWidth: double.infinity, maxHeight: 400),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: 80.0,
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Este producto $texto de',
                      style: TextStyle(
                        color: ConstantesColores.gris_oscuro,
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                          text: " $resultado",
                          style: TextStyle(
                            color: ConstantesColores.azul_precio,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )),
              Text(
                '¿Estas seguro que quieres agregarlo nuevamente?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ConstantesColores.gris_oscuro,
                  fontSize: 16,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: GestureDetector(
                  onTap: () async {
                    Get.back();
                    showDialog(
                        context: context,
                        builder: (_) => PopUpChooseList(
                              producto: producto,
                              cantidad: cantidad,
                            ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                    height: 40,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        "assets/image/btn_aceptar.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    alignment: Alignment.center,
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: ConstantesColores.gris_oscuro,
                        width: 1,
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadiusDirectional.all(
                        Radius.circular(50),
                      ),
                    ),
                    child: Text(
                      "Cancelar",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ConstantesColores.gris_oscuro,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
