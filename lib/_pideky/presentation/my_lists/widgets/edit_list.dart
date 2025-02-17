import 'package:emart/_pideky/presentation/my_lists/view_model/my_lists_view_model.dart';
import 'package:emart/_pideky/presentation/my_lists/widgets/body_acordion_mis_listas.dart';
import 'package:emart/shared/widgets/boton_agregar_carrito.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/utils/alertas.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class EditList extends StatefulWidget {
  const EditList({Key? key}) : super(key: key);

  @override
  State<EditList> createState() => _EditListState();
}

class _EditListState extends State<EditList> {
  void mainStateList() {
    setState(() {});
  }

  final misListasViewModel = Get.find<MyListsViewModel>();

  @override
  Widget build(BuildContext context) {
    Map arguments = Get.arguments;
    final title = arguments['title'];
    final id = arguments['id'];
    return Scaffold(
      backgroundColor: ConstantesColores.color_fondo_gris,
      appBar: AppBar(
        leading: IconButton(
          iconSize: 30,
          icon: Icon(Icons.arrow_back_ios),
          color: ConstantesColores.azul_aguamarina_botones,
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Mis listas',
          textAlign: TextAlign.left,
          style: TextStyle(
              color: ConstantesColores.azul_precio,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  '$title',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: ConstantesColores.azul_precio,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 7,
                ),
                GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Align(
                            alignment: Alignment.center,
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              content: Container(
                                height: Get.height * 0.25,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Puede que algunos de los productos no estén disponibles o hayan cambiado de precio desde la última vez',
                                      style: TextStyle(
                                        color: ConstantesColores.azul_precio,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    BotonAgregarCarrito(
                                      borderRadio: 50,
                                      height: 40,
                                      color: ConstantesColores.azul_precio,
                                      onTap: () {
                                        Get.back();
                                      },
                                      text: "Entiendo",
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: SvgPicture.asset(
                      'assets/icon/Icono_informacion.svg',
                      height: 18,
                    )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Puede que alguno de los productos no estén disponibles o hayan cambiado de precio desde la última vez',
                style: TextStyle(
                  color: ConstantesColores.gris_oscuro,
                  fontSize: 15,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 13, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      misListasViewModel.mapListasProductos
                          .forEach((fabricante, value) {
                        value['isSelected'].value = !value['isSelected'].value;
                        value['items'].forEach((producto) {
                          producto.isSelected = value['isSelected'].value;
                          if (producto.isSelected!) {
                            misListasViewModel
                                .mapListasProductos[fabricante]
                                    ["precioProductos"]
                                .value += producto.precio * producto.cantidad;
                          } else {
                            misListasViewModel
                                .mapListasProductos[fabricante]
                                    ["precioProductos"]
                                .value = 0.0;
                          }
                        });
                      });
                    },
                    child: Text(
                      'Seleccionar todos',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: ConstantesColores.azul_precio,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(children: [
                  ...createAcordionListas(context, mainStateList).toList(),
                ]),
              ),
            ),
            Container(
              width: Get.width,
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  mostrarAlertCarteraEliminarLista(
                      context,
                      "¿Estas seguro que desea eliminar la lista de compras ",
                      null,
                      title,
                      id);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SvgPicture.asset(
                      'assets/icon/Icono_eliminar.svg',
                      height: 25,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Eliminar esta lista',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: ConstantesColores.azul_precio,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            BotonAgregarCarrito(
              marginTop: 30,
              borderRadio: 50,
              color: ConstantesColores.azul_aguamarina_botones,
              height: 50,
              width: Get.width * 0.7,
              onTap: () async {
                var flag = await misListasViewModel.addToCar(context);
                if (flag) {
                  await UxcamTagueo().addToCartMyLists(
                      misListasViewModel.productListToCartUxcam);
                }
              },
              text: 'Agregar al carrito',
            ),
            SizedBox(height: Get.height * 0.03)
          ],
        ),
      ),
    );
  }
}
