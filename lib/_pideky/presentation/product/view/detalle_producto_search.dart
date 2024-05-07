import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/_pideky/presentation/my_lists/view_model/my_lists_view_model.dart';
import 'package:emart/_pideky/presentation/my_lists/widgets/pop_up_add_new_product.dart';
import 'package:emart/_pideky/presentation/my_lists/widgets/pop_up_choose_list.dart';
import 'package:emart/_pideky/presentation/product/view/ir_mi_carrito.dart';
import 'package:emart/_pideky/presentation/product/view_model/product_view_model.dart';
import 'package:emart/generated/l10n.dart';
import 'package:emart/shared/widgets/boton_agregar_carrito.dart';
import 'package:emart/shared/widgets/notification_of_maximum_promotion_limit.dart';
import 'package:emart/src/classes/producto_cambiante.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/controllers/controller_product.dart';
import 'package:emart/_pideky/domain/product/model/product_model.dart';
import 'package:emart/src/controllers/slide_up_automatic.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/const.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/metodo_ingresados.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/_pideky/presentation/cart/view_model/cart_view_model.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/utils/util.dart';
import 'package:emart/src/widget/acciones_carrito_bart.dart';
import 'package:emart/src/widget/boton_actualizar.dart';
import 'package:emart/src/widget/custom_card.dart';
import 'package:emart/src/widget/dialog_details_image.dart';
import 'package:emart/src/widget/titulo_pideky.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:provider/provider.dart';
import '../../../../src/utils/alertas.dart';

final prefs = new Preferencias();

class DetalleProductoSearch extends StatefulWidget {
  final Product producto;
  final double tamano;
  final String title;
  DetalleProductoSearch(
      {Key? key,
      required this.producto,
      required this.tamano,
      required this.title})
      : super(key: key);

  @override
  _DetalleProductoSearchState createState() => _DetalleProductoSearchState();
}

class _DetalleProductoSearchState extends State<DetalleProductoSearch> {
  ProductViewModel productViewModel = Get.find();
  final cargoConfirmar = Get.find<CambioEstadoProductos>();
  final controllerNotifiaction = Get.find<SlideUpAutomatic>();
  final listViewModel = Get.find<MyListsViewModel>();
  final constrollerProductos = Get.find<ControllerProductos>();
  final TextEditingController _controllerCantidadProducto =
      TextEditingController();

  bool isAgotado = false;

  @override
  void initState() {
    super.initState();
    print(
        "producto ${widget.producto.bloqueoCartera} ${widget.producto.fabricante}");
    isAgotado = constrollerProductos.validarAgotado(widget.producto);
    _controllerCantidadProducto.text =
        cargoConfirmar.controllerCantidadProducto.value;
    //FIREBASE: Llamamos el evento view_item
    TagueoFirebase().sendAnalityticViewItem(
        widget.producto, int.parse(_controllerCantidadProducto.text));

    setState(() {});
  }

  @override
  void dispose() {
    _controllerCantidadProducto.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    RxBool isValidMax = (widget.producto.cantidadMaxima! -
                widget.producto.cantidadSolicitada!) <=
            0 && widget.producto.cantidadMaxima != 0
        ? false.obs
        : true.obs;
    final size = MediaQuery.of(context).size;
    final cartProvider = Provider.of<CartViewModel>(context);
    bool isFrecuencia = prefs.paisUsuario == 'CR'
        ? productViewModel
            .validarFrecuencia(widget.producto.fabricante.toString())
        : true;

    _controllerCantidadProducto.text = isAgotado
        ? '0'
        : cargoConfirmar.controllerCantidadProducto.value == '0'
            ? '1'
            : cargoConfirmar.controllerCantidadProducto.value;

    bool showNotificationMaximumPromotionLimit =
        productViewModel.isMaximumPromotionLimitReached(
            widget.producto.cantidadMaxima!,
            toInt(cargoConfirmar.controllerCantidadProducto.value),
            widget.producto.cantidadSolicitada!);

    return Scaffold(
      backgroundColor: ConstantesColores.color_fondo_gris,
      appBar: AppBar(
        title: TituloPideky(size: size),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ConstantesColores.color_fondo_gris,
          statusBarIconBrightness: Brightness.dark,
        ),
        elevation: 0,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: HexColor("#30C3A3")),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          BotonActualizar(),
          AccionesBartCarrito(esCarrito: true),
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(children: [
          Container(
            margin: EdgeInsets.only(top: 20),
            child: CustomCard(
              padding: EdgeInsets.fromLTRB(30, 50, 20, 0),
              body: Column(
                children: [
                  //Titulo Detalle
                  Container(
                    margin: EdgeInsets.only(bottom: 15),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${widget.producto.nombre}',
                      maxLines: 2,
                      textAlign: TextAlign.left,
                      style: diseno_valores(),
                    ),
                  ),
                  // Imagen detalle
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 40),
                    child: Container(
                      alignment: Alignment.center,
                      height: widget.tamano * 0.4,
                      width: double.infinity,
                      child: Stack(children: [
                        InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => DialogDetailsImage(
                                    Constantes().urlImgProductos +
                                        '${widget.producto.codigo}.png',
                                    '${widget.producto.nombre}'));
                          },
                          child: Align(
                            alignment: Alignment.center,
                            child: PinchZoomImage(
                              zoomedBackgroundColor: Colors.transparent,
                              hideStatusBarWhileZooming: true,
                              image: CachedNetworkImage(
                                  imageUrl: Constantes().urlImgProductos +
                                      '${widget.producto.codigo}.png',
                                  placeholder: (context, url) => Image.asset(
                                      'assets/image/jar-loading.gif'),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                          'assets/image/logo_login.png'),
                                  fit: BoxFit.contain),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                  // Cuerpo
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'SKU: ${widget.producto.codigo}',
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: HexColor("#a2a2a2")),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Visibility(
                                          visible:
                                              widget.producto.descuento != 0,
                                          child: Container(
                                            height: Get.width * 0.07,
                                            padding:
                                                EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            alignment: Alignment.topLeft,
                                            child: AutoSizeText(
                                              productViewModel.getCurrency(
                                                  widget.producto.precio),
                                              textAlign: TextAlign.left,
                                              presetFontSizes: [17, 15],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17,
                                                  color: Colors.red),
                                            ),
                                          )),
                                      Container(
                                        height: widget.producto.descuento != 0
                                            ? Get.width * 0.05
                                            : Get.width * 0.07,
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        alignment: Alignment.topLeft,
                                        child: AutoSizeText(
                                          productViewModel.getCurrency(
                                              widget.producto.descuento != 0
                                                  ? widget
                                                      .producto.precioinicial
                                                  : widget.producto.precio),
                                          textAlign: TextAlign.left,
                                          style: widget.producto.descuento != 0
                                              ? TextStyle(
                                                  color: ConstantesColores
                                                      .azul_precio,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 11,
                                                  decoration: TextDecoration
                                                      .lineThrough)
                                              : TextStyle(
                                                  color: ConstantesColores
                                                      .azul_precio,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        child: AutoSizeText(
                                            S.current.price_per_sales_unit,
                                            maxLines: 2,
                                            presetFontSizes: [15, 14],
                                            style: TextStyle(
                                              color: ConstantesColores.verde,
                                            )),
                                      ),
                                      Visibility(
                                        visible:
                                            isAgotado == true ? false : true,
                                        child: IconButton(
                                            onPressed: () async {
                                              final listaProductos =
                                                  await listViewModel
                                                      .existProductInList(
                                                          widget
                                                              .producto.codigo,
                                                          context);
                                              if (listaProductos.isNotEmpty) {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        PopUpAddNewProduct(
                                                          nombresListas:
                                                              listaProductos,
                                                          producto:
                                                              widget.producto,
                                                          cantidad: toInt(
                                                              cargoConfirmar
                                                                  .controllerCantidadProducto
                                                                  .value),
                                                        ));
                                              } else {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        PopUpChooseList(
                                                          productos: List.generate(
                                                              1,
                                                              (index) => widget
                                                                  .producto),
                                                          cantidad: toInt(
                                                              cargoConfirmar
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
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 55.0,
                              width: Get.width * 0.35,
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    SizedBox(
                                      height: 70.0,
                                      width: Get.width * 0.11,
                                      child: IconButton(
                                        icon: Image.asset(
                                            'assets/image/menos.png'),
                                        onPressed: () => menos(
                                            widget.producto, cartProvider),
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
                                            controller:
                                                _controllerCantidadProducto,
                                            keyboardType: TextInputType.number,
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            textAlign: TextAlign.center,
                                            maxLength: 3,
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Escribe el precio de compra';
                                              }
                                              return null;
                                            },
                                            style:
                                                TextStyle(color: Colors.black),
                                            onChanged: (value) {
                                              cargoConfirmar
                                                  .cambiarValoresEditex(value);
                                            },
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              fillColor: Colors.black,
                                              hintText: '0',
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
                                      height: 70.0,
                                      width: Get.width * 0.11,
                                      child:
                                          showNotificationMaximumPromotionLimit
                                              ? IconButton(
                                                  icon: Icon(
                                                    Icons.lock_outline_sharp,
                                                    color: ConstantesColores
                                                        .gris_sku,
                                                  ),
                                                  onPressed: () async {
                                                    if (Get.isSnackbarOpen) {
                                                      await Get
                                                          .closeCurrentSnackbar();
                                                      notificationMaximumPromotionlimit();
                                                    } else {
                                                      notificationMaximumPromotionlimit();
                                                    }
                                                  })
                                              : IconButton(
                                                  icon: Image.asset(
                                                      'assets/image/mas.png'),
                                                  onPressed: () => mas(
                                                      widget.producto,
                                                      cartProvider),
                                                ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Visibility(
                            visible: isAgotado,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: isAgotado
                                    ? EdgeInsets.only(top: 5, bottom: 80)
                                    : EdgeInsets.only(top: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Colors.red[100],
                                ),
                                height: Get.width * 0.07,
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                  // Visibility(
                  //   visible: !isAgotado,
                  //   child: InkWell(
                  //     onTap: () {
                  //       llenarCarrito(widget.producto, cartProvider);
                  //     },
                  //     child: Container(
                  //       margin: EdgeInsets.only(top: 40),
                  //       height: widget.tamano * 0.1,
                  //       child: Padding(
                  //         padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
                  //         child: Image.asset(
                  //           "assets/image/agregar_al_carrito_btn.png",
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  if (widget.producto.cantidadMaxima != 0)
                    Text(
                      isValidMax.value == true
                          ? 'Esta promoción tiene un tope máximo de compra de ${widget.producto.cantidadMaxima! - widget.producto.cantidadSolicitada!} unidades'
                          : 'Has alcanzado el límite máximo de compra de esta promoción',
                      style: TextStyle(
                          fontSize: 15.0,
                          color: ConstantesColores.azul_precio,
                          fontWeight: FontWeight.bold),
                    ),
                  Visibility(
                    visible: !isAgotado,
                    child: BotonAgregarCarrito(
                      onTap: widget.producto.bloqueoCartera != 1
                          ? isFrecuencia && isValidMax.value == true
                              ? () =>
                                  llenarCarrito(widget.producto, cartProvider)
                              : isValidMax.value == false
                                  ? () {}
                                  : () => productViewModel.iniciarModal(
                                      context, widget.producto.fabricante)
                          : () => mostrarAlertCartera(
                                context,
                                "Este producto no se encuentra disponible. Revisa el estado de tu cartera para poder comprar.",
                                null,
                              ),
                      width: Get.width * 0.8,
                      height: widget.tamano * 0.06,
                      color: isFrecuencia && isValidMax.value == true
                          ? ConstantesColores.azul_aguamarina_botones
                          : ConstantesColores.gris_sku,
                      text: 'Agregar al carrito ',
                      borderRadio: 30,
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            width: 50,
            height: 50,
            margin: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: HexColor("#41398D")),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
        ]),
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
    controllerNotifiaction.mostrarSlide(producto.negocio, context);
    if (_controllerCantidadProducto.text != '' &&
        _controllerCantidadProducto.text != '0') {
      PedidoEmart.listaControllersPedido![producto.codigo]!.text =
          _controllerCantidadProducto.text;
      PedidoEmart.registrarValoresPedido(
          producto, _controllerCantidadProducto.text, true);
      MetodosLLenarValores().calcularValorTotal(cartProvider);

      cargoConfirmar.cargarProductoNuevo(
          ProductoCambiante.m(widget.producto.nombre, widget.producto.codigo),
          2);
      cartProvider.guardarCambiodevista = 2;
      PedidoEmart.cambioVista.value = 2;
      //FIREBASE: Llamamos el evento add_to_cart
      TagueoFirebase().sendAnalityticAddToCart(
          producto, int.parse(_controllerCantidadProducto.text));
      //insertamos el producto en la temporal
      productViewModel.insertarPedidoTemporal(widget.producto.codigo);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => IrMiCarrito(
                  productos: widget.producto,
                  tamano: retornarTamano(cartProvider) * 1.5)));
    }
  }

  double retornarTamano(cartProvider) {
    double precioMinimo = 0;
    double valor = 0.7;

    try {
      if (cartProvider.getListaFabricante[widget.producto.fabricante]
                  ["precioFinal"] <
              precioMinimo &&
          widget.producto.fabricante!.toUpperCase() != 'MEALS') {
        valor = Get.height > 600 ? Get.height * 0.8 : Get.height * 0.8;
      } else {
        valor = widget.producto.fabricante!.toUpperCase() == 'MEALS'
            ? Get.height * 0.8
            : Get.height * 0.8;
      }
    } catch (e) {
      precioMinimo = 0;
      valor = Get.height > 750 ? 0.7 : 0.8;
    }

    return valor;
  }

  double retornarTamanoPrincipal(cartProvider) {
    double precioMinimo = 0;
    double valor = 0.6;

    try {
      if (cartProvider.getListaFabricante[widget.producto.fabricante]
                  ["precioFinal"] <
              precioMinimo &&
          widget.producto.fabricante!.toUpperCase() != 'MEALS') {
        valor = Get.height > 600 ? Get.height * 0.75 : Get.height * 0.8;
      } else if (Get.height > 600) {
        valor = widget.producto.fabricante!.toUpperCase() == 'MEALS'
            ? Get.height * 0.75
            : Get.height * 0.6;
      }
    } catch (e) {
      precioMinimo = 0;
      valor = Get.height > 750 ? 0.7 : 0.8;
    }

    return valor;
  }

  TextStyle diseno_valores() => TextStyle(
      fontSize: 16.0, color: HexColor("#43398E"), fontWeight: FontWeight.bold);
}
