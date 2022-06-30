import 'package:emart/src/modelos/historico.dart';
import 'package:emart/src/provider/db_provider_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class GrupoDetalle extends StatefulWidget {
  final String grupo;
  final int numeroDoc;
  const GrupoDetalle({Key? key, required this.grupo, required this.numeroDoc})
      : super(key: key);

  @override
  _GrupoDetalleState createState() => _GrupoDetalleState();
}

class _GrupoDetalleState extends State<GrupoDetalle> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
        future: DBProviderHelper.db
            .consultarDetalleGrupo(widget.numeroDoc, widget.grupo),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            var detalles = snapshot.data;
            return Column(
              children: [
                for (int i = 0; i < detalles!.length; i++)
                  Container(
                    alignment: Alignment.centerLeft,
                    // duration: Duration(milliseconds: 500),
                    padding: EdgeInsets.only(left: 16),
                    child: Text(
                      '${detalles[i].nombreProducto}  ${detalles[i].cantidad}',
                      style: TextStyle(color: HexColor("#8A8A8A")),
                    ),
                  ),
              ],
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
