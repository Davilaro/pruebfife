import 'package:emart/_pideky/domain/brand/model/brand.dart';
import 'package:emart/_pideky/domain/brand/use_cases/brand_use_cases.dart';
import 'package:emart/_pideky/domain/product/use_cases/producto_use_cases.dart';
import 'package:emart/_pideky/infrastructure/brand/brand_service.dart';
import 'package:emart/_pideky/infrastructure/product/product_service.dart';
import 'package:emart/_pideky/presentation/authentication/view/log_in/login_page.dart';
import 'package:emart/_pideky/presentation/product/view/detalle_producto_compra.dart';
import 'package:emart/src/classes/producto_cambiante.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/modelos/bannner.dart';
import 'package:emart/src/modelos/fabricante.dart';
import 'package:emart/_pideky/domain/product/model/product_model.dart';
import 'package:emart/src/pages/principal_page/widgets/custom_buscador_fuzzy.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/_pideky/presentation/cart/view_model/cart_view_model.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/pages/catalogo/widgets/tab_categorias_opciones.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BannnerControllers extends GetxController {
  RxBool cargoDatos = false.obs;
  RxInt inicialControllerSubCategoria = 0.obs;
  RxBool isVisitBanner = false.obs;

  List<dynamic> listaBanners = [].obs;

  BrandUseCases marcaService = BrandUseCases(MarcaRepositorySqlite());

  void cambiarSubCategoria(int value) {
    inicialControllerSubCategoria.value = value;
  }

  void setIsVisitBanner(bool value) {
    isVisitBanner.value = value;
  }

  setCargoDatos(bool value) {
    cargoDatos.value = value;
  }

  void cargarDatosBanner(dynamic banners) {
    setCargoDatos(false);
    if (banners.length > 0) {
      setCargoDatos(true);
    }
    listaBanners = banners;
  }

  validarOnClick(
      Banners banner,
      BuildContext context,
      CartViewModel provider,
      CambioEstadoProductos cargoConfirmar,
      Preferencias prefs,
      String locasionBanner) async {
    ProductoService productService =
        ProductoService(ProductoRepositorySqlite());

    var resBusqueda;
    if (banner.tipoSeccion == 'Detalle Producto') {
      resBusqueda = await productService.cargarProductosFiltro(
          banner.seccion.toString(), "");
      _detalleProducto(
          resBusqueda[0], provider, context, cargoConfirmar, prefs);
    } else if (banner.tipoSeccion == 'Categoria') {
      resBusqueda = await DBProvider.db
          .consultarCategorias(banner.subSeccion.toString(), 1);
      var resSubBusqueda = await DBProvider.db
          .consultarCategoriasSubCategorias(resBusqueda[0].codigo);
      _direccionarCategoria(
          context, provider, resSubBusqueda, banner.seccion.toString());
    } else if (banner.tipoSeccion == 'Proveedor') {
      resBusqueda =
          await DBProvider.db.consultarFabricante(banner.seccion.toString());
      // print('soy proveedor ${jsonEncode(resBusqueda)}');
      _direccionarProveedor(context, resBusqueda[0]);
    } else if (banner.tipoSeccion == 'Marca') {
      resBusqueda =
          await marcaService.consultaMarcas(banner.seccion.toString());
      _direccionarMarca(context, resBusqueda[0]);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CustomBuscardorFuzzy(
                    codCategoria: banner.empresa!,
                    numEmpresa: 'nutresa',
                    tipoCategoria: 4,
                    nombreCategoria: banner.nombrecomercial!,
                    img: banner.link,
                    locasionBanner: locasionBanner,
                    locacionFiltro: "proveedor",
                    codigoProveedor: "",
                  )));
    }
  }

  _direccionarCategoria(BuildContext context, CartViewModel provider,
      List<dynamic> resSubBusqueda, String subCategoria) async {
    if (subCategoria != '') {
      setIsVisitBanner(true);
      cambiarSubCategoria(resSubBusqueda.indexWhere((element) =>
          element.descripcion.toLowerCase() == subCategoria.toLowerCase()));
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TabOpcionesCategorias(
                  listaCategorias: resSubBusqueda,
                  nombreCategoria: subCategoria,
                )));
  }

  _direccionarMarca(
    BuildContext context,
    Brand marca,
  ) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CustomBuscardorFuzzy(
                  codCategoria: marca.codigo,
                  numEmpresa: 'nutresa',
                  tipoCategoria: 3,
                  nombreCategoria: marca.nombre,
                  locacionFiltro: "marca",
                  codigoProveedor: "",
                )));
  }

  _direccionarProveedor(
    BuildContext context,
    Fabricante proveedor,
  ) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CustomBuscardorFuzzy(
                  codCategoria: proveedor.empresa!,
                  numEmpresa: 'nutresa',
                  tipoCategoria: 4,
                  nombreCategoria: proveedor.nombrecomercial!,
                  img: proveedor.icono,
                  locacionFiltro: "proveedor",
                  codigoProveedor: proveedor.empresa.toString(),
                )));
  }

  _detalleProducto(
      Product producto,
      final CartViewModel cartProvider,
      BuildContext context,
      CambioEstadoProductos cargoConfirmar,
      Preferencias prefs) {
    if (prefs.usurioLogin == -1) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LogInPage()));
    } else {
      PedidoEmart.inicializarValoresFabricante();
      cartProvider.actualizarListaFabricante =
          PedidoEmart.listaPrecioPorFabricante!;
      cargoConfirmar.cambiarValoresEditex(PedidoEmart.obtenerValor(producto)!);
      cargoConfirmar.cargarProductoNuevo(
          ProductoCambiante.m(producto.nombre, producto.codigo), 1);
      cartProvider.guardarCambiodevista = 1;
      PedidoEmart.cambioVista.value = 1;

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CambiarDetalleCompra(cambioVista: 1,)));
    }
  }
}
