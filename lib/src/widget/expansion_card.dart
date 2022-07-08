import 'package:emart/src/modelos/historico.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/db_provider_helper.dart';
import 'package:emart/src/widget/grupo_detalle.dart';
import 'package:emart/src/widget/soporte.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import 'animated_container_card.dart';

final prefs = new Preferencias();
const double _kPanelHeaderCollapsedHeight = 80.0;
const double _kPanelHeaderExpandedHeight = 80.0;
const EdgeInsets kExpandedEdgeInsets = const EdgeInsets.symmetric(
    vertical: _kPanelHeaderExpandedHeight - _kPanelHeaderCollapsedHeight);

class ExpansionCard extends StatefulWidget {
  final Historico historico;
  const ExpansionCard({
    Key? key,
    required this.historico,
  }) : super(key: key);

  @override
  _ExpansionCardState createState() => _ExpansionCardState();
}

class _ExpansionCardState extends State<ExpansionCard> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final estadoCompra = '';
    // double cardExpadend = 310;
    // double cardNotExpadend = 109;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        // width: size.width * 0.9,
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(10),
        //   color: Colors.white,
        //   boxShadow: [
        //     BoxShadow(
        //       color: Colors.grey.withOpacity(0.5),
        //       spreadRadius: 5,
        //       blurRadius: 7,
        //       offset: Offset(0, 3), // changes position of shadow
        //     ),
        //   ],
        // ),
        // duration: Duration(milliseconds: 500),
        // height: _isExpanded ? cardExpadend : cardNotExpadend,
        // curve: Curves.easeInOut,
        child: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(children: [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Table(
          columnWidths: {1: FractionColumnWidth(.36)},
          children: [
            TableRow(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Text(
                    "Orden Pideky ${widget.historico.numeroDoc}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  padding: EdgeInsets.all(16),
                ),
                Container(
                  alignment: Alignment.topRight,
                  child: Text(
                    widget.historico.fechaTrans!,
                    style: TextStyle(fontSize: 12),
                  ),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Container(
        padding: EdgeInsets.only(left: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Table(
          columnWidths: {2: FractionColumnWidth(.3)},
          children: [
            TableRow(
              children: [
                Container(
                  child: Row(children: [
                    Text(
                      "Ver detalles",
                      style: TextStyle(
                          color: HexColor("#43398E"),
                          fontWeight: FontWeight.bold),
                    ),
                    ExpandIcon(
                      isExpanded: _isExpanded,
                      padding: const EdgeInsets.all(16.0),
                      onPressed: (bool isExpanded) {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                    ),
                  ]),
                ),
              ],
            ),
          ],
        ),
      ),
      AnimatedOpacity(
          duration: Duration(milliseconds: 700),
          opacity: _isExpanded ? 1 : 0,
          child: _isExpanded
              ?
              // duration: Duration(milliseconds: 500),
              // curve: Curves.fastOutSlowIn,
              // margin: _isExpanded ? kExpandedEdgeInsets : EdgeInsets.zero,
              Column(
                  children: [
                    // Row(
                    //   children: [
                    //     _validarNumeroPedido(widget.historico.numeroDoc)
                    //   ],
                    // ),
                    _grupoComercial(size, widget.historico.numeroDoc),
                    Container(
                      // duration: Duration(milliseconds: 500),
                      margin: const EdgeInsets.only(top: 8.0),
                      padding: EdgeInsets.only(left: 16, right: 16),
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color: HexColor("#43398E"),
                                        width: 1.0)))),
                        child: Text(
                          '¿Necesitas ayuda con este pedido?',
                          style: TextStyle(color: HexColor("#43398E")),
                        ),
                        onPressed: () {
                          _soporte();
                        },
                      ),
                    ),
                  ],
                )
              : null)
    ]);
  }

  Widget _separador(size) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      width: size.width * 0.8,
      padding: EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            //                   <--- left side
            color: HexColor("#EAE8F5"),
            width: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _grupoComercial(size, numeroDocumento) {
    return Column(children: [
      // Row(
      //   children: [_validarNumeroPedido(widget.historico.numeroDoc)],
      // ),
      FutureBuilder<List<Historico>>(
          future: DBProviderHelper.db.consultarGrupoHistorico(numeroDocumento),
          builder: (context, AsyncSnapshot<List<Historico>> snapshot) {
            if (snapshot.hasData) {
              var grupos = snapshot.data;
              return Column(
                children: [
                  for (int i = 0; i < grupos!.length; i++)
                    AnimatedContainerCard(
                      grupo: grupos[i].fabricante!,
                      numeroDoc: numeroDocumento,
                      ordenCompra: grupos[i].ordenCompra!,
                    ),
                  _separador(size),
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          })
    ]);

    // return FutureBuilder<List<Historico>>(
    //     future: DBProviderHelper.db.consultarGrupoHistorico(numeroDocumento),
    //     builder: (context, AsyncSnapshot<List<Historico>> snapshot) {
    //       if (snapshot.hasData) {
    //         var grupos = snapshot.data;
    //         return Column(
    //           children: [
    //             for (int i = 0; i < grupos!.length; i++)
    //               AnimatedContainerCard(
    //                 grupo: grupos[i].fabricante!,
    //                 numeroDoc: numeroDocumento,
    //                 ordenCompra: grupos[i].ordenCompra!,
    //               ),
    //             _separador(size),
    //           ],
    //         );
    //       } else {
    //         return CircularProgressIndicator();
    //       }
    //     });
  }

  void _soporte() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Soporte(numEmpresa: prefs.numEmpresa)));
  }
}

class Item {
  String orden;
  String fecha;
  String numeroPedido;
  Item({required this.orden, required this.fecha, required this.numeroPedido});
}
