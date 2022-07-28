import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:device_info/device_info.dart';
import 'package:emart/src/preferences/const.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/provider/db_provider_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class AppUtil {
  static String? _appUtil;

  static final AppUtil appUtil = AppUtil._();
  AppUtil._();

  Future<String> get crearFolder async {
    if (_appUtil != null) return _appUtil!;

    _appUtil = await createFolderInAppDocDir(Constantes().nombreApp);
    return _appUtil!;
  }

  String _localZipFileName = 'db.zip';

  Future<String> createFolderInAppDocDir(String folderName) async {
    final Directory _appDocDirFolder = await getApplicationDocumentsDirectory();

    final Directory _appDocDirNewFolder =
        await _appDocDirFolder.create(recursive: true);

    return _appDocDirNewFolder.path;
  }

  Future<String> get crearFolderIos async {
    try {
      Directory appDocDirectory = await getApplicationDocumentsDirectory();

      final Directory _appDocDirNewFolder =
          await appDocDirectory.create(recursive: true);

      _appUtil = _appDocDirNewFolder.path + Constantes().carpeta;
    } catch (e) {
      print(e);
    }
    return _appUtil!;
  }

  Future<bool> downloadZip(String usuario, String sucursal, codigonutresa,
      codigozenu, codigomeals, generico) async {
    try {
      String archivo = '';

      await eliminarCarpeta();

      archivo = await crearFolderIos;

      File zippedFile = await _downloadFile(
          usuario,
          sucursal,
          _localZipFileName,
          archivo,
          codigonutresa,
          codigozenu,
          codigomeals,
          generico);
      var estado = await unarchiveAndSave(zippedFile, archivo);
      if (estado) {
        return true;
      }
    } catch (ex) {
      print('hola data error ${ex.toString()}');
      return false;
    }

    return false;
  }

  Future<File> _downloadFile(
      String usuario,
      String sucursal,
      String fileName,
      String dir,
      String codigonutresa,
      String codigozenu,
      String codigomeals,
      bool generico) async {
    String url = "";
    var req;
    var file;
    if (generico) {
      url = Constantes().urlBaseGenerico + 'sync/Db/Generico/db.zip';
    } else {
      url = Constantes().urlBase +
          'CrearDB.aspx?nit=$usuario&cliente=$sucursal&clientenutresa=$codigonutresa&clientezenu=$codigozenu&clientemeals=$codigomeals';
    }

    print('url : $url');
    try {
      req = await http.Client().get(Uri.parse(url));
      file = File('$dir$fileName');
    } catch (e) {
      print('error al descar archivo $e');
    }
    return await file.writeAsBytes(
      req.bodyBytes,
      flush: false,
    )!;
  }

  Future<bool> unarchiveAndSave(var zippedFile, String dir) async {
    var descargoBien = false;
    var bytes = await zippedFile.readAsBytesSync();
    var archive = ZipDecoder().decodeBytes(bytes);
    for (var file in archive) {
      var fileName = '$dir${file.name}';
      if (file.isFile) {
        var outFile = File(fileName);
        outFile = await outFile.create(recursive: true);
        await outFile.writeAsBytes(file.content);
        descargoBien = true;
      }
    }

    return descargoBien;
  }

  comprimirArchivo(_appDocDirFolder) {
    // Zip a directory to out.zip using the zipDirectory convenience method
    var encoder = ZipFileEncoder();

    encoder.create(_appDocDirFolder.path + 'Temp.zip');
    encoder.addFile(File(_appDocDirFolder.path + 'Temp.db'));
    encoder.close();
  }

  Future<bool> abrirBases() async {
    await DBProvider.db.database;
    await DBProviderHelper.db.database;
    return true;
  }

  enviarNotificacion(String usuario, String titulo, String cuerpo,
      List<String> datosPersonas, String numDoc) async {
    datosPersonas.forEach((element) async {
      DateTime now = new DateTime.now();
      String fecha = DateFormat('yyyyMMddkkmm').format(now);
      String
          URL = /*Constantes().urlApi +*/ "to=$element&title=$titulo&body=$cuerpo&from=$usuario&doc=$numDoc";

      var request = http.MultipartRequest('POST', Uri.parse(URL));

      debugPrint(URL);

      request.headers['content-type'] =
          'multipart/form-data; boundary=O.VhPut0067inOIWt0._Pt8RaPKiPHWU0oNOtWz-xTY1iY.3WKN';

      http.StreamedResponse response = await request.send();
      response.stream.transform(utf8.decoder).listen((value) async {
        print(value);
      });
    });
  }

  Future<void> eliminarCarpeta() async {
    try {
      await DBProviderHelper.db.eliminarBasesDeDatosTemporal();
      // await DBProviderHelper.db.cerrarBases();
      // await DBProvider.db.cerrarBases();

      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var release = androidInfo.version.release;
      Directory appDocDirectory = await getApplicationDocumentsDirectory();

      await appDocDirectory.delete(recursive: true);
    } catch (e) {
      print('error al cerrar las bases de datos $e');
    }
  }
}
