import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class SimpleCardOneNotExpand extends StatefulWidget {
  final String texto;
  final String referencia;
  SimpleCardOneNotExpand(
      {Key? key, required this.texto, required this.referencia})
      : super(key: key);

  @override
  _SimpleCardOneNotExpandState createState() => _SimpleCardOneNotExpandState();
}

class _SimpleCardOneNotExpandState extends State<SimpleCardOneNotExpand> {
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
                          width: size.width * 0.9,
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
                                    widget.referencia,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: size.width * 0.9,
                            padding: const EdgeInsets.only(top: 2),
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
