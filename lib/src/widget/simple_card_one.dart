import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class SimpleCardOne extends StatefulWidget {
  final String texto;
  final String referencia;
  SimpleCardOne({Key? key, required this.texto, required this.referencia})
      : super(key: key);

  @override
  _SimpleCardOneState createState() => _SimpleCardOneState();
}

class _SimpleCardOneState extends State<SimpleCardOne> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14),
      child: Column(
        children: [
          SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.white,
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
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          padding: const EdgeInsets.all(20.0),
                          child: Text(widget.texto,
                              style: TextStyle(
                                color: _isExpanded
                                    ? HexColor("#43398E")
                                    : Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              )),
                          alignment: Alignment.centerLeft,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
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
                                  padding: const EdgeInsets.only(top: 2),
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.task_alt,
                                    color: HexColor("#30C3A3"),
                                    size: 30,
                                  ),
                                ),
                                Container(
                                  child: Column(
                                    children: [
                                      Container(
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
