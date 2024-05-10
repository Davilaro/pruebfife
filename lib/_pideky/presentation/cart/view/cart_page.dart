// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:emart/_pideky/presentation/cart/widgets/expanded_shopping_cart_panel.dart';
import 'package:emart/_pideky/presentation/cart/widgets/general_saved_indicator.dart';
import 'package:emart/_pideky/presentation/product/view_model/product_view_model.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/controllers/notifiactions_controllers.dart';
import 'package:emart/src/controllers/slide_up_automatic.dart';
import 'package:emart/src/controllers/state_controller_radio_buttons.dart';
import 'package:emart/src/pages/catalogo/view_model/botones_proveedores_vm.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/_pideky/presentation/cart/view_model/cart_view_model.dart';
import 'package:emart/src/utils/alertas.dart';
import 'package:emart/src/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

final prefs = new Preferencias();
RxBool isValid = false.obs;
//late CarroModelo cartProvider;

class CartPage extends StatefulWidget {
  final int numEmpresa;

  const CartPage({Key? key, required this.numEmpresa}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final cargoConfirmar = Get.find<CambioEstadoProductos>();
  ProductViewModel productoViewModel = Get.find();
  late final cartViewModel = Provider.of<CartViewModel>(context);
  final controller = Get.put(StateControllerRadioButtons());
  final slideUpAutomatic = Get.find<SlideUpAutomatic>();
  final prospectionSlideUp =
      Get.find<NotificationsSlideUpAndPushInUpControllers>();
  final btProveedoresVm = Get.find<BotonesProveedoresVm>();

  @override
  void initState() {
    super.initState();
    //UXCAM: Se define el nombre de la interfaz
    FlutterUxcam.tagScreenName('ShoppingCart');
    PedidoEmart.iniciarProductosPorFabricante();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await btProveedoresVm.cargarListaProovedor('Categoria');
      if (btProveedoresVm.listaProveedoresInactivos.isNotEmpty) {
        prospectionSlideUp.getSlideUpByDataBaseCart('Carrito', context);
      }
      // se crean los listeners para cuando se pierda el foco en los campos de texto
      // de los productos se establezca el valor en 1 en caso de que la persona no digite un valor
      cartViewModel.focusNodesMaps.forEach((productCode, focusNode) {
        cartViewModel.scrollControllerGridItems = ScrollController();
        focusNode.addListener(() {
          if (!focusNode.hasFocus) {
            if (cartViewModel.currentProducto != null &&
                cartViewModel.currentQuantityProduct != 0)
              cartViewModel.editarCantidad(cartViewModel.currentProducto,
                  cartViewModel, '1', updateStateSendingAsParameter);
            else {
              slideUpAutomatic.mostrarSlide(
                  cartViewModel.currentProducto!.productos!.negocio, context);
              PedidoEmart
                  .listaControllersPedido![
                      cartViewModel.currentProducto!.productos!.codigo]!
                  .text = "0";
              PedidoEmart.registrarValoresPedido(
                  cartViewModel.currentProducto!.productos!, '1', false);
              cartViewModel.loadAgain = true;
              PedidoEmart.iniciarProductosPorFabricante();
              // eliminar producto de la temporal
              productoViewModel.eliminarProductoTemporal(
                  cartViewModel.currentProducto!.productos!.codigo);
              setState(() {});
            }
          }
        });
      });
    });
  }

  updateStateSendingAsParameter() {
    setState(() {});
  }

  @override
  void dispose() {
    // se cierran los focus node de cada uno de los productos
    cartViewModel.focusNodesMaps.forEach((productCode, focusNode) {
      focusNode.removeListener(() {});
      focusNode.dispose();
    });
    cartViewModel.timer.cancel();
    cartViewModel.isSavedBymanufacturerOpen.value = false;
    cartViewModel.isSavedBymanufacturerOpenToShowTrashBox.value = false;
    cartViewModel.isTimerActive.value = false;
    cartViewModel.focusNodesMaps.clear();
    if (cartViewModel.scrollControllerGridItems != null) {
      cartViewModel.scrollControllerGridItems!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    //UXCAM: Se define el nombre de la pantalla
    FlutterUxcam.tagScreenName('ShoppingCartPage');
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: ConstantesColores.color_fondo_gris,
        appBar: AppBar(
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back_ios, color: HexColor("#30C3A3")),
              onPressed: () => {
                    if (Get.isSnackbarOpen) {Get.closeCurrentSnackbar()},
                    PedidoEmart.cambioVista.value = 1,
                    cartViewModel.guardarCambiodevista = 1,
                    Navigator.of(context).pop()
                  }),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 13, right: 13, top: 5),
          child: Column(
            children: [
              Container(
                child: Container(
                  width: Get.width,
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: [
                      GeneralSavedIndicator(cartViewModel: cartViewModel),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                                'Total: ${productoViewModel.getCurrency(cartViewModel.getTotal)}',
                                style: TextStyle(
                                    fontSize: 17.0,
                                    color: HexColor("#43398E"),
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            Text(
                                'Estos productos serán entregados según el inventario del proveedor',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 15.0)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  height: Get.height * 0.8,
                  child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: loadDynamicExpansionPanel(
                                context,
                                cartViewModel,
                                cartViewModel.loadAgain,
                                updateStateSendingAsParameter,
                                isValid)
                            .toList()),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: Get.height * 0.09,
          decoration: BoxDecoration(
            color: ConstantesColores.azul_precio,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: Get.width * 0.08, vertical: Get.height * 0.016),
            child: CustomButton(
                height: 100,
                width: 100,
                onPressed: () {
                  controller.cashPayment.value = false;
                  controller.payOnLine.value = false;
                  prefs.typeCollaborator != "2"
                      ? cartViewModel.configurarPedido(size, cartViewModel,
                          prefs, context, updateStateSendingAsParameter)
                      : mostrarAlert(
                          context,
                          "No puedes realizar pedidos ya que te encuentras en modo colaborador",
                          null);
                },
                isFontBold: true,
                text: 'Realiza tu pedido',
                backgroundColor: ConstantesColores.azul_aguamarina_botones),
          ),
        ),
      ),
    );
  }
}
