import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/_pideky/domain/producto/model/producto.dart';
import 'package:emart/_pideky/presentation/productos/view_model/producto_view_model.dart';
import 'package:emart/src/preferences/const.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:emart/src/utils/alertas.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardProductCustom extends StatefulWidget {
  final Producto producto;
  final CarroModelo cartProvider;
  final bool isProductoEnOferta;
  final bool isAgotadoLabel;
  final int? tipoCategoria;
  final Function()? onTapCard;
  final Function()? onTapBtnAgregar;
  final bool isVisibleLabelPromo;
  final bool isVisibleLabelNuevo;

  const CardProductCustom(
      {Key? key,
      required this.producto,
      required this.cartProvider,
      required this.isProductoEnOferta,
      required this.onTapCard,
      required this.isAgotadoLabel,
      required this.isVisibleLabelPromo,
      required this.isVisibleLabelNuevo,
      this.tipoCategoria,
      this.onTapBtnAgregar})
      : super(key: key);

  @override
  State<CardProductCustom> createState() => _CardProductCustomState();
}

class _CardProductCustomState extends State<CardProductCustom> {
  ProductoViewModel productViewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    var typeCurrency = productViewModel.getCurrency(
        widget.producto.descuento != 0
            ? widget.producto.precioinicial
            : widget.producto.precio);
    return Card(
        shape: RoundedRectangleBorder(
            side: new BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(8.0)),
        child: GestureDetector(
          onTap: widget.producto.bloqueoCartera == 0
              ? widget.onTapCard
              : () => mostrarAlertCartera(
                    context,
                    "Este producto no se encuentra disponible. Revisa el estado de tu cartera para poder comprar.",
                    null,
                  ),
          child: Stack(
            children: [
              Container(
                height: Get.height * 0.35,
                width: Get.width * 0.4,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //Imagen producto
                        Container(
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: CachedNetworkImage(
                              height: Get.height * 0.12,
                              imageUrl: Constantes().urlImgProductos +
                                  '${widget.producto.codigo}.png',
                              placeholder: (context, url) =>
                                  Image.asset('assets/image/jar-loading.gif'),
                              errorWidget: (context, url, error) => Image.asset(
                                'assets/image/logo_login.png',
                                width: Get.width * 0.35,
                              ),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        //Cuerpo de la targeta
                        Container(
                          width: Get.width * 0.4,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxHeight: 70, minHeight: 20),
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: AutoSizeText(
                                              '${widget.producto.nombre}',
                                              textAlign: TextAlign.left,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              presetFontSizes: [16, 15],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      ConstantesColores.verde),
                                            ),
                                          ),
                                          Expanded(
                                            child: AutoSizeText(
                                              'SKU: ${widget.producto.codigo}',
                                              maxLines: 1,
                                              minFontSize: 10,
                                              maxFontSize: 11,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: ConstantesColores
                                                      .gris_sku),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                //Precio producto
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxHeight: 52, minHeight: 40),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Visibility(
                                            visible:
                                                widget.producto.descuento != 0,
                                            child: Expanded(
                                              flex: 1,
                                              child: Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 10, 0),
                                                alignment: Alignment.topLeft,
                                                child: AutoSizeText(
                                                  productViewModel.getCurrency(
                                                      widget.producto.precio),
                                                  minFontSize: 15,
                                                  maxFontSize: 18,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                      color: Colors.red),
                                                ),
                                              ),
                                            )),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 0, 10, 0),
                                            alignment: Alignment.topLeft,
                                            child: AutoSizeText(
                                              typeCurrency,
                                              minFontSize: 10,
                                              textAlign: TextAlign.left,
                                              style: widget
                                                          .producto.descuento !=
                                                      0
                                                  ? TextStyle(
                                                      color: ConstantesColores
                                                          .azul_precio,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 11,
                                                      decoration: TextDecoration
                                                          .lineThrough)
                                                  : TextStyle(
                                                      color: ConstantesColores
                                                          .azul_precio,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          widget.isAgotadoLabel
                                                              ? 16
                                                              : 18),
                                            ),
                                          ),
                                        ),
                                        //Label Agotado
                                        Visibility(
                                            visible: widget.isAgotadoLabel,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                  color: Colors.red[100],
                                                ),
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 0, 10, 0),
                                                child: AutoSizeText(
                                                  'Agotado',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                      color: Colors.red),
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                              margin: EdgeInsets.only(bottom: 5),
                              height: Get.width * 0.1,
                              alignment: Alignment.center,
                              child: GestureDetector(
                                child: Container(
                                  width: Get.width * 0.35,
                                  child: Image.asset(
                                    "assets/image/agregar_btn.png",
                                  ),
                                ),
                                onTap: widget.isAgotadoLabel
                                    ? () => null
                                    : widget.onTapBtnAgregar,
                              )),
                        ),
                      ],
                    ),
                    //Label de Promo y Nuevo
                    Positioned(
                      top: 0,
                      left: 7,
                      child: Container(
                        width: Get.width * 0.4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 5, right: 10),
                              child: Visibility(
                                visible: widget.isVisibleLabelPromo,
                                child: Image.asset(
                                  'assets/image/promo_abel.png',
                                  height: 30,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            (widget.producto.fechafinnuevo_1!
                                    .contains(RegExp(r'[0-9]')))
                                ? Container(
                                    alignment: Alignment.centerRight,
                                    padding: EdgeInsets.only(top: 5, right: 10),
                                    child: Visibility(
                                      visible: widget.isVisibleLabelNuevo,
                                      child: Image.asset(
                                        'assets/image/nuevos_label.png',
                                        height: 30,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: widget.producto.bloqueoCartera == 1 ? true : false,
                child: Container(
                  height: Get.height * 0.35,
                  width: Get.width * 0.4,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8)),
                ),
              )
            ],
          ),
        ));
  }

  // String _definirMoneda() {
  //   var locale = Intl().locale;
  //   NumberFormat formatNumber = new NumberFormat("#,##0.00", "es_AR");

  //   var format = locale.toString() != 'es_CO'
  //       ? locale.toString() == 'es_CR'
  //           ? NumberFormat.currency(locale: locale.toString(), symbol: '\₡')
  //           : NumberFormat.simpleCurrency(locale: locale.toString())
  //       : NumberFormat.currency(locale: locale.toString(), symbol: '\$');

  //   var valor = '${format.currencySymbol}' +
  //       formatNumber.format().replaceAll(',00', '');

  //   return valor;
  // }
}
