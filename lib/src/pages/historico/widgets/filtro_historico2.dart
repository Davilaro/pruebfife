import 'package:emart/src/controllers/controller_historico.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/provider/db_provider_helper.dart';
import 'package:emart/src/utils/alertas.dart';
import 'package:emart/src/utils/util.dart';
import 'package:emart/src/widget/dropdown_custom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class FiltroHistorico extends StatefulWidget {
  FiltroHistorico({Key? key}) : super(key: key);

  @override
  _FiltroHistoricoState createState() => _FiltroHistoricoState();
}

class _FiltroHistoricoState extends State<FiltroHistorico> {
  final controlerHistorico = Get.find<ControllerHistorico>();

  TextEditingController diaInicioController = TextEditingController();
  TextEditingController mesInicioController = TextEditingController();
  TextEditingController anoInicioController = TextEditingController();

  TextEditingController diaFinController = TextEditingController();
  TextEditingController mesFinController = TextEditingController();
  TextEditingController anoFinController = TextEditingController();

  List<String> listDias = [];
  List<String> listMeses = [];
  List<String> listAnos = [];
  List<String> listFinDias = [];
  RxString mensajeInformativo = ''.obs;

  final meses = {
    1: 'Enero',
    2: 'Febrero',
    3: 'Marzo',
    4: 'Abril',
    5: 'Mayo',
    6: 'Junio',
    7: 'Julio',
    8: 'Agosto',
    9: 'Septiembre',
    10: 'Octubre',
    11: 'Noviembre',
    12: 'Diciembre'
  };

  @override
  void initState() {
    dropdownItemsDia();
    dropdownItemsDiaFinal();
    dropdownItemsMes();
    dropdownItemsAno();
    validarInicio();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Filtro',
              style: TextStyle(color: HexColor("#41398D"), fontSize: 27)),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: HexColor("#30C3A3")),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0,
          actions: [iconLimpiarFiltro()],
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                color: ConstantesColores.color_fondo_gris,
                height: Get.height,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                      child: Text('Elige el periodo para filtrar tus pedidos',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey)),
                    ),
                    Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                        height: Get.height * 0.75,
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.zero,
                                  height: Get.height * 0.4,
                                  child: Stack(
                                      alignment: AlignmentDirectional.center,
                                      children: [
                                        Obx(() => Visibility(
                                              visible:
                                                  mensajeInformativo.value !=
                                                      '',
                                              child: Positioned(
                                                top: 250,
                                                width: Get.width * 0.8,
                                                child: Container(
                                                  child: Text(
                                                    mensajeInformativo.value,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                  ),
                                                ),
                                              ),
                                            )),
                                        Positioned(
                                          top: 300,
                                          child: Container(
                                              width: Get.width,
                                              margin:
                                                  EdgeInsets.only(bottom: 20),
                                              child: Divider(
                                                thickness: 2,
                                              )),
                                        ),
                                        //Fecha Final
                                        Positioned(
                                          top: 100,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  margin:
                                                      EdgeInsets.only(top: 30),
                                                  child: Text('Fecha final',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.grey))),
                                              Container(
                                                width: Get.width * 0.8,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Año final
                                                    _dropFecha(
                                                        'Año',
                                                        listAnos,
                                                        TextInputType.number,
                                                        'fin',
                                                        anoFinController),
                                                    // Mes final
                                                    _dropFecha(
                                                        'Mes',
                                                        listMeses,
                                                        TextInputType.text,
                                                        'fin',
                                                        mesFinController),
                                                    // Dia final
                                                    _dropFecha(
                                                        'Dia',
                                                        listFinDias,
                                                        TextInputType.text,
                                                        'fin',
                                                        diaFinController),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 10),
                                                child: Text('Fecha de inicio',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.grey))),
                                            Container(
                                              width: Get.width * 0.8,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // Año inicio
                                                  _dropFecha(
                                                      'Año',
                                                      listAnos,
                                                      TextInputType.number,
                                                      'inicio',
                                                      anoInicioController),
                                                  // Mes inicio
                                                  _dropFecha(
                                                      'Mes',
                                                      listMeses,
                                                      TextInputType.text,
                                                      'inicio',
                                                      mesInicioController),
                                                  // Dia Inicio
                                                  _dropFecha(
                                                      'Dia',
                                                      listDias,
                                                      TextInputType.number,
                                                      'inicio',
                                                      diaInicioController),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ]),
                                ),
                                Container(
                                    child: Text('Periodo seleccionado',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey))),
                                Obx(() => Center(
                                      child: Container(
                                          margin: EdgeInsets.only(
                                              top: 30, bottom: 130),
                                          child: Text(
                                              '${controlerHistorico.dia.isNotEmpty && controlerHistorico.dia.value != '-1' ? controlerHistorico.dia : ""} ${meses[toInt(controlerHistorico.mes.value)] ?? ""} - ${controlerHistorico.diaFin.isNotEmpty && controlerHistorico.diaFin.value != '-1' ? controlerHistorico.diaFin : ""} ${meses[toInt(controlerHistorico.mesFin.value)] ?? ""} ${controlerHistorico.anoFin.isNotEmpty && controlerHistorico.anoFin.value != '-1' ? controlerHistorico.anoFin : ""}',
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  color: ConstantesColores
                                                      .azul_precio))),
                                    )),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Center(
                                    child: Container(
                                      width: Get.width * 0.8,
                                      height: Get.height * 0.05,
                                      child: RaisedButton(
                                        onPressed: () {
                                          confirmarFiltro(context);
                                        },
                                        child: Text(
                                          'Filtrar',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        textColor: Colors.white,
                                        color: ConstantesColores.agua_marina,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _dropFecha(String fecha, List<String> list, TextInputType? keyboard,
      String tipoFecha, TextEditingController controller) {
    return Obx(() => Container(
          margin: EdgeInsets.only(top: 10),
          width: Get.width * 0.26,
          decoration: BoxDecoration(
            color: HexColor("#E4E3EC"),
            borderRadius: BorderRadius.circular(30),
          ),
          child: DropDownCustom(
              controller: controller,
              value: validarValue(fecha, tipoFecha),
              hintText: fecha,
              enabled: true,
              keyboard: keyboard,
              textStyle:
                  TextStyle(color: ConstantesColores.azul_precio, fontSize: 15),
              hintStyle: TextStyle(color: ConstantesColores.azul_precio),
              validListSeleect: (String? newValue) =>
                  validarData(newValue, fecha, tipoFecha),
              items: list),
        ));
  }

  String validarValue(String fecha, String tipoFecha) {
    if (fecha == 'Dia') {
      if (controlerHistorico.dia.value != '' &&
          controlerHistorico.dia.value != '-1') {
        if (tipoFecha == 'inicio') {
          return controlerHistorico.dia.value;
        } else {
          return controlerHistorico.diaFin.value;
        }
      } else {
        return '';
      }
    } else if (fecha == 'Mes') {
      if (controlerHistorico.mes.value != '' &&
          controlerHistorico.mes.value != '-1') {
        if (tipoFecha == 'inicio') {
          return meses[toInt(controlerHistorico.mes.value)].toString();
        } else {
          return meses[toInt(controlerHistorico.mesFin.value)].toString();
        }
      } else {
        return '';
      }
    } else {
      if (controlerHistorico.ano.value != '' &&
          controlerHistorico.ano.value != '-1') {
        if (tipoFecha == 'inicio') {
          return controlerHistorico.ano.value;
        } else {
          return controlerHistorico.anoFin.value;
        }
      } else {
        return '';
      }
    }
  }

  String obtenerMes(String? mes) {
    var res = '';
    meses.forEach((key, value) {
      if (value == mes) {
        res = key.toString();
      }
    });
    return res;
  }

  validarData(String? value, fecha, tipoFecha) {
    if (fecha == 'Dia') {
      if (tipoFecha == 'inicio') {
        controlerHistorico.dia.value = value!;
      } else {
        controlerHistorico.diaFin.value = value!;
      }
    } else if (fecha == 'Mes') {
      String res = obtenerMes(value);
      if (tipoFecha == 'inicio') {
        diaInicioController.text = '';
        controlerHistorico.dia.value = '';
        controlerHistorico.mes.value = res;
        dropdownItemsDia();
      } else {
        diaFinController.text = '';
        controlerHistorico.diaFin.value = '';
        controlerHistorico.mesFin.value = res;
        dropdownItemsDiaFinal();
      }
    } else {
      if (tipoFecha == 'inicio') {
        diaInicioController.text = '';
        controlerHistorico.dia.value = '';
        controlerHistorico.ano.value = value!;
        dropdownItemsDia();
      } else {
        diaFinController.text = '';
        controlerHistorico.diaFin.value = '';
        controlerHistorico.anoFin.value = value!;
        dropdownItemsDiaFinal();
      }
    }
  }

  confirmarFiltro(BuildContext context) async {
    if (controlerHistorico.dia.value != '' &&
        controlerHistorico.mes.value != '' &&
        controlerHistorico.ano.value != '' &&
        controlerHistorico.dia.value != '-1' &&
        controlerHistorico.mes.value != '-1' &&
        controlerHistorico.ano.value != '-1' &&
        controlerHistorico.diaFin.value != '' &&
        controlerHistorico.mesFin.value != '' &&
        controlerHistorico.anoFin.value != '' &&
        controlerHistorico.diaFin.value != '-1' &&
        controlerHistorico.mesFin.value != '-1' &&
        controlerHistorico.anoFin.value != '-1') {
      var fechaInicial =
          '${controlerHistorico.ano.value}-${controlerHistorico.mes.value.toString().length > 1 ? controlerHistorico.mes.value : '0${controlerHistorico.mes.value}'}-${controlerHistorico.dia.value.toString().length > 1 ? controlerHistorico.dia.value : '0${controlerHistorico.dia.value}'}';
      var fechaFin =
          '${controlerHistorico.anoFin.value}-${controlerHistorico.mesFin.value.toString().length > 1 ? controlerHistorico.mesFin.value : '0${controlerHistorico.mesFin.value}'}-${controlerHistorico.diaFin.value.toString().length > 1 ? controlerHistorico.diaFin.value : '0${controlerHistorico.diaFin.value}'}';
      var num1 = fechaInicial.replaceAll('-', '');
      var num2 = fechaFin.replaceAll('-', '');
      if (toInt(num1) < toInt(num2)) {
        if (await validarHistoricoFiltro(context, fechaInicial, fechaFin)) {
          mensajeInformativo.value = '';
          controlerHistorico.setFechaInicial(fechaInicial);
          controlerHistorico.setFechaFinal(fechaFin);
          Navigator.pop(context);
        }
      } else {
        mensajeInformativo.value =
            'Por favor selecciona una fecha inicial menor a la final';
      }
    } else {
      controlerHistorico.setFechaFinal('-1');
      controlerHistorico.setFechaInicial('-1');
      controlerHistorico.setFiltro('-1');
      Navigator.pop(context);
    }
  }

  limpiarFiltro() {
    setState(() {
      controlerHistorico.setFechaFinal('-1');
      controlerHistorico.setFechaInicial('-1');
      controlerHistorico.setFiltro('-1');

      controlerHistorico.dia.value = '';
      controlerHistorico.mes.value = '';
      controlerHistorico.ano.value = '';

      controlerHistorico.diaFin.value = '';
      controlerHistorico.mesFin.value = '';
      controlerHistorico.anoFin.value = '';
      diaInicioController.text = '';
      mesInicioController.text = '';
      anoInicioController.text = '';

      diaFinController.text = '';
      mesFinController.text = '';
      anoFinController.text = '';
    });
  }

  Widget iconLimpiarFiltro() {
    return OutlineButton(
      borderSide: BorderSide(style: BorderStyle.none),
      onPressed: () => limpiarFiltro(),
      child: Row(
        children: [
          Icon(
            Icons.cleaning_services_outlined,
            size: 30,
            color: HexColor("#43398E"),
          ),
          Container(
            width: 60,
            child: Text(
              'Limpiar Filtro',
              maxLines: 2,
              style: TextStyle(
                  color: ConstantesColores.azul_precio,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  validarInicio() {
    if (controlerHistorico.fechaInicial.value != '-1' ||
        controlerHistorico.fechaFinal.value != '-1') {
      DateTime _fechaInicial =
          DateTime.parse(controlerHistorico.fechaInicial.value);
      DateTime _fechaFinal =
          DateTime.parse(controlerHistorico.fechaFinal.value);

      diaInicioController.text = _fechaInicial.day.toString();
      mesInicioController.text =
          meses[toInt(_fechaInicial.month.toString())].toString();
      anoInicioController.text = _fechaInicial.year.toString();

      diaFinController.text = _fechaFinal.day.toString();
      mesFinController.text =
          meses[toInt(_fechaFinal.month.toString())].toString();
      anoFinController.text = _fechaFinal.year.toString();
    }
  }

  //cargar itemas de los dias
  void dropdownItemsDia() {
    Map<String, int> menuItems = {};

    List<String> list = [];

    if (controlerHistorico.mes.value == '2' &&
            controlerHistorico.ano.value == '2024' ||
        controlerHistorico.ano.value == '2028' ||
        controlerHistorico.ano.value == '2032' ||
        controlerHistorico.ano.value == '2036' ||
        controlerHistorico.ano.value == '2040' ||
        controlerHistorico.ano.value == '2044' ||
        controlerHistorico.ano.value == '2048') {
      for (int i = 1; i <= 29; i++) {
        menuItems.addAll({'$i': i});
      }
    } else if (controlerHistorico.mes.value == '2') {
      for (int i = 1; i <= 28; i++) {
        menuItems.addAll({'$i': i});
      }
    } else if (controlerHistorico.mes.value == '4' ||
        controlerHistorico.mes.value == '6' ||
        controlerHistorico.mes.value == '9' ||
        controlerHistorico.mes.value == '11') {
      for (int i = 1; i <= 30; i++) {
        menuItems.addAll({'$i': i});
      }
    } else {
      for (int i = 1; i <= 31; i++) {
        menuItems.addAll({'$i': i});
      }
    }

    menuItems.forEach((key, value) {
      list.add(key);
    });
    setState(() {
      listDias = list;
    });
  }

  //cargar itemas de los dias fecha final
  void dropdownItemsDiaFinal() {
    Map<String, int> menuItems = {};

    List<String> list = [];

    if (controlerHistorico.mesFin.value == '2' &&
            controlerHistorico.anoFin.value == '2024' ||
        controlerHistorico.anoFin.value == '2028' ||
        controlerHistorico.anoFin.value == '2032' ||
        controlerHistorico.anoFin.value == '2036' ||
        controlerHistorico.anoFin.value == '2040' ||
        controlerHistorico.anoFin.value == '2044' ||
        controlerHistorico.anoFin.value == '2048') {
      for (int i = 1; i <= 29; i++) {
        menuItems.addAll({'$i': i});
      }
    } else if (controlerHistorico.mesFin.value == '2') {
      for (int i = 1; i <= 28; i++) {
        menuItems.addAll({'$i': i});
      }
    } else if (controlerHistorico.mesFin.value == '4' ||
        controlerHistorico.mesFin.value == '6' ||
        controlerHistorico.mesFin.value == '9' ||
        controlerHistorico.mesFin.value == '11') {
      for (int i = 1; i <= 30; i++) {
        menuItems.addAll({'$i': i});
      }
    } else {
      for (int i = 1; i <= 31; i++) {
        menuItems.addAll({'$i': i});
      }
    }

    menuItems.forEach((key, value) {
      list.add(key);
    });

    setState(() {
      listFinDias = list;
    });

    // return menuItems;
  }

  //cargar items de los meses
  void dropdownItemsMes() {
    Map<String, int> menuItems = {};
    List<String> list = [];

    menuItems.addAll({'Enero': 1});
    menuItems.addAll({'Febrero': 2});
    menuItems.addAll({'Marzo': 3});
    menuItems.addAll({'Abril': 4});
    menuItems.addAll({'Mayo': 5});
    menuItems.addAll({'Junio': 6});
    menuItems.addAll({'Julio': 7});
    menuItems.addAll({'Agosto': 8});
    menuItems.addAll({'Septiembre': 9});
    menuItems.addAll({'Octubre': 10});
    menuItems.addAll({'Noviembre': 11});
    menuItems.addAll({'Diciembre': 12});

    menuItems.forEach((key, value) {
      list.add(key);
    });

    setState(() {
      listMeses = list;
    });
  }

  //cargar itemas de los años
  void dropdownItemsAno() {
    Map<String, int> menuItems = {};
    List<String> list = [];

    for (int i = 2021; i <= 2050; i++) {
      menuItems.addAll({'$i': i});
    }

    menuItems.forEach((key, value) {
      list.add(key);
    });
    setState(() {
      listAnos = list;
    });
  }

  validarHistoricoFiltro(
      BuildContext context, String fechaInicial, String fechaFin) async {
    var res = await DBProviderHelper.db
        .consultarHistoricos('-1', fechaInicial, fechaFin);
    if (res.length > 0) {
      return true;
    } else {
      String mensaje = 'No encontramos registros para esas fechas';
      mostrarAlert(context, mensaje, null);
      return false;
    }
  }

  @override
  void dispose() {
    diaInicioController.dispose();
    mesInicioController.dispose();
    anoInicioController.dispose();
    diaFinController.dispose();
    mesFinController.dispose();
    anoFinController.dispose();
    super.dispose();
  }
}
