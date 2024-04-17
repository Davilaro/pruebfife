import 'package:flutter/material.dart';

double screenSize(context, String type, double hisVar) {
  final _screeenSize = MediaQuery.of(context).size;
  final double height = (_screeenSize.width >
          _screeenSize.height -
              MediaQuery.of(context).viewPadding.top -
              MediaQuery.of(context).viewPadding.bottom)
      ? ((_screeenSize.width -
                  MediaQuery.of(context).viewPadding.top -
                  MediaQuery.of(context).viewPadding.bottom) *
              hisVar) *
          2.4
      : (_screeenSize.width -
              MediaQuery.of(context).viewPadding.top -
              MediaQuery.of(context).viewPadding.bottom) *
          hisVar;
  final double width = (_screeenSize.width -
          MediaQuery.of(context).viewPadding.left -
          MediaQuery.of(context).viewPadding.right) *
      hisVar;
  if (type == 'height') {
    return height;
  } else if (type == 'width') {
    return width;
  } else {
    return 0;
  }
}
