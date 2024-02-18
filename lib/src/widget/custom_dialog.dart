import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog(
      {Key? key,
      this.hasLeftButton = true,
      this.hasRightButton = false,
      this.onRightPressed,
      this.onLeftPressed,
      this.title,
      this.padding = 10.0,
      this.isVertical = false,
      required this.content})
      : super(key: key);

  final bool hasLeftButton;
  final bool hasRightButton;
  final Function()? onLeftPressed;
  final Function()? onRightPressed;
  final Widget? title;
  final Widget content;
  final double padding;
  final bool isVertical;

  @override
  Widget build(BuildContext context) {
    return BounceInDown(
      duration: const Duration(milliseconds: 500),
      child: AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
          Radius.circular(24),
        )),
        contentPadding: EdgeInsets.all(padding),
        title: title,
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            content,
            Visibility(
              visible: !isVertical,
              child: Row(
                children: <Widget>[
                  Visibility(
                    visible: hasLeftButton,
                    child: Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                        child: ElevatedButton(
                          child: Text(
                            "Aceptar",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: onLeftPressed ??
                              () => {Navigator.of(context).pop()},
                          style: ElevatedButton.styleFrom(
                            foregroundColor: HexColor("#E4E3AD"), backgroundColor: HexColor("#30C3A3"), // foreground
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: hasRightButton,
                    child: Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                        child: ElevatedButton(
                          child: Text(
                            "Cancelar",
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: onRightPressed ??
                              () => {Navigator.of(context).pop()},
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            //
            Visibility(
              visible: isVertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Visibility(
                    visible: hasRightButton,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 20, left: 5, right: 5),
                      child: ElevatedButton(
                        child: Text(
                          "Cancelar",
                          style: TextStyle(
                              color: ConstantesColores.azul_precio,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: onRightPressed ??
                            () => {Navigator.of(context).pop()},
                        style: ElevatedButton.styleFrom(
                          foregroundColor: ConstantesColores.azul_precio, backgroundColor: Colors.white, fixedSize: Size(Get.width * 0.9, 45), // foreground
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: BorderSide(
                                color: ConstantesColores.azul_precio, width: 2),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: hasLeftButton,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 10),
                      child: ElevatedButton(
                        child: Text(
                          "Aceptar",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: onLeftPressed ??
                            () => {Navigator.of(context).pop()},
                        style: ElevatedButton.styleFrom(
                          foregroundColor: HexColor("#E4E3AD"), backgroundColor: ConstantesColores.agua_marina, fixedSize: Size(Get.width * 0.9, 45), // foreground
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
