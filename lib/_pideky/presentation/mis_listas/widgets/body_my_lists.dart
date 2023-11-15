import 'package:emart/_pideky/presentation/mis_listas/widgets/edit_list.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BodyMyLists extends StatelessWidget {
  const BodyMyLists({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () => Get.to(() => EditList(),
              arguments: {'title': 'Lista de compras'}),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              margin: EdgeInsets.only(left: 20, right: 10),
              child: Row(
                children: [
                  Image(
                    image: AssetImage('assets/icon/Icono_lista.png'),
                    height: 30,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: Text(
                    "Listas de pedidos",
                    style: TextStyle(
                        color: ConstantesColores.azul_precio,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
