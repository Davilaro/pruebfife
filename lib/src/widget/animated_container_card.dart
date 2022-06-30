import 'package:emart/src/modelos/historico.dart';
import 'package:emart/src/provider/db_provider_helper.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AnimatedContainerCard extends StatefulWidget {
  final String grupo;
  final int numeroDoc;
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
  bool _isExpanded = false;

  Widget _validarNumeroPedido(String? pedido) {
    if (pedido != 'Pendiente') {
      return Container(
        child: Text("N° Pedido ${widget.ordenCompra}",
            style: TextStyle(
                fontSize: 13,
                color: Colors.black.withOpacity(.6),
                fontWeight: FontWeight.bold)),
      );
    } else {
      return Container(
        // duration: Duration(milliseconds: 500),
        child: Text(
          "Número de pedido por validar",
          style: TextStyle(
              fontSize: 13,
              color: HexColor("#FFD94D"),
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
        Row(
          children: [
            Container(
              // color: Colors.white,
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.only(left: 16, top: 10),
                child: Column(
                  children: [
                    Text(" ${widget.grupo}",
                        style: TextStyle(
                            fontSize: 13,
                            color: HexColor("#43398E"),
                            fontWeight: FontWeight.bold)),
                    _validarNumeroPedido(widget.ordenCompra),
                    // Text("N° Pedido ${widget.ordenCompra}",
                    //     style: TextStyle(
                    //         fontSize: 13,
                    //         color: Colors.black.withOpacity(.6),
                    //         fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.only(left: 50, top: 4),
                // color: Colors.green,
                child: ExpandIcon(
                  isExpanded: _isExpanded,
                  size: 30,
                  color: HexColor("#30C3A3"),
                  onPressed: (bool isExpanded) {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                )
                // color: Colors.yellow,
                )
          ],
        ),
        AnimatedOpacity(
            duration: Duration(milliseconds: 700),
            opacity: _isExpanded ? 1 : 0,
            child: _isExpanded
                ? FutureBuilder<List<dynamic>>(
                    future: DBProviderHelper.db
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
                                // duration: Duration(milliseconds: 500),
                                // curve: Curves.fastOutSlowIn,
                                // margin: _isExpanded ? kExpandedEdgeInsets : EdgeInsets.zero,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Container(
                                            // duration: Duration(milliseconds: 500),
                                            padding: EdgeInsets.only(left: 16),
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
                                          child: Container(
                                            // duration: Duration(milliseconds: 500),
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
