import 'package:emart/src/classes/producto_cambiante.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/modelos/bannner.dart';
import 'package:emart/src/modelos/fabricantes.dart';
import 'package:emart/src/modelos/marcas.dart';
import 'package:emart/src/modelos/productos.dart';
import 'package:emart/src/pages/login/login.dart';
import 'package:emart/src/pages/principal_page/widgets/custom_buscador_fuzzy.dart';
import 'package:emart/src/pages/productos/detalle_producto_compra.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/pages/catalogo/widgets/tab_categorias_opciones.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BannnerControllers extends GetxController {
  var cargoDatos = false.obs;
  RxInt inicialControllerSubCategoria = 0.obs;

  List<dynamic> listaBanners = [].obs;

  void cambiarSubCategoria(int value) {
    inicialControllerSubCategoria.value = value;
  }

  void cargarDatosBanner(dynamic banners) {
    if (banners.length > 0) {
      this.cargoDatos.value = true;
    }
    listaBanners = banners;
  }

  validarOnClick(
      Banners banner,
      BuildContext context,
      CarroModelo provider,
      CambioEstadoProductos cargoConfirmar,
      Preferencias prefs,
      String locasionBanner) async {
    var resBusqueda;
    if (banner.tipoSeccion == 'Detalle Producto') {
      // Listo
      resBusqueda =
          await DBProvider.db.cargarProductosFiltro(banner.seccion.toString());
      _detalleProducto(
          resBusqueda[0], provider, context, cargoConfirmar, prefs);
    } else if (banner.tipoSeccion == 'Categoria') {
      //Listo
      resBusqueda = await DBProvider.db
          .consultarCategorias(banner.subSeccion.toString(), 1);
      var resSubBusqueda = await DBProvider.db
          .consultarCategoriasSubCategorias(resBusqueda[0].codigo);
      _direccionarCategoria(
          context, provider, resSubBusqueda, banner.seccion.toString());
    } else if (banner.tipoSeccion == 'Proveedor') {
      // Listo
      resBusqueda =
          await DBProvider.db.consultarFricante(banner.seccion.toString());
      _direccionarProveedor(context, resBusqueda[0]);
    } else if (banner.tipoSeccion == 'Marca') {
      // Listo
      resBusqueda =
          await DBProvider.db.consultarMarcas(banner.seccion.toString());
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
                  )));
    }
  }

  _direccionarCategoria(BuildContext context, CarroModelo provider,
      List<dynamic> resSubBusqueda, String subCategoria) async {
    if (subCategoria != '') {
      cambiarSubCategoria(resSubBusqueda.indexWhere((element) =>
          element.descripcion.toLowerCase() == subCategoria.toLowerCase()));
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TabOpcionesCategorias(
                  listaCategorias: resSubBusqueda,
                )));
  }

  _direccionarMarca(
    BuildContext context,
    Marcas marca,
  ) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CustomBuscardorFuzzy(
                  codCategoria: marca.codigo,
                  numEmpresa: 'nutresa',
                  tipoCategoria: 3,
                  nombreCategoria: marca.titulo,
                  isActiveBanner: false,
                )));
  }

  _direccionarProveedor(
    BuildContext context,
    Fabricantes proveedor,
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
                )));
  }

  _detalleProducto(
      Productos producto,
      final CarroModelo cartProvider,
      BuildContext context,
      CambioEstadoProductos cargoConfirmar,
      Preferencias prefs) {
    if (prefs.usurioLogin == -1) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
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
          MaterialPageRoute(builder: (context) => CambiarDetalleCompra()));
    }
  }
}
