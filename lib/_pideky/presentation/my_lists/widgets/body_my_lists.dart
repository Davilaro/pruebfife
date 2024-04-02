import 'package:emart/_pideky/presentation/my_lists/view_model/my_lists_view_model.dart';
import 'package:emart/_pideky/presentation/my_lists/widgets/edit_list.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BodyMyLists extends StatelessWidget {
  const BodyMyLists({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final misListasViewModel = Get.find<MyListsViewModel>();
    misListasViewModel.getMisListas();
    return Expanded(
      child: Obx(
        () => misListasViewModel.misListas.isNotEmpty
            ? ListView.builder(
                itemCount: misListasViewModel.misListas.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () async {
                      await misListasViewModel.mapearProductos(
                          misListasViewModel.misListas[index].id);
                      Get.to(() => EditList(), arguments: {
                        'id': misListasViewModel.misListas[index].id,
                        'title': misListasViewModel.misListas[index].nombre
                      });
                    },
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
                              "${misListasViewModel.misListas[index].nombre}",
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
              )
            : SizedBox.shrink(),
      ),
    );
  }
}
