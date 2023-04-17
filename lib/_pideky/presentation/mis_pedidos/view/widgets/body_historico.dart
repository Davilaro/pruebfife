import 'package:emart/_pideky/presentation/mis_pedidos/view/widgets/acordion_mis_pedidos.dart';
import 'package:emart/_pideky/presentation/mis_pedidos/view/widgets/filtro_historico.dart';
import 'package:emart/_pideky/presentation/mis_pedidos/view_model/mis_pedidos_view_model.dart';
import 'package:emart/_pideky/presentation/pedido_sugerido/view/widgets/top_text.dart';
import 'package:emart/_pideky/presentation/productos/view_model/producto_view_model.dart';
import 'package:emart/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class BodyHistorico extends StatefulWidget {
  @override
  State<BodyHistorico> createState() => _BodyHistoricoState();
}

class _BodyHistoricoState extends State<BodyHistorico> {
  final misPedidosViewModel = Get.find<MisPedidosViewModel>();
  final productViewModel = Get.find<ProductoViewModel>();
  final TextEditingController _controladorFiltro = new TextEditingController();
  String filtroHistorico = "-1";

  @override
  Widget build(BuildContext context) {
    //Se define el nombre de la pantalla para UXCAM
    FlutterUxcam.tagScreenName('HistoricalPage');
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TopText(
            message: S.current.in_this_section_you_will,
          ),
          _buscador(size),
          Obx(() => FutureBuilder<dynamic>(
              future: misPedidosViewModel.getHistorico(
                  filtroHistorico,
                  misPedidosViewModel.fechaInicial.value,
                  misPedidosViewModel.fechaFinal.value),
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  var listaHistoricos = snapshot.data;
                  return Container(
                    height: Get.height * 0.5,
                    child: ListView.builder(
                        itemCount: listaHistoricos.length,
                        itemBuilder: (BuildContext context, int index) =>
                            AcordionMisPedidos(
                                titulo: "${S.current.order_pideky}:",
                                supTitulo: listaHistoricos[index].numeroDoc,
                                precio: productViewModel
                                    .getCurrency(listaHistoricos[index].precio),
                                fecha:
                                    '${listaHistoricos[index].fechaTrans} ${misPedidosViewModel.tranformarHora(listaHistoricos[index].horaTrans)}',
                                contend:
                                    misPedidosViewModel.cargarContendHistorico(
                                        listaHistoricos[index].numeroDoc))),
                  );
                }
                return Container();
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
                    filtroHistorico = _controladorFiltro.text == ""
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
                          controlerFiltro: misPedidosViewModel,
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
