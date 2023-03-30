import 'package:auto_size_text/auto_size_text.dart';
import 'package:emart/_pideky/domain/mis_pedidos/model/historico.dart';
import 'package:emart/_pideky/domain/mis_pedidos/model/seguimiento_pedido.dart';
import 'package:emart/_pideky/domain/mis_pedidos/service/mis_pedidos_service.dart';
import 'package:emart/_pideky/infrastructure/mis_pedidos/mis_pedidos_query.dart';
import 'package:emart/_pideky/presentation/mis_pedidos/view/widgets/container_acordion.dart';
import 'package:emart/_pideky/presentation/mis_pedidos/view/widgets/detalle_pedido.dart';
import 'package:emart/_pideky/presentation/mis_pedidos/view/widgets/seguiminto_pedido.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/utils/alertas.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MisPedidosViewModel extends GetxController
    with GetSingleTickerProviderStateMixin {
  MisPedidosService misPedidosService;

  MisPedidosViewModel(this.misPedidosService);

  late TabController tabController;

  RxInt tabActual = 0.obs;
  final List titulosSeccion = ["Histórico", "En tránsito"];

  RxString fechaInicial = '-1'.obs;
  RxString fechaFinal = '-1'.obs;

  void setFechaInicial(String val) {
    fechaInicial.value = val;
  }

  void setFechaFinal(String val) {
    fechaFinal.value = val;
  }

  void cambiarTab(int estado) {
    fechaInicial = '-1'.obs;
    fechaFinal = '-1'.obs;
    this.tabActual.value = estado;
  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    // clearList();
    initListasHistorico();
  }

  initListasHistorico() async {
    fechaInicial = '-1'.obs;
    fechaFinal = '-1'.obs;
    await getHistorico('-1', '-1', '-1');
  }

  getHistorico(filtro, fechaInicial, fechafin) async => await misPedidosService
      .consultarHistoricos(filtro, fechaInicial, fechafin);

  getSeguimintoPedido(filtro, fechaInicial, fechafin) async =>
      await misPedidosService.consultarSeguimientoPedido(
          filtro, fechaInicial, fechafin);

  getGrupoFabricantes(numeroDoc) async =>
      await misPedidosService.consultarGrupoHistorico(numeroDoc);

  cargarContendHistorico(numeroDoc) {
    return Column(children: [
      FutureBuilder<List<Historico>>(
          future: misPedidosService.consultarGrupoHistorico(numeroDoc),
          builder: (context, AsyncSnapshot<List<Historico>> snapshot) {
            if (snapshot.hasData) {
              var listaGrupoHistorico = snapshot.data;
              return Column(
                children: [
                  for (int i = 0; i < listaGrupoHistorico!.length; i++)
                    ContainerAcordion(
                        imagen: listaGrupoHistorico[i].icoFabricante.toString(),
                        titulo:
                            'No.pedido ${listaGrupoHistorico[i].ordenCompra.toString()}',
                        onPressedLink: () => Get.to(() => DetallePedidoPage(
                            historico: listaGrupoHistorico[i])),
                        tituloOnPressed: 'Ver detalle',
                        isVisibleSeparador:
                            listaGrupoHistorico.length - 1 != i),
                ],
              );
            }
            return CircularProgressIndicator();
          })
    ]);
  }

  cargarContendSeguimientoPedido(numeroDoc) {
    return Column(children: [
      FutureBuilder<List<SeguimientoPedido>>(
          future: misPedidosService.consultarGrupoSeguimientoPedido(numeroDoc),
          builder: (context, AsyncSnapshot<List<SeguimientoPedido>> snapshot) {
            if (snapshot.hasData) {
              var listaSeguimientoPedido = snapshot.data;
              print('res ${listaSeguimientoPedido?.length}');
              return Column(
                children: [
                  for (int i = 0; i < listaSeguimientoPedido!.length; i++)
                    ContainerAcordion(
                        imagen:
                            listaSeguimientoPedido[i].icoFabricante.toString(),
                        titulo:
                            'No.pedido ${listaSeguimientoPedido[i].consecutivo.toString()}',
                        onPressedLink: () => Get.to(() => SeguimientoPedidoPage(
                            pedido: listaSeguimientoPedido[i])),
                        tituloOnPressed: 'Hacer seguimiento',
                        isVisibleSeparador:
                            listaSeguimientoPedido.length - 1 != i),
                ],
              );
            }
            return CircularProgressIndicator();
          })
    ]);
  }

  tranformarHora(String horaOld) {
    var hora = int.parse(horaOld.substring(0, 3));

    var horaNew = '$horaOld ${hora > 11 ? 'pm' : 'am'}';
    return horaNew;
  }

  validarFiltro(
      BuildContext context, String fechaInicial, String fechaFin) async {
    var res = await getHistorico('-1', fechaInicial, fechaFin);

    if (res.length > 0) {
      return true;
    } else {
      String mensaje = 'No encontramos registros para esas fechas';
      mostrarAlert(context, mensaje, null);
      return false;
    }
  }

  ///CARGAR ITEMS DORPDOWN
  List<DropdownMenuItem<String>> getDropdownItemsDia(String mes, String ano) {
    List<DropdownMenuItem<String>> menuItems = [];
    menuItems.add(DropdownMenuItem(
        child: Text(
          'Dia            ',
          style: TextStyle(
              color: ConstantesColores.azul_precio,
              fontSize: 13,
              fontWeight: FontWeight.bold),
        ),
        value: ''));

    if (mes == '2' && ano == '2024' ||
        ano == '2028' ||
        ano == '2032' ||
        ano == '2036' ||
        ano == '2040' ||
        ano == '2044' ||
        ano == '2048') {
      for (int i = 1; i <= 29; i++) {
        menuItems.add(DropdownMenuItem(
            child: Text('$i',
                style: TextStyle(
                    color: ConstantesColores.azul_precio,
                    fontSize: 13,
                    fontWeight: FontWeight.bold)),
            value: '$i'));
      }
    } else if (mes == '2') {
      for (int i = 1; i <= 28; i++) {
        menuItems.add(DropdownMenuItem(
            child: Text('$i',
                style: TextStyle(
                    color: ConstantesColores.azul_precio,
                    fontSize: 13,
                    fontWeight: FontWeight.bold)),
            value: '$i'));
      }
    } else if (mes == '4' || mes == '6' || mes == '9' || mes == '11') {
      for (int i = 1; i <= 30; i++) {
        menuItems.add(DropdownMenuItem(
            child: Text('$i',
                style: TextStyle(
                    color: ConstantesColores.azul_precio,
                    fontSize: 13,
                    fontWeight: FontWeight.bold)),
            value: '$i'));
      }
    } else {
      for (int i = 1; i <= 31; i++) {
        menuItems.add(DropdownMenuItem(
            child: Text('$i',
                style: TextStyle(
                    color: ConstantesColores.azul_precio,
                    fontSize: 13,
                    fontWeight: FontWeight.bold)),
            value: '$i'));
      }
    }

    return menuItems;
  }

  ///CARGAR ITEMS DORPDOWN
  List<DropdownMenuItem<String>> getDropdownItemsMes() {
    List<DropdownMenuItem<String>> menuItems = [];
    menuItems.add(DropdownMenuItem(child: textCustomation('Mes'), value: ''));
    menuItems.add(DropdownMenuItem(
      child: textCustomation('Enero'),
      value: '1',
    ));
    menuItems
        .add(DropdownMenuItem(child: textCustomation('Febrero'), value: '2'));
    menuItems
        .add(DropdownMenuItem(child: textCustomation('Marzo'), value: '3'));
    menuItems
        .add(DropdownMenuItem(child: textCustomation('Abril'), value: '4'));
    menuItems.add(DropdownMenuItem(child: textCustomation('Mayo'), value: '5'));
    menuItems
        .add(DropdownMenuItem(child: textCustomation('Junio'), value: '6'));
    menuItems
        .add(DropdownMenuItem(child: textCustomation('Julio'), value: '7'));
    menuItems
        .add(DropdownMenuItem(child: textCustomation('Agosto'), value: '8'));
    menuItems.add(
        DropdownMenuItem(child: textCustomation('Septiembre'), value: '9'));
    menuItems
        .add(DropdownMenuItem(child: textCustomation('Octubre'), value: '10'));
    menuItems.add(
        DropdownMenuItem(child: textCustomation('Noviembre'), value: '11'));
    menuItems.add(
        DropdownMenuItem(child: textCustomation('Diciembre'), value: '12'));

    return menuItems;
  }

  ///CARGAR ITEMS DORPDOWN
  List<DropdownMenuItem<String>> getDropdownItemsAno() {
    List<DropdownMenuItem<String>> menuItems = [];
    menuItems.add(DropdownMenuItem(
        child: Text(
          'Año            ',
          style: TextStyle(
              color: ConstantesColores.azul_precio,
              fontSize: 13,
              fontWeight: FontWeight.bold),
        ),
        value: ''));
    for (int i = 2021; i <= 2050; i++) {
      menuItems.add(DropdownMenuItem(
          child: AutoSizeText('$i',
              maxLines: 1,
              style: TextStyle(
                  color: ConstantesColores.azul_precio,
                  fontSize: 13,
                  fontWeight: FontWeight.bold)),
          value: '$i'));
    }

    return menuItems;
  }

  textCustomation(String texto) {
    return AutoSizeText(
      texto.substring(0, 3),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          color: ConstantesColores.azul_precio,
          fontSize: 13,
          fontWeight: FontWeight.bold),
    );
  }

  @override
  void onClose() {
    super.onClose();
    tabController.dispose();
  }

  static MisPedidosViewModel get findOrInitialize {
    try {
      return Get.find<MisPedidosViewModel>();
    } catch (e) {
      Get.put(MisPedidosViewModel(MisPedidosService(MisPedidosQuery())));
      return Get.find<MisPedidosViewModel>();
    }
  }
}
