import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class SimpleCard extends StatefulWidget {
  final String texto;
  final String ciudad;
  final String direccion;
  final String razonsocial;
  SimpleCard(
      {Key? key,
      required this.texto,
      required this.ciudad,
      required this.direccion,
      required this.razonsocial})
      : super(key: key);

  @override
  _SimpleCardState createState() => _SimpleCardState();
}

class _SimpleCardState extends State<SimpleCard> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          SingleChildScrollView(
            child: Container(
              // height: 62,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.white,
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.withOpacity(0.5),
                //     spreadRadius: 5,
                //     blurRadius: 7,
                //     offset: Offset(0, 3), // changes position of shadow
                //   ),
                // ],
              ),
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
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.white),
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            widget.texto,
                            style: TextStyle(
                                color: _isExpanded
                                    ? HexColor("#43398E")
                                    : Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.white),
                          padding: const EdgeInsets.all(5.0),
                          alignment: Alignment.center,
                          child: ExpandIcon(
                            size: 20,
                            color: HexColor("#30C3A3"),
                            isExpanded: _isExpanded,
                            padding: const EdgeInsets.all(16.0),
                            onPressed: (bool isExpanded) {
                              setState(() {
                                _isExpanded = !_isExpanded;
                              });
                            },
                          ),
                        ),
                      ])
                    ],
                  ),
                ],
              ),
            ),
          ),
          _isExpanded
              ? AnimatedContainer(
                  duration: Duration(milliseconds: 2000),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          child: Table(
                            columnWidths: {
                              0: FlexColumnWidth(2),
                              1: FlexColumnWidth(5)
                            },
                            children: [
                              TableRow(children: [
                                Container(
                                  padding: const EdgeInsets.only(top: 14),
                                  // color: Colors.yellow,
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.task_alt,
                                    color: HexColor("#30C3A3"),
                                    size: 30,
                                  ),
                                ),
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
                                        // width: size.width * 0.9,
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
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.left,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ])
                            ],
                          ),
                          margin: EdgeInsets.only(top: 14),
                        ),
                      ],
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
