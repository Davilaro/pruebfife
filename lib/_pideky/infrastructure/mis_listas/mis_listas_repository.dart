import 'dart:convert';

import 'package:emart/_pideky/domain/mi_listas/interface/mis_listas_interface.dart';
import 'package:emart/_pideky/domain/mi_listas/model/lista_detalle_model.dart';
import 'package:emart/_pideky/domain/mi_listas/model/lista_encabezado_model.dart';
import 'package:emart/_pideky/presentation/mis_listas/view_model/mis_listas_view_model.dart';
import 'package:emart/src/controllers/controller_db.dart';
import 'package:emart/src/preferences/const.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/widget/boton_actualizar.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class MisListasRepository implements MisListasInterface {
  @override
  Future addLista(
      {required String nombreLista,
      required String sucursal,
      required String ccup}) async {
    try {
      final url;
      url = Uri.parse(Constantes().urlPrincipal + "ListaCompra/CreateHeader");
      final response = await http.post(url, body: {
        "Nombre": nombreLista,
        "Sucursal": sucursal,
        "CCUP": ccup,
      });
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data != '-1') {
        return [
          '¡Has creado con éxito una nueva lista personalizada!',
          true,
          int.parse(data)
        ];
      } else if (data == '-1') {
        return ['Ya existe una lista con ese nombre', false];
      } else {
        throw ("algo salio mal");
      }
    } catch (e) {
      print("error creando lista $e");
      return ['Ha ocurrido un error, por favor intenta de nuevo', false];
    }
  }

  @override
  Future addProducto(
      {required int idLista,
      required String codigoProducto,
      required int cantidad,
      required String proveedor}) async {
    try {
      print('data enviada $idLista, $codigoProducto, $cantidad, $proveedor');
      final url;
      url = Uri.parse(Constantes().urlPrincipal + "ListaCompra/CreateDetail");
      final response = await http.post(url, body: {
        "Id": "$idLista",
        "Codigo": codigoProducto,
        "Cantidad": '$cantidad',
        "Proveedor": proveedor
      });

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data == 'OK') {
        print('todo bien');
        return [true, true];
      } else {
        throw ('algo salio mal');
      }
    } catch (e) {
      print("error creando producto $e");
      return ['Ha ocurrido un error, por favor intenta de nuevo', false];
    }
  }

  @override
  Future deleteLista(
      {required String ccup,
      required String nombre,
      required String sucursal,
      required int idLista,
      required context}) async {
    try {
      final myList = Get.find<MyListsViewModel>();
      final cargoConfirmar = Get.find<ControlBaseDatos>();
      final url;
      url = Uri.parse(Constantes().urlPrincipal + "ListaCompra/DeleteHeader");

      final response = await http.post(url, body: {
        "Id": "$idLista",
        "CCUP": "$ccup",
        "Sucursal": "$sucursal",
        "Nombre": "$nombre"
      });
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data == 'OK') {
        await actualizarPaginaSinReset(context, cargoConfirmar);
        var copy = List.from(myList.misListas);
        copy.forEach((lista) {
          if (lista.id == idLista && lista.nombre == nombre) {
            myList.misListas.remove(lista);
          }
          print('eliminando lista');
        });
        return [true, true];
      } else {
        throw ('algo salio mal');
      }
    } catch (e) {
      print("error eliminando lista $e");
      return ['Ha ocurrido un error, por favor intenta de nuevo', false];
    }
  }

  @override
  Future deleteProducto({required List productos}) async {
    try {
      final url =
          Uri.parse(Constantes().urlPrincipal + "ListaCompra/DeleteDetail");
      var body = jsonEncode(productos);

      final response = await http.post(url, body: body, headers: {
        'Content-Type': 'application/json',
      });

      print('body $body ');
      final data = jsonDecode(response.body);
      print('status $data');

      if (response.statusCode == 200 && data == 'OK') {
        return [true, true];
      } else {
        throw ('algo salio mal');
      }
    } catch (e) {
      print("error eliminando productos $e");
      return ['Ha ocurrido un error, por favor intenta de nuevo', false];
    }
  }

  @override
  Future getMisListas() async {
    final db = await DBProvider.db.baseAbierta;
    var sql =
        """select le.Id as id, le.Nombre as nombre from ListaCompraEncabezado le""";
    try {
      var response = await db.rawQuery(sql);
      return response.isNotEmpty
          ? response.map((e) => ListaEncabezado.fromJson(e)).toList()
          : [];
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future updateLista(
      {required String nombreLista,
      required String sucursal,
      required String ccup,
      required int idLista}) {
    throw UnimplementedError();
  }

  @override
  Future updateProducto(
      {required int idLista,
      required String codigoProducto,
      required int cantidad,
      required String proveedor}) async {
    try {
      final url;
      final myList = Get.find<MyListsViewModel>();
      url = Uri.parse(Constantes().urlPrincipal + "ListaCompra/UpdateDetail");
      var body = {
        "Id": idLista.toString(),
        "Codigo": codigoProducto,
        "Cantidad": cantidad.toString(),
        "Proveedor": proveedor
      };
      final response = await http.post(url, body: body);
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data == 'OK') {
        myList.mapListasProductos.forEach((key, value) {
          if (key == proveedor) {
            value['items'].forEach((ListaDetalle element) {
              if (element.codigo == codigoProducto) {
                element.cantidad = cantidad;
                myList.update();
              }
            });
          }
        });
        return [true, true];
      }
    } catch (e) {
      print("error actualizando producto $e");
      return ['Ha ocurrido un error, por favor intenta de nuevo', false];
    }
  }

  @override
  Future getProductos({int? idLista}) async {
    final db = await DBProvider.db.baseAbierta;
    var sql = idLista != null
        ? """ SELECT   ld.proveedor  proveedor, ld.Codigo codigo , P.Nombre nombre, ld.nombre nombreLista, ld.Id , F.ico icon, 
		F.nombrecomercial nombreComercial , 
        ROUND((( p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)) + 
            (CASE
                  WHEN p.ICUI = 0 THEN p.IBUA
                   ELSE ((p.precio * p.ICUI) / 100)
                END) + 
            (( p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)) * p.iva / 100)), 0)
     AS precio, ld.Cantidad
        FROM ListaCompraDetalle ld 
        INNER JOIN Producto P ON P.Codigo = ld.Codigo 
        left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
             select count(P.codigo) identificador,*
             from descuentos D inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante group by material
        ) tmp where tmp.identificador = 1) tmp on P.fabricante = tmp.proveedor and P.codigo = tmp.codigo
        INNER JOIN Fabricante F ON F.empresa = P.Fabricante where ld.Id = "$idLista" """
        : """
        SELECT   ld.proveedor  proveedor, ld.Codigo codigo , P.Nombre nombre, ld.nombre nombreLista, ld.Id , F.ico icon, 
            F.nombrecomercial nombreComercial , 
                ROUND((( p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)) + 
                    (CASE
                          WHEN p.ICUI = 0 THEN p.IBUA
                          ELSE ((p.precio * p.ICUI) / 100)
                        END) + 
                    (( p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)) * p.iva / 100)), 0)
            AS precio, ld.Cantidad
                FROM ListaCompraDetalle ld 
                INNER JOIN Producto P ON P.Codigo = ld.Codigo 
                left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
                    select count(P.codigo) identificador,*
                    from descuentos D inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante group by material
                ) tmp where tmp.identificador = 1) tmp on P.fabricante = tmp.proveedor and P.codigo = tmp.codigo
                INNER JOIN Fabricante F ON F.empresa = P.Fabricante 
        """;
    try {
      var response = await db.rawQuery(sql);
      return response.isNotEmpty
          ? response.map((e) => ListaDetalle.fromJson(e)).toList()
          : [];
    } catch (e) {
      print("error obteniendo productos $e");
      return [];
    }
  }
}
