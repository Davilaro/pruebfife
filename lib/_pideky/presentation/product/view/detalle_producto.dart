// ignore_for_file: invalid_use_of_protected_member, non_constant_identifier_names

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/_pideky/presentation/my_lists/view_model/my_lists_view_model.dart';
import 'package:emart/_pideky/presentation/my_lists/widgets/pop_up_add_new_product.dart';
import 'package:emart/_pideky/presentation/my_lists/widgets/pop_up_choose_list.dart';
import 'package:emart/_pideky/presentation/product/view_model/product_view_model.dart';
import 'package:emart/generated/l10n.dart';
import 'package:emart/shared/widgets/boton_agregar_carrito.dart';
import 'package:emart/src/classes/producto_cambiante.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/controllers/controller_product.dart';
import 'package:emart/_pideky/domain/product/model/product_model.dart';
import 'package:emart/src/controllers/slide_up_automatic.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/const.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/metodo_ingresados.dart';
import 'package:emart/_pideky/presentation/cart/view_model/cart_view_model.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/utils/util.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:emart/src/widget/acciones_carrito_bart.dart';
import 'package:emart/src/widget/boton_actualizar.dart';
import 'package:emart/src/widget/dialog_details_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/notification_of_maximum_promotion_limit.dart';

class DetalleProducto extends StatefulWidget {
  final Product productos;
  final double tamano;
  final bool isFrecuencia;
  final bool isByBuySellEarn;

  const DetalleProducto(
      {Key? key,
      required this.productos,
      required this.tamano,
      required this.isFrecuencia,
      required this.isByBuySellEarn})
      : super(key: key);

  @override
  State<DetalleProducto> createState() => _DetalleProductoState();
}

class _DetalleProductoState extends State<DetalleProducto> {
  ProductViewModel productViewModel = Get.find();
  final listViewModel = Get.find<MyListsViewModel>();
  final cargoConfirmar = Get.find<CambioEstadoProductos>();
  final constrollerProductos = Get.find<ControllerProductos>();
  final controllerNotifiaction = Get.find<SlideUpAutomatic>();

  final TextEditingController _controllerCantidadProducto =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    cargoConfirmar.isAgotado.value =
        constrollerProductos.validarAgotado(widget.productos);
    //FIREBASE: Llamamos el evento view_item
    TagueoFirebase().sendAnalityticViewItem(widget.productos, 1);
    setState(() {});
  }

  @override
  void dispose() {
    _controllerCantidadProducto.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartViewModel>(context);

    _controllerCantidadProducto.text = cargoConfirmar.isAgotado.value
        ? '0'
        : cargoConfirmar.controllerCantidadProducto.value == '0'
            ? '1'
            : cargoConfirmar.controllerCantidadProducto.value;

    bool showNotificationMaximumPromotionLimit =
        productViewModel.isMaximumPromotionLimitReached(
            widget.productos.cantidadMaxima!,
            toInt(cargoConfirmar.controllerCantidadProducto.value),
            widget.productos.cantidadSolicitada!);
     int remainingQuantity = widget.productos.cantidadMaxima! - widget.productos.cantidadSolicitada!;       

    return Scaffold(
      backgroundColor: ConstantesColores.color_fondo_gris,
      appBar: showNotificationMaximumPromotionLimit
          ? null
          : AppBar(
              title: Text(
                S.current.product,
                style: TextStyle(color: HexColor("#41398D")),
              ),
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: ConstantesColores.color_fondo_gris,
                statusBarIconBrightness: Brightness.dark,
              ),
              elevation: 0,
              leading: new IconButton(
                icon:
                    new Icon(Icons.arrow_back_ios, color: HexColor("#30C3A3")),
                onPressed: () => Navigator.pop(context),
              ),
              actions: <Widget>[
                GestureDetector(
                  child: BotonActualizar(),
                  onTap: () {
                    setState(() {
                      initState();
                      (context as Element).reassemble();
                    });
                  },
                ),
                AccionesBartCarrito(esCarrito: true),
              ],
            ),
      body: Column(
        children: [
          if (showNotificationMaximumPromotionLimit)
            Align(
              alignment: Alignment.topCenter,
              child: NotificationMaximumPromotionlimit(
                onClose: () {
                  setState(() {
                    //toInt(cargoConfirmar.controllerCantidadProducto.value) - 1;
                    //  showNotificationMaximumPromotionLimit = false;
                  });
                },
              ),
            ),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 10, 20, 0),
            child: Container(
              child: Text(
                '${widget.productos.nombre}',
                maxLines: 2,
                style: diseno_valores(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Container(
              alignment: Alignment.center,
              height: widget.tamano * 0.4,
              width: double.infinity,
              child: InkWell(
                onTap: () => showDialog(
                    context: context,
                    builder: (context) => DialogDetailsImage(
                        Constantes().urlImgProductos +
                            '${widget.productos.codigo}.png',
                        '${widget.productos.nombre}')),
                child: Align(
                  alignment: Alignment.center,
                  child: PinchZoomImage(
                    zoomedBackgroundColor: Colors.transparent,
                    hideStatusBarWhileZooming: true,
                    image: CachedNetworkImage(
                        imageUrl: Constantes().urlImgProductos +
                            '${widget.productos.codigo}.png',
                        placeholder: (context, url) =>
                            Image.asset('assets/image/jar-loading.gif'),
                        errorWidget: (context, url, error) =>
                            Image.asset('assets/image/logo_login.png'),
                        fit: BoxFit.contain),
                  ),
                ),
              ),
            ),
          ),
          Obx(
            () => Container(
              width: double.infinity,
              height: widget.tamano * 0.30,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Container(
                  width: Get.width,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: Get.width * 0.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'SKU: ' + widget.productos.codigo,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        color: HexColor("#a2a2a2"),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: Get.height * 0.15,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Visibility(
                                      visible: widget.productos.descuento != 0,
                                      child: Container(
                                        height: Get.width * 0.07,
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        alignment: Alignment.topLeft,
                                        child: AutoSizeText(
                                          productViewModel.getCurrency(
                                              widget.productos.precio),
                                          textAlign: TextAlign.left,
                                          presetFontSizes: [17, 15],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red),
                                        ),
                                      )),
                                  Container(
                                    height: widget.productos.descuento != 0
                                        ? Get.width * 0.05
                                        : Get.width * 0.07,
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      productViewModel.getCurrency(
                                          widget.productos.descuento != 0
                                              ? widget.productos.precioinicial
                                              : widget.productos.precio),
                                      textAlign: TextAlign.left,
                                      style: widget.productos.descuento != 0
                                          ? TextStyle(
                                              color:
                                                  ConstantesColores.azul_precio,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                              decoration:
                                                  TextDecoration.lineThrough)
                                          : TextStyle(
                                              color:
                                                  ConstantesColores.azul_precio,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: AutoSizeText(
                                        S.current.price_per_sales_unit,
                                        maxLines: 2,
                                        presetFontSizes: [15, 13],
                                        style: TextStyle(
                                          color: ConstantesColores.verde,
                                        )),
                                  ),
                                  Visibility(
                                    visible:
                                        cargoConfirmar.isAgotado.value == true
                                            ? false
                                            : true,
                                    child: IconButton(
                                        onPressed: () async {
                                          final listaProductos =
                                              await listViewModel
                                                  .existProductInList(
                                                      widget.productos.codigo,
                                                      context);
                                          if (listaProductos.isNotEmpty) {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    PopUpAddNewProduct(
                                                      nombresListas:
                                                          listaProductos,
                                                      producto:
                                                          widget.productos,
                                                      cantidad: toInt(cargoConfirmar
                                                          .controllerCantidadProducto
                                                          .value),
                                                    ));
                                          } else {
                                            await listViewModel.getMisListas();
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    PopUpChooseList(
                                                      productos: List.generate(
                                                          1,
                                                          (index) =>
                                                              widget.productos),
                                                      cantidad: toInt(cargoConfirmar
                                                          .controllerCantidadProducto
                                                          .value),
                                                    ));
                                          }
                                        },
                                        padding: EdgeInsets.all(0),
                                        alignment: Alignment.centerLeft,
                                        icon: SvgPicture.asset(
                                          'assets/icon/Corazón_Trazo.svg',
                                          height: 25,
                                        )
                                        // Image(
                                        //     image: AssetImage(
                                        //         'assets/icon/Icono_corazón_vacio_pequeño.png'))

                                        ),
                                  ),
                                  Visibility(
                                      visible: cargoConfirmar.isAgotado.value,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            color: Colors.red[100],
                                          ),
                                          height: Get.width * 0.06,
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 10, 0),
                                          child: Text(
                                            'Agotado',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: Colors.red),
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        height: 45.0,
                        width: Get.width * 0.35,
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(
                                height: 40.0,
                                width: Get.width * 0.1,
                                child: IconButton(
                                  icon: Image.asset('assets/image/menos.png'),
                                  onPressed: () =>
                                      menos(widget.productos, cartProvider),
                                ),
                              ),
                              Container(
                                width: Get.width * 0.1,
                                alignment: Alignment.bottomCenter,
                                child: ConstrainedBox(
                                  constraints: new BoxConstraints(
                                    minWidth: 20,
                                    maxWidth: 100,
                                    minHeight: 40.0,
                                    maxHeight: 40.0,
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    reverse: true,
                                    child: TextFormField(
                                      maxLines: 1,
                                      controller: _controllerCantidadProducto,
                                      keyboardType: TextInputType.number,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      textAlign: TextAlign.center,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Escribe el precio de compra';
                                        }
                                        return null;
                                      },
                                      style: TextStyle(color: Colors.black),
                                      onChanged: (value) {
                                        print('value: $value');
                                        cargoConfirmar
                                            .cambiarValoresEditex(value);
                                      },
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        fillColor: Colors.black,
                                        hintText: '',
                                        isDense: true,
                                        counterText: "",
                                        hintStyle: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 40.0,
                                width: Get.width * 0.1,
                                child: showNotificationMaximumPromotionLimit
                                    ? IconButton(
                                        icon: Icon(Icons.lock_outline),
                                        onPressed: () {
                                          showNotificationMaximumPromotionLimit =
                                              true;
                                        })
                                    : IconButton(
                                        icon:
                                            Image.asset('assets/image/mas.png'),
                                        onPressed: () =>
                                            mas(widget.productos, cartProvider),
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
            ),
          ),
          
          if (widget.productos.cantidadMaxima != 0)

            Text(
                'Esta promoción tiene un tope máximo de compra de ${remainingQuantity}'),
          Visibility(
            visible: !cargoConfirmar.isAgotado.value,
            child: BotonAgregarCarrito(
              onTap: widget.isFrecuencia
                  ? () => llenarCarrito(widget.productos, cartProvider)
                  : () => productViewModel.iniciarModal(
                      context, widget.productos.fabricante),
              width: Get.width * 0.9,
              height: widget.tamano * 0.08,
              color: widget.isFrecuencia
                  ? ConstantesColores.azul_aguamarina_botones
                  : ConstantesColores.gris_sku,
              text: 'Agregar al carrito ',
              borderRadio: 30,
            ),
          )
        ],
      ),
    );
  }

  mas(Product producto, CartViewModel cartProvider) {
    String valorInicial = _controllerCantidadProducto.text;

    if (valorInicial.length < 3) {
      if (valorInicial == "") {
        cargoConfirmar.cambiarValoresEditex('1');
        setState(() {});
      } else {
        int valoSuma = int.parse(valorInicial) + 1;
        setState(() {
          cargoConfirmar.cambiarValoresEditex('$valoSuma');
        });
      }
    }
  }

  menos(Product producto, CartViewModel cartProvider) {
    String valorInicial = _controllerCantidadProducto.text;
    if (valorInicial != "" && valorInicial != '1' && valorInicial != '0') {
      int valorResta = int.parse(valorInicial) - 1;
      valorResta <= 0
          ? setState(() {
              cargoConfirmar.cambiarValoresEditex('0');
            })
          : setState(() {
              cargoConfirmar.cambiarValoresEditex('$valorResta');
            });
    }
  }

  llenarCarrito(Product producto, CartViewModel cartProvider) {
    if(widget.isByBuySellEarn) {
      //UXCam: Llamamos el evento addToCart
      UxcamTagueo()
          .addToCartBuySellAndEarn(producto, int.parse(_controllerCantidadProducto.text));
    }
    controllerNotifiaction.mostrarSlide(producto.negocio, context);
    if (_controllerCantidadProducto.text != '' &&
        _controllerCantidadProducto.text != '0') {
      PedidoEmart.listaControllersPedido![producto.codigo]!.text =
          _controllerCantidadProducto.text;
      PedidoEmart.registrarValoresPedido(
          producto, _controllerCantidadProducto.text, true);
      MetodosLLenarValores().calcularValorTotal(cartProvider);

      cargoConfirmar.cargarProductoNuevo(
          ProductoCambiante.m(widget.productos.nombre, widget.productos.codigo),
          2);
      cartProvider.guardarCambiodevista = 2;
      PedidoEmart.cambioVista.value = 2;
      //FIREBASE: Llamamos el evento add_to_cart
      TagueoFirebase().sendAnalityticAddToCart(
          producto, int.parse(_controllerCantidadProducto.text));
      //UXCam: Llamamos el evento addToCart
      UxcamTagueo()
          .addToCart(producto, int.parse(_controllerCantidadProducto.text));
      //insertamos el producto en la temporal
      productViewModel.insertarPedidoTemporal(widget.productos.codigo);
      setState(() {});
    }
  }

  TextStyle diseno_valores() => TextStyle(
      fontSize: 16.0, color: HexColor("#43398E"), fontWeight: FontWeight.bold);
}
