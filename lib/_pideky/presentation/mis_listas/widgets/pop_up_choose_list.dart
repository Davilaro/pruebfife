import 'package:emart/_pideky/domain/mi_listas/model/lista_encabezado_model.dart';
import 'package:emart/_pideky/domain/producto/model/producto.dart';
import 'package:emart/_pideky/presentation/mis_listas/view_model/mis_listas_view_model.dart';
import 'package:emart/_pideky/presentation/mis_listas/widgets/pop_up_crear_lista.dart';
import 'package:emart/shared/widgets/boton_agregar_carrito.dart';
import 'package:emart/src/controllers/controller_db.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class PopUpChooseList extends StatefulWidget {
  final List<Producto> productos;
  final cantidad;
  const PopUpChooseList(
      {Key? key, required this.productos, required this.cantidad})
      : super(key: key);

  @override
  State<PopUpChooseList> createState() => _PopUpChooseListState();
}

class _PopUpChooseListState extends State<PopUpChooseList> {
  final myList = Get.find<MyListsViewModel>();
  final cargoConfirmar = Get.find<ControlBaseDatos>();
  RxMap mapProducts = {}.obs;
  Map<ListaEncabezado, bool> mapaDeListas = {};

  @override
  void initState() {
    super.initState();
    mapaDeListas = Map.fromIterable(
      myList.misListas,
      key: (modelo) => modelo,
      value: (modelo) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: Get.width * 0.05,
          right: Get.width * 0.05,
          top: Get.height * 0.18,
          bottom: Get.height * 0.17),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
            height: Get.height,
            width: Get.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Column(
                children: [
                  Text('Lista personalizada',
                      style: TextStyle(
                          color: ConstantesColores.gris_oscuro,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) =>
                                  PopUpCrearNuevaLista());
                        },
                        child: Icon(Icons.add_circle_outline_rounded,
                            size: 35, color: ConstantesColores.azul_precio),
                      ),
                      Expanded(
                        child: Text('Crear nueva lista personalizada',
                            style: TextStyle(
                                color: ConstantesColores.azul_precio,
                                fontSize: 15,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                  Container(
                    height: Get.height * 0.3,
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: mapaDeListas.length,
                      itemBuilder: (BuildContext context, int index) {
                        ListaEncabezado clave =
                            mapaDeListas.keys.elementAt(index);
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      mapaDeListas[clave] =
                                          !mapaDeListas[clave]!;
                                    });
                                  },
                                  child: SvgPicture.asset(
                                    mapaDeListas[clave] == true
                                        ? 'assets/icon/Corazón_lleno.svg'
                                        : 'assets/icon/Corazón_Trazo.svg',
                                    height: 25,
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Añadir a:',
                                        style: TextStyle(
                                            color:
                                                ConstantesColores.gris_textos,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold)),
                                    Text('${clave.nombre}',
                                        style: TextStyle(
                                            color:
                                                ConstantesColores.gris_oscuro,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  BotonAgregarCarrito(
                      height: 40,
                      color: ConstantesColores.azul_precio,
                      onTap: () async {
                        for (var i = 0; i < mapaDeListas.length; i++) {
                          ListaEncabezado clave =
                              mapaDeListas.keys.elementAt(i);
                          if (mapaDeListas[clave] == true) {
                            widget.productos.forEach((element) async {
                              await myList.addProduct(element, clave.id,
                                  widget.cantidad, clave.nombre);
                            });
                          }
                        }

                        Get.back();
                      },
                      text: 'Aceptar')
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 8,
            child: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: ConstantesColores.azul_precio,
                borderRadius: BorderRadius.circular(50),
              ),
              child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Icon(Icons.close, color: Colors.white, size: 30)),
            ),
          )
        ],
      ),
    );
  }
}
