import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class SimpleCardNotExpand extends StatefulWidget {
  final String texto;
  final String ciudad;
  final String direccion;
  final String razonsocial;
  SimpleCardNotExpand(
      {Key? key,
      required this.texto,
      required this.ciudad,
      required this.direccion,
      required this.razonsocial})
      : super(key: key);

  @override
  _SimpleCardNotExpandState createState() => _SimpleCardNotExpandState();
}

class _SimpleCardNotExpandState extends State<SimpleCardNotExpand> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: 14),
      child: Column(
        children: [
          SingleChildScrollView(
            child: Container(
              height: 40,
              child: Column(
                children: [
                  Table(
                    columnWidths: {
                      0: FlexColumnWidth(5),
                      1: FlexColumnWidth(1),
                    },
                    children: [
                      TableRow(children: [
                        Container(
                          child: Text(
                            widget.texto,
                            style: TextStyle(
                                color: HexColor("#43398E"),
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                      ])
                    ],
                  ),
                ],
              ),
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 2000),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: Table(
                      columnWidths: {
                        0: FlexColumnWidth(5),
                        1: FlexColumnWidth(2)
                      },
                      children: [
                        TableRow(children: [
                          Container(
                            child: Column(
                              children: [
                                Container(
                                  width: size.width * 0.9,
                                  child: Text(
                                    widget.razonsocial.trim(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Container(
                                  width: size.width * 0.9,
                                  child: Text(
                                    widget.direccion,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Container(
                                  width: size.width * 0.9,
                                  child: Text(
                                    widget.ciudad,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 14),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.create_outlined,
                              color: HexColor("#30C3A3"),
                              size: 30,
                            ),
                          ),
                        ])
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
