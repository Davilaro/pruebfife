// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class Acordion extends StatefulWidget {
  final String? urlIcon;
  final Widget contenido;
  final Widget? contenido2;
  final Widget title;
  final bool isIconState;
  final String? estado;
  final double? elevation;
  final double? margin;

  Acordion(
      {this.urlIcon,
      required this.title,
      required this.contenido,
      this.isIconState = false,
      this.estado,
      this.elevation,
      this.contenido2,
      this.margin});
  _EstadoAcordion createState() => _EstadoAcordion();
}

class _EstadoAcordion extends State<Acordion> {
  bool _mostrarContenido = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          color: Colors.white,
          margin: EdgeInsets.symmetric(vertical: 10),
          elevation: widget.elevation,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              margin: widget.margin == null
                  ? EdgeInsets.symmetric(vertical: 15)
                  : EdgeInsets.symmetric(vertical: widget.margin!),
              child: ListTile(
                leading: widget.urlIcon == null
                    ? null
                    : CachedNetworkImage(
                        imageUrl: widget.urlIcon ?? '',
                        height: Get.height * 0.1,
                        placeholder: (context, url) =>
                            Image.asset('assets/image/jar-loading.gif'),
                        errorWidget: (context, url, error) =>
                            Image.asset('assets/image/logo_login.png'),
                        fit: BoxFit.contain,
                      ),
                title: widget.title,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    widget.isIconState
                        ? Icon(
                            Icons.circle_rounded,
                            size: 13,
                            color: widget.estado == 'Activo'
                                ? HexColor('#00FF44')
                                : HexColor('#FF0045'),
                          )
                        : Container(),
                    widget.isIconState
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              widget.estado == 'Activo' ? 'Activo' : 'Inactivo',
                              style: TextStyle(fontSize: 11.0),
                            ),
                          )
                        : Container(),
                    widget.estado == 'Activo' || widget.estado == null
                        ? IconButton(
                            icon: Icon(
                              _mostrarContenido
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: 40,
                            ),
                            color: ConstantesColores.agua_marina,
                            onPressed: () {
                              widget.estado == 'Activo' || widget.estado == null
                                  ? setState(() {
                                      _mostrarContenido = !_mostrarContenido;
                                    })
                                  : null;
                            },
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
            _mostrarContenido
                ? Container(
                    padding: EdgeInsets.only(bottom: 15),
                    child: widget.contenido,
                  )
                : Container()
          ]),
        ),
        Visibility(
          visible: _mostrarContenido,
          child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.only(bottom: 15),
            child: widget.contenido2,
          ),
        ),
      ],
    );
  }
}
