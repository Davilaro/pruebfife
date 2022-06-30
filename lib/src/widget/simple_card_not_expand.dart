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
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(14),
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
                          // decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(10),
                          //     color: Colors.white),
                          // padding: const EdgeInsets.all(20.0),
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
                            // color: Colors.red,
                            child: Column(
                              children: [
                                Container(
                                  width: size.width * 0.9,
                                  // color: Colors.yellow,
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
                                  // color: Colors.blue,
                                  child: Text(
                                    widget.direccion,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Container(
                                  // color: Colors.green,
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
                            // color: Colors.yellow,
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
                    // margin: EdgeInsets.only(top: 10),
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
