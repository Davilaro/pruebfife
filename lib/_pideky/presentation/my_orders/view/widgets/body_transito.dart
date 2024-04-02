import 'package:emart/_pideky/presentation/my_orders/view/widgets/acordion_mis_pedidos.dart';
import 'package:emart/_pideky/presentation/my_orders/view/widgets/filtro_historico.dart';
import 'package:emart/_pideky/presentation/my_orders/view_model/mis_pedidos_view_model.dart';
import 'package:emart/_pideky/presentation/my_orders/view_model/transit_orders_view_model.dart';
import 'package:emart/_pideky/presentation/suggested_order/view/widgets/top_text.dart';
import 'package:emart/_pideky/presentation/product/view_model/product_view_model.dart';
import 'package:emart/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class BodyTransito extends StatefulWidget {
  @override
  State<BodyTransito> createState() => _BodyTransitoState();
}

class _BodyTransitoState extends State<BodyTransito> {
  final misPedidosViewModel = Get.find<MyOrdersViewModel>();
  final transitoViewModel = Get.find<TransitOrdersViewModel>();
  final productViewModel = Get.find<ProductViewModel>();
  final TextEditingController _controladorFiltro = new TextEditingController();
  String filtroSeguimientoPedido = "-1";

  @override
  void initState() {
    //Se define el nombre de la pantalla para UXCAM
    FlutterUxcam.tagScreenName('InTransitPage');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TopText(
            message: S.current.in_this_section_the_status,
          ),
          _buscador(size),
          Obx(() => FutureBuilder<dynamic>(
              future: misPedidosViewModel.getSeguimintoPedido(
                  filtroSeguimientoPedido,
                  transitoViewModel.fechaInicial.value,
                  transitoViewModel.fechaFinal.value),
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasError) {
                      return Text(S.current.no_information_to_display);
                    } else {
                      var listaSeguimientoPedido = snapshot.data;
                      return Container(
                        height: Get.height * 0.5,
                        child: ListView.builder(
                            itemCount: listaSeguimientoPedido.length,
                            itemBuilder: (BuildContext context, int index) =>
                                AcordionMisPedidos(
                                    titulo: "${S.current.order_pideky}:",
                                    supTitulo:
                                        listaSeguimientoPedido[index].numeroDoc,
                                    precio: productViewModel.getCurrency(
                                        listaSeguimientoPedido[index].precio),
                                    fecha:
                                        '${listaSeguimientoPedido[index].fechaServidor} ${misPedidosViewModel.tranformarHora(listaSeguimientoPedido[index].horaTrans)}',
                                    contend: misPedidosViewModel
                                        .cargarContendSeguimientoPedido(
                                            listaSeguimientoPedido[index]
                                                .numeroDoc))),
                      );
                    }
                }
              }))
        ],
      ),
    );
  }

  Widget _buscador(size) {
    return Container(
      width: size.width * 0.9,
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              width: size.width * 0.75,
              decoration: BoxDecoration(
                color: HexColor("#E4E3EC"),
                borderRadius: BorderRadius.circular(45),
              ),
              child: TextField(
                onChanged: (value) => {
                  setState(() {
                    filtroSeguimientoPedido = _controladorFiltro.text == ""
                        ? "-1"
                        : _controladorFiltro.text;
                  })
                },
                controller: _controladorFiltro,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 10),
                  border: InputBorder.none,
                  hintText: "Busca tu orden Pideky",
                  suffixIcon: Icon(
                    Icons.search,
                    color: HexColor("#43398E"),
                    size: 36,
                  ),
                ),
                textAlign: TextAlign.left,
                textAlignVertical: TextAlignVertical.center,
              )),
          GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FiltroHistorico(
                          controlerFiltro: transitoViewModel,
                        ))),
            child: Container(
                color: Colors.transparent,
                child: Image.asset(
                  'assets/icon/calendario.png',
                  width: 35,
                )),
          )
        ],
      ),
    );
  }
}
