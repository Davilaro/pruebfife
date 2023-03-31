import 'dart:convert';
import 'dart:typed_data';
import 'package:emart/_pideky/presentation/mis_pedidos/view_model/mis_pedidos_view_model.dart';
import 'package:emart/src/modelos/bannner.dart';
import 'package:emart/src/modelos/categorias.dart';
import 'package:emart/src/modelos/encuesta.dart';
import 'package:emart/src/modelos/estado.dart';
import 'package:emart/src/modelos/fabricantes.dart';
import 'package:emart/_pideky/domain/mis_pedidos/model/historico.dart';
import 'package:emart/src/modelos/lista_empresas.dart';
import 'package:emart/src/modelos/lista_productos.dart';
import 'package:emart/src/modelos/lista_sucursales_data.dart';
import 'package:emart/src/modelos/marcas.dart';
import 'package:emart/src/modelos/notificaciones.dart';
import 'package:emart/src/modelos/novedades_registro.dart';
import 'package:emart/src/modelos/pedido.dart';
import 'package:emart/src/modelos/productos_recomendados.dart';
import 'package:emart/src/modelos/respuesta.dart';
import 'package:emart/src/modelos/validacion.dart';
import 'package:emart/src/modelos/validar.dart';
import 'package:emart/src/modelos/validar_pedido.dart';
import 'package:emart/src/notificaciones/push_notification.dart';
import 'package:emart/src/preferences/const.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

final prefs = new Preferencias();

class Servicies {
  Future<List<dynamic>> loginUsurio(String nit) async {
    final url = Uri.parse(
      Constantes().urlPrincipal + 'empresa/sucursal?nit=$nit',
    );
    print(url);
    final reponse = await http.get(url);

    final res = json.decode(reponse.body);

    return res.isNotEmpty
        ? res.map((valor) => ListaEmpresas.fromJson(valor)).toList()
        : [];
  }

  Future<List<dynamic>> getListaSucursales(String nit) async {
    try {
      final url = Uri.parse(
        Constantes().urlPrincipal + 'SucursalesPideKi?nit=$nit',
      );
      print(url);
      final reponse = await http.get(url);

      final res = json.decode(reponse.body);

      return res.isNotEmpty
          ? res.map((valor) => ListaSucursalesData.fromJson(valor)).toList()
          : [];
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> getListaNotificaciones(String nit) async {
    final Uri url;
    if (prefs.usurioLogin == -1) {
      url = Uri.parse(
        Constantes().urlPrincipal + 'notificacion/leerNotificacionesGenerica',
      );
    } else {
      url = Uri.parse(
        Constantes().urlPrincipal +
            'notificacion/leerNotificaciones?nit=${nit}&sucursal=${nit}',
      );
    }

    print('url notificaciones $url');
    final reponse = await http.get(url);
    final res = json.decode(reponse.body);

    return res.isNotEmpty
        ? res.map((valor) => Notificaciones.fromJson(valor)).toList()
        : [];
  }

  Future<List<dynamic>> getListaCategorias(
      String codEmpresa, String codSucursal) async {
    try {
      final url = Uri.parse(
        Constantes().urlPrincipal +
            'categoria?origen=$codEmpresa&cliente=$codSucursal',
      );
      print(url);
      final reponse = await http.get(url);

      final res = json.decode(reponse.body);

      return res.isNotEmpty
          ? res.map((valor) => Categorias.fromJson(valor)).toList()
          : [];
    } catch (e) {
      print(e.toString());
    }

    return [];
  }

  Future<dynamic> getListaProductos(String codEmpresa, String codCliente,
      String codCategoria, int tipoPedido) async {
    final url;
    //normal sin filtro
    if (tipoPedido == 1) {
      url = Uri.parse(
        Constantes().urlPrincipal +
            'producto?origen=$codEmpresa&cliente=$codCliente',
      );
      print(url);
      //filtro categoria
    } else if (tipoPedido == 2) {
      url = Uri.parse(
        Constantes().urlPrincipal +
            'producto?origen=$codEmpresa&cliente=$codCliente&ca=$codCategoria',
      );
      print(url);
      //filtro marca
    } else if (tipoPedido == 3) {
      url = Uri.parse(
        Constantes().urlPrincipal +
            'producto?origen=$codEmpresa&cliente=$codCliente&ma=$codCategoria',
      );
      print(url);
    } else {
      //filtro por fabricante
      url = Uri.parse(
        Constantes().urlPrincipal +
            'producto?origen=$codEmpresa&cliente=$codCliente&fe=$codCategoria',
      );
      print(url);
    }

    final response = await http.get(url);

    final res = json.decode(response.body);

    return res.isNotEmpty ? ListaProductos.fromJson(res) : null;
  }

  Future<dynamic> getListaMarcas(String codEmpresa, String codCliente) async {
    try {
      final url;

      url = Uri.parse(
        Constantes().urlPrincipal +
            'marca?origen=$codEmpresa&cliente=$codCliente',
      );
      print(url);
      final response = await http.get(url);

      final res = json.decode(response.body);

      return res.isNotEmpty
          ? res.map((valor) => Marcas.fromJson(valor)).toList()
          : [];
    } catch (e) {}

    return [];
  }

  Future<dynamic> getListaBanners() async {
    final url;

    url = Uri.parse(
      Constantes().urlPrincipal + 'banner?tipo=home',
    );
    print(url);
    final response = await http.get(url);

    final res = json.decode(response.body);

    return res.isNotEmpty
        ? res.map((valor) => Banners.fromJson(valor)).toList()
        : null;
  }

  Future<dynamic> getListaSugerido(String codEmpresa, String codCliente) async {
    final url;

    url = Uri.parse(
      Constantes().urlPrincipal +
          'sugerido?origen=$codEmpresa&cliente=$codCliente',
    );
    print(url);
    final response = await http.get(url);

    final res = json.decode(response.body);

    return res.isNotEmpty
        ? res.map((valor) => ProductosRecomendados.fromJson(valor)).toList()
        : null;
  }

  Future<dynamic> validarUsuari(
      String codUsuario, String idUnicoMovil, String plataforma) async {
    try {
      final url;

      url = Uri.parse(Constantes().urlPrincipal + 'cliente/validar');
      print(url);
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "DeviceId": "$idUnicoMovil",
          "DeviceType": "$plataforma",
          "Nit": "$codUsuario"
        }),
      );
      print([
        "DeviceId $idUnicoMovil",
        "DeviceType $plataforma",
        "Nit $codUsuario"
      ]);
      if (response.statusCode == 200) {
        return Validacion.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> enviarCorreo(String correo, int codigo) async {
    try {
      final url;

      url = Uri.parse(Constantes().urlPrincipal + 'cliente/enviarcodigo');
      print(url);
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            <String, String>{"Codigo": '$codigo', "Email": '$correo'}),
      );

      if (response.statusCode == 200) {
        return Estado.fromJson(jsonDecode(response.body));
      } else {
        return response.statusCode;
      }
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> enviarMS(String telefono, int codigo) async {
    try {
      final url;

      url = Uri.parse(Constantes().urlPrincipal + 'cliente/enviarcodigo');
      print(url);
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "Codigo": '$codigo',
          "Telefono": '$telefono',
          "Pais": "US"
        }),
      );

      if (response.statusCode == 200) {
        return Estado.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> enviarCodigoVerificacion(
      int codigo, String codigoVerificion) async {
    try {
      final url;

      url = Uri.parse(Constantes().urlPrincipal + 'cliente/activar');
      print(url);
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "Codigo": '$codigo',
          "CodigoVerficacion": '$codigoVerificion'
        }),
      );

      if (response.statusCode == 200) {
        return Validar.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> getHistoricoPedido(
      String codEmpresa, String codCliente) async {
    final url;

    try {
      url = Uri.parse(Constantes().urlPrincipal +
          'pedido?origen=$codEmpresa&cliente=$codCliente');
      print(url);
      final response = await http.get(url);

      final res = json.decode(response.body);

      return res.isNotEmpty
          ? res.map((valor) => Historico.fromJson(valor)).toList()
          : null;
    } catch (e) {}

    return [];
  }

  Future<dynamic> enviarPedido(List<Pedido> listaPedido, String usuarioLogin,
      String fechaPedido, String numDoc) async {
    String datos = "{\"ListaDetalle\" :[";
    final misPedidosViewModel = Get.find<MisPedidosViewModel>();

    for (var i = 0; i < listaPedido.length; i++) {
      print(
          'hola prueba ${listaPedido[i].codigoFabricante} ----- ${listaPedido[i].nitFabricante}');
      datos += jsonEncode(<String, dynamic>{
        "NumeroDoc": numDoc,
        "Cantidad": listaPedido[i].cantidad,
        "CodigoCliente": prefs.codCliente,
        "CodigoProducto": listaPedido[i].codigoProducto,
        "CodigoProveedor": 123,
        "DescripcionParam1": listaPedido[i].fabricante,
        "DescripcionParam2": listaPedido[i].codigocliente,
        "DescripcionParam3": listaPedido[i].nitFabricante,
        "descripcionparam5": listaPedido[i]
            .codigoFabricante, // colocar el codigo del fabricante de sucursales
        "FechaMovil": '$fechaPedido',
        "Iva": listaPedido[i].iva,
        "Observacion": 'Prueba',
        "Posicion": i,
        "Pais": prefs.paisUsuario,
        "Precio": listaPedido[i].precio,
        "ValorDescuento":
            listaPedido[i].precioInicial! * (listaPedido[i].descuento! / 100),
        "Param1": listaPedido[i].descuento!
      });
      await misPedidosViewModel.misPedidosService
          .guardarSeguimientoPedido(listaPedido[i], numDoc);
      // await DBProviderHelper.db.guardarHistorico(listaPedido[i], numDoc);
      if (i < listaPedido.length - 1) {
        datos += ",";
      }
    }

    datos += "]}";

    try {
      final url;

      url = Uri.parse(
          '${Constantes().urlPrincipal}Pedido?codigo=nutresa&codUsuario=$usuarioLogin');
      print("url pedido $url");
      print("datos pedido $datos");

      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: datos);

      if (response.statusCode == 200) {
        var res = ValidarPedido.fromJson(jsonDecode(response.body));
        print('respuesta ${res.mensaje}');
        return res;
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      print('pedido res error ${e.toString()}');
      return null;
    }
  }

  Future<List<dynamic>> getListaFabricantes(String cliente) async {
    try {
      final url = Uri.parse(
        Constantes().urlPrincipal + 'Fabricante?origen=nutresa&nit=$cliente',
      );
      print(url);
      final reponse = await http.get(url);

      final res = json.decode(reponse.body);

      return res.isNotEmpty
          ? res.map((valor) => Fabricantes.fromJson(valor)).toList()
          : [];
    } catch (e) {
      print(e.toString());
    }

    return [];
  }

  Future<dynamic> varificarCodigoMaestro(String codigoVerificion) async {
    final url = Uri.parse(
      Constantes().urlPrincipal + 'ClaveMaster?clave=$codigoVerificion',
    );
    print(url);
    final reponse = await http.get(url);

    final res = json.decode(reponse.body);

    return res.isNotEmpty
        ? res.map((valor) => Respuesta.fromJson(valor)).toList()
        : null;
  }

  Future<dynamic> novedadesRegistro() async {
    final url = Uri.parse(
      Constantes().urlPrincipal + 'Tiponovedad',
    );
    print(url);
    final reponse = await http.get(url);

    final res = json.decode(reponse.body);

    return res.isNotEmpty
        ? res.map((valor) => NovedadesRegistro.fromJson(valor)).toList()
        : null;
  }

  Future<dynamic> getListaInternosBanners(String fabricante) async {
    final url;

    url = Uri.parse(
      Constantes().urlPrincipal + 'banner?tipo=$fabricante',
    );
    print(url);
    final response = await http.get(url);

    final res = json.decode(response.body);

    return res.isNotEmpty
        ? res.map((valor) => Banners.fromJson(valor)).toList()
        : '';
  }

  Future<dynamic> enviarNovedadRegistro(int tipo, String observacion) async {
    try {
      final url;

      url = Uri.parse(Constantes().contencion + 'NovedadRegistro');

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "Tipo": "$tipo",
          "Observacion": "$observacion",
          "Nit": prefs.codClienteLogueado,
          "Telefono": "",
          "Correo": ""
        }),
      );

      if (response.statusCode == 200) {
        return Validar.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> validarUsuariNuevo(String codUsuario, String idUnicoMovil,
      String plataforma, String token) async {
    try {
      final url;

      url = Uri.parse(Constantes().urlPrincipal + 'cliente/nuevoValidar');
      print(url);
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "DeviceId": "$idUnicoMovil",
          "DeviceType": "$plataforma",
          "Nit": "$codUsuario",
          "Token": "$token"
        }),
      );
      print(response.body);
      print([
        "datos enviados",
        "DeviceId $idUnicoMovil",
        "DeviceType $plataforma",
        "Nit $codUsuario",
        "Token $token",
      ]);
      print(response.statusCode);

      if (response.statusCode == 200) {
        return Validacion.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> actualizarToken(String codUsuario, String idUnicoMovil,
      String plataforma, String token) async {
    try {
      final url;

      url =
          Uri.parse(Constantes().urlPrincipalToken + 'cliente/ActualizarToken');
      print(url);
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "IdDevice": "$idUnicoMovil",
          "Plataforma": "$plataforma",
          "Nit": "$codUsuario",
          "Token": "$token"
        }),
      );
      print([
        "IdDevice $idUnicoMovil",
        "Plataforma $plataforma",
        "Nit $codUsuario",
        "Token $token"
      ]);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> enviarEncuesta(Encuesta encuesta, String respuesta) async {
    try {
      DateTime now = DateTime.now();
      final url;
      String numDoc = DateFormat('yyyyMMddHHmmss').format(now);
      url = Uri.parse(
          Constantes().urlPrincipal + 'Encuestas/enviarRespuestaEncuesta');
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "NumdocEncuesta": "$numDoc",
          "EncuestaId": "${encuesta.encuestaId}",
          "EncuestaTitulo": "${encuesta.encuestaTitulo}",
          "PreguntaId": "${encuesta.preguntaId}",
          "TipoPreguntaId": "${encuesta.tipoPreguntaId}",
          "Pregunta": "${encuesta.pregunta}",
          "ParamPreguntaId": "${encuesta.paramPreguntaId}",
          "Valor": "${encuesta.valor}",
          "Parametro": "$respuesta", //respuesta
          "CodigoCliente": "${prefs.codCliente}",
          "pais": prefs.paisUsuario,
          "NitCliente": "${prefs.codClienteLogueado}",
        }),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      print('Encuesta enviar failed $e');
      return false;
    }
  }

  Future registrarToken(divace, String plataforma, String text) async {
    String? token = PushNotificationServer.token as String;
    await Servicies().actualizarToken(text, divace, plataforma, token);
  }

  Future<dynamic> editarTelefonoWhatsapp(String telefono) async {
    try {
      final url;

      url = Uri.parse(Constantes().urlPrincipal + 'Encuestas/CrearTelefonoNit');
      print(url);
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'usuario': '',
          'clave': ''
        },
        body: jsonEncode(<String, String>{
          "nit": "${prefs.codClienteLogueado}",
          "telefono": "$telefono",
        }),
      );
      print('respuesta ${response.statusCode}');
      if (response.statusCode == 200) {
        return response.statusCode;
      } else {
        return response.statusCode;
      }
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> cargarArchivo(urlGeneral) async {
    try {
      final url;

      url = Uri.parse(urlGeneral.toString());
      final response = await http.get(url);
      Uint8List file = response.bodyBytes;

      return file;
    } catch (e) {
      print('problema al buscar archivo en db $e');
    }
  }

  Future<bool> loadDataTermsAndConditions() async {
    try {
      DateTime current = DateTime.now();
      String currentDate = DateFormat('yyyy-MM-dd HH:mm').format(current);

      final url;
      url = Uri.parse(Constantes().urlPrincipal + 'Encuestas/crearCondiciones');
      print("url de tyc $url");

      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, String>{
            "nit": "${prefs.codClienteLogueado}",
            "fecha": "$currentDate",
            "pais": "${prefs.paisUsuario}"
          }));
      print("estado envio ${response.statusCode}");
      if (response.statusCode == 200) {
        print("tyc enviados correctamente");
        return true;
      } else {
        return false;
      }
    } catch (err) {
      print("something wrong $err");
      return false;
    }
  }

  Future<bool> deleteAccount() async {
    try {
      DateTime current = DateTime.now();
      String currentDate = DateFormat('yyyy-MM-dd HH:mm').format(current);

      final url;
      url = Uri.parse(Constantes().urlPrincipal + 'Encuestas/eliminaUsuario');
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, String>{
            "CCUP": "${prefs.codigoUnicoPideky}",
            "fecha": "$currentDate",
            "pais": "${prefs.paisUsuario}"
          }));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
