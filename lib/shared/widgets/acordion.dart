import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class Acordion extends StatefulWidget {
  final String? urlIcon;
  final Widget contenido;
  final Widget title;
  final bool isIconState;
  final String? estado;
  final double? elevation;

  Acordion(
      {this.urlIcon,
      required this.title,
      required this.contenido,
      this.isIconState = false,
      this.estado,
      this.elevation});
  _EstadoAcordion createState() => _EstadoAcordion();
}

class _EstadoAcordion extends State<Acordion> {
  bool _mostrarContenido = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: widget.elevation,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 15),
          child: ListTile(
            leading: widget.urlIcon == ''
                ? CachedNetworkImage(
                    imageUrl: widget.urlIcon ?? '',
                    height: Get.height * 0.1,
                    placeholder: (context, url) =>
                        Image.asset('assets/image/jar-loading.gif'),
                    errorWidget: (context, url, error) =>
                        Image.asset('assets/image/logo_login.png'),
                    fit: BoxFit.contain,
                  )
                : null,
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
                padding: EdgeInsets.symmetric(vertical: 15),
                child: widget.contenido,
              )
            : Container()
      ]),
    );
  }
}
