import 'package:emart/_pideky/presentation/mis_pedidos/view_model/mis_pedidos_view_model.dart';
import 'package:emart/src/provider/db_provider_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class AnimatedContainerCard extends StatefulWidget {
  final String grupo;
  final String numeroDoc;
  final String ordenCompra;
  AnimatedContainerCard(
      {Key? key,
      required this.grupo,
      required this.numeroDoc,
      required this.ordenCompra})
      : super(key: key);

  @override
  _AnimatedContainerCardState createState() => _AnimatedContainerCardState();
}

class _AnimatedContainerCardState extends State<AnimatedContainerCard> {
  final misPedidosViewModel = Get.find<MisPedidosViewModel>();
  bool _isExpanded = false;

  Widget _validarNumeroPedido(String? pedido) {
    if (pedido != 'Pendiente') {
      return Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Text("N° ${widget.ordenCompra}",
            style: TextStyle(
                fontSize: 13,
                color: Color(0xff4f4f4f),
                fontWeight: FontWeight.bold)),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Text(
          "Número de pedido por validar",
          style: TextStyle(
              fontSize: 13,
              color: Color(0xff43398E),
              fontWeight: FontWeight.bold),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          width: size.width * 0.99,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(" ${widget.grupo}",
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: "RoundedMplus1c-Bold.ttf",
                            color: HexColor("#43398E"),
                            fontWeight: FontWeight.bold)),
                    _validarNumeroPedido(widget.ordenCompra),
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.only(top: 4),
                  child: ExpandIcon(
                    isExpanded: _isExpanded,
                    size: 30,
                    color: HexColor("#30C3A3"),
                    onPressed: (bool isExpanded) {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                  ))
            ],
          ),
        ),
        AnimatedOpacity(
            duration: Duration(milliseconds: 700),
            opacity: _isExpanded ? 1 : 0,
            child: _isExpanded
                ? FutureBuilder<List<dynamic>>(
                    future: misPedidosViewModel.misPedidosService
                        .consultarDetalleGrupo(widget.numeroDoc, widget.grupo),
                    builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                      if (snapshot.hasData) {
                        var detalles = snapshot.data;
                        return Column(
                          children: [
                            for (int i = 0; i < detalles!.length; i++)
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                width: size.width * 0.9,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          flex: 2,
                                          child: Container(
                                            width: Get.width * 0.9,
                                            padding: EdgeInsets.only(left: 4),
                                            child: Text(
                                              "${detalles[i].nombreProducto}",
                                              style: TextStyle(
                                                  color: HexColor("#8A8A8A"),
                                                  fontSize: 12),
                                              overflow: TextOverflow.clip,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            padding: EdgeInsets.only(left: 16),
                                            child: Text(
                                              "${detalles[i].cantidad}",
                                              style: TextStyle(
                                                  color: HexColor("#8A8A8A"),
                                                  fontSize: 12),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                          ],
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    })
                : null),
      ],
    );
  }
}
