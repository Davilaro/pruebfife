

 import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/_pideky/presentation/cart/view_model/cart_view_model.dart';
import 'package:emart/_pideky/presentation/cart/widgets/grid_item_by_expansion_panel.dart';
import 'package:emart/_pideky/presentation/product/view_model/product_view_model.dart';
import 'package:emart/generated/l10n.dart';
import 'package:emart/shared/widgets/barra_faltante_monto_minimo.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/utils/util.dart';
import 'package:emart/src/widget/custom_expansion_panel_list.dart';
import 'package:emart/src/widget/simple_card_groups.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

// WIDGET GENERAL DEL ACORDEON EXPANDIBLE DEL CARRITO
List<Widget> loadDynamicExpansionPanel(
      BuildContext context1, CartViewModel cartProvider, bool loadAgain, VoidCallback setState, RxBool isValid) {
    List<Widget> listaWidget = [];
    ProductViewModel productoViewModel = Get.find();
    PedidoEmart.listaProductosPorFabricante!.forEach((fabricante, value) {
      // Variables para calcular el faltante del monto minimo para realizar un pedido
      double sumaPreciosProductos =
          cartProvider.getListaFabricante[fabricante]["precioFinal"];

      double valorMontoMinimo = value["preciominimo"];

      calcularFaltanteMontoMinimo(sumaPreciosProductos, valorMontoMinimo) {
        double resultado = valorMontoMinimo - sumaPreciosProductos;
        return resultado;
      }

      double resulCalcularMontoMinimo =
          calcularFaltanteMontoMinimo(sumaPreciosProductos, valorMontoMinimo);

      if (value['precioProducto'] == 0.0) {
      } else {
        cartProvider.actualizarFrecuenciaFabricante(
            fabricante, value["isFrecuencia"]);
        listaWidget.add(
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              child: Column(
                children: [
                  CustomExpansionPanelList(
                    expansionCallback: (int i, bool status) {
                        value["expanded"] = !status;
                        loadAgain = false;
                        setState();
                    },
                    children: [
                      ExpansionPanel(
                        canTapOnHeader: true,
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25))),
                            padding: EdgeInsets.all(10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 70,
                                  width: 70,
                                  alignment: Alignment.center,
                                  child: CachedNetworkImage(
                                      imageUrl: PedidoEmart
                                              .listaProductosPorFabricante![
                                          fabricante]["imagen"],
                                      placeholder: (context, url) =>
                                          Image.asset(
                                              'assets/image/jar-loading.gif'),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                              'assets/image/logo_login.png'),
                                      fit: BoxFit.cover),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    child: Text(
                                        cartProvider.getListaFabricante[
                                                    fabricante] ==
                                                null
                                            ? '${productoViewModel.getFormat().currencySymbol}: 0'
                                            : productoViewModel.getCurrency(
                                                cartProvider.getListaFabricante[
                                                    fabricante]["precioFinal"]),
                                        style: TextStyle(
                                            color:
                                                ConstantesColores.azul_precio,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500))),
                              ],
                            ),
                          );
                        },
                        body: Container(
                          color: Colors.white,
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Visibility(
                                    //value["preciominimo"] != 0.0, Con esta validacion podemos definir si se muestra o no la barra indicadora de monto minimo con sus textos adicionales
                                    visible: value["preciominimo"] != 0.0,
                                    child: Column(
                                      children: [
                                        if (sumaPreciosProductos <=
                                            valorMontoMinimo)
                                          Container(
                                            height: Get.height * 0.022,
                                            padding: EdgeInsets.only(
                                                right: Get.width * 0.10),
                                            width: Get.width * 1.0,
                                            child: Text(
                                              productoViewModel.getCurrency(
                                                  value["preciominimo"]),
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  color:
                                                      ConstantesColores.verde,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                        BarraFaltanteMontoMin(
                                          minimumAmount: valorMontoMinimo,
                                          currentAmount: sumaPreciosProductos,
                                          punteroBarra: Column(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/image/carro_progress_bar.svg',
                                                height: Get.height * 0.055,
                                                width: Get.width * 0.28,
                                              ),
                                              Stack(children: [
                                                SvgPicture.asset(
                                                  'assets/image/Pop.svg',
                                                  height: Get.height * 0.040,
                                                  width: Get.width * 0.28,
                                                ),
                                                Positioned(
                                                  top: Get.height * 0.013,
                                                  left: Get.width * 0.015,
                                                  child: Text(
                                                    productoViewModel
                                                        .getCurrency(cartProvider
                                                                    .getListaFabricante[
                                                                fabricante]
                                                            ["precioFinal"]),
                                                    style: TextStyle(
                                                        fontSize: 11.5,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ]),
                                            ],
                                          ),
                                        ),

                                        // Text(
                                        //     'Solo te falta ${productoViewModel.getCurrency(resulCalcularMontoMinimo)} para completar tu monto mínimo',
                                        //     style: disenoValores(),
                                        //     textAlign: TextAlign.center,
                                        //   ),
                                        SizedBox(height: Get.height * 0.056)
                                      ],
                                    )),
                                    valorMontoMinimo > sumaPreciosProductos
                              ?  Visibility(
                                  visible: cartProvider.getVisibilityMessage(
                                      fabricante,
                                      cartProvider
                                              .getListaFabricante[fabricante]
                                          ["precioFinal"],
                                      value["preciominimo"],
                                      value["topeMinimo"]),
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(20, 0, 10, 2),
                                    child: Row(
                                      children: [
                                        Obx(() => Visibility(
                                              visible: isValid.value,
                                              child: SvgPicture.asset(
                                                'assets/image/alerta_pedido_inferio.svg',
                                                color: value['restrictivofrecuencia'] ==
                                                                0 &&
                                                            value['isFrecuencia'] ==
                                                                true ||
                                                        value['restrictivonofrecuencia'] ==
                                                                0 &&
                                                            value['isFrecuencia'] ==
                                                                false
                                                    ? HexColor("#42B39C")
                                                    : Colors.red,
                                              ),
                                            )),
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: Center(
                                                child: Text(
                                              cartProvider.textAlertCompany(
                                                productoViewModel.getCurrency(
                                                    resulCalcularMontoMinimo),
                                                fabricante,
                                                cartProvider.getListaFabricante[
                                                    fabricante]["precioFinal"],
                                                value["preciominimo"],
                                                productoViewModel
                                                    .getFormat()
                                                    .currencySymbol,
                                                value['restrictivofrecuencia'],
                                                value[
                                                    'restrictivonofrecuencia'],
                                                value["diasVisita"],
                                                value["isFrecuencia"],
                                                value["texto1"],
                                                value["texto2"],
                                                value["itinerario"],
                                                isValid
                                              ),
                                              style: TextStyle(
                                                  color: value['restrictivofrecuencia'] ==
                                                                  0 &&
                                                              value['isFrecuencia'] ==
                                                                  true ||
                                                          value['restrictivonofrecuencia'] ==
                                                                  0 &&
                                                              value['isFrecuencia'] ==
                                                                  false
                                                      ? Colors.black
                                                          .withOpacity(.7)
                                                      : Colors.red,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                : value["preciominimo"] != 0
                                ? Container(
                                  margin: EdgeInsets.symmetric(horizontal: 40),
                                    child: Text('¡Muy bien!, alcanzaste el monto mínimo para realizar tu pedido',
                                      style: TextStyle(color: ConstantesColores.azul_precio, fontWeight: FontWeight.bold
                                  
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                                :Container(),
                                SizedBox(height: 20.0),
                                Container(
                                  constraints: BoxConstraints(
                                      minHeight: 150,
                                      maxHeight: 250,
                                      maxWidth: double.infinity),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          child: Column(
                                            children: gridItem(
                                                    value["items"],
                                                    fabricante,
                                                    context1,
                                                    cartProvider,
                                                    value["preciominimo"],
                                                    setState
                                                    )
                                                .toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        isExpanded: cargarDeNuevo ? true : value["expanded"],
                      )
                    ],
                  ),
                  Visibility(
                    visible: cartProvider.getListaFabricante[fabricante]
                                ["descuento"] ==
                            0.0
                        ? false
                        : true,
                    child: Container(
                      height: 70,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        color: ConstantesColores.azul_precio,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: ConstantesColores
                                        .azul_aguamarina_botones,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Image.asset(
                                    'assets/icon/Icono_valor_ahorrado.png',
                                    fit: BoxFit.cover,
                                    width: 30,
                                    color: Colors.white,
                                  ),
                                )),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      getCurrency(cartProvider
                                              .getListaFabricante[fabricante]
                                          ["descuento"]),
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      S.current.value_saved_cart,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
    });

    return listaWidget;
  }